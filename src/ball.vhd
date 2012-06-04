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
		rgb_for_position : in positionT;
		rgb : out rgbT;
		-- set position of ball
		set_ball_active : in std_logic;
		set_ball_position : in positionT;
		dead : out std_logic; -- indicates ball death
		ball_position : out positionT; -- current middle point of ball
		ball_radius : out radiusT;
		collision_vector : in collision_vectorT
	);
end entity ball;

architecture RTL of ball is
    signal current_position : positionT := (x=>to_unsigned(10, x_pos'length), y=>to_unsigned(10, y_pos'length));
    signal current_positionNext : positionT;
	 -- state stuff
    type ballStateT is (death, moving, catched);
	 signal State : ballStateT := death;
	 signal NextState : ballStateT;
	 -- movement stuff
	 signal movement_cnt : unsigned (15 downto 0) := (others => '0');
	 signal movement_cnt_old : unsigned (15 downto 0) := (others => '0');
	 signal horizontal_velocity : unsigned(3 downto 0) := "1000";
	 signal vertical_velocity : unsigned(3 downto 0) := "1000";
	 signal horizontal_move : std_logic := '0';
	 signal vertical_move : std_logic := '0';
	 signal horizontal_negative : std_logic := '0';
	 signal vertical_negative : std_logic := '1';
	 signal horizontal_negativeNext : std_logic;
	 signal vertical_negativeNext : std_logic;
	 signal collision_vector_old : collision_vectorT;
	
begin
    -- static things
	 -- location
    ball_radius <= (others => '0');
	 ball_position <= current_position;
	 -- graphics
	 rgb <= "010" when rgb_for_position.x >= current_position.x and rgb_for_position.x <= current_position.x + 5 and rgb_for_position.y <= current_position.y and rgb_for_position.y >= current_position.y-5 and State /= death else "000";
	 -- movement
	 horizontal_move <= movement_cnt(15 - to_integer(horizontal_velocity)) and not movement_cnt_old(15 - to_integer(horizontal_velocity)) and game_clk;
	 vertical_move <= movement_cnt(15 - to_integer(vertical_velocity)) and not movement_cnt_old(15 - to_integer(vertical_velocity)) and game_clk;
	 
	 process(game_clk, rst)
	 begin
	     if rst = '1' then
				movement_cnt <= (others => '0');
		  elsif rising_edge(game_clk) then
		      if movement_cnt(14 downto 0) = (14 downto 0 => '1') then
				    movement_cnt <= (others => '0');
			   else
				    movement_cnt <= movement_cnt + 1;
				end if;
				movement_cnt_old <= movement_cnt;
		  end if;
	 end process;
	 
	 -- state changing register
	 process(clk, rst)
	 begin
	     if rst = '1' then
		      State <= death;
	     elsif rising_edge(clk) then
		      State <= NextState;
				current_position <= current_positionNext;
            vertical_negative <= vertical_negativeNext;
            horizontal_negative <= horizontal_negativeNext;
				collision_vector_old <= collision_vector;
		  end if;
    end process;
	 
	 -- state machine
	 process(State, collision_vector, collision_vector_old, set_ball_active, current_position, horizontal_move, vertical_move, vertical_negative, horizontal_negative)
	 begin
	     -- standard output to prevent latches
	     NextState <= State;
		  dead <= '0';
		  current_positionNext <= current_position;
        vertical_negativeNext <= vertical_negative;
        horizontal_negativeNext <= horizontal_negative;
		  case (State) is
		      when death =>
				    dead <= '1';
					 if set_ball_active = '1' then
					     NextState <= catched;
					 end if;
			   when moving =>
				    -- movement calculation
					 if horizontal_move = '1' then
					     if horizontal_negative = '1' then
						      current_positionNext.x <= current_position.x - 1;
						  else
						      current_positionNext.x <= current_position.x + 1;
						  end if;
					 end if;
					 if vertical_move = '1' then
					     if vertical_negative = '1' then
						      current_positionNext.y <= current_position.y - 1;
						  else
						      current_positionNext.y <= current_position.y + 1;
						  end if;
					 end if;
					 -- collision calculation
					 if collision_vector(1) = '1' and collision_vector_old(1) = '0' then
					     vertical_negativeNext <= not vertical_negative;
					 end if;
					 if collision_vector(0) = '1' and collision_vector_old(0) = '0' then
					     horizontal_negativeNext <= not horizontal_negative;
					 end if;
					 -- state transitions
					 if set_ball_active = '1' then
					     NextState <= catched;
					 elsif current_position.y = to_unsigned(479, y_pos'length) then
					     NextState <= death;
					 end if;
				when catched =>
				    current_positionNext <= set_ball_position;
                vertical_negativeNext <= '1';
                horizontal_negativeNext <= '0';
					 
					 -- state transitions
					 if set_ball_active = '0' then
					     NextState <= moving;
					 -- don't know in which world the following statement could be reached
					 -- but for completness
					 elsif current_position.y = to_unsigned(479, y_pos'length) then
					     NextState <= death;
					 end if;
		  end case;
	 end process;
	 

end architecture RTL;
