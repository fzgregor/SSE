library ieee;
use ieee.std_logic_1164.all;
use ieee.NUMERIC_STD.all;
use work.types.all;

entity brick is
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
end entity brick;

 
architecture RTL of brick is
	component collision_box
		port(
			 position         : in  positionT;
			 size             : in  sizeT;
			 ball_position    : in  positionT;
			 ball_radius      : in  radiusT;
			 collision_vector : out collision_vectorT);
	end component collision_box;
	
	signal brick_size : sizeT := (x=>TO_UNSIGNED(25, x_pos'length), y=>TO_UNSIGNED(5, y_pos'length));
	signal brick_collision_vector_tmp :collision_vectorT;
	type tState is (alive,dead);
	signal State: tState := alive;
	signal NextState : tState;
	
begin
	collision_box_inst : collision_box
		port map(
			     position         => brick_position,
			     size             => brick_size,
			     ball_position    => ball_position,
			     ball_radius      => ball_radius,
			     collision_vector => brick_collision_vector_tmp);
				  
	process (clk)
	begin
		if rising_edge(clk) then 
			if rst = '1' then 
				State <= alive;
			else 
				State <= NextState;
			end if;
		end if;
	
	end process;
	
	process(brick_collision_vector_tmp,rgb_for_position, brick_position,brick_size)
	begin 
	NextState <= State;
   rgb <= "000";
		case (State) is
			when alive =>
			  brick_collision_vector <= brick_collision_vector_tmp ;
			  if brick_collision_vector_tmp /= "00" then 
				 NextState <= dead;
			  end if;
			  if (rgb_for_position.x > brick_position.x) and (rgb_for_position.x < (brick_position.x + brick_size.x)) and (rgb_for_position.y > brick_position.y) and (rgb_for_position.y < (brick_position.y + brick_size.y)) then
			    rgb <= "001";
			  end if;
			  
			when dead =>
				 brick_collision_vector <= "00";
			when others => Null;
		end case;
	
	end process;

end architecture RTL;
