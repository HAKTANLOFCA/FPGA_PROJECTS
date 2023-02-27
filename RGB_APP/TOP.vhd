


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;



entity top is
port(
clk:in std_logic;
rst:in std_logic;
pwm_r_out: out std_logic;
pwm_g_out: out std_logic;
pwm_b_out: out std_logic

);
end top;

architecture Behavioral of top is

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_out0 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe_out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe_out3 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe_out4 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    probe_out5 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
  );
END COMPONENT;

component pwm is
port(
clk:in std_logic;
rst:in std_logic;
high_time:in integer;
period: in integer;
pwm_out: out std_logic

);
end component;
signal pwm_r_high_data : std_logic_vector(31 downto 0);
signal pwm_r_period_data : std_logic_vector(31 downto 0);

signal pwm_r_high_data_int : integer;
signal pwm_r_period_data_int : integer;

signal pwm_g_high_data : std_logic_vector(31 downto 0);
signal pwm_g_period_data : std_logic_vector(31 downto 0);

signal pwm_g_high_data_int : integer;
signal pwm_g_period_data_int : integer;

signal pwm_b_high_data : std_logic_vector(31 downto 0);
signal pwm_b_period_data : std_logic_vector(31 downto 0);

signal pwm_b_high_data_int : integer;
signal pwm_b_period_data_int : integer;
begin


pwm_r_high_data_int <=to_integer(unsigned(pwm_r_high_data));
pwm_r_period_data_int <=to_integer(unsigned(pwm_r_period_data));

pwm_g_high_data_int <=to_integer(unsigned(pwm_g_high_data));
pwm_g_period_data_int <=to_integer(unsigned(pwm_g_period_data));

pwm_b_high_data_int <=to_integer(unsigned(pwm_b_high_data));
pwm_b_period_data_int <=to_integer(unsigned(pwm_b_period_data));


vio_inst: vio_0
port map(
clk => clk,
probe_out0 => pwm_r_high_data,
probe_out1  =>pwm_r_period_data,

probe_out2 => pwm_g_high_data,
probe_out3  =>pwm_g_period_data,

probe_out4 => pwm_b_high_data,
probe_out5  =>pwm_b_period_data

);

pwmred_inst:pwm
port map(
clk => clk,
rst  => rst,
period  => pwm_r_period_data_int,
high_time => pwm_r_high_data_int,
pwm_out => pwm_r_out

);

pwmgreen_inst:pwm
port map(
clk => clk,
rst  => rst,
period  => pwm_g_period_data_int,
high_time => pwm_g_high_data_int,
pwm_out => pwm_g_out

);

pwmblue_inst:pwm
port map(
clk => clk,
rst  => rst,
period  => pwm_b_period_data_int,
high_time => pwm_b_high_data_int,
pwm_out => pwm_b_out

);

end Behavioral;
