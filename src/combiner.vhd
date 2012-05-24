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
    signal current_value : std_logic_vector(set_length-1 downto 0) := (others=>'0');
    signal low_index : natural := 0;
    signal sets_to_come : natural := set_number;
    signal output_tmp : std_logic_vector(set_length-1 downto 0);
begin
    output <= output_tmp;

    process (clk, rst, game_clk)
    begin
        if rising_edge(game_clk) or rst = '1' then
            current_value <= (others => '0');
            low_index <= 0;
            sets_to_come <= set_number;
        elsif rising_edge(clk) and sets_to_come > 0 then
            current_value <= current_value or input(low_index+set_length-1 downto low_index);
            low_index <= low_index + set_length;
            sets_to_come <= sets_to_come - 1;
        elsif sets_to_come = 0 then
            output_tmp <= current_value;
        end if;
    end process;
    end architecture RTL;
