--###########################################################################
-- top.vhd (UPDATED)
--  Top-level that instantiates:
--    1) sub_system_wrapper (MicroBlaze + AXI BRAM + UART + GPIO)
--    2) dsp_control
--    3) filter_coeffs
--    4) wave_gen (square wave)
--    5) sine_gen (CORDIC sine)
--    6) fir_filter
--    7) bram_writer (ping-pong half-buffer + wrap)
--###########################################################################

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_pkg.all;  -- sample_t, coef_array_t

entity top is
  port (
    i_clk     : in  std_logic;
    i_resetn  : in  std_logic;

    uart_rx_in  : in  std_logic;
    uart_tx_out : out std_logic
    -- Add extra FPGA pins here
  );
end entity top;

architecture rtl of top is

  ----------------------------------------------------------------------------
  -- BRAM Port B signals as exposed by the block design wrapper.
  -- These connect the PL-side BRAM writer to the AXI BRAM controller used
  -- by MicroBlaze. The writer stores raw/filtered samples into BRAM, and
  -- MicroBlaze later reads/dumps those samples over UART.
  ----------------------------------------------------------------------------
  signal bram_portb_addr : std_logic_vector(31 downto 0);
  signal bram_portb_din  : std_logic_vector(31 downto 0);
  signal bram_portb_dout : std_logic_vector(31 downto 0);
  signal bram_portb_en   : std_logic;
  signal bram_portb_we   : std_logic_vector(3 downto 0);
  signal bram_portb_clk  : std_logic;
  signal bram_portb_rst  : std_logic;

  -- Reset from block design, active-high inside PL.
  signal peripheral_reset : std_logic_vector(0 to 0);

  ----------------------------------------------------------------------------
  -- DSP control / configuration signals.
  -- ctrl_word and wave_divider are written by MicroBlaze through AXI GPIO.
  -- dsp_control decodes ctrl_word into cleaner internal control signals.
  ----------------------------------------------------------------------------
  signal ctrl_word       : std_logic_vector(31 downto 0);
  signal filter_sel      : unsigned(1 downto 0);
  signal wave_divider    : std_logic_vector(31 downto 0);

  -- wave_type selects which waveform generator is active.
  -- Current convention:
  --   "01" = sine / CORDIC
  --   "11" = square
  --   others = no waveform selected
  signal wave_type       : std_logic_vector(1 downto 0);

  -- Capture and pattern-mode controls passed to bram_writer.
  signal start_capture   : std_logic;
  signal pattern_mode    : std_logic;

  ----------------------------------------------------------------------------
  -- Waveform & filter signals.
  ----------------------------------------------------------------------------
  signal raw_sample  : sample_t;   -- selected waveform sample sent into FIR/BRAM
  signal sine_out    : sample_t;   -- output sample from sine generator
  signal square_out  : sample_t;   -- output sample from square generator

  signal raw_valid   : std_logic;  -- selected valid pulse sent into FIR/BRAM

  signal square_valid : std_logic; -- valid pulse from square generator
  signal sine_valid   : std_logic; -- valid pulse from sine generator

  signal filt_sample : sample_t;   -- FIR-filtered output sample
  signal filt_valid  : std_logic;  -- FIR output valid pulse

  signal coef_sig : coef_array_t;  -- selected FIR coefficient set

  ----------------------------------------------------------------------------
  -- BRAM writer handshake/status.
  -- The BRAM buffer is split into two halves. MicroBlaze reads each half and
  -- toggles ack0/ack1 to clear the corresponding full flag.
  ----------------------------------------------------------------------------
  signal ack0_tgl : std_logic := '0';  -- CPU toggle acknowledgement for lower half
  signal ack1_tgl : std_logic := '0';  -- CPU toggle acknowledgement for upper half
  signal full0    : std_logic;         -- lower half full flag
  signal full1    : std_logic;         -- upper half full flag
  signal wr_half  : std_logic;         -- current write half: 0=lower, 1=upper

  ----------------------------------------------------------------------------
  -- Debug / status to Vitis through GPIO inputs.
  -- Test_Point1 and Test_Point2 are read by MicroBlaze through AXI GPIO.
  ----------------------------------------------------------------------------
  signal Test_Point1 : std_logic_vector(31 downto 0);
  signal Test_Point2 : std_logic_vector(31 downto 0);

  -- Counts number of actual BRAM writes. Useful to confirm that data is being
  -- written into memory.
  signal write_cnt   : unsigned(31 downto 0) := (others => '0');

  -- Counts number of selected raw_valid pulses. Useful to confirm selected
  -- waveform sample-rate activity before BRAM write logic.
  signal write_cnt1  : unsigned(31 downto 0) := (others => '0');

  signal sys_clk : std_logic; -- clock output from block design

  ----------------------------------------------------------------------------
  -- Debug signals from BRAM writer.
  -- These are packed into Test_Point1 for MicroBlaze/Vitis readback.
  ----------------------------------------------------------------------------
  signal dbg_allow_write : std_logic;              -- high when writer is in write state
  signal dbg_addr_word   : std_logic_vector(31 downto 0); -- current BRAM word address
  signal dbg_capture_en  : std_logic;              -- internal capture enable inside writer
  signal dbg_block_full  : std_logic;              -- writer blocked because selected half is full

  -- Encoded BRAM writer FSM state.
  -- Expected values from bram_writer:
  --   x"00" = S_IDLE
  --   x"10" = S_WAIT
  --   x"11" = S_WRITE
  --   x"30" = S_BLOCKED
  signal dbg_state       : std_logic_vector(7 downto 0);

  -- Software reset bit and combined PL reset.
  signal soft_rst_r      : std_logic;
  signal pl_rst          : std_logic;

begin

  ----------------------------------------------------------------------------
  -- Block design wrapper (MicroBlaze system)
  -- Provides MicroBlaze, AXI BRAM, UART, GPIO, reset and clocking.
  ----------------------------------------------------------------------------
  u_subsystem : entity work.sub_system_wrapper
    port map (
      sys_clock    => i_clk,
      reset        => i_resetn,
      usb_uart_rxd => uart_rx_in,
      usb_uart_txd => uart_tx_out,

      BRAM_PORTB_addr => bram_portb_addr,
      BRAM_PORTB_din  => bram_portb_din,
      BRAM_PORTB_dout => bram_portb_dout,
      BRAM_PORTB_en   => bram_portb_en,
      BRAM_PORTB_we   => bram_portb_we,
      BRAM_PORTB_clk  => bram_portb_clk,
      BRAM_PORTB_rst  => bram_portb_rst,

      peripheral_reset_0 => peripheral_reset,

      -- CPU writes control word and divider via AXI GPIO
      ctrl_word_tri_o    => ctrl_word,
      wave_divider_tri_o => wave_divider,

      -- Debug/status signals back to CPU through AXI GPIO
      Test_Point_tri_i   => Test_Point1,
      Test_Point_2_tri_i => Test_Point2,

      clk_out1           => sys_clk
    );

  ----------------------------------------------------------------------------
  -- ACK toggles.
  -- MicroBlaze toggles these bits after dumping each BRAM half.
  ----------------------------------------------------------------------------
  ack0_tgl <= ctrl_word(16);
  ack1_tgl <= ctrl_word(17);

  ----------------------------------------------------------------------------
  -- DSP control decoder.
  -- Converts raw ctrl_word fields into filter select, waveform type,
  -- capture enable, and pattern mode.
  ----------------------------------------------------------------------------
  u_dsp_control : entity work.dsp_control
    port map (
      clk                  => sys_clk,
      rst                  => pl_rst,
      ctrl_word            => ctrl_word,
      filter_sel           => filter_sel,
      wave_type            => wave_type,
      start_capture        => start_capture,
      pattern_mode         => pattern_mode
    );

  ----------------------------------------------------------------------------
  -- Filter coefficient selector.
  -- Chooses one coefficient set based on filter_sel from dsp_control.
  ----------------------------------------------------------------------------
  u_filter_coeffs : entity work.filter_coeffs
    port map (
      clk      => sys_clk,
      sel      => filter_sel,
      coef_out => coef_sig
    );

  ----------------------------------------------------------------------------
  -- Square wave generator.
  -- wave_type is passed into the generator; inside wave_gen it runs when
  -- wave_type = "11".
  ----------------------------------------------------------------------------
  u_wave_gen : entity work.wave_gen
    port map (
      clk          => sys_clk,
      rst          => pl_rst,
      div_value    => unsigned(wave_divider),
      sample_out   => square_out,
      sample_valid => square_valid,
      square_en    => wave_type
    );

  ----------------------------------------------------------------------------
  -- Sine generator.
  -- wave_type is passed into the generator; inside sine_gen it runs when
  -- wave_type = "01".
  ----------------------------------------------------------------------------
  u_sine_gen : entity work.sine_gen
    port map (
      clk          => sys_clk,
      rst          => pl_rst,
      phase_step   => unsigned(wave_divider),
      sample_out   => sine_out,
      sample_valid => sine_valid,
      cordic_en    => wave_type
    );

  ----------------------------------------------------------------------------
  -- Waveform MUX.
  -- Selects only one waveform stream to feed the FIR and BRAM writer.
  -- The selected valid pulse is muxed with the selected sample.
  ----------------------------------------------------------------------------
  process(wave_type, sine_out, square_out, sine_valid, square_valid)
  begin
      if wave_type = "01" then
          -- Select sine wave path
          raw_sample <= sine_out;
          raw_valid  <= sine_valid;

      elsif wave_type = "11" then
          -- Select square wave path
          raw_sample <= square_out;
          raw_valid  <= square_valid;

      else
          -- No waveform selected
          raw_sample <= (others => '0');
          raw_valid  <= '0';
      end if;
  end process;

  ----------------------------------------------------------------------------
  -- FIR filter.
  -- Filters selected raw waveform stream.
  ----------------------------------------------------------------------------
  u_fir : entity work.fir_filter
    port map (
      clk     => sys_clk,
      rst     => pl_rst,
      x_in    => raw_sample,
      x_valid => raw_valid,
      coef    => coef_sig,
      y_out   => filt_sample,
      y_valid => filt_valid
    );

  ----------------------------------------------------------------------------
  -- BRAM writer.
  -- Stores packed {filtered sample, raw sample} into BRAM when capture is active.
  -- pattern_mode can override data with address-pattern writes for debugging.
  ----------------------------------------------------------------------------
  u_bram_writer : entity work.bram_writer
    port map (
      clk          => sys_clk,
      rst          => pl_rst,

      raw_sample   => raw_sample,
      filt_sample  => filt_sample,
      sample_valid => raw_valid,

      ack0_tgl     => ack0_tgl,
      ack1_tgl     => ack1_tgl,

      full0        => full0,
      full1        => full1,
      wr_half      => wr_half,

      bram_addr    => bram_portb_addr,
      bram_din     => bram_portb_din,
      bram_dout    => bram_portb_dout,
      bram_en      => bram_portb_en,
      bram_we      => bram_portb_we,

      start_capture => start_capture,
      pattern_mode  => pattern_mode,

      -- BRAM writer debug outputs
      dbg_state       => dbg_state,
      dbg_allow_write => dbg_allow_write,
      dbg_addr_word   => dbg_addr_word,
      dbg_capture_en  => dbg_capture_en,
      dbg_block_full  => dbg_block_full
    );

  ----------------------------------------------------------------------------
  -- Debug counters
  ----------------------------------------------------------------------------

  -- Counts actual BRAM write transactions.
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if peripheral_reset(0) = '1' then
        write_cnt <= (others => '0');
      else
        if (bram_portb_en = '1') and (bram_portb_we = "1111") then
          write_cnt <= write_cnt + 1;
        end if;
      end if;
    end if;
  end process;

  -- Counts selected raw_valid pulses.
  process(sys_clk)
  begin
    if rising_edge(sys_clk) then
      if peripheral_reset(0) = '1' then
        write_cnt1 <= (others => '0');
      else
        if (raw_valid = '1') then
          write_cnt1 <= write_cnt1 + 1;
        end if;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------
  -- Debug bus to MicroBlaze through GPIO.
  --
  -- Test_Point1 bit mapping:
  --   [31:24] = dbg_state
  --   [23:21] = reserved
  --   [20]    = ack1_tgl
  --   [19]    = ack0_tgl
  --   [18:8]  = bram_portb_addr(10 downto 0)
  --   [7]     = bram_portb_en
  --   [6]     = dbg_allow_write
  --   [5]     = raw_valid
  --   [4]     = filt_valid
  --   [3]     = dbg_capture_en
  --   [2]     = wr_half
  --   [1]     = full1
  --   [0]     = full0
  ----------------------------------------------------------------------------
  Test_Point1 <= dbg_state &
               (23 downto 21 => '0') &
               ack1_tgl &
               ack0_tgl &
               bram_portb_addr(10 downto 0) &
               bram_portb_en &
               dbg_allow_write &
               raw_valid &
               filt_valid &
               dbg_capture_en &
               wr_half &
               full1 &
               full0;

  -- Full BRAM address readback for debugging.
  Test_Point2 <= bram_portb_addr;

  -- Drive BRAM Port B clock from system clock.
  bram_portb_clk <= sys_clk;

  -- Software reset from ctrl_word bit 2.
  soft_rst_r <= ctrl_word(2);

  -- Combined PL reset: block design reset OR software reset.
  pl_rst <= peripheral_reset(0) or soft_rst_r;

end architecture rtl;