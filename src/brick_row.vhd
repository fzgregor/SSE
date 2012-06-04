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

entity brick_row is
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : in std_logic; -- next game action
		row_position : in positionT;
		-- visible representation
		rgb_for_position : in positionT;
		rgb : out rgbT;
		-- collision detection
		ball_position : in positionT;
		ball_radius : in radiusT;
		collision_vector : out collision_vectorT
	);
end entity brick_row;

architecture Behavioral of brick_row is
   constant BRICK_NUMBER : integer := 44;
	
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
   component combiner
	   generic(set_number  : natural;
		       set_length  : natural);
	   port(clk     : in  std_logic;
		    rst      : in  std_logic;
		    game_clk : in std_logic;
		    input    : in  std_logic_vector(set_number * set_length - 1 downto 0);
		    output   : out std_logic_vector(set_length - 1 downto 0));
   end component combiner;
	signal rgb_summary_vector : std_logic_vector(3*BRICK_NUMBER-1 downto 0);
	signal collision_summary_vector : std_logic_vector(2*BRICK_NUMBER-1 downto 0);
	
	type position_vectorT is array (natural range<>) of positionT;
	signal position_i : position_vectorT(0 to BRICK_NUMBER-1);

begin
	rgb_combiner : combiner
	   generic map(set_number=>BRICK_NUMBER, set_length=>3)
	   port map(clk=>clk, rst=>rst, game_clk=>game_clk,
               input=>rgb_summary_vector, output=>rgb);
	collision_combiner : combiner
	   generic map(set_number=>BRICK_NUMBER, set_length=>2)
	   port map(clk=>clk, rst=>rst, game_clk=>game_clk,
               input=>collision_summary_vector, output=>collision_vector);
   brick_creation : for i in 0 to BRICK_NUMBER-1 generate
	begin
	   position_i(i) <= (x=>row_position.x+to_unsigned(60*i, x_pos'length), y=>row_position.y);
	   brick_i : brick
		port map(clk=>clk, rst=>rst, game_clk=>game_clk, brick_position=>position_i(i),
		         rgb_for_position=>rgb_for_position, rgb=>rgb_summary_vector(3*i+2 downto 3*i),
					ball_position=>ball_position, ball_radius=>ball_radius,
					brick_collision_vector=>collision_summary_vector(2*i+1 downto 2*i));
	end generate;

end Behavioral;

