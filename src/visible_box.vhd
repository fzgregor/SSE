library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity visible_box is
	generic (
		size : size -- define which size this visible box has
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		rgba_for_position : in position;
		position : in position;
		flatted_rgba : in std_logic_vector (0 to size.x * size.y);
		rgba : out rgba
	);
end entity visible_box;

architecture RTL of visible_box is
	
begin

end architecture RTL;
