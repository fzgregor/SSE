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
		rgba_for_position : in position;
		rgba : out rgba;
		-- set position of ball
		set_ball_active : in std_logic;
		set_ball_position : in position;
		dead : out std_logic; -- indicates ball death
		ball_position : out position; -- current middle point of ball
		ball_radius : out radius;
		collision_vector : in collision_vector
	);
end entity ball;

architecture RTL of ball is
	component visible_box
		generic(size : size);
		port(clk               : in  std_logic;
			 rst               : in  std_logic;
			 rgba_for_position : in  position;
			 position          : in  position;
			 flatted_rgab      : in  std_logic_vector(0 to size.x * size.y);
			 rgba              : out rgba);
	end component visible_box;
	
	signal ball_size : size := (x=>TO_UNSIGNED(10, size.x'length), y=>TO_UNSIGNED(10, size.y'length));	
begin
	visible_box_inst : visible_box
		generic map(size => ball_size)
		port map(clk               => clk,
			     rst               => rst,
			     rgba_for_position => rgba_for_position,
			     position          => position,
			     flatted_rgab      => X"",
			     rgba              => rgba);

ball_radius <= TO_UNSIGNED(5, ball_radius'length);

end architecture RTL;
