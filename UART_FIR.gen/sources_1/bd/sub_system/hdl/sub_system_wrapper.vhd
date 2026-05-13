--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.1 (win64) Build 6140274 Thu May 22 00:12:29 MDT 2025
--Date        : Tue Feb  3 14:18:35 2026
--Host        : IC-5CG4104D9F running 64-bit major release  (build 9200)
--Command     : generate_target sub_system_wrapper.bd
--Design      : sub_system_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity sub_system_wrapper is
  port (
    BRAM_PORTB_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_clk : in STD_LOGIC;
    BRAM_PORTB_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_en : in STD_LOGIC;
    BRAM_PORTB_rst : in STD_LOGIC;
    BRAM_PORTB_we : in STD_LOGIC_VECTOR ( 3 downto 0 );
    Test_Point_2_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Test_Point_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    clk_out1 : out STD_LOGIC;
    ctrl_word_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    peripheral_reset_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    reset : in STD_LOGIC;
    sys_clock : in STD_LOGIC;
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC;
    wave_divider_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );
end sub_system_wrapper;

architecture STRUCTURE of sub_system_wrapper is
  component sub_system is
  port (
    usb_uart_rxd : in STD_LOGIC;
    usb_uart_txd : out STD_LOGIC;
    BRAM_PORTB_addr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_clk : in STD_LOGIC;
    BRAM_PORTB_din : in STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_dout : out STD_LOGIC_VECTOR ( 31 downto 0 );
    BRAM_PORTB_en : in STD_LOGIC;
    BRAM_PORTB_rst : in STD_LOGIC;
    BRAM_PORTB_we : in STD_LOGIC_VECTOR ( 3 downto 0 );
    ctrl_word_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    wave_divider_tri_o : out STD_LOGIC_VECTOR ( 31 downto 0 );
    Test_Point_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    Test_Point_2_tri_i : in STD_LOGIC_VECTOR ( 31 downto 0 );
    sys_clock : in STD_LOGIC;
    reset : in STD_LOGIC;
    peripheral_reset_0 : out STD_LOGIC_VECTOR ( 0 to 0 );
    clk_out1 : out STD_LOGIC
  );
  end component sub_system;
begin
sub_system_i: component sub_system
     port map (
      BRAM_PORTB_addr(31 downto 0) => BRAM_PORTB_addr(31 downto 0),
      BRAM_PORTB_clk => BRAM_PORTB_clk,
      BRAM_PORTB_din(31 downto 0) => BRAM_PORTB_din(31 downto 0),
      BRAM_PORTB_dout(31 downto 0) => BRAM_PORTB_dout(31 downto 0),
      BRAM_PORTB_en => BRAM_PORTB_en,
      BRAM_PORTB_rst => BRAM_PORTB_rst,
      BRAM_PORTB_we(3 downto 0) => BRAM_PORTB_we(3 downto 0),
      Test_Point_2_tri_i(31 downto 0) => Test_Point_2_tri_i(31 downto 0),
      Test_Point_tri_i(31 downto 0) => Test_Point_tri_i(31 downto 0),
      clk_out1 => clk_out1,
      ctrl_word_tri_o(31 downto 0) => ctrl_word_tri_o(31 downto 0),
      peripheral_reset_0(0) => peripheral_reset_0(0),
      reset => reset,
      sys_clock => sys_clock,
      usb_uart_rxd => usb_uart_rxd,
      usb_uart_txd => usb_uart_txd,
      wave_divider_tri_o(31 downto 0) => wave_divider_tri_o(31 downto 0)
    );
end STRUCTURE;
