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

aktive_x <= '1' when (ball_position.x >= position.x) and  ((position.x + size.x) >= ball_position.x) else '0';
aktive_y <= '1' when (ball_position.y >= position.y) and  ((position.y + size.y) >= ball_position.y) else '0';

process (ball_position,ball_radius,aktive_x,aktive_y,size,position)
begin

collision_vector <= "00";

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
