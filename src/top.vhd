library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types.all;

entity brickout_game is
	port (
		clk : in std_logic;
		rst : in std_logic;
		-- ps2 stuff
		ps2_data_raw : inout std_logic;
		ps2_clk : inout std_logic;
		-- vga stuff
		rgb : out std_logic_vector(2 downto 0);
		h_sync : out std_logic;
		v_sync : out std_logic
	);
end entity brickout_game;

architecture RTL of brickout_game is
component ball
	port(clk               : in  std_logic;
		 rst               : in  std_logic;
		 game_clk          : in  std_logic;
		 rgba_for_position : in  position;
		 rgba              : out rgba;
		 set_ball_active   : in  std_logic;
		 set_ball_position : in  position;
		 dead              : out std_logic;
		 ball_position     : out position;
		 ball_radius	   : out radius;
		 collision_vector  : in  collision_vector);
end component ball;
component brick
	port(clk                     : in  std_logic;
		 rst                     : in  std_logic;
		 game_clk                : in  std_logic;
		 brick_position          : in  position;
		 rgba_for_position       : in  position;
		 rgba                    : out rgba;
		 ball_position           : in  position;
		 ball_radius             : in  radius;
		 paddle_collision_vector : out collision_vector);
end component brick;
component paddle
	port(clk                     : in  std_logic;
		 rst                     : in  std_logic;
		 game_clk                : in  std_logic;
		 catch_ball              : in  std_logic;
		 ps2_data                : in  std_logic_vector(7 downto 0);
		 ps2_strobe              : in  std_logic;
		 set_ball_strobe         : out std_logic;
		 set_ball_position       : out position;
		 rgba_for_position       : in  position;
		 rgba                    : out rgba;
		 ball_position           : in  position;
		 ball_radius             : in  radius;
		 paddle_collision_vector : out collision_vector);
end component paddle;
component screen
	port(ball_position    : in  position;
		 ball_radius      : in  radius;
		 collision_vector : out collision_vector);
end component screen;
component combiner
	generic(set_number  : natural;
		    set_length  : natural;
		    alpha_index : natural);
	port(clk    : in  std_logic;
		 rst    : in  std_logic;
		 input  : in  std_logic_vector(set_number * set_length - 1 downto 0);
		 output : out std_logic_vector(set_length - 1 downto 0));
end component combiner;
component ps2_uart
	port(rst, clk   : in    std_logic;
		 ps2_clk    : inout std_logic;
		 ps2_dat    : inout std_logic;
		 snd_ready  : out   std_logic;
		 snd_strobe : in    std_logic;
		 snd_data   : in    std_logic_vector(7 downto 0);
		 rcv_strobe : out   std_logic;
		 rcv_data   : out   std_logic_vector(7 downto 0));
end component ps2_uart;


signal game_clk : std_logic := '1';
-- component connection signals
signal set_ball_active : std_logic;
signal set_ball_position : position;
signal catch_dead_ball : std_logic;
signal ball_position : position;
signal ball_radius : radius;
signal collision_summary_vector : std_logic_vector(5 downto 0);
signal collision_vector : std_logic_vector(1 downto 0);
signal rgba_summary_vector : std_logic_vector(11 downto 0);
signal rgba : std_logic_vector(3 downto 0);
signal vga_pixel : position;
signal ps2_data : std_logic_vector(7 downto 0);
signal ps2_strobe : std_logic;


begin
	ps2_uart_inst : ps2_uart
		port map(rst        => rst,
			     clk        => clk,
			     ps2_clk    => ps2_clk,
			     ps2_dat    => ps2_data_raw,
			     snd_ready  => open,
			     snd_strobe => open,
			     snd_data   => open,
			     rcv_strobe => ps2_strobe,
			     rcv_data   => ps2_data);
	ball_inst : ball
		port map(clk               => clk,
			     rst               => rst,
			     game_clk          => game_clk,
			     rgba_for_position => vga_pixel,
			     rgba              => rgba_summary_vector(3 downto 0),
			     set_ball_active   => set_ball_active,
			     set_ball_position => set_ball_position,
			     dead              => catch_dead_ball,
			     ball_position     => ball_position,
			     ball_radius	   => ball_radius,
			     collision_vector  => collision_vector);
	paddle_inst : paddle
		port map(clk                     => clk,
			     rst                     => rst,
			     game_clk                => game_clk,
			     catch_ball              => catch_dead_ball,
			     ps2_data                => ps2_data,
			     ps2_strobe              => ps2_strobe,
			     set_ball_strobe         => set_ball_active,
			     set_ball_position       => set_ball_position,
			     rgba_for_position       => vga_pixel,
			     rgba                    => rgba_summary_vector(7 downto 4),
			     ball_position           => ball_position,
			     ball_radius             => ball_radius,
			     paddle_collision_vector => collision_summary_vector(1 downto 0));
	brick_inst : brick
		port map(clk                     => clk,
			     rst                     => rst,
			     game_clk                => game_clk,
			     brick_position          => (x=>TO_UNSIGNED(400, position.x'length), y=>TO_UNSIGNED(300, position.y'length)),
			     rgba_for_position       => vga_pixel,
			     rgba                    => rgba_summary_vector(11 downto 8),
			     ball_position           => ball_position,
			     ball_radius             => ball_radius,
			     paddle_collision_vector => collision_summary_vector(3 downto 2));
	screen_inst : screen
		port map(ball_position    => ball_position,
			     ball_radius      => ball_radius,
			     collision_vector => collision_summary_vector(5 downto 4));
	rgba_combiner_inst : combiner
		generic map(set_number  => 3,
			        set_length  => 4,
			        alpha_index => 3)
		port map(clk    => clk,
			     rst    => rst,
			     input  => rgba_summary_vector,
			     output => rgba);
	collision_combiner_inst : combiner
		generic map(set_number  => 3,
			        set_length  => 2,
			        alpha_index => -1)
		port map(clk    => clk,
			     rst    => rst,
			     input  => collision_summary_vector,
			     output => collision_vector);
	
end architecture RTL;
