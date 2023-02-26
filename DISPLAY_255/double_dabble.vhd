

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity display1 is
   port(
   b2 : in std_logic_vector(15 downto 0);
   p1 : out std_logic_vector(19 downto 0)
   );
   
   
  
end display1;

architecture Behavioral of display1 is

begin
     bcd2: process(b2)
     variable z1: std_logic_vector(35 downto 0);
     begin
        for i1 in 0 to 35 loop
            z1(i1) :=    '0';
        end loop;
        z1(18 downto 3) :=     b2;
        
        for i1 in 0 to 12 loop
            if z1(19 downto 16) > 4 then
                    z1(19 downto 16) :=    z1(19 downto 16) +3;
            end if;
            if z1(23 downto 20)> 4 then
                 z1(23 downto 20) :=    z1(23 downto 20) +3;
            end if;
            if z1(27 downto 24)> 4 then
                z1(27 downto 24) :=    z1(27 downto 24) +3;
            end if;
            if z1(31 downto 28)> 4 then
                z1(31 downto 28) :=    z1(31 downto 28) +3;
            end if;
             z1(34 downto 1)  :=   z1(33 downto 0);
         end loop;
         p1 <= z1(35 downto 16);
    end process bcd2;
    
end Behavioral;
