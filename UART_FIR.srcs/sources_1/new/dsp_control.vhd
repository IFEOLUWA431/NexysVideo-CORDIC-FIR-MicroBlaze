--###########################################################################
-- dsp_control.vhd
--
-- Decodes the 32-bit ctrl_word written by MicroBlaze through AXI GPIO into
-- cleaner DSP-side control signals.
--
-- Current ctrl_word mapping:
--
--   bit 0   = capture enable
--   bit 1   = pattern mode enable
--   bit 2   = PL soft reset (handled in top.vhd)
--   bits 5:4 = waveform select
--       "01" = sine generator
--       "11" = square generator
--   bits 7:6 = FIR filter coefficient selection
--
-- This module performs only combinational decoding.
-- No state machines or pulse generation are currently used.
--###########################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dsp_control is
    port (

        ---------------------------------------------------------------------
        -- System clock and reset.
        -- Currently unused internally, but kept for future expansion such as:
        --   - edge detection
        --   - pulse generation
        --   - synchronizers
        ---------------------------------------------------------------------
        clk       : in  std_logic;
        rst       : in  std_logic;  -- active-high reset

        ---------------------------------------------------------------------
        -- Raw 32-bit control register from AXI GPIO.
        -- Written by MicroBlaze software.
        ---------------------------------------------------------------------
        ctrl_word : in  std_logic_vector(31 downto 0);

        ---------------------------------------------------------------------
        -- Decoded outputs to DSP fabric.
        ---------------------------------------------------------------------

        -- FIR coefficient set selection.
        -- Used by filter_coeffs module.
        filter_sel    : out unsigned(1 downto 0);

        -- Waveform generator selection.
        -- Current encoding:
        --   "01" = sine
        --   "11" = square
        wave_type     : out std_logic_vector(1 downto 0);

        -- Enables BRAM capture/write logic.
        start_capture : out std_logic;

        -- Enables BRAM address-pattern mode for debugging.
        pattern_mode  : out std_logic
    );
end entity dsp_control;

architecture rtl of dsp_control is

    -------------------------------------------------------------------------
    -- Internal decoded bitfields extracted from ctrl_word.
    -------------------------------------------------------------------------

    -- Capture enable bit.
    signal start_capture_bit : std_logic;

    -- Pattern mode enable bit.
    signal pattern_mode_bit  : std_logic;

    -- Waveform selection field.
    signal wave_type_bits    : std_logic_vector(1 downto 0);

    -- FIR coefficient selection field.
    signal filter_sel_bits   : std_logic_vector(1 downto 0);

begin

    -------------------------------------------------------------------------
    -- Decode ctrl_word fields.
    -------------------------------------------------------------------------

    -- bit 0 = capture enable
    start_capture_bit <= ctrl_word(0);

    -- bit 1 = pattern mode enable
    pattern_mode_bit <= ctrl_word(1);

    -- bits 5:4 = waveform selection
    wave_type_bits <= ctrl_word(5 downto 4);

    -- bits 7:6 = FIR coefficient selection
    filter_sel_bits <= ctrl_word(7 downto 6);

    -------------------------------------------------------------------------
    -- Drive decoded outputs.
    -------------------------------------------------------------------------

    -- Convert std_logic_vector to unsigned for coefficient selector.
    filter_sel <= unsigned(filter_sel_bits);

    -- Waveform select output.
    wave_type <= wave_type_bits;

    -- Capture enable output.
    start_capture <= start_capture_bit;

    -- Pattern mode output.
    pattern_mode <= pattern_mode_bit;

end architecture rtl;