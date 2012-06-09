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
		level : in unsigned(2 downto 0);
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
	constant FIFO_ELEMENTS : integer := 32;
	constant FIFO_ELEMENTS_LD : integer := 5;
	constant SPACE_POSITION_Y : integer := 32;
	-- bricks levels and so on
	type spaceT is array(0 to 63) of std_logic_vector(0 to 329);
	type levelsT is array(0 to 7) of spaceT;
	signal alive : spaceT;
	signal levels : levelsT;
   -- the killer fifo
	signal fifo_read : unsigned(FIFO_ELEMENTS_LD downto 0) := (others => '0');
	signal fifo_write : unsigned(FIFO_ELEMENTS_LD downto 0) := (others => '0');
	type fifoT is array(0 to FIFO_ELEMENTS) of positionT;
	signal fifo : fifoT;
	signal kill_element : std_logic := '0';
	signal kill_element_pos : positionT;
	signal kill_element_pos_old : positionT;
begin
	-- levels
	levels(0)(0) <= (others => '0');
	levels(0)(1) <= x"0FFFF0FFFF0FFFF0FFFF0FFFF0FFFF0FFFF0FFFF";
	levels(0)(2) <= levels(0)(1);
	levels(0)(3) <= levels(0)(1);
	levels(0)(4) <= levels(0)(1);
	levels(0)(5) <= levels(0)(1); 
	levels(0)(6) <= (others => '0');
	levels(0)(7) <= (others => '0');
	levels(0)(8) <= (others => '0');
	levels(0)(9) <= (others => '0');
	levels(0)(10) <= (others => '0');

   fifo_syncer : process(clk)
	-- needed to insert new elements into kill fifo
	begin
		if rising_edge(clk) then
			if kill_element_pos /= kill_element_pos_old then
				kill_element <= '1';
			else
				kill_element <= '0';
			end if;
			kill_element_pos_old <= kill_element_pos;
		end if;
	end process;
	
	level_setter : process(rst)
	begin
		if rst = '1'then
			alive <= levels(to_integer(level));
		end if;
	end process;
	
	rgb_writer : process(rgb_for_position, alive)
	begin
		if rgb_for_position.y >= SPACE_POSITION_Y and
		   rgb_for_position.y <= SPACE_POSITION_Y + 63 and
			alive(to_integer(rgb_for_position.y) - SPACE_POSITION_Y)(to_integer(rgb_for_position.x)) = '1' then
			rgb <= "101";
		else
			rgb <= "000";
		end if;
	end process;
	
	collision_detection : process(ball_position, alive)
		variable current_x : integer;
		variable current_y : integer;
	begin
		current_x := to_integer(ball_position.x);
		current_y := to_integer(ball_position.y - SPACE_POSITION_Y);
		collision_vector <= (others => '0');
		if ball_position.y >= SPACE_POSITION_Y and
		   ball_position.y <= SPACE_POSITION_Y + 63 and
			alive(current_y)(current_x) = '1' then
				-- vertical collision
				collision_vector(0) <= alive(current_y+1)(current_x) or alive(current_y-1)(current_x);
				-- horizontal collision
				collision_vector(1) <= alive(current_y)(current_x+1) or alive(current_y)(current_x-1);
				-- kill this point
				kill_element_pos <= (x=>to_unsigned(current_x, x_pos'length), y=>to_unsigned(current_y, y_pos'length));
		end if;
	end process;
	
	killer : process (clk)
		variable current_x : integer;
		variable current_y : integer;
	begin
		if rising_edge(clk) then
			if kill_element = '1' then
			-- there is a new point to kill
				fifo(to_integer(fifo_write)) <= kill_element_pos;
				fifo_write <= fifo_write + 1;
			elsif fifo_read /= fifo_write then
			-- there is something in the fifo to read
				current_x := to_integer(fifo(to_integer(fifo_read)).x);
				current_y := to_integer(fifo(to_integer(fifo_read)).y);
				if alive(current_y)(current_x) = '1' then
				-- the point to kill is alive -- KILL IT!
					alive(current_y)(current_x) <= '0';
					-- and the neigbours
					fifo(to_integer(fifo_write)) <= (x=>to_unsigned(current_x-1, x_pos'length), y=>to_unsigned(current_y, y_pos'length));
					fifo(to_integer(fifo_write+1)) <= (x=>to_unsigned(current_x+1, x_pos'length), y=>to_unsigned(current_y, y_pos'length));
					fifo(to_integer(fifo_write+2)) <= (x=>to_unsigned(current_x, x_pos'length), y=>to_unsigned(current_y-1, y_pos'length));
					fifo(to_integer(fifo_write+3)) <= (x=>to_unsigned(current_x, x_pos'length), y=>to_unsigned(current_y+1, y_pos'length));
					-- increase fifo_write pointer
					fifo_write <= fifo_write + 4;
				end if;
				fifo_read <= fifo_read + 1;
			end if;
		end if;
	end process;

end Behavioral;

