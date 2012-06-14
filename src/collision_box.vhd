library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity collision_box is
	port (
		position : in positionT; -- left upper corner of this collision_box
		size : in sizeT;
		ball_position : in positionT;
		collision_vector : out collision_vectorT
	);
	
end entity collision_box;							--										<---- aktive_x ------>

architecture RTL of collision_box is													----------------------
															--									   |							|
signal aktive_x : std_logic:='0';				--										|							|
signal aktive_y : std_logic:='0';														----------------------

begin

-- help signals
-- we are at the correct x coordinates for a collision
aktive_x <= '1' when (ball_position.x >= position.x) and  ((position.x + size.x) >= ball_position.x) else '0';
-- dito y
aktive_y <= '1' when (ball_position.y >= position.y) and  ((position.y + size.y) >= ball_position.y) else '0';

process (ball_position,aktive_x,aktive_y,size,position)
begin
	collision_vector <= "00";
	if aktive_x ='1' then 
		if ball_position.y = position.y then 
			collision_vector(1) <= '1';
		end if;
	end if;

	if aktive_y = '1' then
		if ball_position.x = position.x then
			collision_vector(0) <= '1';
		end if;
	end if;
end process;
	
end architecture RTL;
