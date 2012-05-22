library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity screen is
	port (
		ball_position : in position;
		ball_radius : in radius;
		collision_vector : out collision_vector
	);
end entity screen;

architecture RTL of screen is
	
begin
	
end architecture RTL;
