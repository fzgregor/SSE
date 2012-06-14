library ieee;
use ieee.std_logic_1164.all;
use work.types.all;
use IEEE.numeric_std.all;

entity screen is
	port (
		ball_position : in positionT;
		collision_vector : out collision_vectorT
	);
end entity screen;
architecture RTL of screen is
	
begin

collision_vector(0) <= '1' when ball_position.x >= to_unsigned(319, x_pos'length) else '0';
collision_vector(1) <= '1' when ball_position.y >= to_unsigned(239, y_pos'length) else '0';
				 
end architecture RTL;
