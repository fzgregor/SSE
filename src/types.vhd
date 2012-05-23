library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

package types is
	type positionT is
		record
			x : unsigned (9 downto 0);
			y : unsigned (8 downto 0);
		end record;
	subtype sizeT is positionT;
	subtype collision_vectorT is std_logic_vector(1 downto 0); -- bit 1 horizontal, bit 0 vertical collision
	subtype rgbaT is std_logic_vector(3 downto 0); -- bit 3 red, bit 0 alpha occording to name
	subtype radiusT is unsigned (4 downto 0);
end package types;

package body types is
	
end package body types;
