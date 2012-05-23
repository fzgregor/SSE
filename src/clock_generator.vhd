library ieee;
use ieee.std_logic_1164.all;

entity clock_generator is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : out std_logic;
		clk_25mhz : out std_logic
	);
end entity clock_generator;

architecture RTL of clock_generator is
	
begin
	
end architecture RTL;
