library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use work.types.all;

entity brick is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : in std_logic; -- next game action
		brick_position : in positionT;
		-- visible representation
		rgb_for_position : in positionT;
		rgb : out rgbT;
		-- collision detection
		ball_position : in positionT;
		ball_radius : in radiusT;
		brick_collision_vector : out collision_vectorT
	);
end entity brick;


architecture RTL of brick is
	component collision_box
		port(
			 position         : in  positionT;
			 size             : in  sizeT;
			 ball_position    : in  positionT;
			 ball_radius      : in  radiusT;
			 collision_vector : out collision_vectorT);
	end component collision_box;
	
	signal brick_size : sizeT := (x=>TO_UNSIGNED(35, 10), y=>TO_UNSIGNED(5, 9));
	signal dead : std_logic := '0';
	signal brick_collision_vector_tmp :collision_vectorT;
begin
	collision_box_inst : collision_box
		port map(
			     position         => brick_position,
			     size             => brick_size,
			     ball_position    => ball_position,
			     ball_radius      => ball_radius,
			     collision_vector => brick_collision_vector_tmp);

dead <= '0' when brick_collision_vector_tmp = "00" else '1';
rgb <= "001" when (dead = '0') and (rgb_for_position.x > brick_position.x) and (rgb_for_position.x < (brick_position.x + brick_size.x)) and (rgb_for_position.y > brick_position.y) and (rgb_for_position.y < (brick_position.y + brick_size.y)) else "000";
brick_collision_vector <= brick_collision_vector_tmp;

end architecture RTL;
