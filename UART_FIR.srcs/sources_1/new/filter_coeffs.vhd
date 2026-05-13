library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_pkg.all;   -- SAMPLE_WIDTH, N_TAPS, sample_t, coef_array_t

entity filter_coeffs is
    port (
        clk      : in  std_logic;
        sel      : in  unsigned(1 downto 0); -- 00=LP, 01=HP, 10=BP, 11=BS
        coef_out : out coef_array_t
    );
end entity;

architecture rtl of filter_coeffs is

    -------------------------------------------------------------------------
    -- 16-tap LOW-PASS FIR  (Cutoff ≈ 0.15 * Fs)
    -------------------------------------------------------------------------
    constant LP_COEF : coef_array_t := (
        to_signed(   256, SAMPLE_WIDTH),
        to_signed(   512, SAMPLE_WIDTH),
        to_signed(  1024, SAMPLE_WIDTH),
        to_signed(  2048, SAMPLE_WIDTH),
        to_signed(  4096, SAMPLE_WIDTH),
        to_signed(  4096, SAMPLE_WIDTH),
        to_signed(  2048, SAMPLE_WIDTH),
        to_signed(  1024, SAMPLE_WIDTH),
        to_signed(  1024, SAMPLE_WIDTH),
        to_signed(  2048, SAMPLE_WIDTH),
        to_signed(  4096, SAMPLE_WIDTH),
        to_signed(  4096, SAMPLE_WIDTH),
        to_signed(  2048, SAMPLE_WIDTH),
        to_signed(  1024, SAMPLE_WIDTH),
        to_signed(   512, SAMPLE_WIDTH),
        to_signed(   256, SAMPLE_WIDTH)
    );

    -------------------------------------------------------------------------
    -- 16-tap HIGH-PASS FIR  (Cutoff ≈ 0.20 * Fs)
    -------------------------------------------------------------------------
    -- Generated from LP kernel using hp[n] = delta[n] - lp[n]
    -------------------------------------------------------------------------
    constant HP_COEF : coef_array_t := (
        to_signed(  -256, SAMPLE_WIDTH),
        to_signed(  -512, SAMPLE_WIDTH),
        to_signed( -1024, SAMPLE_WIDTH),
        to_signed( -2048, SAMPLE_WIDTH),
        to_signed( -4096, SAMPLE_WIDTH),
        to_signed( -4096, SAMPLE_WIDTH),
        to_signed( -2048, SAMPLE_WIDTH),
        to_signed( -1024, SAMPLE_WIDTH),
        to_signed( 32767 - 1024, SAMPLE_WIDTH),   -- impulse at center tap
        to_signed( -2048, SAMPLE_WIDTH),
        to_signed( -4096, SAMPLE_WIDTH),
        to_signed( -4096, SAMPLE_WIDTH),
        to_signed( -2048, SAMPLE_WIDTH),
        to_signed( -1024, SAMPLE_WIDTH),
        to_signed(  -512, SAMPLE_WIDTH),
        to_signed(  -256, SAMPLE_WIDTH)
    );

    -------------------------------------------------------------------------
    -- 16-tap BAND-PASS FIR  (~0.15-0.35 * Fs)
    -------------------------------------------------------------------------
    -- Designed by subtracting two LP filters (LP(0.35) - LP(0.15))
    -------------------------------------------------------------------------
    constant BP_COEF : coef_array_t := (
        to_signed(  -120, SAMPLE_WIDTH),
        to_signed(  -256, SAMPLE_WIDTH),
        to_signed(  -160, SAMPLE_WIDTH),
        to_signed(   480, SAMPLE_WIDTH),
        to_signed(  2800, SAMPLE_WIDTH),
        to_signed(  5400, SAMPLE_WIDTH),
        to_signed(  7200, SAMPLE_WIDTH),
        to_signed(  7100, SAMPLE_WIDTH),
        to_signed(  7100, SAMPLE_WIDTH),
        to_signed(  7200, SAMPLE_WIDTH),
        to_signed(  5400, SAMPLE_WIDTH),
        to_signed(  2800, SAMPLE_WIDTH),
        to_signed(   480, SAMPLE_WIDTH),
        to_signed(  -160, SAMPLE_WIDTH),
        to_signed(  -256, SAMPLE_WIDTH),
        to_signed(  -120, SAMPLE_WIDTH)
    );

    -------------------------------------------------------------------------
    -- 16-tap BAND-STOP / NOTCH FIR  (~0.20-0.30 * Fs)
    -------------------------------------------------------------------------
    -- Designed by hp1 + lp1 (LP below notch + LP above notch)
    -------------------------------------------------------------------------
    constant BS_COEF : coef_array_t := (
        to_signed(   200, SAMPLE_WIDTH),
        to_signed(   280, SAMPLE_WIDTH),
        to_signed(   160, SAMPLE_WIDTH),
        to_signed(  -400, SAMPLE_WIDTH),
        to_signed( -2600, SAMPLE_WIDTH),
        to_signed( -5100, SAMPLE_WIDTH),
        to_signed( -6800, SAMPLE_WIDTH),
        to_signed( 25000, SAMPLE_WIDTH),  -- center tap boost (delta function)
        to_signed( 25000, SAMPLE_WIDTH),
        to_signed( -6800, SAMPLE_WIDTH),
        to_signed( -5100, SAMPLE_WIDTH),
        to_signed( -2600, SAMPLE_WIDTH),
        to_signed(  -400, SAMPLE_WIDTH),
        to_signed(   160, SAMPLE_WIDTH),
        to_signed(   280, SAMPLE_WIDTH),
        to_signed(   200, SAMPLE_WIDTH)
    );

    signal coef_reg : coef_array_t;

begin

    -------------------------------------------------------------------------
    -- Coefficient selector
    -------------------------------------------------------------------------
    process(clk)
    begin
        if rising_edge(clk) then
            case sel is
                when "00" => coef_reg <= LP_COEF; -- Low-pass
                when "01" => coef_reg <= HP_COEF; -- High-pass
                when "10" => coef_reg <= BP_COEF; -- Band-pass
                when others => coef_reg <= BS_COEF; -- Band-stop / Notch
            end case;
        end if;
    end process;

    coef_out <= coef_reg;

end architecture;
