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
		rgb_to_screen : out rgbT;
		h_sync : out std_logic;
		v_sync : out std_logic
	);
end entity brickout_game;

architecture RTL of brickout_game is
component ball
	port(clk               : in  std_logic;
		 rst               : in  std_logic;
		 game_clk          : in  std_logic;
		 rgb_for_position  : in  positionT;
		 rgb               : out rgbT;
		 set_ball_active   : in  std_logic;
		 set_ball_position : in  positionT;
		 dead              : out std_logic;
		 ball_position     : out positionT;
		 ball_radius	   : out radiusT;
		 collision_vector  : in  collision_vectorT);
end component ball;
component brick
	port(clk                     : in  std_logic;
		 rst                     : in  std_logic;
		 game_clk                : in  std_logic;
		 brick_position          : in  positionT;
		 rgb_for_position        : in  positionT;
		 rgb                     : out rgbT;
		 ball_position           : in  positionT;
		 ball_radius             : in  radiusT;
		 brick_collision_vector : out collision_vectorT);
end component brick;
component paddle
	port(clk                     : in  std_logic;
		 rst                     : in  std_logic;
		 game_clk                : in  std_logic;
		 catch_ball              : in  std_logic;
		 ps2_data                : in  std_logic_vector(7 downto 0);
		 ps2_strobe              : in  std_logic;
		 set_ball_strobe         : out std_logic;
		 set_ball_position       : out positionT;
		 rgb_for_position        : in  positionT;
		 rgb                     : out rgbT;
		 ball_position           : in  positionT;
		 ball_radius             : in  radiusT;
		 paddle_collision_vector : out collision_vectorT);
end component paddle;
component screen
	port(ball_position    : in  positionT;
		 ball_radius      : in  radiusT;
		 collision_vector : out collision_vectorT);
end component screen;
component combiner
	generic(set_number  : natural;
		    set_length  : natural);
	port(clk     : in  std_logic;
		 rst      : in  std_logic;
		 game_clk : in std_logic;
		 input    : in  std_logic_vector(set_number * set_length - 1 downto 0);
		 output   : out std_logic_vector(set_length - 1 downto 0));
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
component clock_generator
	port(clk       : in  std_logic;
		 rst       : in  std_logic;
		 game_clk  : out std_logic;
		 clk_25mhz : out std_logic);
end component clock_generator;
component vga
	port(clk25             : in  std_logic;
		 reset             : in  std_logic;
		 rgb_for_position  : out positionT;
		 rgb_in            : in  rgbT;
		 rgb_out           : out rgbT;
		 vga_hs            : out std_logic;
		 vga_vs            : out std_logic);
end component vga;


-- component connection signals
signal set_ball_active : std_logic;
signal set_ball_position : positionT;
signal catch_dead_ball : std_logic;
-- collision stuff
signal ball_position : positionT;
signal ball_radius : radiusT;
signal collision_summary_vector : std_logic_vector(5 downto 0);
signal collision_vector : std_logic_vector(1 downto 0);
-- graphic stuff
signal rgb_summary_vector : std_logic_vector(8 downto 0);
signal rgb_to_vga_component : rgbT;
signal vga_pixel : positionT;
-- ps2 stuff
signal ps2_data : std_logic_vector(7 downto 0);
signal ps2_strobe : std_logic;
-- clock stuff
signal game_clk : std_logic;
signal clk_25mhz : std_logic;


begin
	ps2_uart_inst : ps2_uart
		port map(rst        => rst,
			     clk        => clk,
			     ps2_clk    => ps2_clk,
			     ps2_dat    => ps2_data_raw,
			     snd_ready  => open,
			     snd_strobe => '0',
			     snd_data   => "00000000",
			     rcv_strobe => ps2_strobe,
			     rcv_data   => ps2_data);
	clock_generator_inst : clock_generator
		port map(clk       => clk,
			     rst       => rst,
			     game_clk  => game_clk,
			     clk_25mhz => clk_25mhz);
	vga_inst : vga
		port map(clk25             => clk_25mhz,
			     reset             => rst,
			     rgb_for_position  => vga_pixel,
			     rgb_in            => rgb_to_vga_component,
			     rgb_out           => rgb_to_screen,
			     vga_hs            => h_sync,
			     vga_vs            => v_sync);
	ball_inst : ball
		port map(clk               => clk,
			     rst               => rst,
			     game_clk          => game_clk,
			     rgb_for_position  => vga_pixel,
			     rgb               => rgb_summary_vector(2 downto 0),
			     set_ball_active   => set_ball_active,
			     set_ball_position => set_ball_position,
			     dead              => catch_dead_ball,
			     ball_position     => ball_position,
			     ball_radius	     => ball_radius,
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
			     rgb_for_position        => vga_pixel,
			     rgb                     => rgb_summary_vector(5 downto 3),
			     ball_position           => ball_position,
			     ball_radius             => ball_radius,
			     paddle_collision_vector => collision_summary_vector(1 downto 0));
	brick_inst : brick
		port map(clk                    => clk,
			     rst                     => rst,
			     game_clk                => game_clk,
			     brick_position          => (x=>TO_UNSIGNED(400, 10), y=>TO_UNSIGNED(300, 9)), --(x=>TO_UNSIGNED(400, positionT.x'length), y=>TO_UNSIGNED(300, positionT.y'length)),
			     rgb_for_position        => vga_pixel,
			     rgb                     => rgb_summary_vector(8 downto 6),
			     ball_position           => ball_position,
			     ball_radius             => ball_radius,
			     brick_collision_vector  => collision_summary_vector(3 downto 2));
	screen_inst : screen
		port map(ball_position    => ball_position,
			     ball_radius      => ball_radius,
			     collision_vector => collision_summary_vector(5 downto 4));
	rgba_combiner_inst : combiner
		generic map(set_number  => 3,
			        set_length  => 3)
		port map(clk    => clk,
			     rst    => rst,
				  game_clk => game_clk,
			     input  => rgb_summary_vector,
			     output => rgb_to_vga_component);
	collision_combiner_inst : combiner
		generic map(set_number  => 3,
			        set_length  => 2)
		port map(clk    => clk,
			     rst    => rst,
				  game_clk => game_clk,
			     input  => collision_summary_vector,
			     output => collision_vector);
	
end architecture RTL;
