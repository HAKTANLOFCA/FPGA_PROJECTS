


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;



entity top is
port(
clk:in std_logic;
rst:in std_logic;
pwm_out: out std_logic

);
end top;

architecture Behavioral of top is

component vio_0 
PORT (
CLK : IN STD_LOGIC;

probe_out0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000";
probe_out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := "00000000000000000000000000000000" 
);
end component;

component pwm is
port(
clk:in std_logic;
rst:in std_logic;
high_time:in integer;
period: in integer;
pwm_out: out std_logic

);
end component;
signal pwm_high_data : std_logic_vector(31 downto 0);
signal pwm_period_data : std_logic_vector(31 downto 0);

signal pwm_high_data_int : integer;
signal pwm_period_data_int : integer;
begin

pwm_high_data_int <=to_integer(unsigned(pwm_high_data));
pwm_period_data_int <=to_integer(unsigned(pwm_period_data));

vio_inst: vio_0
port map(
clk => clk,
probe_out0 => pwm_high_data,
probe_out1  =>pwm_period_data


);

pwm_inst:pwm
port map(
clk => clk,
rst  => rst,
period  => pwm_period_data_int,
high_time => pwm_high_data_int,
pwm_out => pwm_out



);
end Behavioral;
