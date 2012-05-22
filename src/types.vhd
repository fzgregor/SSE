library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

package types is
	type position is
		record
			x : unsigned (9 downto 0);
			y : unsigned (8 downto 0);
		end record;
	subtype size is position;
	subtype collision_vector is std_logic_vector(1 downto 0); -- bit 1 horizontal, bit 0 vertical collision
	subtype rgba is std_logic_vector(3 downto 0); -- bit 3 red, bit 0 alpha occording to name
	subtype radius is unsigned (4 downto 0);
end package types;

package body types is
	
end package body types;
