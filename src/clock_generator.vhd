library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity clock_generator is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : out std_logic;
		clk_25mhz : out std_logic
	);
end entity clock_generator;

architecture RTL of clock_generator is
	
signal cnt : unsigned(1 downto 0);
begin
	
process (clk)
begin
	if rising_edge(clk) then
		if rst = '1' then 
			cnt <= "00";
		else 
			cnt <= cnt+1;
		end if;
	end if;
end process;
clk_25mhz <= '1' when cnt(1)= '1' else '0';
end architecture RTL;
