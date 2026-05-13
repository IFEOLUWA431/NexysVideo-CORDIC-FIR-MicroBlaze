/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

#include "xparameters.h"
#include "xuartlite.h"
#include "xgpio.h"
//#include "xbram.h"
#include <string.h>
#include <ctype.h>

#include "xil_io.h"
#include "xil_types.h"

//#define DEVICE_ID   XPAR_XUARTLITE_0_BASEADDR

#define BRAM_BASEADDR XPAR_XBRAM_0_BASEADDR
#define HALF_WORDS    1024
#define SYS_CLK_HZ    100000000U

#define CTRL_CAP_EN    (1u << 0)
#define CTRL_PAT_EN    (1u << 1)
#define CTRL_SOFT_RST  (1u << 2)

#define CTRL_WAVE_EN       (1u << 3)

#define CTRL_WAVE_TYPE_MASK (3u << 4)
#define CTRL_WAVE_SINE      (1u << 4)   /* wave_type = "01" */
#define CTRL_WAVE_SQUARE    (3u << 4)   /* wave_type = "11" */

#define CTRL_ACK0_TGL  (1u << 16)
#define CTRL_ACK1_TGL  (1u << 17)

#define CTRL_FILTER_MASK   (3u << 6)

/******************************************************************************
* FIR FILTER SELECT
*
* ctrl_word[7:6]
*
*   00 = filter 0
*   01 = filter 1
*   10 = filter 2
*   11 = filter 3
******************************************************************************/

#define CTRL_FILTER_0      (0u << 6)
#define CTRL_FILTER_1      (1u << 6)
#define CTRL_FILTER_2      (2u << 6)
#define CTRL_FILTER_3      (3u << 6)

XUartLite Uart;
XGpio     GpioOut;
XGpio     GpioIn;

u8 buf[4];
static u32 ctrl = 0;

static u32 parse_u32_decimal(const char *p)
{
    u32 v = 0;

    while (*p == ' ')
        p++;

    while (*p >= '0' && *p <= '9')
    {
        v = (v * 10u) + (u32)(*p - '0');
        p++;
    }

    return v;
}

static void gpio_apply_ctrl(void)
{
    XGpio_DiscreteWrite(&GpioOut, 1, ctrl);
}

static void uart_send_str(const char *s)
{
    const u8 *b = (const u8 *)s;
    unsigned len = (unsigned)strlen(s);
    unsigned sent = 0;

    while (sent < len)
    {
        int n = XUartLite_Send(&Uart, (u8 *)(b + sent), len - sent);
        if (n > 0)
            sent += (unsigned)n;

        while (XUartLite_IsSending(&Uart)) { }
    }
}

static void uart_send_bytes(const u8 *data, unsigned len)
{
    XUartLite_Send(&Uart, (u8 *)data, len);
    while (XUartLite_IsSending(&Uart)) { }
}

static int uart_readline(char *line, int maxlen)
{
    int n = 0;
    u8 ch;

    while (1)
    {
        if (XUartLite_Recv(&Uart, &ch, 1) == 1)
        {
            if (ch == '\r' || ch == '\n')
            {
                if (n == 0)
                    continue;

                line[n] = '\0';
                return n;
            }

            if (n < (maxlen - 1))
                line[n++] = (char)ch;
        }
    }
}

static void to_upper_str(char *s)
{
    while (*s)
    {
        *s = (char)toupper((unsigned char)*s);
        s++;
    }
}

static void print_menu(void)
{
    uart_send_str(
        "\r\nCMD: HELP CAP SINE SQUARE FILT DUMP0 DUMP1 AUTO RST\r\n"
        "CAP 1/0\r\n"
        "SINE N\r\n"
        "SQUARE N\r\n"
        "FILT 0..3\r\n"
        "DUMP0/DUMP1\r\n"
        "AUTO\r\n"
        "RST\r\n"
        "<<<MENU_END>>>\r\n"
    );
}

static void stream_bram_half(u32 base_addr, u32 start_word, u32 word_count)
{
    uart_send_str("DATA\r\n");

    for (u32 i = 0; i < word_count; i++)
    {
        u32 w = Xil_In32(base_addr + (start_word + i) * 4);

        buf[0] = (w >> 24) & 0xFF;
        buf[1] = (w >> 16) & 0xFF;
        buf[2] = (w >>  8) & 0xFF;
        buf[3] = (w >>  0) & 0xFF;

        uart_send_bytes(buf, 4);
    }

    uart_send_str("\r\nEND\r\n");
}

static void ack0_toggle(void)
{
    ctrl ^= CTRL_ACK0_TGL;
    gpio_apply_ctrl();
}

static void ack1_toggle(void)
{
    ctrl ^= CTRL_ACK1_TGL;
    gpio_apply_ctrl();
}

static void soft_reset_pulse(void)
{
    ctrl |= CTRL_SOFT_RST;
    gpio_apply_ctrl();

    ctrl &= ~CTRL_SOFT_RST;
    gpio_apply_ctrl();
}

static void prepare_wave_change(void)
{
    ctrl &= ~CTRL_CAP_EN;
    gpio_apply_ctrl();

    /* Disable waveform and clear wave_type */
    ctrl &= ~CTRL_WAVE_EN;
    ctrl &= ~CTRL_WAVE_TYPE_MASK;
    gpio_apply_ctrl();

    ctrl |= CTRL_SOFT_RST;
    gpio_apply_ctrl();
}

static void finish_wave_change(void)
{
    /*
     * 1. Release PL reset
     * 2. Restart capture
     */

    ctrl &= ~CTRL_SOFT_RST;
    gpio_apply_ctrl();

    ctrl |= CTRL_CAP_EN;
    gpio_apply_ctrl();
}

static void auto_stream_bram(void)
{
    u32 prev_full0 = 0;
    u32 prev_full1 = 0;

    uart_send_str("AUTO STREAM MODE\r\n");

    while (1)
    {
        u32 tp1 = XGpio_DiscreteRead(&GpioIn, 1);

        u32 full0 = (tp1 >> 0) & 1;
        u32 full1 = (tp1 >> 1) & 1;

        if (full0 && !prev_full0)
        {
            stream_bram_half(BRAM_BASEADDR, 0, HALF_WORDS);
            ack0_toggle();
        }

        if (full1 && !prev_full1)
        {
            stream_bram_half(BRAM_BASEADDR, HALF_WORDS, HALF_WORDS);
            ack1_toggle();
        }

        prev_full0 = full0;
        prev_full1 = full1;

        {
            u8 ch;
            if (XUartLite_Recv(&Uart, &ch, 1) == 1)
            {
                uart_send_str("\r\nEXIT AUTO\r\n");
                break;
            }
        }
    }
}

int main()
{
    int status;
    char line[80];

    status = XUartLite_Initialize(&Uart, 0);
    if (status != XST_SUCCESS)
        return -1;

    status = XGpio_Initialize(&GpioOut, XPAR_XGPIO_0_BASEADDR);
    if (status != XST_SUCCESS)
        return -1;

    XGpio_SetDataDirection(&GpioOut, 1, 0x00000000);
    XGpio_SetDataDirection(&GpioOut, 2, 0x00000000);

    status = XGpio_Initialize(&GpioIn, XPAR_XGPIO_1_BASEADDR);
    if (status != XST_SUCCESS)
        return -1;

    XGpio_SetDataDirection(&GpioIn, 1, 0xFFFFFFFF);
    XGpio_SetDataDirection(&GpioIn, 2, 0xFFFFFFFF);

    ctrl = 0;
    gpio_apply_ctrl();

    XGpio_DiscreteWrite(&GpioOut, 2, 0);

    uart_send_str("READY\r\n");
    print_menu();

    while (1)
    {
        uart_readline(line, sizeof(line));
        to_upper_str(line);

        if (strcmp(line, "HELP") == 0 || strcmp(line, "?") == 0)
        {
            print_menu();
            continue;
        }

        if (strcmp(line, "RST") == 0 || strcmp(line, "SRST") == 0)
        {
            soft_reset_pulse();
            uart_send_str("OK SRST\r\n");
            continue;
        }

        if (strcmp(line, "CAP 1") == 0)
        {
            ctrl |= CTRL_CAP_EN;
            gpio_apply_ctrl();
            uart_send_str("OK CAP=1\r\n");
            continue;
        }

        if (strcmp(line, "CAP 0") == 0)
        {
            ctrl &= ~CTRL_CAP_EN;
            gpio_apply_ctrl();
            uart_send_str("OK CAP=0\r\n");
            continue;
        }

        if (strcmp(line, "DUMP0") == 0)
        {
            stream_bram_half(BRAM_BASEADDR, 0, HALF_WORDS);
            ack0_toggle();
            continue;
        }

        if (strcmp(line, "DUMP1") == 0)
        {
            stream_bram_half(BRAM_BASEADDR, HALF_WORDS, HALF_WORDS);
            ack1_toggle();
            continue;
        }

        if (strcmp(line, "AUTO") == 0)
        {
            auto_stream_bram();
            continue;
        }

        if (strncmp(line, "SINE ", 5) == 0)
        {
            u32 freq_hz = parse_u32_decimal(line + 5);
            u32 phase_step;

            if (freq_hz == 0)
            {
                uart_send_str("ERR SINE FREQ\r\n");
                continue;
            }

            if (freq_hz >= (SYS_CLK_HZ / 2))
            {
                uart_send_str("ERR SINE TOO HIGH\r\n");
                continue;
            }

            prepare_wave_change();

            phase_step = (u32)(((u64)freq_hz << 32) / SYS_CLK_HZ);

            XGpio_DiscreteWrite(&GpioOut, 2, phase_step);
            ctrl &= ~CTRL_WAVE_TYPE_MASK;
            ctrl |= CTRL_WAVE_SINE;
            ctrl |= CTRL_WAVE_EN;
            gpio_apply_ctrl();

            finish_wave_change();

            uart_send_str("OK SINE\r\n");
            continue;
        }

        if (strncmp(line, "SQUARE ", 7) == 0)
        {
            u32 freq_hz = parse_u32_decimal(line + 7);
            u32 div;

            if (freq_hz == 0)
            {
                uart_send_str("ERR SQUARE FREQ\r\n");
                continue;
            }

            prepare_wave_change();

            div = SYS_CLK_HZ / (2u * freq_hz);

            if (div == 0)
                div = 1;

            XGpio_DiscreteWrite(&GpioOut, 2, div);

            ctrl &= ~CTRL_WAVE_TYPE_MASK;
            ctrl |= CTRL_WAVE_SQUARE;
            ctrl |= CTRL_WAVE_EN;
            gpio_apply_ctrl();

            finish_wave_change();

            uart_send_str("OK SQUARE\r\n");
            continue;
        }

        if (strncmp(line, "FILT ", 5) == 0)
        {
            u32 filt;

            filt = parse_u32_decimal(line + 5);

            if (filt > 3)
            {
                uart_send_str("ERR FILTER\r\n");
                continue;
            }

            /* Clear existing filter select bits */
            ctrl &= ~CTRL_FILTER_MASK;

            /* Apply new filter selection */
            switch (filt)
            {
                case 0:
                    ctrl |= CTRL_FILTER_0;
                    break;

                case 1:
                    ctrl |= CTRL_FILTER_1;
                    break;

                case 2:
                    ctrl |= CTRL_FILTER_2;
                    break;

                case 3:
                    ctrl |= CTRL_FILTER_3;
                    break;

                default:
                    break;
            }

            gpio_apply_ctrl();

            uart_send_str("OK FILTER\r\n");
            continue;
        }

        uart_send_str("ERR UNKNOWN CMD\r\n");
    }

    return 0;
}