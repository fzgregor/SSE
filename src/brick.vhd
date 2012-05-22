library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use work.types.all;

entity brick is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : in std_logic; -- next game action
		brick_position : in position;
		-- visible representation
		rgba_for_position : in position;
		rgba : out rgba;
		-- collision detection
		ball_position : in position;
		ball_radius : in radius;
		paddle_collision_vector : out collision_vector
	);
end entity brick;


architecture RTL of brick is
	component visible_box
		generic(size : size);
		port(clk               : in  std_logic;
			 rst               : in  std_logic;
			 rgba_for_position : in  position;
			 position          : in  position;
			 flatted_rgba      : in  std_logic_vector(0 to size.x * size.y);
			 rgba              : out rgba);
	end component visible_box;
	
	component collision_box
		port(clk              : in  std_logic;
			 rst              : in  std_logic;
			 position         : in  position;
			 size             : in  size;
			 ball_position    : in  position;
			 ball_radius      : in  radius;
			 collision_vector : out collision_vector);
	end component collision_box;
	
	signal brick_size : size := (x=>TO_UNSIGNED(35, size.x'length), y=>TO_UNSIGNED(1, size.y'length));
begin
	visible_box_inst : visible_box
		generic map(size => brick_size)
		port map(clk              => clk,
			     rst               => rst,
			     rgba_for_position => rgba_for_position,
			     position          => brick_position,
			     flatted_rgba      => x"88888888888888888888888888888888888",
			     rgba              => rgba);
	collision_box_inst : collision_box
		port map(clk              => clk,
			     rst              => rst,
			     position         => brick_position,
			     size             => brick_size,
			     ball_position    => ball_position,
			     ball_radius      => ball_radius,
			     collision_vector => paddle_collision_vector);

end architecture RTL;
