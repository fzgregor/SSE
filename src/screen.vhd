library ieee;
use ieee.std_logic_1164.all;
use work.types.all;
use IEEE.numeric_std.all;

entity screen is
	port (
		ball_position : in positionT;
		ball_radius : in radiusT;
		collision_vector : out collision_vectorT
	);
end entity screen;

architecture RTL of screen is
	
begin

process (ball_position,ball_radius)
begin

 if (ball_position.x - ball_radius = 0) or (ball_position.x + ball_radius = 640) then 
	collision_vector <= "01";
 elsif (ball_position.y - ball_radius = 0) then
	collision_vector <= "10";
 else 
	collision_vector <= "00";
 end if;
end process;
	
				 
end architecture RTL;
