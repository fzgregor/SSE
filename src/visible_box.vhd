library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity visible_box is
	generic (
		size : sizeT -- define which size this visible box has
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		rgba_for_position : in positionT;
		position : in positionT;
		flatted_rgba : in std_logic_vector (0 to 5); -- should be size.x * size.y
		rgba : out rgbaT
	);
end entity visible_box;

architecture RTL of visible_box is
	
begin

end architecture RTL;
