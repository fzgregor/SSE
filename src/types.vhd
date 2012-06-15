library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

package types is
   subtype x_pos is unsigned (8 downto 0); -- 0 to 319
	subtype y_pos is unsigned (7 downto 0); -- 0 to 239
	subtype x_size is x_pos;
	subtype y_size is y_pos;
	type positionT is
		record
			x : x_pos;
			y : y_pos;
		end record;
	subtype sizeT is positionT;
	subtype collision_vectorT is std_logic_vector(1 downto 0); -- bit 1 horizontal, bit 0 vertical collision
	subtype rgbT is std_logic_vector(2 downto 0); -- bit 2 red, bit 1 blue occording to name
	subtype levelT is unsigned (2 downto 0);
	subtype livesT is unsigned (2 downto 0);
end package types;

package body types is
	
end package body types;
