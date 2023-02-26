
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity seven_segment is
    Port ( SEG_OUT : out std_logic_vector (6 downto 0);
           
		   en_out : out std_logic_vector(3 downto 0);
           clk    :in std_logic;
           

           select_i1 : in std_logic_vector(3 downto 0);
           select_i2 : in std_logic_vector(3 downto 0);
            select_i3 : in std_logic_vector(3 downto 0);
            select_i4 : in std_logic_vector(3 downto 0)
           );
end seven_segment;

-- Declare the architecture for the seven segment display
architecture Behavioral of seven_segment is
signal count2: integer range 0 to 50_000_000;
signal count:integer:=0;
signal clk2:std_logic;
--signal pwm: std_logic:='0';

begin

process(clk)
begin
    if(rising_edge(clk)) then
        count2 <= count2+ 1;
        if(count2 = 100_000) then
            clk2 <= not clk2;
             count2 <= 1;
        end if;
     end if;
end process;

process(clk2)
begin

    if(rising_edge(clk2)) then
        if(count=0)then

        
        
          
             case select_i1 is
                            when "0000" => SEG_OUT <= "0000001"; --0
                            when "0001" => SEG_OUT <= "1001111"; --1
                            when "0010" => SEG_OUT <= "0010010"; --2
                            when "0011" => SEG_OUT <= "0000110"; --3
                            when "0100" => SEG_OUT <= "1001100"; --4
                            when "0101" => SEG_OUT <= "0100100"; --5
                            when "0110" => SEG_OUT <= "0100000"; --6
                            when "0111" => SEG_OUT <= "0001111"; --7
                            when "1000" => SEG_OUT <= "0000000"; --8
                            when "1001" => SEG_OUT <= "0000100"; --9
                            when others   => SEG_OUT <= "1111111";		
                                end case;
                en_out<="0111";
                count<=1;
        elsif(count = 1) then
                      case select_i2 is
							when "0000" => SEG_OUT <= "0000001"; --0
                            when "0001" => SEG_OUT <= "1001111"; --1
                            when "0010" => SEG_OUT <= "0010010"; --2
                            when "0011" => SEG_OUT <= "0000110"; --3
                            when "0100" => SEG_OUT <= "1001100"; --4
                            when "0101" => SEG_OUT <= "0100100"; --5
                            when "0110" => SEG_OUT <= "0100000"; --6
                            when "0111" => SEG_OUT <= "0001111"; --7
                            when "1000" => SEG_OUT <= "0000000"; --8
                            when "1001" => SEG_OUT <= "0000100"; --9
                            when others   => SEG_OUT <= "1111111";                                            					
                                        end case;
                        en_out<="1011";
                         count<=2;
                  
                          elsif(count = 2) then
                            case select_i3 is
								when "0000" => SEG_OUT <= "0000001"; --0
								when "0001" => SEG_OUT <= "1001111"; --1
								when "0010" => SEG_OUT <= "0010010"; --2
								when "0011" => SEG_OUT <= "0000110"; --3
								when "0100" => SEG_OUT <= "1001100"; --4
								when "0101" => SEG_OUT <= "0100100"; --5
								when "0110" => SEG_OUT <= "0100000"; --6
								when "0111" => SEG_OUT <= "0001111"; --7
								when "1000" => SEG_OUT <= "0000000"; --8
								when "1001" => SEG_OUT <= "0000100"; --9
								when others   => SEG_OUT <= "1111111";                                                                   			
                             end case;
                             
							 en_out<="1101";
                             count<=3;
                           elsif(count = 3) then
                             case select_i4 is
                                when "0000" => SEG_OUT <= "0000001"; --0
                                when "0001" => SEG_OUT <= "1001111"; --1
                                when "0010" => SEG_OUT <= "0010010"; --2
                             	when "0011" => SEG_OUT <= "0000110"; --3
                             	when "0100" => SEG_OUT <= "1001100"; --4
                             	when "0101" => SEG_OUT <= "0100100"; --5
                             	when "0110" => SEG_OUT <= "0100000"; --6
                             	when "0111" => SEG_OUT <= "0001111"; --7
                             	when "1000" => SEG_OUT <= "0000000"; --8
                             	when "1001" => SEG_OUT <= "0000100"; --9
                                when others   => SEG_OUT <= "1111111";                                                                   			
                              end case;
                                                          
                            en_out<="1110";
                               count<=0;   
                                                              
        end if;
     end if;
    end process;
end Behavioral;
