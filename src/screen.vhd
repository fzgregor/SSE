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
---- update
architecture RTL of screen is
	
begin

-- this version of implementation does not considere that the pixel differenz in 1 step can be more than 1 pixel position
-- for example (ball_position.x = ball_position.y +1 , ball_position.y = ball_position.y +2) 
-- a possible solution is an extra signal :
-- signal max_speed : unsigned(1 downto 0) := to_unsigned(2,max_speed'length); -- Maximum pixel difference in 1 clk for example (ball_position.x = ball_position.x + 2)	--> max_speed = 2	
-- dont forget max_speed in sensetivity list !
	
process (ball_position,ball_radius)
begin

-- if ((ball_position.x - ball_radius <= 0 + max_speed) or (ball_position.x + ball_radius >= 639 + max_speed)) and (ball_position.y - ball_radius <= 0 + max_speed) then 
--	collision_vector <= "11"; 
-- elsif (ball_position.x - ball_radius <= 0 + max_speed) or (ball_position.x + ball_radius = 639 + max_speed) then 
--	collision_vector <= "01";
-- elsif (ball_position.y - ball_radius <= 0 + max_speed) then
--	collision_vector <= "10";
-- else 
--	collision_vector <= "00";
-- end if;



 if ((ball_position.x - ball_radius = 0) or (ball_position.x + ball_radius = 639)) and (ball_position.y - ball_radius = 0) then 
	collision_vector <= "11"; 
 elsif (ball_position.x - ball_radius = 0) or (ball_position.x + ball_radius = 639) then 
	collision_vector <= "01";
 elsif (ball_position.y - ball_radius = 0) then
	collision_vector <= "10";
 else 
	collision_vector <= "00";
 end if;
end process;
	
				 
end architecture RTL;
