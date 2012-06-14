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
		level : in levelT;
		-- visible representation
		rgb_for_position : in positionT;
		rgb : out rgbT;
		-- collision detection
		ball_position : in positionT;
		collision_vector : out collision_vectorT
	);
end entity brick_space;

architecture Behavioral of brick_space is
	constant Y_OFFSET : integer := 32;
	constant X_OFFSET : integer := 4;
	signal ball_index_x : unsigned(3 downto 0);
	signal ball_index_y : unsigned(1 downto 0);
	signal ball_index_valid : std_logic;
	signal horizontal_collision_line : std_logic;
	signal vertical_collision_line : std_logic;
	signal rgb_index_x : unsigned(3 downto 0);
	signal rgb_index_y : unsigned(1 downto 0);
	signal rgb_index_valid : std_logic;
	
	type aliveT is array(0 to 3) of std_logic_vector(0 to 9);
	type unset_aliveT is record y : unsigned(1 downto 0); x : unsigned(3 downto 0); end record;
	signal unset_alive : unset_aliveT;
	signal unset_alive_old : unset_aliveT;
	signal alive : aliveT;
	
	signal debug: std_logic;
begin

	index_calculator : process (ball_position, rgb_for_position)
	   variable ball_position_without_offset_x : x_pos;
		variable ball_position_without_offset_y : y_pos;
	   variable rgb_without_offset_x : x_pos;
		variable rgb_without_offset_y : y_pos;
		variable ball_index_valid_x : std_logic;
		variable ball_index_valid_y : std_logic;
		variable rgb_index_valid_x : std_logic;
		variable rgb_index_valid_y : std_logic;
	begin
		ball_position_without_offset_x := ball_position.x - X_OFFSET;
		ball_position_without_offset_y := ball_position.y - Y_OFFSET;
		-- there are 4 rows of bricks each 8 pixels high seperated
		-- by 8 pixels void -> so 16 pixels per row
		-- so we are only interested on the bits indicating 16 or above
		-- in the end this is our divide
		ball_index_y <= ball_position_without_offset_y(5 downto 4);
		-- same thing horizontal, there are 10 bricks per row, each brick
		-- is 24 pixels long and they are seperated by 8 pixels void
		-- so together 32 pixels...
		ball_index_x <= ball_position_without_offset_x(8 downto 5);
		-- the calculated index is valid if we are currently not pointing
		-- into the void or not out of the brick space scope 
		-- y : 0,000 brick 1,000 void 10,000 brick 11,000 void 100,000 brick 101,000
		-- => 000, 010, 100 => true, 001, 011, 101 => false
		-- x : 00,000 brick 11,000 void 100,000 brick 111,000 void 1000,000 brick 1011,000
		-- => 0000, 0100, 1000 => true, 0011, 0111, 1011 => false
		if(ball_position_without_offset_y(4) = '0' and ball_position_without_offset_y < 64) then ball_index_valid_y := '1'; else ball_index_valid_y := '0'; end if;
		if(ball_position_without_offset_x(4 downto 3) = "00" and ball_position.x >= X_OFFSET and ball_position.x < 320) then ball_index_valid_x := '1'; else ball_index_valid_x := '0'; end if;
		debug <= ball_index_valid_x;
		ball_index_valid <= ball_index_valid_x and ball_index_valid_y;
		-- these are the collision lines
		-- if the ball is on one of these lines and the brick is alive we're colliding
		if(ball_position_without_offset_y(2 downto 0) = "000" or ball_position_without_offset_y(2 downto 0) = "111") then horizontal_collision_line <= '1'; else horizontal_collision_line <= '0'; end if;
		if(ball_position_without_offset_x(3 downto 0) = "0000" or ball_position_without_offset_x(3 downto 0) = "1000") then vertical_collision_line <= '1'; else vertical_collision_line <= '0'; end if;
		
		-- and now the same thing for rgb once again
		rgb_without_offset_x := rgb_for_position.x - X_OFFSET;
		rgb_without_offset_y := rgb_for_position.y - Y_OFFSET;
		rgb_index_y <= rgb_without_offset_y(5 downto 4);
		rgb_index_x <= rgb_without_offset_x(8 downto 5);
		if(rgb_without_offset_y(4) = '0' and rgb_without_offset_y < 64) then rgb_index_valid_y := '1'; else rgb_index_valid_y := '0'; end if;
		if(rgb_without_offset_x(4 downto 3) = "00" and rgb_for_position.x >= X_OFFSET and rgb_for_position.x < 320) then rgb_index_valid_x := '1'; else rgb_index_valid_x := '0'; end if;
		rgb_index_valid <= rgb_index_valid_x and rgb_index_valid_y;	
	end process;
	
	collision_detection : process(ball_index_y, ball_index_x, ball_index_valid, horizontal_collision_line, vertical_collision_line, alive)
	begin
		collision_vector <= "00";
		if ball_index_valid = '1' then
			if alive(to_integer(ball_index_y))(to_integer(ball_index_x)) = '1' and 
			   (horizontal_collision_line = '1' or vertical_collision_line = '1') then
				collision_vector <= horizontal_collision_line & vertical_collision_line;
				unset_alive <= (y=>ball_index_y, x=>ball_index_x);
			end if;
		end if;
	end process;
	
	alive_writer : process(rst, clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then
				if level = to_unsigned(0, levelT'length) then
					alive <= (0=>"1000110001", others=>(others=>'0'));
				else
					alive <= (others=>(others=>'1'));
				end if;
			elsif unset_alive_old /= unset_alive then
				alive(to_integer(unset_alive.y))(to_integer(unset_alive.x)) <= '0';
			end if;
			unset_alive_old <= unset_alive;
		end if;
	end process;
	
	rgb_writer : process(rgb_index_y, rgb_index_x, rgb_index_valid, alive)
	begin
		if rgb_index_valid = '1' then
			rgb <= "100";
		else
			rgb <= "000";
		end if;
	end process;
end Behavioral;

