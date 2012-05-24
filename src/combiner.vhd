library ieee;
use ieee.std_logic_1164.all;

entity combiner is
	generic (
		set_number : natural; -- eg. number of rgba inputs
		set_length : natural -- eg. for rgba 4 for collision_vector 2
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		input : in std_logic_vector(set_number*set_length-1 downto 0);
		output : out std_logic_vector(set_length-1 downto 0)
	);
end entity combiner;

architecture RTL of combiner is
	
begin

end architecture RTL;
