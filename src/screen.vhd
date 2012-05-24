library ieee;
use ieee.std_logic_1164.all;
use work.types.all;

entity screen is
	port (
		ball_position : in positionT;
		ball_radius : in radiusT;
		collision_vector : out collision_vectorT
	);
end entity screen;
---- update
architecture RTL of screen is
	
begin
	
end architecture RTL;
