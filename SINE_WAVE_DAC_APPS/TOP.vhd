
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;

ENTITY top IS
  GENERIC(
    clk_freq    : INTEGER := 100;  --system clock frequency in MHz
    spi_clk_div : INTEGER := 5);  --spi_clk_div = clk_freq/100 (answer rounded up)
  PORT(
    clk             : IN      STD_LOGIC;                      --system clock
    reset_n         : IN      STD_LOGIC;                      --active low asynchronous reset
    
    mosi_o          : OUT    STD_LOGIC; 
    sclk            : BUFFER  STD_LOGIC;                      --SPI bus to DPOT: serial clock (SCLK)
    ss_n            : BUFFER  STD_LOGIC_VECTOR(0 DOWNTO 0));  --SPI bus to DPOT: slave select (~SYNC)
END top;

ARCHITECTURE behavior OF top IS
  TYPE machine IS(start, pause, ready, send_data);            --needed states
  SIGNAL state         : machine := start;                    --state machine
  SIGNAL spi_busy_prev : STD_LOGIC;                           --previous value of the SPI component's busy signal
  SIGNAL spi_busy      : STD_LOGIC;                           --busy signal from SPI component
  SIGNAL spi_ena       : STD_LOGIC;                           --enable for SPI component
  SIGNAL spi_tx_data   : STD_LOGIC_VECTOR(23 DOWNTO 0);       --transmit data for SPI component
  SIGNAL sine_data       : STD_LOGIC_VECTOR(15 DOWNTO 0);
  SIGNAL   update_output_n :       STD_LOGIC;                      --controls updating of DAC output
  SIGNAL   busy            :      STD_LOGIC;                      --indicates when transactions with DAC can be initiated
  SIGNAL   ldac_n          :      STD_LOGIC;        

  SIGNAL period_data_int : integer;
  SIGNAL period_data : std_logic_vector(15 downto 0);
  
  component sine_lut is
     Port
          (
             clk      :     in   STD_LOGIC;
             rst      :     in   STD_LOGIC;
             period   :     in   integer;       
             sine     :     out  STD_LOGIC_VECTOR(15 downto 0)
         );
end component;

component vio_0 IS
PORT (
CLK : IN STD_LOGIC;

probe_out0 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000"
);
END component;

  COMPONENT spi_master IS
    GENERIC(
      slaves  : INTEGER := 1;   --number of spi slaves
      d_width : INTEGER := 24);  --data bus width
    PORT(
      clock   : IN     STD_LOGIC;                             --system clock
      reset_n : IN     STD_LOGIC;                             --asynchronous reset
      enable  : IN     STD_LOGIC;                             --initiate transaction
      cpol    : IN     STD_LOGIC;                             --spi clock polarity
      cpha    : IN     STD_LOGIC;                             --spi clock phase
      cont    : IN     STD_LOGIC;                             --continuous mode command
      clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
      addr    : IN     INTEGER;                               --address of slave
      tx_data : IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
      miso    : IN     STD_LOGIC;                             --master in, slave out
      sclk    : BUFFER STD_LOGIC;                             --spi clock
      ss_n    : BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
      mosi    : OUT    STD_LOGIC;                             --master out, slave in
      busy    : OUT    STD_LOGIC;                             --busy / data ready signal
      rx_data : OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
  END COMPONENT spi_master;

BEGIN
period_data_int <=to_integer(unsigned(period_data));
sine_lut_0:  sine_lut
 
 port map(
 
 clk        =>     clk,
 rst        =>     reset_n,
 period     =>     period_data_int,
 sine       =>     sine_data
 
 );
 vio_inst: vio_0
port map(
clk        =>     clk,
probe_out0 =>     period_data


);

  --instantiate the SPI Master component
  spi_master_0:  spi_master
    GENERIC MAP(slaves  =>     1, 
                d_width =>     24)
    PORT MAP(   clock   =>     clk, 
                reset_n =>     reset_n, 
                enable  =>     spi_ena, 
                cpol    =>     '1', 
                cpha    =>     '0',
                cont    =>     '0', 
                clk_div =>     spi_clk_div, 
                addr    =>     0, 
                tx_data =>     spi_tx_data, 
                miso    =>     '0',
                sclk    =>     sclk, 
                ss_n    =>     ss_n, 
                mosi    =>     mosi_o, 
                busy    =>     spi_busy, 
                rx_data =>     open);

  ldac_n <= update_output_n;  --'0' updates the DAC output with the latest value sent to the DAC
  PROCESS(clk, reset_n)
    VARIABLE count : INTEGER RANGE 0 TO clk_freq*100 := 0; --counter
  BEGIN
  
    IF(reset_n = '0') THEN              --reset activated
      spi_ena <= '0';                     --clear SPI component enable
      spi_tx_data <= (OTHERS => '0');     --clear SPI component transmit data
      busy <= '1';                        --indication component is unavailable
      state <= start;                     --restart state machine
    ELSIF(clk'EVENT AND clk = '1') THEN --rising edge of system clock

      spi_busy_prev <= spi_busy;          --collect previous spi_busy
   
      CASE state IS                       --state machine

        --entry state, give DPOT 100us to power up before communicating
        WHEN start =>
          busy <= '1';                    --component is busy, DPOT not yet available
          IF(count < clk_freq*100) THEN   --100us not yet reached
            count := count + 1;             --increment counter
          ELSE                            --100us reached
            count := 0;                     --clear counter
            state <= pause;                 --advance to operating states
          END IF;

        --pauses 40ns between SPI transactions
        WHEN pause =>
          IF(count < clk_freq/10) THEN    --less than 100ns
            count := count + 1;             --increment counter
          ELSE                            --100ns has elapsed
            count := 0;                     --clear counter
            busy <= '0';                    --indicate component is ready for a transaction
            state <= ready;                 --advance to ready state 
          END IF;
        
        --wait for a new transaction and latch it in
        WHEN ready =>
            spi_tx_data <= "01" & sine_data(15 downto 0) & "000000" ;       --latch in data stream to send
            busy <= '1';                    --indicate transaction is in progress
            state <= send_data;             --advance to sending transaction

        --performs SPI transaction to DPOT  
        WHEN send_data =>
          IF(spi_busy = '0' AND spi_busy_prev = '0') THEN  --transaction not started
            spi_ena <= '1';                                  --enable SPI transaction

          ELSIF(spi_busy = '1') THEN                       --transaction underway
            spi_ena <= '0';                                  --clear enable                            
          ELSE                                             --transaction complete
            state <= pause;                                  --return to pause state
          END IF;

        WHEN OTHERS => 
          state <= start;

      END CASE;      
    END IF;
  END PROCESS;
END behavior;
