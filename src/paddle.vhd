library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use work.types.all;

entity paddle is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : in std_logic; -- next game action
		catch_ball : in std_logic; -- catch the ball onto the paddle
		ps2_data : in std_logic_vector (7 downto 0);
		ps2_strobe : in std_logic;
		set_ball_strobe : out std_logic; -- indicate that set_ball is correct address
		set_ball_position : out positionT;
		-- visible representation
		rgba_for_position : in positionT;
		rgba : out rgbaT;
		-- collision detection
		ball_position : in positionT;
		ball_radius : in radiusT;
		paddle_collision_vector : out collision_vectorT
	);
end entity paddle;


architecture RTL of paddle is
	component collision_box
		port(clk              : in  std_logic;
			 rst              : in  std_logic;
			 position         : in  positionT;
			 size             : in  sizeT;
			 ball_position    : in  positionT;
			 ball_radius      : in  radiusT;
			 collision_vector : out collision_vectorT);
	end component collision_box;
	
	type paddleState is (ball_catched, normal);
	signal current_position : positionT; -- left upper corner of paddle
	signal paddle_size : sizeT; -- := (x=>TO_UNSIGNED(10, sizeT.x'length), y=>TO_UNSIGNED(1, sizeT.y'length));
begin
	collision_box_inst : collision_box
		port map(clk              => clk,
			     rst              => rst,
			     position         => current_position,
			     size             => paddle_size,
			     ball_position    => ball_position,
			     ball_radius      => ball_radius,
			     collision_vector => paddle_collision_vector);

    rgba <= x"2";
end architecture RTL;
