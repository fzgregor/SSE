library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity ball is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : in std_logic; -- next game action
		-- visible representation
		rgba_for_position : in positionT;
		rgba : out rgbaT;
		-- set position of ball
		set_ball_active : in std_logic;
		set_ball_position : in positionT;
		dead : out std_logic; -- indicates ball death
		ball_position : out positionT; -- current middle point of ball
		ball_radius : out radiusT;
		collision_vector : in collision_vectorT
	);
end entity ball;

architecture RTL of ball is
	
   signal current_position : positionT;
	
begin

	ball_radius <= TO_UNSIGNED(5, ball_radius'length);
	rgba <= x"E";

end architecture RTL;
