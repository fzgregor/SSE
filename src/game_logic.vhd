----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:49:27 06/08/2012 
-- Design Name: 
-- Module Name:    game_logic - Behavioral 
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

entity game_logic is
	port(
		clk : in std_logic;
		rst : in std_logic;
		rgb_x_639 : in unsigned(9 downto 0);
		rgb_y_479 : in unsigned(8 downto 0);
		rgb : out rgbT;
		ps2_data : in std_logic_vector (7 downto 0);
		ps2_strobe : in std_logic;
		space_empty : in std_logic;
		dead : in std_logic;
		catch_ball : out std_logic;
		rst_level : out std_logic;
		rgb_decider : out std_logic;
		level_nr : out levelT;
		lives : out livesT
		);
end game_logic;

architecture Behavioral of game_logic is

type tState is (start_screen, level_x ,playing,you_win,game_over);
signal State : tState:= start_screen;
signal NextState : tState;
signal Level_Nr_tmp : levelT;
signal Level_Nr_tmp_next :levelT;

signal ps2_strobe_old : std_logic;
signal ps2_strobe_edge : std_logic;
signal cnt : unsigned (27 downto 0):=(others =>'0');
signal Lives_tmp : livesT;
signal Lives_tmp_next : livesT;
signal dead_edge: std_logic;
signal dead_old: std_logic;
signal Start_Signal: std_logic;
signal max_level_nr : unsigned (2 downto 0);



begin

dead_edge <= '1' when dead = '1' and dead_old = '0' else '0';
Start_Signal <= '1' when ps2_data = x"5A" and ps2_strobe_edge = '1' else '0';
ps2_strobe_edge <= ps2_strobe and not ps2_strobe_old;
level_nr <= Level_Nr_tmp;
lives <= Lives_tmp;
max_level_nr <= to_unsigned(3,max_level_nr'length);

process (clk,rst)
begin
	if rst = '1' then 
		State <= start_screen;
	elsif rising_edge(clk) then
		State <= NextState;
		ps2_strobe_old <= ps2_strobe;
		dead_old <= dead;
		lives_tmp <= lives_tmp_next;
		Level_Nr_tmp <= Level_Nr_tmp_next;
	end if;
end process;

process (clk,state)
begin
	if rising_edge(clk) then
		if state = level_x then
			cnt <= cnt+1;
		else 
			cnt <= (others=>'0');
		end if;
	end if;
end process;

process (State,Start_Signal,cnt(cnt'left),Lives_tmp,space_empty,Level_Nr_tmp,dead_edge, rst)
begin
	NextState <= State;
	rgb_decider <='1';
	lives_tmp_next <= lives_tmp;
	Level_Nr_tmp_next <= Level_Nr_tmp;
	rst_level <= rst;
	catch_ball <= '0';
	
	case (State) is 
	   
		when start_screen =>
			Level_Nr_tmp_next <= to_unsigned(0,Level_Nr_tmp'length);
			Lives_tmp_next <= to_unsigned(4,Lives_tmp'length);
			if Start_Signal = '1' then
				NextState <= level_x;
			end if;
			
		when level_x =>
			rst_level <= '1';
			if cnt(cnt'left) = '1' then 
				rst_level <= '0';
				NextState <= playing;
				catch_ball <= '1';
			end if;
			
		when playing =>
			rgb_decider <= '0';
			if dead_edge = '1' then
				if lives_tmp > to_unsigned(0, lives_tmp'length) then
					lives_tmp_next <= lives_tmp - 1;
					catch_ball <= '1';
				else
					NextState <= game_over;
				end if;
			end if;
				
			if space_empty ='1' then 
				if Level_Nr_tmp = max_level_nr then 
					NextState <= you_win;
				else 
					--cnt <= (others => '0');
					Level_Nr_tmp_next <= Level_Nr_tmp +1;
					NextState <= level_x;
				end if;
			end if;
		
		when others => Null;
	end case;
		
end process;

process (State,rgb_x_639,rgb_y_479,Level_Nr_tmp)

variable gameOver_g_Position: integer :=282;
variable gameOver_a_Position: integer :=288;
variable gameOver_m_Position: integer :=294;
variable gameOver_e_Position: integer :=300;
variable gameOver_o_Position: integer :=312;
variable gameOver_v_Position: integer :=318;
variable gameOver_e2_Position: integer :=324;
variable gameOver_r_Position: integer :=330;

variable youWin_y_Position: integer :=288;
variable youWin_o_Position: integer :=294;
variable youWin_u_Position: integer :=300;
variable youWin_w_Position: integer :=312;
variable youWin_i_Position: integer :=318;
variable youWin_n_Position: integer :=324;
variable youWin_e_Position: integer :=330;

variable brickout_b_Position: integer :=282;
variable brickout_r_Position: integer :=288;
variable brickout_i_Position: integer :=294;
variable brickout_c_Position: integer :=300;
variable brickout_k_Position: integer :=306;
variable brickout_o_Position: integer :=318;
variable brickout_u_Position: integer :=324;
variable brickout_t_Position: integer :=330;

variable press_p_Position: integer :=246;
variable press_r_Position: integer :=252;
variable press_e_Position: integer :=258;
variable press_s_Position: integer :=264;
variable press_s2_Position: integer :=270;

variable enter_e_Position: integer :=282;
variable enter_n_Position: integer :=288;
variable enter_t_Position: integer :=294;
variable enter_e2_Position: integer :=300;
variable enter_r_Position: integer :=306;

variable to_t_Position: integer :=318;
variable to_o_Position: integer :=324;

variable start_s_Position: integer :=336;
variable start_t_Position: integer :=342;
variable start_a_Position: integer :=348;
variable start_r_Position: integer :=354;
variable start_t2_Position: integer :=360;

variable level_l_Position: integer :=288;
variable level_e_Position: integer :=294;
variable level_v_Position: integer :=300;
variable level_e2_Position: integer :=306;
variable level_l2_Position: integer :=312;

variable x_Position: integer :=324;

begin
	rgb <= "000";
	case (state) is 
		when start_screen =>
		-- BRICK OUT Draw
		--B
			IF ((rgb_y_479 >= 300 AND rgb_y_479<=310) AND ((rgb_x_639 = brickout_b_Position))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 305  OR rgb_y_479 = 310 ) AND ((rgb_x_639 = brickout_b_Position+1))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 305  OR rgb_y_479 = 310 ) AND ((rgb_x_639 = brickout_b_Position+2))) OR
				((rgb_y_479 = 301 OR rgb_y_479 = 304  OR rgb_y_479 = 306 OR rgb_y_479 = 309 ) AND ((rgb_x_639 = brickout_b_Position+3))) OR
				((rgb_y_479 = 302 OR rgb_y_479 = 303 OR rgb_y_479 = 307  OR rgb_y_479 = 308 ) AND ((rgb_x_639 = brickout_b_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/B
		--R
			IF ((rgb_y_479 >= 300 AND rgb_y_479<=310) AND ((rgb_x_639 =  brickout_r_Position))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 305  OR rgb_y_479 = 307 ) AND ((rgb_x_639 = brickout_r_Position+1))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 305  OR rgb_y_479 = 308 ) AND ((rgb_x_639 = brickout_r_Position+2))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 304  OR rgb_y_479 = 309 ) AND ((rgb_x_639 = brickout_r_Position+3))) OR
				((rgb_y_479 = 301 OR rgb_y_479 = 302 OR rgb_y_479 = 303  OR rgb_y_479 = 310 ) AND ((rgb_x_639 = brickout_r_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/R
		--I
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= brickout_i_Position+1) AND (rgb_x_639 <= brickout_i_Position+3))) OR
				(((rgb_x_639 = brickout_i_Position+2)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) THEN
					rgb <= "101";	
			END IF;
		--/I	
		--C
			IF ((rgb_y_479 >= 302 AND rgb_y_479<=308) AND ((rgb_x_639 = brickout_c_Position))) OR
				((rgb_y_479 = 301 OR rgb_y_479 = 309)   AND ((rgb_x_639 = brickout_c_Position+1))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 310 ) AND ((rgb_x_639 = brickout_c_Position+2))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 310 ) AND ((rgb_x_639 = brickout_c_Position+3))) OR
				((rgb_y_479 = 301 OR rgb_y_479 = 309 ) AND ((rgb_x_639 = brickout_c_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/C
		--K
			IF ((rgb_y_479 >= 300 AND rgb_y_479<=310) AND ((rgb_x_639 = brickout_k_Position))) OR
				((rgb_y_479 = 305 )AND ((rgb_x_639 = brickout_k_Position+1))) OR
				((rgb_y_479 = 304 OR rgb_y_479 = 306 ) AND ((rgb_x_639 = brickout_k_Position+2))) OR
				((rgb_y_479 = 303 OR rgb_y_479 = 307 ) AND ((rgb_x_639 = brickout_k_Position+3))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 301 OR rgb_y_479 = 302 OR rgb_y_479 = 308 OR rgb_y_479 = 309 OR rgb_y_479 = 310) AND ((rgb_x_639 = brickout_k_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/K
		--0
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= brickout_o_Position+1) AND (rgb_x_639 <= brickout_o_Position+3))) OR
				(((rgb_x_639 = brickout_o_Position OR rgb_x_639 = brickout_o_Position+4)) AND ((rgb_y_479 >= 301) AND (rgb_y_479 <= 309))) THEN
					rgb <= "101";	
			END IF;
		--/0	
		--U
			IF (((rgb_y_479 = 310)) AND ((rgb_x_639 >= brickout_u_Position+1) AND (rgb_x_639 <= brickout_u_Position+3))) OR 
				(((rgb_x_639 = brickout_u_Position OR rgb_x_639 = brickout_u_Position+4)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 309))) THEN
					rgb <= "101";		
			END IF;
		--/U	
		--T
			IF (((rgb_y_479 = 300 )) AND ((rgb_x_639 >= brickout_t_Position) AND (rgb_x_639 <= brickout_t_Position+4))) OR
				(((rgb_x_639 = brickout_t_Position+2)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) THEN
					rgb <= "101";	
			END IF;
		--/T
		--/ BRICK OUT
		
		-- PRESS ENTER Draw
		--P
			IF ((rgb_y_479 >= 320 AND rgb_y_479<=330) AND ((rgb_x_639 = press_p_Position))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325 ) AND ((rgb_x_639 = press_p_Position+1))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325 ) AND ((rgb_x_639 = press_p_Position+2))) OR
				((rgb_y_479 = 321 OR rgb_y_479 = 324 ) AND ((rgb_x_639 = press_p_Position+3))) OR
				((rgb_y_479 = 322 OR rgb_y_479 = 323 ) AND ((rgb_x_639 = press_p_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/P
		--R
			IF ((rgb_y_479 >= 320 AND rgb_y_479<=330) AND ((rgb_x_639 = press_r_Position))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325  OR rgb_y_479 = 327 ) AND ((rgb_x_639 = press_r_Position+1))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325  OR rgb_y_479 = 328 ) AND ((rgb_x_639 = press_r_Position+2))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 324  OR rgb_y_479 = 329 ) AND ((rgb_x_639 = press_r_Position+3))) OR
				((rgb_y_479 = 321 OR rgb_y_479 = 322 OR rgb_y_479 = 323  OR rgb_y_479 = 330 ) AND ((rgb_x_639 = press_r_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/R
		--E
			IF (((rgb_y_479 = 320 OR rgb_y_479 = 330)) AND ((rgb_x_639 >= press_e_Position) AND (rgb_x_639 <= press_e_Position+4))) OR
			(((rgb_y_479 = 325)) AND ((rgb_x_639 >= press_e_Position) AND (rgb_x_639 <= press_e_Position+3)))OR 
			(((rgb_x_639 = press_e_Position)) AND ((rgb_y_479 >= 320) AND (rgb_y_479 <= 330)))THEN
					rgb <= "101";			
			END IF;
		--/E
		--S
			IF ((rgb_y_479 = 321 OR rgb_y_479 = 322 OR rgb_y_479 = 323 OR rgb_y_479 = 329) AND ((rgb_x_639 = press_s_Position))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 324 OR rgb_y_479 = 330) AND ((rgb_x_639 = press_s_Position+1))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325 OR rgb_y_479 = 330) AND ((rgb_x_639 = press_s_Position+2))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 326 OR rgb_y_479 = 330) AND ((rgb_x_639 = press_s_Position+3))) OR
				((rgb_y_479 = 321 OR rgb_y_479 = 327 OR rgb_y_479 = 328 OR rgb_y_479 = 329) AND ((rgb_x_639 = press_s_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/S
		--S
			IF ((rgb_y_479 = 321 OR rgb_y_479 = 322 OR rgb_y_479 = 323 OR rgb_y_479 = 329) AND ((rgb_x_639 = press_s2_Position))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 324 OR rgb_y_479 = 330) AND ((rgb_x_639 = press_s2_Position+1))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325 OR rgb_y_479 = 330) AND ((rgb_x_639 = press_s2_Position+2))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 326 OR rgb_y_479 = 330) AND ((rgb_x_639 = press_s2_Position+3))) OR
				((rgb_y_479 = 321 OR rgb_y_479 = 327 OR rgb_y_479 = 328 OR rgb_y_479 = 329) AND ((rgb_x_639 = press_s2_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/S
		--E
			IF (((rgb_y_479 = 320 OR rgb_y_479 = 330)) AND ((rgb_x_639 >= enter_e_Position) AND (rgb_x_639 <= enter_e_Position+4))) OR
			(((rgb_y_479 = 325)) AND ((rgb_x_639 >= enter_e_Position) AND (rgb_x_639 <= enter_e_Position+3)))OR 
			(((rgb_x_639 = enter_e_Position)) AND ((rgb_y_479 >= 320) AND (rgb_y_479 <= 330)))THEN
					rgb <= "101";			
			END IF;
		--/E
		--N
			IF ((rgb_y_479 >= 320 AND rgb_y_479<=330) AND ((rgb_x_639 = enter_n_Position))) OR
				((rgb_y_479 = 322 OR rgb_y_479 = 323 ) AND ((rgb_x_639 = enter_n_Position+1))) OR
				((rgb_y_479 = 324 OR rgb_y_479 = 325 OR rgb_y_479 = 326 ) AND ((rgb_x_639 =enter_n_Position+2))) OR
				((rgb_y_479 = 327 OR rgb_y_479 = 328 ) AND ((rgb_x_639 = enter_n_Position+3))) OR
				((rgb_y_479 >= 320 AND rgb_y_479<=330) AND ((rgb_x_639 = enter_n_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/N
		--T
			IF (((rgb_y_479 = 320 )) AND ((rgb_x_639 >= enter_t_Position) AND (rgb_x_639 <= enter_t_Position+4))) OR
				(((rgb_x_639 = enter_t_Position+2)) AND ((rgb_y_479 >= 320) AND (rgb_y_479 <= 330))) THEN
					rgb <= "101";	
			END IF;
		--/T
		--E
			IF (((rgb_y_479 = 320 OR rgb_y_479 = 330)) AND ((rgb_x_639 >= enter_e2_Position) AND (rgb_x_639 <= enter_e2_Position+4))) OR
			(((rgb_y_479 = 325)) AND ((rgb_x_639 >= enter_e2_Position) AND (rgb_x_639 <= enter_e2_Position+3)))OR 
			(((rgb_x_639 = enter_e2_Position)) AND ((rgb_y_479 >= 320) AND (rgb_y_479 <= 330)))THEN
					rgb <= "101";			
			END IF;
		--/E
		--R
			IF ((rgb_y_479 >= 320 AND rgb_y_479<=330) AND ((rgb_x_639 =  enter_r_Position))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325  OR rgb_y_479 = 327 ) AND ((rgb_x_639 = enter_r_Position+1))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325  OR rgb_y_479 = 328 ) AND ((rgb_x_639 = enter_r_Position+2))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 324  OR rgb_y_479 = 329 ) AND ((rgb_x_639 = enter_r_Position+3))) OR
				((rgb_y_479 = 321 OR rgb_y_479 = 322 OR rgb_y_479 = 323  OR rgb_y_479 = 330 ) AND ((rgb_x_639 = enter_r_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/R
		
		--/PRESS ENTER 
		-- draw to start
		--T
			IF (((rgb_y_479 = 320 )) AND ((rgb_x_639 >= to_t_Position) AND (rgb_x_639 <= to_t_Position+4))) OR
				(((rgb_x_639 = to_t_Position+2)) AND ((rgb_y_479 >= 320) AND (rgb_y_479 <= 330))) THEN
					rgb <= "101";	
			END IF;
		--/T
		--0
			IF (((rgb_y_479 = 320 OR rgb_y_479 = 330)) AND ((rgb_x_639 >= to_o_Position+1) AND (rgb_x_639 <= to_o_Position+3))) OR
				(((rgb_x_639 = to_o_Position OR rgb_x_639 = to_o_Position+4)) AND ((rgb_y_479 >= 321) AND (rgb_y_479 <= 329))) THEN
					rgb <= "101";		
			END IF;
		--/0
		--S
			IF ((rgb_y_479 = 321 OR rgb_y_479 = 322 OR rgb_y_479 = 323 OR rgb_y_479 = 329) AND ((rgb_x_639 = start_s_Position))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 324 OR rgb_y_479 = 330) AND ((rgb_x_639 = start_s_Position+1))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325 OR rgb_y_479 = 330) AND ((rgb_x_639 = start_s_Position+2))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 326 OR rgb_y_479 = 330) AND ((rgb_x_639 = start_s_Position+3))) OR
				((rgb_y_479 = 321 OR rgb_y_479 = 327 OR rgb_y_479 = 328 OR rgb_y_479 = 329) AND ((rgb_x_639 = start_s_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/S
		--T
			IF (((rgb_y_479 = 320 )) AND ((rgb_x_639 >= start_t_Position) AND (rgb_x_639 <= start_t_Position+4))) OR
				(((rgb_x_639 = start_t_Position+2)) AND ((rgb_y_479 >= 320) AND (rgb_y_479 <= 330))) THEN
					rgb <= "101";	
			END IF;
		--/T
		--A
			IF (((rgb_y_479 = 320 OR rgb_y_479 = 325)) AND ((rgb_x_639 >= start_a_Position+1) AND (rgb_x_639 <= start_a_Position+3))) OR
			(((rgb_x_639 = start_a_Position OR rgb_x_639 = start_a_Position+4)) AND ((rgb_y_479 >= 321) AND (rgb_y_479 <= 330))) THEN
					rgb <= "101";			
			END IF;
		--/A
		--R
			IF ((rgb_y_479 >= 320 AND rgb_y_479<=330) AND ((rgb_x_639 =  start_r_Position))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325  OR rgb_y_479 = 327 ) AND ((rgb_x_639 = start_r_Position+1))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 325  OR rgb_y_479 = 328 ) AND ((rgb_x_639 = start_r_Position+2))) OR
				((rgb_y_479 = 320 OR rgb_y_479 = 324  OR rgb_y_479 = 329 ) AND ((rgb_x_639 = start_r_Position+3))) OR
				((rgb_y_479 = 321 OR rgb_y_479 = 322 OR rgb_y_479 = 323  OR rgb_y_479 = 330 ) AND ((rgb_x_639 = start_r_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/R
		--T
			IF (((rgb_y_479 = 320 )) AND ((rgb_x_639 >= start_t2_Position) AND (rgb_x_639 <= start_t2_Position+4))) OR
				(((rgb_x_639 = start_t2_Position+2)) AND ((rgb_y_479 >= 320) AND (rgb_y_479 <= 330))) THEN
					rgb <= "101";	
			END IF;
		--/T
		--/ to start
		
		when level_x =>
		-- LEVEL X Draw
		--L
			IF (((rgb_y_479 = 310 )) AND ((rgb_x_639 >= level_l_Position) AND (rgb_x_639 <= level_l_Position+4))) OR
				(((rgb_x_639 = level_l_Position)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) THEN
					rgb <= "101";	
			END IF;
		--/L
		--E
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= level_e_Position) AND (rgb_x_639 <= level_e_Position+4))) OR
			(((rgb_y_479 = 305)) AND ((rgb_x_639 >= level_e_Position) AND (rgb_x_639 <= level_e_Position+3)))OR 
			(((rgb_x_639 = level_e_Position)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310)))THEN
					rgb <= "101";			
			END IF;
		--/E
		--V
			IF ((rgb_y_479 >= 300 AND rgb_y_479 <= 302) AND ((rgb_x_639 = level_v_Position))) OR
				((rgb_y_479 >= 303 AND rgb_y_479 <= 308) AND ((rgb_x_639 = level_v_Position+1))) OR
				((rgb_y_479 = 309 OR rgb_y_479 = 310 ) AND ((rgb_x_639 = level_v_Position+2))) OR
				((rgb_y_479 >= 303 AND rgb_y_479 <= 308 ) AND ((rgb_x_639 = level_v_Position+3))) OR
				((rgb_y_479 >= 300 AND rgb_y_479 <= 302 ) AND ((rgb_x_639 = level_v_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/V
		--E
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= level_e2_Position) AND (rgb_x_639 <= level_e2_Position+4))) OR
			(((rgb_y_479 = 305)) AND ((rgb_x_639 >= level_e2_Position) AND (rgb_x_639 <= level_e2_Position+3)))OR 
			(((rgb_x_639 = level_e2_Position)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310)))THEN
					rgb <= "101";			
			END IF;
		--/E
		--L
			IF (((rgb_y_479 = 310 )) AND ((rgb_x_639 >= level_l2_Position) AND (rgb_x_639 <= level_l2_Position+4))) OR
				(((rgb_x_639 = level_l2_Position)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) THEN
					rgb <= "101";	
			END IF;
		--/L
		-- level_Nr draw 
			if Level_Nr_tmp = to_unsigned(0,Level_Nr_tmp'length) then 
				--1
				IF (((rgb_y_479 = 310 )) AND ((rgb_x_639 >= x_Position+1) AND (rgb_x_639 <= x_Position+4))) OR
					(((rgb_x_639 = x_Position+2)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) OR
					(((rgb_x_639 = x_Position+1)) AND ((rgb_y_479 = 301))) OR
					(((rgb_x_639 = x_Position)) AND ((rgb_y_479 = 302))) THEN
						rgb <= "101";	
				END IF;
				--/1
			elsif Level_Nr_tmp = to_unsigned(1,Level_Nr_tmp'length) then
				--2
				IF ((rgb_y_479 = 300 OR(rgb_y_479 >= 305 AND rgb_y_479 <= 310)) AND ((rgb_x_639 = x_Position))) OR
					((rgb_y_479 = 300 OR rgb_y_479 = 305 OR rgb_y_479 = 310) AND ((rgb_x_639 = x_Position+1))) OR
					((rgb_y_479 = 300 OR rgb_y_479 = 305 OR rgb_y_479 = 310) AND ((rgb_x_639 = x_Position+2))) OR
					((rgb_y_479 = 300 OR rgb_y_479 = 305 OR rgb_y_479 = 310) AND ((rgb_x_639 = x_Position+3))) OR
					((rgb_y_479 = 310 OR(rgb_y_479 >= 300 AND rgb_y_479 <= 305)) AND ((rgb_x_639 = x_Position+4))) THEN
						rgb <= "101";			
				END IF;
				--/2
			elsif Level_Nr_tmp = to_unsigned(2,Level_Nr_tmp'length) then
				--3
				IF ((rgb_y_479 = 300 OR rgb_y_479 = 305 OR rgb_y_479 = 310) AND ((rgb_x_639 >= x_Position) and (rgb_x_639 <= x_Position+4))) OR
					((rgb_y_479 >= 301 AND rgb_y_479 <= 309) AND ((rgb_x_639 = x_Position+4))) THEN
						rgb <= "101";			
				END IF;
				--/3
			elsif Level_Nr_tmp = to_unsigned(3,Level_Nr_tmp'length) then
				--4
				IF ((rgb_y_479 = 305) AND ((rgb_x_639 >= x_Position) and (rgb_x_639 <= x_Position+4))) OR
					((rgb_y_479 >= 301 AND rgb_y_479 <= 304) AND ((rgb_x_639 = x_Position))) OR 
					((rgb_y_479 >= 301 AND rgb_y_479 <= 309) AND ((rgb_x_639 = x_Position+4)))THEN
						rgb <= "101";			
				END IF;
				--/4
			end if;
				
		-- /level_Nr 
		--/ LEVEL X
		when playing =>
				rgb <= "000";
		when you_win =>
			-- YOU WIN ! draw
			--Y
				IF (((rgb_y_479 = 300)) AND ((rgb_x_639 = youWin_y_Position) OR (rgb_x_639 = youWin_y_Position+4))) OR
				(((rgb_y_479 = 301)) AND ((rgb_x_639 = youWin_y_Position+1) OR (rgb_x_639 = youWin_y_Position+3)))OR 
				(((rgb_x_639 = youWin_y_Position+2)) AND ((rgb_y_479 >= 302) AND (rgb_y_479 <= 310)))THEN
					rgb <= "101";	
				END IF;
			--/Y			
			--0
				IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= youWin_o_Position+1) AND (rgb_x_639 <= youWin_o_Position+3))) OR
					(((rgb_x_639 = youWin_o_Position OR rgb_x_639 = youWin_o_Position+4)) AND ((rgb_y_479 >= 301) AND (rgb_y_479 <= 309))) THEN
						rgb <= "101";	
				END IF;
			--/0			
			--U
				IF (((rgb_y_479 = 310)) AND ((rgb_x_639 >= youWin_u_Position+1) AND (rgb_x_639 <= youWin_u_Position+3))) OR 
				(((rgb_x_639 = youWin_u_Position OR rgb_x_639 = youWin_u_Position+4)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 309))) THEN
					rgb <= "101";		
				END IF;
			--/U		
			--W
				IF (((rgb_x_639 = youWin_w_Position OR rgb_x_639 = youWin_w_Position+4)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 309))) OR
					(((rgb_x_639 = youWin_w_Position+1 OR rgb_x_639 = youWin_w_Position+3)) AND ((rgb_y_479 = 310)))OR 
					(((rgb_x_639 = youWin_w_Position+2)) AND ((rgb_y_479 >= 306) AND rgb_y_479<=309))THEN
						rgb <= "101";		
				END IF;

			--/W	
			--I
				IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= youWin_i_Position+1) AND (rgb_x_639 <= youWin_i_Position+3))) OR
					(((rgb_x_639 = youWin_i_Position+2)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) THEN
					rgb <= "101";	
				END IF;
			--/I	
			--N
				IF (((rgb_x_639 = youWin_n_Position OR rgb_x_639 = youWin_n_Position+4)) AND ((rgb_y_479 >=300) AND (rgb_y_479 <= 310))) OR
					((rgb_x_639 = youWin_n_Position+1) AND (rgb_y_479 >= 301) AND (rgb_y_479 <= 302)) OR
					(((rgb_x_639 = youWin_n_Position+2) AND (rgb_y_479 >= 303) AND (rgb_y_479 <= 304))) OR
					((rgb_x_639 = youWin_n_Position+3) AND (rgb_y_479 >= 305) AND (rgb_y_479 <= 306)) THEN
					rgb <= "101";	
				END IF;
			--/N			
			--!
				IF (((rgb_y_479 >= 300 AND rgb_y_479<308)) AND ((rgb_x_639 = youWin_e_Position+3) )) OR
					(((rgb_y_479 = 310)) AND ((rgb_x_639 = youWin_e_Position+3) )) THEN
					rgb <= "101";		
				END IF;
			--/!
		--You Win
		
		when game_over =>
		
		-- GAME OVER draw
		--G
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= gameOver_g_Position+1) AND (rgb_x_639 <= gameOver_g_Position+3))) OR
				(((rgb_x_639 = gameOver_g_Position+4 )) AND ((rgb_y_479 = 301) OR (rgb_y_479 = 309) OR (rgb_y_479 = 308) OR (rgb_y_479 = 307))) OR
				(((rgb_x_639 = gameOver_g_Position )) AND ((rgb_y_479 >= 301) AND (rgb_y_479 <= 309))) OR
				(((rgb_y_479 = 307 )) AND ((rgb_x_639 >= gameOver_g_Position+2) AND (rgb_x_639 <= gameOver_g_Position+4))) THEN
					rgb <= "101";		
			END IF;
		--/G
		--A
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 305)) AND ((rgb_x_639 >= gameOver_a_Position+1) AND (rgb_x_639 <= gameOver_a_Position+3))) OR
			(((rgb_x_639 = gameOver_a_Position OR rgb_x_639 = gameOver_a_Position+4)) AND ((rgb_y_479 >= 301) AND (rgb_y_479 <= 310))) THEN
					rgb <= "101";			
			END IF;
		--/A
		--M
			IF (((rgb_x_639 = gameOver_m_Position OR rgb_x_639 = gameOver_m_Position+4)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) OR
			(((rgb_x_639 = gameOver_m_Position+1 OR rgb_x_639 = gameOver_m_Position+3) AND (rgb_y_479 >= 301) AND (rgb_y_479 <= 302)) )OR
			((rgb_x_639 = gameOver_m_Position+2) AND (rgb_y_479 >= 302) AND (rgb_y_479 <= 303)) OR 
			((rgb_x_639 = gameOver_m_Position+2) AND (rgb_y_479 >= 302) AND (rgb_y_479 <= 303)) THEN
					rgb <= "101";		
			END IF;
		--/M
		--E
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= gameOver_e_Position) AND (rgb_x_639 <= gameOver_e_Position+4))) OR
			(((rgb_y_479 = 305)) AND ((rgb_x_639 >= gameOver_e_Position) AND (rgb_x_639 <= gameOver_e_Position+3)))OR 
			(((rgb_x_639 = gameOver_e_Position)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310)))THEN
					rgb <= "101";			
			END IF;
		--/E
		--0
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= gameOver_o_Position+1) AND (rgb_x_639 <= gameOver_o_Position+3))) OR
				(((rgb_x_639 = gameOver_o_Position OR rgb_x_639 = gameOver_o_Position+4)) AND ((rgb_y_479 >= 301) AND (rgb_y_479 <= 309))) THEN
					rgb <= "101";		
			END IF;
		--/0
		--V
			IF ((rgb_y_479 >= 300 AND rgb_y_479 <= 305) AND ((rgb_x_639 = gameOver_v_Position) OR (rgb_x_639 = gameOver_v_Position+4))) OR
				((rgb_y_479 >= 305 AND rgb_y_479 <= 307) AND ((rgb_x_639 = gameOver_v_Position+1) OR (rgb_x_639 = gameOver_v_Position+3))) OR 
				((rgb_y_479 >= 308 AND rgb_y_479 <= 310) AND ((rgb_x_639 = gameOver_v_Position+2))) THEN
					rgb <= "101";	
			END IF;
		--/V
		--E
			IF (((rgb_y_479 = 300 OR rgb_y_479 = 310)) AND ((rgb_x_639 >= gameOver_e2_Position) AND (rgb_x_639 <= gameOver_e2_Position+4))) OR
			(((rgb_y_479 = 305)) AND ((rgb_x_639 >= gameOver_e2_Position) AND (rgb_x_639 <= gameOver_e2_Position+3))) OR
			(((rgb_x_639 = gameOver_e2_Position)) AND ((rgb_y_479 >= 300) AND (rgb_y_479 <= 310))) THEN
					rgb <= "101";			
			END IF;
		--/E
		--R
			IF ((rgb_y_479 >= 300 AND rgb_y_479<=310) AND ((rgb_x_639 = gameOver_r_Position))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 305  OR rgb_y_479 = 307 ) AND ((rgb_x_639 = gameOver_r_Position+1))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 305  OR rgb_y_479 = 308 ) AND ((rgb_x_639 = gameOver_r_Position+2))) OR
				((rgb_y_479 = 300 OR rgb_y_479 = 304  OR rgb_y_479 = 309 ) AND ((rgb_x_639 = gameOver_r_Position+3))) OR
				((rgb_y_479 = 301 OR rgb_y_479 = 302 OR rgb_y_479 = 303  OR rgb_y_479 = 310 ) AND ((rgb_x_639 = gameOver_r_Position+4))) THEN
					rgb <= "101";			
			END IF;
		--/R

		--/GAME OVER draw
		
		when others => Null;
	end case;
	
end process;

end Behavioral;

