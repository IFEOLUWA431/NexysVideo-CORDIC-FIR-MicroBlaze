library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_pkg.all;  -- SAMPLE_WIDTH, sample_t

--###########################################################################
-- wave_gen.vhd
--
-- Runtime-configurable square wave generator.
--
-- Features:
--   - Programmable frequency using div_value
--   - Generates full-scale bipolar square wave
--   - Generates periodic sample_valid pulse
--   - Can be enabled/disabled dynamically
--
-- Waveform selection convention:
--   square_en = "11" → square wave enabled
--   otherwise        → disabled
--
-- Example:
--   fclk      = 100 MHz
--   div_value = 500000
--
--   fout = 100e6 / (2 * 500000)
--        = 100 Hz
--###########################################################################

entity wave_gen is
    port (

        ---------------------------------------------------------------------
        -- System clock.
        ---------------------------------------------------------------------
        clk : in std_logic;

        ---------------------------------------------------------------------
        -- Active-high synchronous reset.
        ---------------------------------------------------------------------
        rst : in std_logic;

        ---------------------------------------------------------------------
        -- Runtime divider value from MicroBlaze.
        --
        -- Controls square wave frequency:
        --
        --   fout = fclk / (2 * div_value)
        --
        -- Larger divider = lower output frequency.
        ---------------------------------------------------------------------
        div_value : in unsigned(31 downto 0);

        ---------------------------------------------------------------------
        -- Generated square wave sample output.
        --
        -- Output swings between:
        --   SAMPLE_MAX
        --   SAMPLE_MIN
        ---------------------------------------------------------------------
        sample_out : out sample_t;

        ---------------------------------------------------------------------
        -- Output valid pulse.
        --
        -- Pulses high for 1 clock cycle every 20000 clocks.
        -- At 100 MHz this gives:
        --
        --   100e6 / 20000 = 5 kHz
        ---------------------------------------------------------------------
        sample_valid : out std_logic;

        ---------------------------------------------------------------------
        -- Square wave enable control.
        --
        -- Current encoding:
        --   "11" = enable square wave
        --   others = disabled
        --
        -- When disabled:
        --   - counter stops
        --   - waveform holds last value
        ---------------------------------------------------------------------
        square_en : in std_logic_vector(1 downto 0)
    );
end entity wave_gen;

architecture rtl of wave_gen is

    -------------------------------------------------------------------------
    -- Main frequency divider counter.
    --
    -- Counts system clocks until divider threshold is reached.
    -------------------------------------------------------------------------
    signal cnt : unsigned(31 downto 0) := (others => '0');

    -------------------------------------------------------------------------
    -- Internal waveform polarity bit.
    --
    -- '1' = positive full scale
    -- '0' = negative full scale
    -------------------------------------------------------------------------
    signal level : std_logic := '0';

    -------------------------------------------------------------------------
    -- Safe divider register.
    --
    -- Prevents divide-by-zero behaviour.
    -- If div_value = 0, force divider to 1.
    -------------------------------------------------------------------------
    signal div_reg : unsigned(31 downto 0);

    -------------------------------------------------------------------------
    -- Counter used to generate sample_valid pulse.
    --
    -- Generates one pulse every 20000 clocks.
    -------------------------------------------------------------------------
    signal ce_cnt : unsigned(31 downto 0) := (others => '0');

begin

    -------------------------------------------------------------------------
    -- Divider protection logic.
    --
    -- Ensures divider is never zero.
    -------------------------------------------------------------------------
    div_reg <= to_unsigned(1, 32) when div_value = 0 else div_value;

    --=======================================================================
    -- Square Wave Frequency Generator
    --=======================================================================
    --
    -- Toggles waveform polarity every div_reg clock cycles.
    --
    -- Since polarity toggles once every half-period:
    --
    --   full_period = 2 * div_reg clocks
    --
    -- Therefore:
    --
    --   fout = fclk / (2 * div_reg)
    --=======================================================================
    process(clk)
    begin
        if rising_edge(clk) then

            -----------------------------------------------------------------
            -- Synchronous reset.
            -----------------------------------------------------------------
            if rst = '1' then

                -- Reset divider counter.
                cnt <= (others => '0');

                -- Reset waveform polarity.
                level <= '0';

            else

                -----------------------------------------------------------------
                -- Generator runs only when enabled.
                -----------------------------------------------------------------
                if square_en = "11" then

                    -------------------------------------------------------------
                    -- Divider reached.
                    -- Toggle waveform polarity.
                    -------------------------------------------------------------
                    if cnt = div_reg - 1 then

                        cnt <= (others => '0');

                        -- Toggle square wave polarity.
                        level <= not level;

                    else

                        ---------------------------------------------------------
                        -- Continue counting.
                        ---------------------------------------------------------
                        cnt <= cnt + 1;

                    end if;
                end if;
            end if;
        end if;
    end process;


    --=======================================================================
    -- sample_valid Pulse Generator
    --=======================================================================
    --
    -- Generates a 1-clock-cycle pulse every 20000 clocks.
    --
    -- At 100 MHz:
    --
    --   100e6 / 20000 = 5 kHz
    --
    -- Used as a lower-rate sample strobe for downstream DSP/BRAM logic.
    --=======================================================================
    process(clk)
    begin
        if rising_edge(clk) then

            -----------------------------------------------------------------
            -- Synchronous reset.
            -----------------------------------------------------------------
            if rst = '1' then

                sample_valid <= '0';
                ce_cnt <= (others => '0');

            else

                -----------------------------------------------------------------
                -- Generate valid pulses only when square generator enabled.
                -----------------------------------------------------------------
                if square_en = "11" then

                    -------------------------------------------------------------
                    -- Pulse generation point.
                    -------------------------------------------------------------
                    if ce_cnt = 19999 then

                        ce_cnt <= (others => '0');

                        -- 1-clock-cycle valid pulse.
                        sample_valid <= '1';

                    else

                        ---------------------------------------------------------
                        -- Continue counting.
                        ---------------------------------------------------------
                        ce_cnt <= ce_cnt + 1;

                        sample_valid <= '0';

                    end if;
                end if;
            end if;
        end if;
    end process;

    --=======================================================================
    -- Output Mapping
    --=======================================================================
    --
    -- Convert internal logic polarity into signed full-scale samples.
    --
    -- level = '1'
    --     → positive full scale
    --
    -- level = '0'
    --     → negative full scale
    --=======================================================================
    sample_out <= SAMPLE_MAX when level = '1'
                  else SAMPLE_MIN;

end architecture rtl;