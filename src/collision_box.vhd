library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity collision_box is
	port (
		clk : in std_logic;
		rst : in std_logic;
		position : in position; -- left upper corner of this collision_box
		size : in size;
		ball_position : in position;
		ball_radius : in radius;
		collision_vector : out collision_vector
	);
end entity collision_box;

architecture RTL of collision_box is
	
begin

end architecture RTL;
