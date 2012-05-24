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
		paddle_collision_vector : out collision_vectorT
	);
end entity brick;


architecture RTL of brick is
	component collision_box
		port(clk              : in  std_logic;
			 rst              : in  std_logic;
			 position         : in  positionT;
			 size             : in  sizeT;
			 ball_position    : in  positionT;
			 ball_radius      : in  radiusT;
			 collision_vector : out collision_vectorT);
	end component collision_box;
	
	signal brick_size : sizeT; -- := (x=>TO_UNSIGNED(35, size.x'length), y=>TO_UNSIGNED(1, size.y'length));
begin
	collision_box_inst : collision_box
		port map(clk              => clk,
			     rst              => rst,
			     position         => brick_position,
			     size             => brick_size,
			     ball_position    => ball_position,
			     ball_radius      => ball_radius,
			     collision_vector => paddle_collision_vector);
	rgb <= "100";

end architecture RTL;
