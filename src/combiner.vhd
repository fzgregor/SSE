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
		game_clk : in std_logic;
		input : in std_logic_vector(set_number*set_length-1 downto 0);
		output : out std_logic_vector(set_length-1 downto 0)
	);
end entity combiner;

architecture RTL of combiner is

begin
    recursion_end : if set_number = 2 generate
	     output <= input(set_length*2-1 downto set_length) or input(set_length-1 downto 0);
	 end generate recursion_end;

	 recursion_step : if set_number > 2 generate
	     signal temp : std_logic_vector(set_length-1 downto 0);
	 begin
	     next_combiner : entity work.combiner
          generic map(set_number  => set_number-1,
			             set_length  => set_length)
		    port map(clk    => clk,
                             rst    => rst,
                             game_clk => game_clk,
                             input  => input(set_length*set_number-1 downto set_length),
                             output => temp);
	     output <= temp or input(set_length-1 downto 0);
	 end generate recursion_step;
end architecture RTL;
