library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_pkg.all;  -- SAMPLE_WIDTH, sample_t

entity sine_gen is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;

        -- Runtime phase increment from MicroBlaze.
        -- This controls sine frequency:
        -- phase_step = fout * 2^32 / fclk
        phase_step    : in  unsigned(31 downto 0);

        sample_out   : out sample_t;
        sample_valid : out std_logic;

        -- Enables/disables the CORDIC pipeline.
        -- When '0', phase accumulator and pipeline registers hold state.
        cordic_en : in std_logic_vector(1 downto 0)
    );
end entity sine_gen;

architecture rtl of sine_gen is

    constant N_ITER : integer := 16;

    -- =========================
    -- CORDIC constants
    -- =========================
    type lut_t is array (0 to N_ITER-1) of signed(31 downto 0);

    -- ATAN_LUT values are atan(2^-i) represented in 32-bit phase format.
    -- Full circle: 2*pi radians = 2^32 phase counts.
    -- Example: atan(1) = 45 degrees = 1/8 full cycle = 536870912.
    constant ATAN_LUT : lut_t := (
        to_signed(536870912, 32), -- atan(1)       = 45 deg
        to_signed(316933406, 32), -- atan(1/2)
        to_signed(167458907, 32), -- atan(1/4)
        to_signed(85004756,  32), -- atan(1/8)
        to_signed(42667331,  32),
        to_signed(21354465,  32),
        to_signed(10679838,  32),
        to_signed(5340245,   32),
        to_signed(2670163,   32),
        to_signed(1335087,   32),
        to_signed(667544,    32),
        to_signed(333772,    32),
        to_signed(166886,    32),
        to_signed(83443,     32),
        to_signed(41722,     32),
        to_signed(20861,     32)
    );

    -- CORDIC gain pre-compensation.
    -- X_INIT is approximately 1/K scaled for Q1.15-style output with headroom.
    -- Reduced slightly below exact full-scale to avoid positive peak overflow.
    constant X_INIT : signed(31 downto 0) := to_signed(19896,32);
    constant Y_INIT : signed(31 downto 0) := to_signed(0,32);

    -- =========================
    -- Phase accumulator
    -- =========================
    -- 32-bit unsigned phase accumulator.
    -- 0x00000000 = 0 degrees
    -- 0x40000000 = 90 degrees
    -- 0x80000000 = 180 degrees
    -- 0xC0000000 = 270 degrees
    signal phase_acc : unsigned(31 downto 0) := (others=>'0');

    -- Mapped phase angle into first quadrant for CORDIC input.
    -- sign_neg remembers whether final sine output should be negated.
    signal ph_map   : unsigned(31 downto 0);
    signal sign_neg : std_logic;

    -- =========================
    -- CORDIC pipeline signals
    -- =========================
    type vec_array is array (0 to N_ITER) of signed(31 downto 0);

    -- X/Y are vector components.
    -- Z is residual angle in same 32-bit phase-count units as ATAN_LUT.
    signal X_pipe, Y_pipe, Z_pipe : vec_array;


    signal div_reg : unsigned(31 downto 0);

    -- Registered sine output in sample_t format.
    signal sine_reg : signed(SAMPLE_WIDTH-1 downto 0);
   
    -- ====================================================
    -- SIGN PIPELINE
    -- ====================================================
    -- Delays sign_neg by the same number of stages as CORDIC latency.
    -- This keeps the sign correction aligned with Y_pipe(N_ITER).
    signal sign_pipe : std_logic_vector(0 to N_ITER) := (others => '0');
    
    -- Generates sample_valid pulse every 20000 clocks.
    -- At 100 MHz, this is 5 kHz.
    signal ce_cnt       : unsigned(31 downto 0) := (others => '0'); -- 0..199 fits in 8 bits

begin

   -- div_reg <= to_unsigned(1,32) when div_value = 0 else div_value;
    
    

    -- ====================================================
    -- PHASE + SAMPLE CLOCK
    -- ====================================================
    -- Accumulates phase only when CORDIC is enabled.
    -- This saves switching activity when sine generation is not selected.
    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                phase_acc <= (others=>'0');
            else
                if cordic_en = "01" then
                    phase_acc <= phase_acc + phase_step;
                end if;
            end if;
        end if; 
    end process;

    -- ====================================================
    -- QUADRANT MAPPER
    -- ====================================================
    -- Maps full 0..360 degree phase range into 0..90 degrees.
    -- CORDIC only calculates first-quadrant magnitude.
    -- sign_neg is then used later to restore sine sign.
    process(phase_acc)
    begin
        if phase_acc < x"40000000" then
            -- Quadrant 1: 0..90 degrees
            -- sin is positive, angle is already first-quadrant.
            ph_map   <= phase_acc;
            sign_neg <= '0';

        elsif phase_acc < x"80000000" then
            -- Quadrant 2: 90..180 degrees
            -- sin is positive, mirror angle around 180 degrees.
            ph_map   <= x"80000000" - phase_acc;
            sign_neg <= '0';

        elsif phase_acc < x"C0000000" then
            -- Quadrant 3: 180..270 degrees
            -- sin is negative, map to 0..90 degrees.
            ph_map   <= phase_acc - x"80000000";
            sign_neg <= '1';

        else
            -- Quadrant 4: 270..360 degrees
            -- sin is negative, use two's-complement wrap:
            -- ph_map = 2^32 - phase_acc.
            ph_map   <= not phase_acc + 1;
            sign_neg <= '1';
        end if;
    end process;

    -- ====================================================
    -- CORDIC INITIAL STAGE
    -- ====================================================
    -- Loads a new vector and mapped angle into stage 0 when enabled.
    -- X_INIT/Y_INIT define starting vector. Z_pipe(0) is the angle to rotate.
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                X_pipe(0)    <= (others => '0');
                Y_pipe(0)    <= (others => '0');
                Z_pipe(0)    <= (others => '0');
                sign_pipe(0) <= '0';
            else
                if cordic_en = "01" then
                    X_pipe(0)    <= X_INIT;
                    Y_pipe(0)    <= Y_INIT;
                    Z_pipe(0)    <= signed(ph_map);
                    sign_pipe(0) <= sign_neg;
                end if;
            end if;
            
        end if;
    end process;

    -- ====================================================
    -- CORDIC PIPELINE
    -- ====================================================
    -- Fully pipelined CORDIC.
    -- All stages update every clock when cordic_en = '1'.
    -- Latency is N_ITER clocks, throughput is one output per clock after fill.
    gen_cordic: for i in 0 to N_ITER-1 generate
        process(clk)
        begin
            if rising_edge(clk) then
                if rst = '1' then
                    X_pipe(i+1)    <= (others => '0');
                    Y_pipe(i+1)    <= (others => '0');
                    Z_pipe(i+1)    <= (others => '0');
                    sign_pipe(i+1) <= '0';
                else
                    if cordic_en = "01" then
                        -- Delay sign flag through same pipeline as X/Y/Z.
                        sign_pipe(i+1) <= sign_pipe(i);

                            -- If residual angle is positive, rotate one way.
                            -- shift_right(..., i) implements multiply by 2^-i.
                            if Z_pipe(i) >= 0 then
                                X_pipe(i+1) <= X_pipe(i) - shift_right(Y_pipe(i), i);
                                Y_pipe(i+1) <= Y_pipe(i) + shift_right(X_pipe(i), i);
                                Z_pipe(i+1) <= Z_pipe(i) - ATAN_LUT(i);

                            -- If residual angle is negative, rotate opposite way.
                            else
                                X_pipe(i+1) <= X_pipe(i) + shift_right(Y_pipe(i), i);
                                Y_pipe(i+1) <= Y_pipe(i) - shift_right(X_pipe(i), i);
                                Z_pipe(i+1) <= Z_pipe(i) + ATAN_LUT(i);
                            end if;
                    end if;
                end if;
            end if;
        end process;
    end generate;
    
    -- ====================================================
    -- OUTPUT + SIGN CORRECTION
    -- ====================================================
    -- Applies delayed sine sign and clips positive overflow.
    -- NOTE: Y_pipe is 32-bit, sine_reg is SAMPLE_WIDTH bits.
    -- The slice Y_pipe(15 downto 0) assumes the CORDIC output is already
    -- scaled to fit the final output width.
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sine_reg <= (others => '0');
            else
                if cordic_en = "01" then
                    if sign_pipe(N_ITER) = '1' then
                        -- Negative half-cycle.
                        -- If magnitude is above positive limit, clamp.
                        if Y_pipe(N_ITER) > to_signed(32767,32) then
                            sine_reg <= to_signed(32767, SAMPLE_WIDTH);           
                        else
                            sine_reg <= -Y_pipe(N_ITER)(15 downto 0);
                        end if;
                    else
                        -- Positive half-cycle.
                        -- Clamp if Y exceeds Q1.15 positive maximum.
                        if Y_pipe(N_ITER) > to_signed(32767,32) then
                            sine_reg <= to_signed(32767, SAMPLE_WIDTH);           
                        else
                            sine_reg <=  Y_pipe(N_ITER)(15 downto 0);
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    
    -- Generates a sample_valid pulse when sine generation is enabled.
    -- With ce_cnt = 19999 at 100 MHz, sample_valid pulses at 5 kHz.
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sample_valid <= '0';
                ce_cnt       <= (others => '0');
            else
                if cordic_en = "01" then
                    if ce_cnt = 19999 then
                        ce_cnt       <= (others => '0');
                        sample_valid <= '1'; -- 1-cycle pulse @ 5 kHz
                    else
                        ce_cnt <= ce_cnt + 1;
                        sample_valid <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- Drive module output from registered sine value.
    sample_out <= sine_reg;

end architecture;