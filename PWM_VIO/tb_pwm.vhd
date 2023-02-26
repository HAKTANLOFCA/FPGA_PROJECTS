


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_pwm is

end tb_pwm;

architecture Behavioral of tb_pwm is
component pwm

port(
clk:in std_logic;
rst:in std_logic;
high_time:in integer;
period: in integer;
pwm_out: out std_logic

);
end component;
signal clk:std_logic:='0';
signal rst:std_logic:='0';
signal pwm_out:std_logic:='0';

signal high_time:integer:=5_000_000;
signal period:integer:=10_000_000;
constant clk_period : time := 10 ns;
begin
clk <= not clk after clk_period/2;

uut:pwm
port map(
clk=>clk,
rst=>rst,
high_time=>high_time,
period=>period,

pwm_out=>pwm_out
);

stimulus :process
begin
wait for clk_period*10;
rst<='0';
wait for clk_period*10;
rst<='1';
wait for clk_period*10;
rst<='0';
wait;

end process;
end Behavioral;
