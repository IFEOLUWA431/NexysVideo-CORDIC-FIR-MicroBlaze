# NexysVideo CORDIC + FIR + MicroBlaze DSP Platform

A custom FPGA digital-signal-processing platform for the **Digilent Nexys Video**
board (Xilinx Artix-7, `xc7a200tsbg484-1`). A soft-core MicroBlaze processor acts
as a UART command shell that drives a hand-written VHDL DSP datapath:
runtime-configurable **CORDIC sine** and **square-wave** generation, a 16-tap
**FIR filter** with switchable low-/high-/band-pass/band-stop responses, and a
**ping-pong BRAM capture** buffer whose contents are streamed back to a host PC
over UART.

Built with **Vivado** (RTL + block design) and **Vitis** (embedded C application).

---

## Features

- **MicroBlaze control plane** — soft-core CPU running a bare-metal UART shell that
  configures the DSP fabric over AXI GPIO and reads captured data out of AXI BRAM.
- **CORDIC sine generator** (`sine_gen.vhd`) — 16-iteration CORDIC pipeline with a
  32-bit phase accumulator. Output frequency is set at runtime from the CPU via a
  phase-increment word.
- **Square-wave generator** (`wave_gen.vhd`) — programmable frequency via a clock
  divider written from the CPU.
- **16-tap FIR filter** (`fir_filter.vhd`) — fully parallel taps with signed 16-bit
  samples and coefficients, and a guard-banded accumulator to prevent overflow.
- **Selectable filter banks** (`filter_coeffs.vhd`) — four 16-tap coefficient sets
  (low-pass, high-pass, band-pass, band-stop) chosen at runtime.
- **Ping-pong BRAM capture** (`bram_writer.vhd`) — a 2048-word buffer split into two
  1024-word halves. The PL fills one half while the CPU drains the other, with
  full-flag / acknowledge handshaking.
- **UART data streaming** — captured samples are sent to the host as raw 32-bit words
  framed by `DATA` / `END` markers, with an automatic continuous-capture mode.

---

## System Architecture

```
                Host PC (serial terminal @ UART)
                              |
                              | commands / sample stream
                              v
  +-----------------------------------------------------------+
  |                   sub_system (block design)               |
  |   MicroBlaze  +  AXI UARTLite  +  AXI GPIO x2             |
  |               +  AXI BRAM controller  +  clk wizard       |
  +-----------------------------------------------------------+
        |  ctrl_word / phase_step / div      ^   BRAM port B
        |  (AXI GPIO out)                     |   (sample storage)
        v                                     |
  +-------------+    +------------------+      |
  | dsp_control | -> |  sine_gen (CORDIC)|--\  |
  | (decode the |    |  wave_gen (square)|--->-+--> fir_filter --> bram_writer
  |  ctrl word) |    +------------------+   |       (16-tap)        (ping-pong)
  +-------------+            ^              |          ^
        | filter_sel        | wave_type    |          | coefficients
        +-------------------+--------------+   filter_coeffs (LP/HP/BP/BS)
                                                status / debug
                                              (AXI GPIO in -> CPU)
```

The top level (`TOP.vhd`) wires the MicroBlaze subsystem to the DSP datapath. The CPU
writes a 32-bit **control word** over AXI GPIO; `dsp_control` decodes it into clean
internal control signals. The selected waveform feeds both the FIR filter and the BRAM
writer, so each captured 32-bit word holds the filtered sample in the upper half and
the raw sample in the lower half.

---

## Repository Layout

| Path | Description |
|------|-------------|
| `UART_FIR.srcs/sources_1/new/` | Hand-written VHDL design sources (see below) |
| `UART_FIR.srcs/sim_1/new/tb.vhd` | Testbench |
| `UART_FIR.srcs/constrs_1/imports/.../Nexys-Video-Master.xdc` | Pin / timing constraints |
| `UART_FIR.srcs/sources_1/bd/sub_system/` | MicroBlaze block design |
| `UART_FIR.xpr` | Vivado project file |
| `UART_FIR.tcl` | Project-rebuild Tcl script |
| `FIR.xsa` | Exported hardware handoff for Vitis |
| `VITIS/hello_world/src/helloworld.c` | Embedded UART command-shell application |
| `VITIS/platform/` | Vitis platform / BSP |

### Key VHDL modules

| File | Role |
|------|------|
| `TOP.vhd` | Top level; instantiates the subsystem and all DSP blocks |
| `fir_pkg.vhd` | Shared types and constants (`SAMPLE_WIDTH=16`, `N_TAPS=16`, `sample_t`, coefficient arrays) |
| `dsp_control.vhd` | Combinational decode of the CPU control word |
| `sine_gen.vhd` | CORDIC sine generator (32-bit phase accumulator) |
| `wave_gen.vhd` | Programmable square-wave generator |
| `fir_filter.vhd` | 16-tap parallel FIR filter |
| `filter_coeffs.vhd` | LP / HP / BP / BS coefficient banks |
| `bram_writer.vhd` | Ping-pong BRAM capture with full/ack handshaking |

---

## Hardware Requirements

- **Board:** Digilent Nexys Video (Artix-7 `xc7a200tsbg484-1`)
- **Cabling:** USB for JTAG programming + UART (the board's UART bridge)
- **Host:** A serial terminal capable of sending text commands and capturing raw bytes

### Pinout (from the constraints file)

| Signal | Pin | Notes |
|--------|-----|-------|
| `i_clk` | R4 | 100 MHz system clock |
| `i_resetn` | G4 | Active-low CPU reset button |
| `uart_rx_in` | V18 | UART receive into the FPGA |
| `uart_tx_out` | AA19 | UART transmit from the FPGA |

---

## Build & Run

> The exact tool version is whatever the project was last saved with; open the project
> in a matching Vivado/Vitis release for a clean upgrade-free flow.

### 1. Build the hardware (Vivado)

Open the existing project:

```tcl
# from the Vivado Tcl console, in the repo root
open_project UART_FIR.xpr
```

…or rebuild it from scratch:

```tcl
source UART_FIR.tcl
```

Then **generate the bitstream** (this also regenerates the block-design outputs and the
MicroBlaze subsystem). Export the hardware including the bitstream — the resulting
`.xsa` (`FIR.xsa` is the one committed here) is the handoff for Vitis.

### 2. Build the software (Vitis)

1. Create a platform from `FIR.xsa` (a prebuilt `VITIS/platform/` is included).
2. Create an application using `VITIS/hello_world/src/helloworld.c`.
3. Build, then program the FPGA and launch the ELF on the MicroBlaze.

### 3. Connect a terminal

Open a serial terminal on the board's UART port. On reset you should see:

```
READY
CMD: HELP CAP SINE SQUARE FILT DUMP0 DUMP1 AUTO RST
...
<<<MENU_END>>>
```

---

## UART Command Reference

Commands are line-based (terminated by CR/LF) and case-insensitive.

| Command | Action |
|---------|--------|
| `HELP` / `?` | Print the command menu |
| `CAP 1` / `CAP 0` | Enable / disable sample capture into BRAM |
| `SINE N` | Generate a sine wave at **N Hz** (CORDIC). Rejected if `N = 0` or `N ≥ Fclk/2` |
| `SQUARE N` | Generate a square wave at **N Hz** |
| `FILT 0..3` | Select FIR coefficient bank 0–3 |
| `DUMP0` | Stream the lower BRAM half (1024 words) then acknowledge it |
| `DUMP1` | Stream the upper BRAM half (1024 words) then acknowledge it |
| `AUTO` | Continuous capture: auto-stream each half as it fills (any key exits) |
| `RST` / `SRST` | Pulse the PL soft reset |

### Sample data format

Each captured BRAM word is 32 bits:

```
bits [31:16] = FIR-filtered sample (signed 16-bit)
bits [15:0]  = raw input sample    (signed 16-bit)
```

`DUMP*` and `AUTO` send words as **4 raw bytes, big-endian (MSB first)**, framed like:

```
DATA
<4 bytes per word, 1024 words>
END
```

Samples are produced at roughly **5 kHz** (one valid pulse every 20000 clocks at
100 MHz). Frequency commands are converted to hardware control values on the CPU:

- **Sine:** `phase_step = round(freq_hz * 2^32 / Fclk)`
- **Square:** `div = Fclk / (2 * freq_hz)`

---

## Control-Word Reference

The CPU packs configuration into a single 32-bit word written via AXI GPIO
(channel 1). `dsp_control.vhd` decodes it:

| Bits | Field | Meaning |
|------|-------|---------|
| 0 | capture enable | Start/stop BRAM capture |
| 1 | pattern mode | Write address pattern instead of samples (debug) |
| 2 | PL soft reset | Pulsed reset for the DSP fabric |
| 3 | wave enable | Master enable for the waveform generators |
| 5:4 | wave type | `01` = sine (CORDIC), `11` = square |
| 7:6 | filter select | Coefficient bank 0–3 (LP / HP / BP / BS) |
| 16 | ack0 toggle | Clears the lower-half full flag |
| 17 | ack1 toggle | Clears the upper-half full flag |

GPIO channel 2 carries the waveform tuning word (`phase_step` for sine, `div` for
square). A second AXI GPIO (input) returns status/debug, including the `full0` /
`full1` buffer flags used by `AUTO` mode.

---

## How It Works (signal flow)

1. The host sends e.g. `SINE 1000`. The CPU computes the phase increment, momentarily
   disables capture, soft-resets the fabric, selects the sine generator, then
   re-enables capture.
2. `sine_gen` advances its 32-bit phase accumulator each enabled cycle and runs the
   CORDIC rotation pipeline to produce a signed sample plus a `sample_valid` strobe.
3. The same sample stream feeds `fir_filter`, which convolves it against the selected
   16-tap coefficient set from `filter_coeffs`.
4. `bram_writer` packs `{filtered, raw}` into each 32-bit word and writes it into the
   active BRAM half. When a half fills, it raises the corresponding full flag.
5. The CPU (via `DUMP*` or `AUTO`) reads the full half out of BRAM, streams it over
   UART, and toggles the matching acknowledge bit so the PL can reuse that half.

---

## Notes & Limitations

- Samples and coefficients are signed 16-bit (`fir_pkg.vhd`); changing `SAMPLE_WIDTH`
  or `N_TAPS` there propagates to every DSP block.
- The CORDIC output amplitude is scaled slightly below full scale (`X_INIT`) to leave
  headroom and avoid positive-peak overflow.
- `pattern_mode` writes BRAM word addresses as data instead of samples — useful for
  verifying BRAM read/write ordering from the CPU.
- This repository includes Vivado-generated intermediate directories
  (`*.cache`, `*.runs`, `*.gen`, `*.hw`, etc.); only the files under
  `UART_FIR.srcs/.../new/`, the constraints, and the Vitis sources are hand-authored.

---

## License

The Vitis application is derived from an AMD/Xilinx template carrying an MIT license
header. Add a top-level `LICENSE` file if you want to set the license for the rest of
the project.
