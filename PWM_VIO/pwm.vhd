library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pwm is
port(
clk:in std_logic;
rst:in std_logic;
high_time:in integer;
period: in integer;
pwm_out: out std_logic

);
end pwm;

architecture Behavioral of pwm is
signal cnt: integer range 0 to 100_000_000;
signal pwm_int:std_logic;

begin


process(clk)
begin
pwm_out<=pwm_int;

    if(rising_edge(clk)) then
        if(rst = '1') then
            cnt <= 0;
            pwm_int <= '0';
            pwm_out <= '0';
         else
            if(cnt = 2*high_time) then
                cnt <= 0;
            elsif (cnt < high_time) then
		        pwm_int	<= '1';
		        cnt	<= cnt + 1;
		    else
                pwm_int	<= '0';
                cnt	<= cnt + 1;	
        end if;
        end if;
    end if;
    
end process;
end Behavioral;
