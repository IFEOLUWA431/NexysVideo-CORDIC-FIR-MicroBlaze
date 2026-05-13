library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fir_pkg.all;

--###########################################################################
-- bram_writer.vhd
--
-- Writes raw and filtered samples into AXI BRAM using a ping-pong buffer.
--
-- BRAM layout:
--   Total words : 2048
--   Lower half  : words 0    to 1023
--   Upper half  : words 1024 to 2047
--
-- Each 32-bit BRAM word stores:
--
--   [31:16] = filt_sample
--   [15:0]  = raw_sample
--
-- In pattern_mode, the BRAM word address is written as data instead.
-- This is useful for checking BRAM write/read ordering from MicroBlaze.
--
-- The writer stops when the active half becomes full. MicroBlaze clears
-- full flags by toggling ack0_tgl or ack1_tgl.
--###########################################################################

entity bram_writer is
  port (
    -------------------------------------------------------------------------
    -- Clock and reset.
    -------------------------------------------------------------------------
    clk   : in  std_logic;
    rst   : in  std_logic;

    -------------------------------------------------------------------------
    -- Input sample stream.
    -------------------------------------------------------------------------
    raw_sample   : in  sample_t;  -- unfiltered selected waveform sample
    filt_sample  : in  sample_t;  -- FIR-filtered sample
    sample_valid : in  std_logic; -- 1-clock pulse when sample is valid

    -------------------------------------------------------------------------
    -- CPU acknowledgement toggles.
    -- MicroBlaze toggles these after reading/dumping each BRAM half.
    -------------------------------------------------------------------------
    ack0_tgl : in  std_logic; -- clears full0 when toggled
    ack1_tgl : in  std_logic; -- clears full1 when toggled

    -------------------------------------------------------------------------
    -- Ping-pong buffer status.
    -------------------------------------------------------------------------
    full0   : out std_logic; -- lower half full
    full1   : out std_logic; -- upper half full
    wr_half : out std_logic; -- current write half: 0=lower, 1=upper

    -------------------------------------------------------------------------
    -- AXI BRAM Port B style interface.
    -------------------------------------------------------------------------
    bram_addr : out std_logic_vector(31 downto 0); -- byte address
    bram_din  : out std_logic_vector(31 downto 0); -- write data
    bram_dout : in  std_logic_vector(31 downto 0); -- unused read data
    bram_en   : out std_logic;                     -- BRAM enable
    bram_we   : out std_logic_vector(3 downto 0);  -- byte write enable

    -------------------------------------------------------------------------
    -- Capture controls.
    -------------------------------------------------------------------------
    start_capture   : in  std_logic; -- capture enable level
    pattern_mode    : in  std_logic; -- when 1, write address pattern

    -------------------------------------------------------------------------
    -- Debug outputs to top-level GPIO readback.
    -------------------------------------------------------------------------
    dbg_state       : out std_logic_vector(7 downto 0);  -- encoded FSM state
    dbg_allow_write : out std_logic;                     -- high in S_WRITE
    dbg_addr_word   : out std_logic_vector(31 downto 0); -- current word address
    dbg_capture_en  : out std_logic;                     -- registered capture enable
    dbg_block_full  : out std_logic                      -- active half is full
  );
end entity;

architecture rtl of bram_writer is

  ---------------------------------------------------------------------------
  -- Buffer sizing.
  ---------------------------------------------------------------------------
  constant BRAM_WORDS : integer := 2048;
  constant HALF_WORDS : integer := 1024;

  ---------------------------------------------------------------------------
  -- Last valid word addresses.
  ---------------------------------------------------------------------------
  constant LAST_ADDR  : unsigned(31 downto 0) := to_unsigned(BRAM_WORDS-1, 32);
  constant HALF_LAST0 : unsigned(31 downto 0) := to_unsigned(HALF_WORDS-1, 32);

  ---------------------------------------------------------------------------
  -- FSM states.
  --
  -- S_IDLE    : capture not yet active / initial state
  -- S_WAIT    : waiting for sample_valid or pattern write condition
  -- S_WRITE   : performs one BRAM write
  -- S_BLOCKED : active BRAM half is full; wait for CPU acknowledgement
  ---------------------------------------------------------------------------
  type state_t is (S_IDLE, S_WAIT, S_WRITE, S_BLOCKED);
  signal state_r : state_t := S_IDLE;

  ---------------------------------------------------------------------------
  -- Word address counter.
  -- This is a BRAM word index, not a byte address.
  -- bram_addr is generated by shifting this left by 2.
  ---------------------------------------------------------------------------
  signal addr_word : unsigned(31 downto 0) := (others => '0');

  ---------------------------------------------------------------------------
  -- Registered full flags and current write half.
  ---------------------------------------------------------------------------
  signal full0_r   : std_logic := '0';
  signal full1_r   : std_logic := '0';
  signal wr_half_r : std_logic := '0';

  ---------------------------------------------------------------------------
  -- Previous acknowledgement toggle values for edge detection.
  ---------------------------------------------------------------------------
  signal ack0_prev : std_logic := '0';
  signal ack1_prev : std_logic := '0';

  ---------------------------------------------------------------------------
  -- Registered control bits.
  -- These are sampled from input controls and take effect on the next clock.
  ---------------------------------------------------------------------------
  signal capture_en_r   : std_logic := '0';
  signal pattern_mode_r : std_logic := '0';

  ---------------------------------------------------------------------------
  -- Indicates that the currently selected write half is already full.
  ---------------------------------------------------------------------------
  signal blocked_full : std_logic;

  ---------------------------------------------------------------------------
  -- Data word sent to BRAM.
  ---------------------------------------------------------------------------
  signal din_word : std_logic_vector(31 downto 0);

begin

  ---------------------------------------------------------------------------
  -- Status output assignments.
  ---------------------------------------------------------------------------
  full0   <= full0_r;
  full1   <= full1_r;
  wr_half <= wr_half_r;

  ---------------------------------------------------------------------------
  -- Debug output assignments.
  ---------------------------------------------------------------------------
  dbg_capture_en  <= capture_en_r;
  dbg_addr_word   <= std_logic_vector(addr_word);
  dbg_block_full  <= blocked_full;
  dbg_allow_write <= '1' when (state_r = S_WRITE) else '0';

  ---------------------------------------------------------------------------
  -- Encoded FSM state for GPIO/debug readback.
  ---------------------------------------------------------------------------
  with state_r select
    dbg_state <= x"00" when S_IDLE,
                 x"10" when S_WAIT,
                 x"11" when S_WRITE,
                 x"30" when S_BLOCKED,
                 x"FF" when others;

  ---------------------------------------------------------------------------
  -- Active-half full detector.
  --
  -- If currently writing lower half and full0 is set, writer must block.
  -- If currently writing upper half and full1 is set, writer must block.
  ---------------------------------------------------------------------------
  blocked_full <= '1' when (wr_half_r='0' and full0_r='1') or
                           (wr_half_r='1' and full1_r='1')
                  else '0';

  ---------------------------------------------------------------------------
  -- BRAM write data mux.
  --
  -- Normal mode:
  --   upper 16 bits = filtered sample
  --   lower 16 bits = raw sample
  --
  -- Pattern mode:
  --   write current address word as visible test pattern.
  ---------------------------------------------------------------------------
  din_word <= std_logic_vector(addr_word) when (pattern_mode_r='1') else
              (std_logic_vector(filt_sample) & std_logic_vector(raw_sample));

  ---------------------------------------------------------------------------
  -- Main BRAM writer FSM.
  ---------------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then

      -----------------------------------------------------------------------
      -- Reset state.
      -----------------------------------------------------------------------
      if rst = '1' then
        state_r <= S_IDLE;
        addr_word <= (others => '0');

        full0_r <= '0';
        full1_r <= '0';
        wr_half_r <= '0';

        ack0_prev <= ack0_tgl;
        ack1_prev <= ack1_tgl;

        capture_en_r   <= '0';
        pattern_mode_r <= '0';

        bram_en   <= '0';
        bram_we   <= (others => '0');
        bram_addr <= (others => '0');
        bram_din  <= (others => '0');

      else

        ---------------------------------------------------------------------
        -- Register control inputs.
        -- These take effect in following cycles.
        ---------------------------------------------------------------------
        capture_en_r   <= start_capture;
        pattern_mode_r <= pattern_mode;
        
        ---------------------------------------------------------------------
        -- Default BRAM outputs.
        -- Write enable is only asserted during S_WRITE.
        ---------------------------------------------------------------------
        bram_en <= '0';
        bram_we <= (others => '0');

        ---------------------------------------------------------------------
        -- Acknowledgement edge detection.
        -- Toggling ack clears the corresponding full flag.
        ---------------------------------------------------------------------
        if ack0_tgl /= ack0_prev then
          full0_r <= '0';
        end if;

        if ack1_tgl /= ack1_prev then
          full1_r <= '0';
        end if;

        ack0_prev <= ack0_tgl;
        ack1_prev <= ack1_tgl;

        ---------------------------------------------------------------------
        -- If capture is disabled, reset buffer pointer and full flags.
        -- This prepares the BRAM writer for a clean new capture.
        ---------------------------------------------------------------------
        if capture_en_r = '0' then
          state_r   <= S_IDLE;
          addr_word <= (others => '0');
          wr_half_r <= '0';
          full0_r   <= '0';
          full1_r   <= '0';

        else

          -------------------------------------------------------------------
          -- Update current write half based on address.
          -------------------------------------------------------------------
          if addr_word <= HALF_LAST0 then
            wr_half_r <= '0';
          else
            wr_half_r <= '1';
          end if;

          -------------------------------------------------------------------
          -- FSM next-state logic.
          -------------------------------------------------------------------
          case state_r is

            when S_IDLE =>
              -- Move into wait state once capture is enabled.
              state_r <= S_WAIT;

            when S_WAIT =>
              -- If active half is full, pause writing.
              if blocked_full = '1' then
                state_r <= S_BLOCKED;

              else
                -- Normal mode writes only when sample_valid is high.
                -- Pattern mode writes continuously for address-pattern testing.
                if (pattern_mode_r = '1') or (sample_valid = '1') then
                  state_r <= S_WRITE;
                end if;
              end if;

            when S_WRITE =>
              -- One write cycle only, then return to wait.
              state_r <= S_WAIT;

            when S_BLOCKED =>
              -- Wait here until CPU clears the corresponding full flag.
              if blocked_full = '0' then
                state_r <= S_WAIT;
              end if;

            when others =>
              state_r <= S_IDLE;

          end case;

          -------------------------------------------------------------------
          -- BRAM write transaction.
          --
          -- This executes when current state is S_WRITE.
          -- Because state_r is registered, this write occurs one clock after
          -- S_WAIT decides to enter S_WRITE.
          -------------------------------------------------------------------
          if state_r = S_WRITE then
            bram_en   <= '1';
            bram_we   <= "1111";

            -- AXI BRAM uses byte addressing, so word address is multiplied by 4.
            bram_addr <= std_logic_vector(shift_left(addr_word, 2));

            -- Write selected data word.
            bram_din  <= din_word;

            ---------------------------------------------------------------
            -- Set full flag when reaching end of each half.
            ---------------------------------------------------------------
            if addr_word = HALF_LAST0 then
              full0_r <= '1';

            elsif addr_word = LAST_ADDR then
              full1_r <= '1';
            end if;

            ---------------------------------------------------------------
            -- Increment address, wrapping after final BRAM word.
            ---------------------------------------------------------------
            if addr_word = LAST_ADDR then
              addr_word <= (others => '0');
            else
              addr_word <= addr_word + 1;
            end if;
          end if;

        end if;
      end if;
    end if;
  end process;

end architecture;