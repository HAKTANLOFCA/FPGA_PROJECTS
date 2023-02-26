

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity TOP is
    Port ( 
        S_OUT : out std_logic_vector (6 downto 0);
               
    		   AN_out : out std_logic_vector(3 downto 0);
               clk    :in std_logic;
               
    button:in std_logic_vector(3 downto 0 );
               sw : in std_logic_vector(7 downto 0)
    
    );
end TOP;

architecture Behavioral of TOP is

signal p1:std_logic_vector(19 downto 0);
signal b1:std_logic_vector(3 downto 0);
signal t1:std_logic_vector(3 downto 0);
signal h1:std_logic_vector(3 downto 0);
signal j1:std_logic_vector(3 downto 0);
signal sw1:std_logic_vector(15 downto 0);

signal cntrl : std_logic:='1';
component seven_segment is
    Port ( SEG_OUT : out std_logic_vector (6 downto 0);
           
		   en_out : out std_logic_vector(3 downto 0);
           clk    :in std_logic;
           

                      select_i1 : in std_logic_vector(3 downto 0);
                      select_i2 : in std_logic_vector(3 downto 0);
                       select_i3 : in std_logic_vector(3 downto 0);
                       select_i4 : in std_logic_vector(3 downto 0)
           );
end component;

component display1 is
   port(
   b2 : in std_logic_vector(15 downto 0);
   p1 : out std_logic_vector(19 downto 0)
   );
   
   
  
end component;
begin

process(clk) begin
if rising_edge(clk) then
b1 <=   p1(15 downto 12);
                t1  <=  p1(11 downto 8);
                h1  <=  p1(7 downto 4);
                j1  <=  p1(3 downto 0);
    case (cntrl) is
    
        when '0' => 
                     if button = "0001" then 
                     sw1 <= "00000001" * sw;
                     elsif button = "0010" then 
                     sw1 <= "00000010" * sw;
                     elsif button = "0011" then 
                     sw1 <= "00000011" * sw;
                     elsif button = "0100" then 
                     sw1 <= "00000100" * sw;
                     elsif button = "0101" then 
                     sw1 <= "00000101" * sw;
                     elsif button = "0110" then 
                     sw1 <= "00000110" * sw;
                     elsif button = "0111" then
                     sw1 <= "00000111" * sw; 
                     elsif button = "1000" then
                     sw1 <= "00001000" * sw; 
                     elsif button = "1001" then
                     sw1 <= "00001001" * sw; 
                     elsif button = "1010" then
                     sw1 <= "00001010" * sw; 
                     elsif button = "1011" then
                     sw1 <= "00001011" * sw; 
                     elsif button = "1100" then
                     sw1 <= "00001100" * sw; 
                     elsif button = "1101" then 
                     sw1 <= "00001101" * sw;
                     elsif button = "1110" then 
                     sw1 <= "00001110" * sw;
                    elsif button = "1111" then 
                     sw1 <= "00001111" * sw;
               else
                    cntrl <= '1';
                    end if; 
        when '1' => if button = "0000" then
                    sw1 <= "00000000" & sw;                       
                                       else
                                           cntrl <= '0';
                                       end if;
               
                
        
        
                        
                        
        when others =>
    end case;

end if;
end process;



I_seven_segment:seven_segment


port map(
        SEG_OUT =>S_OUT,
        en_out => AN_out,
        clk     =>  clk,
        select_i1  => b1,
        select_i2   => t1,
        select_i3    => h1,
        select_i4    => j1
);
I_display:display1
port map(
    b2 =>  sw1,
    p1 => p1


);

end Behavioral;
