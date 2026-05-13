--#############################################################################
-- fir_filter.vhd
--  FIR filter with external coefficients
--    - Input:  sample_t stream with x_valid strobe
--    - Output: sample_t stream with y_valid strobe
--    - Coefficients: provided on 'coef' port (e.g. from ROM or UART loader)
--#############################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_pkg.all;  -- SAMPLE_WIDTH, N_TAPS, sample_t, coef_array_t

entity fir_filter is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;

        x_in    : in  sample_t;      -- Input sample (signed fixed-point)
        x_valid : in  std_logic;     -- Valid strobe for input sample

        -- Coefficients for each tap
        coef    : in  coef_array_t;  -- Array of FIR coefficients

        y_out   : out sample_t;      -- Filtered output sample
        y_valid : out std_logic      -- Output valid flag
    );
end entity fir_filter;

architecture rtl of fir_filter is

    -- Shift register holding past input samples (FIR taps)
    signal shift_register : shift_array_t;

    -- Multiplier outputs: coef(i) * sample(i)
    signal multiplier: mult_array_t ;

    -- Accumulator chain (running sum of products)
    signal adder: acc_array_t ;

begin

    -- ========================================================================
    -- SHIFT REGISTER (FIR tap delay line)
    -- ========================================================================
    -- Implements:
    --   x[n], x[n-1], x[n-2], ..., x[n-(N_TAPS-1)]
    --
    -- Only shifts when x_valid = '1'
    -- Maps to flip-flops (NOT SRL, because all taps are needed in parallel)
    -- ========================================================================
    shif_ref_gen: for i in 0 to N_TAPS-1 generate
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    shift_register(i) <= (others => '0');  -- Clear all taps
                else
                    if x_valid = '1' then
                        if i = 0 then
                            shift_register(0) <= x_in;      -- New sample
                        else
                            shift_register(i) <= shift_register(i-1); -- Shift
                        end if;
                    end if;
                end if;
            end if;
        end process;
    end generate;

    -- ========================================================================
    -- MULTIPLIERS (one per tap)
    -- ========================================================================
    -- Each tap multiplies:
    --   coef(i) * delayed_sample(i)
    --
    -- These will map to DSP48 blocks in Artix-7 (important for performance)
    -- Registered for pipelining
    -- ========================================================================
    mult_gen: for i in 0 to N_TAPS-1 generate
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    multiplier(i) <= (others => '0');
                else
                    multiplier(i) <= coef(i) * shift_register(i);
                end if;
            end if;
        end process;
    end generate;

    -- ========================================================================
    -- ADDER CHAIN (accumulate all products)
    -- ========================================================================
    -- Implements:
    --   y = Σ (coef(i) * x[n-i])
    --
    -- This is a sequential accumulation:
    --   adder(0) = multiplier(0)
    --   adder(1) = adder(0) + multiplier(1)
    --   ...
    --
    -- Maps to carry chain (fast FPGA arithmetic)
    -- ========================================================================
    add_gen: for i in 0 to N_TAPS-1 generate
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    adder(i) <= (others => '0');
                else
                    if i = 0 then
                        -- First tap: just resize multiplier to accumulator width
                        adder(0) <= resize(multiplier(0), 2*SAMPLE_WIDTH+4);
                    else
                        -- Accumulate sum
                        adder(i) <= adder(i-1) + resize(multiplier(i), 2*SAMPLE_WIDTH+4);
                    end if;
                end if;
            end if;
        end process;
    end generate;

    -- ========================================================================
    -- OUTPUT STAGE
    -- ========================================================================
    -- The accumulator has grown in bit width:
    --   input:  SAMPLE_WIDTH
    --   multiply: ~2*SAMPLE_WIDTH
    --   accumulation: extra guard bits (+4)
    --
    -- We must SCALE BACK to SAMPLE_WIDTH
    --
    -- shift_right(..., 15) ≈ divide by 2^15 (Q15 scaling)
    --
    -- This assumes coefficients are in Q15 format
    -- ========================================================================
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                y_out <= (others => '0');
                y_valid <= '0';
            else
                -- Scale accumulator back to output width
                -- Equivalent to:
                --   y_out ≈ accumulator / 32768
                y_out <= resize(shift_right(adder(N_TAPS-1), 15), SAMPLE_WIDTH);

                -- NOTE: currently always '1' (no pipeline alignment with x_valid)
                -- In a real design, this should be delayed version of x_valid
                y_valid <= '1';
            end if;
        end if;
    end process;

end architecture rtl;