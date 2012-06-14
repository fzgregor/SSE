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
-- component connection signals
signal set_ball_active : std_logic;
signal set_ball_position : positionT;
signal catch_dead_ball : std_logic;
-- collision stuff
signal ball_position : positionT;
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
signal collision_speed_effect : std_logic_vector(2 downto 0);

-- die Anzahl der Leben wird in der  Paddle Komponente angezeigt da die Behandlung im Top-modul es kpmplizierter macht
--in game_logic benoetigte Signale von oder in anderen Komponenten :
signal space_empty : std_logic; 									 --von space
signal rst_level: std_logic; 	-- in space
signal rgb_decider : std_logic; -- in top
signal lock : std_logic; -- in paddle
signal level_nr: levelT;-- in space
signal lives : unsigned (2 downto 0); -- in Paddle 

signal rgb_from_logic : rgbT;
signal rgb_from_combiner : rgbT;

signal rgb_x_639 : unsigned (9 downto 0);
signal rgb_y_479 : unsigned (8 downto 0);


begin

	rgb_to_vga_component <= rgb_from_logic when rgb_decider = '1' else rgb_from_combiner;
	
	game_logic_inst : entity work.game_logic
		port map(clk 					=> clk,
					rst 					=> rst,
					rgb_x_639			=> rgb_x_639,
					rgb_y_479			=> rgb_y_479,
					rgb 					=> rgb_from_logic,
					ps2_data 			=> ps2_data,
					ps2_strobe 			=> ps2_strobe,
					space_empty 		=> '0',
					dead 					=> catch_dead_ball,
					rst_level 			=> rst_level,
					rgb_decider 		=> rgb_decider,
					lock 					=> lock,
					level_nr 			=> level_nr,
					lives					=> lives	
					);
	ps2_uart_inst : entity work.ps2_uart
		port map(rst        => rst,
			     clk        => clk,
			     ps2_clk    => ps2_clk,
			     ps2_dat    => ps2_data_raw,
			     snd_ready  => open,
			     snd_strobe => '0',
			     snd_data   => "00000000",
			     rcv_strobe => ps2_strobe,
			     rcv_data   => ps2_data);
	clock_generator_inst : entity work.clock_generator
		port map(clk       => clk,
			     rst       => rst,
			     game_clk  => game_clk,
			     clk_25mhz => clk_25mhz);
	vga_inst : entity work.vga
		port map(clk25             => clk_25mhz,
			     reset             => rst,
			     rgb_for_position  => vga_pixel,
			     rgb_in            => rgb_to_vga_component,
			     rgb_out           => rgb_to_screen,
			     vga_hs            => h_sync,
			     vga_vs            => v_sync,
				  rgb_x_639 		  => rgb_x_639,
				  rgb_y_479 		  => rgb_y_479);
	ball_inst : entity work.ball
		port map(clk               => clk,
			     rst               => rst_level,
			     game_clk          => game_clk,
			     rgb_for_position  => vga_pixel,
			     rgb               => rgb_summary_vector(2 downto 0),
			     set_ball_active   => set_ball_active,
			     set_ball_position => set_ball_position,
			     dead              => catch_dead_ball,
			     ball_position     => ball_position,
		 	     collision_speed_effect => collision_speed_effect,
			     collision_vector  => collision_vector);
	paddle_inst : entity work.paddle
		port map(clk                     => clk,
			     rst                     => rst_level,
			     game_clk                => game_clk,
			     catch_ball              => catch_dead_ball,
			     ps2_data                => ps2_data,
				  lock 						  => lock,
			     ps2_strobe              => ps2_strobe,
			     set_ball_strobe         => set_ball_active,
			     set_ball_position       => set_ball_position,
			     rgb_for_position        => vga_pixel,
				  lives 						  => lives,
			     rgb                     => rgb_summary_vector(5 downto 3),
			     ball_position           => ball_position,
				  collision_speed_effect_edge => collision_speed_effect,
			     paddle_collision_vector => collision_summary_vector(1 downto 0));
	brick_space_inst : entity work.brick_space
		port map(clk                    => clk,
			     rst                     => rst_level,
			     game_clk                => game_clk,
				  level						  => level_nr,
			     rgb_for_position        => vga_pixel,
			     rgb                     => rgb_summary_vector(8 downto 6),
			     ball_position           => ball_position,
			     collision_vector        => collision_summary_vector(3 downto 2));
	screen_inst : entity work.screen
		port map(ball_position    => ball_position,
			     collision_vector => collision_summary_vector(5 downto 4));
	rgba_combiner_inst : entity work.combiner
		generic map(set_number  => 3,
			        set_length  => 3)
		port map(clk    => clk,
			     rst    => rst,
				  game_clk => game_clk,
			     input  => rgb_summary_vector,
			     output => rgb_from_combiner);
	collision_combiner_inst : entity work.combiner
		generic map(set_number  => 3,
			        set_length  => 2)
		port map(clk    => clk,
			     rst    => rst,
				  game_clk => game_clk,
			     input  => collision_summary_vector,
			     output => collision_vector);
	
end architecture RTL;
