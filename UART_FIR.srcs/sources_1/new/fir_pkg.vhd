--#############################################################################
-- fir_pkg.vhd
--
-- Common FIR package containing:
--   - Global FIR configuration constants
--   - Shared DSP data types
--   - Array definitions for FIR processing
--   - Default coefficient values
--   - Full-scale sample constants
--
-- This package is shared across:
--   - fir_filter
--   - wave generators
--   - BRAM writer
--   - coefficient modules
--   - DSP test logic
--
-- Centralizing these definitions ensures all DSP modules use consistent
-- widths and compatible signal types.
--#############################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package fir_pkg is

    -------------------------------------------------------------------------
    -- Global FIR Configuration
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- Width of all signed DSP samples and FIR coefficients.
    --
    -- Current format:
    --   signed(15 downto 0)
    --
    -- Range:
    --   -32768 to +32767
    -------------------------------------------------------------------------
    constant SAMPLE_WIDTH : integer := 16;

    -------------------------------------------------------------------------
    -- Number of FIR filter taps.
    --
    -- Current FIR size:
    --   16-tap FIR
    --
    -- Increasing taps:
    --   + improves frequency response
    --   - increases FPGA resource usage
    --   - increases latency
    -------------------------------------------------------------------------
    constant N_TAPS : integer := 16;

    -------------------------------------------------------------------------
    -- Width needed to address FIR coefficients.
    --
    -- For 16 taps:
    --   addresses = 0 to 15
    --   requires 4 bits
    -------------------------------------------------------------------------
    constant COEF_IDX_WIDTH : integer := 4;

    -------------------------------------------------------------------------
    -- DSP Data Types
    -------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- Signed sample/coefficient type.
    --
    -- Used throughout DSP chain:
    --   - waveform generators
    --   - FIR coefficients
    --   - FIR input/output
    --   - BRAM storage
    -------------------------------------------------------------------------
    subtype sample_t is signed(SAMPLE_WIDTH-1 downto 0);

    -------------------------------------------------------------------------
    -- FIR coefficient array.
    --
    -- Example:
    --   coef_array_t(0) = first tap coefficient
    --   coef_array_t(15)= last tap coefficient
    -------------------------------------------------------------------------
    type coef_array_t is array (0 to N_TAPS-1) of sample_t;

    -------------------------------------------------------------------------
    -- FIR shift-register storage array.
    --
    -- Holds delayed input samples:
    --
    --   shift_reg(0) = newest sample
    --   shift_reg(N_TAPS-1) = oldest sample
    -------------------------------------------------------------------------
    type shift_array_t is array(0 to N_TAPS-1) of sample_t;

    -------------------------------------------------------------------------
    -- FIR multiplier output array.
    --
    -- Each multiply result width:
    --
    --   sample_t × sample_t
    --   = 16 × 16
    --   = 32-bit signed product
    -------------------------------------------------------------------------
    type mult_array_t is array(0 to N_TAPS-1)
        of signed(2*SAMPLE_WIDTH-1 downto 0);

    -------------------------------------------------------------------------
    -- FIR accumulator array.
    --
    -- Accumulator requires additional guard bits to prevent overflow during
    -- summation of all tap products.
    --
    -- For 16 taps:
    --
    --   log2(16) = 4 extra bits
    --
    -- Total width:
    --   2*SAMPLE_WIDTH + 4
    -------------------------------------------------------------------------
    type acc_array_t is array(0 to N_TAPS-1)
        of signed(2*SAMPLE_WIDTH+3 downto 0);

    -------------------------------------------------------------------------
    -- Default FIR coefficients.
    --
    -- Initialized to all zeros.
    --
    -- Can later be:
    --   - replaced with fixed filter coefficients
    --   - loaded dynamically from MicroBlaze/UART
    --   - replaced by coefficient ROM
    -------------------------------------------------------------------------
    constant DEFAULT_COEFS : coef_array_t :=
        (others => (others => '0'));

    -------------------------------------------------------------------------
    -- Maximum positive signed sample value.
    --
    -- For SAMPLE_WIDTH = 16:
    --   +32767
    -------------------------------------------------------------------------
    constant SAMPLE_MAX : sample_t :=
        to_signed(2**(SAMPLE_WIDTH-1)-1, SAMPLE_WIDTH);

    -------------------------------------------------------------------------
    -- Maximum negative signed sample value.
    --
    -- For SAMPLE_WIDTH = 16:
    --   -32768
    -------------------------------------------------------------------------
    constant SAMPLE_MIN : sample_t :=
        to_signed(-2**(SAMPLE_WIDTH-1), SAMPLE_WIDTH);

end package fir_pkg;


--#############################################################################
-- Package body
--
-- No executable functions or procedures are currently required.
-- All constants and type declarations are defined in the package declaration.
--#############################################################################
package body fir_pkg is

end package body fir_pkg;