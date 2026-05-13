library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_pkg.all;

entity tb_wave_select is
end entity;

architecture sim of tb_wave_select is

    constant CLK_PERIOD : time := 10 ns; -- 100 MHz

    -- Sine frequency:
    -- phase_step = fout * 2^32 / fclk
    -- 100 Hz = 4295
    constant PHASE_STEP_100HZ : unsigned(31 downto 0) := to_unsigned(4294967, 32);

    -- Square frequency:
    -- square toggles every div_value clocks
    -- fout = fclk / (2 * div_value)
    -- 100 Hz = 100e6 / (2*100) = 500000
    constant DIV_100HZ : unsigned(31 downto 0) := to_unsigned(1000, 32);

    signal clk : std_logic := '0';
    signal rst : std_logic := '1';

    signal ctrl_word : std_logic_vector(1 downto 0) := "00";
    -- ctrl_word(0) = sine enable
    -- ctrl_word(1) = square enable

    signal cordic_en : std_logic;
    signal square_en : std_logic;

    signal phase_step : unsigned(31 downto 0) := (others => '0');
    signal div_value  : unsigned(31 downto 0) := (others => '0');

    signal sine_out   : sample_t;
    signal square_out : sample_t;

    signal sine_valid   : std_logic;
    signal square_valid : std_logic;

    signal sample_out   : sample_t;
    signal sample_valid : std_logic;

begin

    clk <= not clk after CLK_PERIOD/2;

    -- Mutually exclusive enables
    cordic_en <= ctrl_word(0) and not ctrl_word(1);
    square_en <= ctrl_word(1) and not ctrl_word(0);

    -- SINE DUT
    uut_sine : entity work.sine_gen
        port map (
            clk          => clk,
            rst          => rst,
            phase_step   => phase_step,
            sample_out   => sine_out,
            sample_valid => sine_valid,
            cordic_en    => cordic_en
        );

    -- SQUARE DUT
    uut_square : entity work.wave_gen
        port map (
            clk          => clk,
            rst          => rst,
            div_value    => div_value,
            sample_out   => square_out,
            sample_valid => square_valid,
            square_en    => square_en
        );

    -- Output mux
    process(cordic_en, square_en, sine_out, square_out, sine_valid, square_valid)
    begin
        if cordic_en = '1' then
            sample_out   <= sine_out;
            sample_valid <= sine_valid;

        elsif square_en = '1' then
            sample_out   <= square_out;
            sample_valid <= square_valid;

        else
            sample_out   <= (others => '0');
            sample_valid <= '0';
        end if;
    end process;

    -- Stimulus
    process
    begin
        ----------------------------------------------------
        -- Configure for sine while held in reset
        ----------------------------------------------------
        rst <= '1';
        ctrl_word  <= "00";
        phase_step <= PHASE_STEP_100HZ;
        div_value  <= DIV_100HZ;

        wait for 200 ns;

        ctrl_word <= "01"; -- sine only
        wait for 100 ns;

        rst <= '0';

        wait for 1 ms;

        ----------------------------------------------------
        -- Switch to square: hold reset, change control word
        ----------------------------------------------------
        rst <= '1';
        ctrl_word <= "00";

        wait for 200 ns;

        phase_step <= PHASE_STEP_100HZ;
        div_value  <= DIV_100HZ;
        ctrl_word  <= "10"; -- square only

        wait for 100 ns;

        rst <= '0';

        wait for 1 ms;

        ----------------------------------------------------
        -- Disable both
        ----------------------------------------------------
        rst <= '1';
        ctrl_word <= "00";

        wait for 1 us;

        assert false report "Simulation finished" severity failure;
    end process;

    -- Monitor
    process(clk)
        variable count : integer := 0;
    begin
        if rising_edge(clk) then
            count := count + 1;

            if sample_valid = '1' then
                report "sample_out = " & integer'image(to_integer(sample_out));
            end if;
        end if;
    end process;

end architecture;