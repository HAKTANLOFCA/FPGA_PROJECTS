

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity top is

Port ( clk : in STD_LOGIC; 
       reset_btnl: in std_logic;
       uart_rx : in STD_LOGIC;
       uart_tx : out STD_LOGIC 
       );
end top;

architecture Behavioral of top is



-- UART Tx
--    signal tx_en : STD_LOGIC:='0';
    signal exit_control : STD_LOGIC;
--    signal tx_data_in : STD_LOGIC_VECTOR(7 downto 0);
signal tx_en : STD_LOGIC:='0';
    signal tx_busy : STD_LOGIC;
    signal tx_data_in : STD_LOGIC_VECTOR(7 downto 0);
    signal reset : STD_LOGIC := '1';
--    signal reset : STD_LOGIC := '0';
    
     -- UART RX
--     signal reset_rx : STD_LOGIC := '0';
    signal rx_busy : STD_LOGIC := '0';
    signal received_word : STD_LOGIC_VECTOR(7 downto 0);
    signal rdy : STD_LOGIC;
   

    
constant  c_clkfreq		: integer := 100_000_000;
 constant  c_baudrate		: integer := 9600;
constant c_stopbit		: integer := 1;
    signal str_index : integer range 0 to 7 := 0;
    
    
    signal cntrl : STD_LOGIC := '0';
component uart_tx_module is
generic (
c_clkfreq		: integer := 100_000_000;
c_baudrate		: integer := 9600;
c_stopbit		: integer := 1
);
port (
clk				: in std_logic;
din_i			: in std_logic_vector (7 downto 0);
tx_start_i		: in std_logic;
tx_o			: out std_logic;
tx_done_tick_o	: out std_logic
);
end component;





component UART_RX_MODULE is

port(
clk:in std_logic; -- clock girişimi atadım
rst:in std_logic; -- reset girişimi atadım
rx_i:in std_logic; -- rx girişimi atadım
data_out:out std_logic_vector(7 downto 0); -- data çıkışını atadım
rx_exit_control:out std_logic -- gönderme işleminin bittiğini anlamak için bu çıkışı oluşturdum


);
end component;
type CHAR_ARRAY is array (integer range<>) of std_logic_vector(7 downto 0);
    constant WELCOME_STRING : CHAR_ARRAY(0 to 6) := (
                                                    X"48", -- H
                                                    X"65", -- e
                                                    X"6C", -- l
                                                    X"6C", -- l
                                                    X"6F", -- o
                                                    X"0A", -- \n
                                                    X"0D"  -- \r
                                                  );
begin
uart_tx_inst : uart_tx_module 
generic map (
c_clkfreq		=> c_clkfreq,	
c_baudrate		=> c_baudrate	,
c_stopbit		=> c_stopbit	
)
port map(
clk				=> clk,
din_i			=> tx_data_in,
tx_start_i		=> tx_en,
tx_o			=> uart_tx,
tx_done_tick_o	=> exit_control
);

uart_rx_inst:uart_rx_module

port map(

clk => clk,
    rx_i => uart_rx,
    rst  => reset_btnl,
    
    rx_exit_control => rdy,
    data_out => received_word


);

process(clk) 
begin
if rising_edge(clk) then

    case (cntrl) is
    
        when '0' => if tx_en = '0'and exit_control = '0'  and str_index < 7 then -- Ready to transmit
                        tx_en <= '1';
                        tx_data_in <= WELCOME_STRING(str_index);
                        str_index <= str_index + 1;
                    elsif str_index = 7 then
                        cntrl <= '1'; -- Switch to echo 
                    else
                        tx_en <= '0';
                    end if;
        
        when '1' => if rdy = '1' then
                        tx_en <= '1';
                        tx_data_in <= received_word;
                    else
                        tx_en <= '0';
                    end if;
        when others =>
    end case;

end if;
end process;
end Behavioral;
