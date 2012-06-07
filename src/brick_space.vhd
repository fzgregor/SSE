----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:13:26 05/29/2012 
-- Design Name: 
-- Module Name:    brick_row - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity brick_space is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : in std_logic; -- next game action
		-- visible representation
		rgb_for_position : in positionT;
		rgb : out rgbT;
		-- collision detection
		ball_position : in positionT;
		ball_radius : in radiusT;
		collision_vector : out collision_vectorT
	);
end entity brick_space;

architecture Behavioral of brick_space is
   constant ROW_NUMBER : integer := 2;
   constant BRICK_NUMBER : integer := 10;
	constant SPACE_POSITION_X : integer := 40;
	constant SPACE_POSITION_Y : integer := 20;
		
	component brick
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
	end component;
   component combiner
	   generic(set_number  : natural;
		       set_length  : natural);
	   port(clk     : in  std_logic;
		    rst      : in  std_logic;
		    game_clk : in std_logic;
		    input    : in  std_logic_vector(set_number * set_length - 1 downto 0);
		    output   : out std_logic_vector(set_length - 1 downto 0));
   end component combiner;
	
	signal rgb_summary_vector : std_logic_vector(3*ROW_NUMBER*BRICK_NUMBER-1 downto 0);
	signal collision_summary_vector : std_logic_vector(2*ROW_NUMBER*BRICK_NUMBER-1 downto 0);
begin
	rgb_combiner : combiner
	   generic map(set_number=>ROW_NUMBER*BRICK_NUMBER, set_length=>3)
	   port map(clk=>clk, rst=>rst, game_clk=>game_clk,
               input=>rgb_summary_vector, output=>rgb);
	collision_combiner : combiner
	   generic map(set_number=>ROW_NUMBER*BRICK_NUMBER, set_length=>2)
	   port map(clk=>clk, rst=>rst, game_clk=>game_clk,
               input=>collision_summary_vector, output=>collision_vector);
   row_creation : for row in 0 to ROW_NUMBER-1 generate
	   brick_creation : for brick in 0 to BRICK_NUMBER-1 generate
			brick_i : brick
			port map(clk=>clk, rst=>rst, game_clk=>game_clk, brick_position=>(x=>to_unsigned(60*brick+SPACE_POSITION_X, x_pos'length), y=>to_unsigned(20*row+SPACE_POSITION_Y, y_pos'length)),
						rgb_for_position=>rgb_for_position, rgb=>rgb_summary_vector(3*((row*BRICK_NUMBER)+brick)+2 downto 3*((row*BRICK_NUMBER)+brick)),
						ball_position=>ball_position, ball_radius=>ball_radius,
						brick_collision_vector=>collision_summary_vector(2*((row*BRICK_NUMBER)+brick)+1 downto 2*((row*BRICK_NUMBER)+brick)));
		end generate;
	end generate;

end Behavioral;

