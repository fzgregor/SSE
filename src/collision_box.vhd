library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity collision_box is
	port (
		position : in positionT; -- left upper corner of this collision_box
		size : in sizeT;
		ball_position : in positionT;
		ball_radius : in radiusT;
		collision_vector : out collision_vectorT
	);
	
end entity collision_box;							--										<---- aktive_x ------>

architecture RTL of collision_box is													----------------------
															--									   l							l
signal aktive_x : std_logic:='0';				--										l							l
signal aktive_y : std_logic:='0';														----------------------

begin

aktive_x <= '1' when ((ball_position.x + ball_radius) >= position.x) and  ((position.x + size.x) >= (ball_position.x - ball_radius)) else '0';
aktive_y <= '1' when ((ball_position.y + ball_radius) >= position.y) and  ((position.y + size.y) >= (ball_position.y - ball_radius)) else '0';

-- this version of implementation does not considere that the pixel differenz in 1 step can be more than 1 pixel position
-- for example (ball_position.x = ball_position.y +1 , ball_position.y = ball_position.y +2) 
-- a possible solution is an extra signal :
-- signal max_speed : unsigned(1 downto 0) := to_unsigned(2,max_speed'length); -- Maximum pixel difference in 1 clk for example (ball_position.x = ball_position.x + 2)	--> max_speed = 2	
-- dont forget max_speed in sensetivity list !
process (ball_position,ball_radius,aktive_x,aktive_y,size,position)
begin

collision_vector <= "00";

-- this version of implementation does not considere that the pixel differenz in 1 step can be more than 1 pixel position
-- for example (ball_position.x = ball_position.y +1 , ball_position.y = ball_position.y +2) 
-- a possible solution is an extra signal :
-- signal max_speed : unsigned(1 downto 0) := to_unsigned(2,max_speed'length); -- Maximum pixel difference in 1 clk for example (ball_position.x = ball_position.x + 2)	--> max_speed = 2	
	
	
--	
--		if aktive_x ='1' then  
--			
--			if ((ball_position.y + ball_radius >= position.y) and (ball_position.y + ball_radius <= position.y + max_speed)) or ((ball_position.y - ball_radius <= position.y + size.y) and (ball_position.y - ball_radius >= position.y + size.y - max_speed)) then 
--				collision_vector <= "10";
--			end if;
--		end if;
--	
--		if aktive_y = '1' then
--			if ((ball_position.x + ball_radius >= position.x) and (ball_position.x + ball_radius <= position.x + max_speed)) or ((ball_position.x - ball_radius <= position.x + size.x) and (ball_position.x - ball_radius >= position.x + size.x - max_speed)) then
--				collision_vector <= "01";
--			end if;
--		end if;

	
	
	
		if aktive_x ='1' then 
			
			if (ball_position.y + ball_radius = position.y) or (ball_position.y - ball_radius = position.y + size.y) then 
				collision_vector <= "10";
			end if;
		end if;
	
		if aktive_y = '1' then
			if (ball_position.x + ball_radius = position.x) or (ball_position.x - ball_radius = position.x + size.x) then
				collision_vector <= "01";
			end if;
		end if;

		
	
end process;
	
end architecture RTL;
