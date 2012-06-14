--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:33:35 06/14/2012
-- Design Name:   
-- Module Name:   /home/live/workspace/sse/brick_space_test.vhd
-- Project Name:  brickout
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: brick_space
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
Use ieee.numeric_std.all;
USE work.types.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY brick_space_test IS
END brick_space_test;
 
ARCHITECTURE behavior OF brick_space_test IS 

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal game_clk : std_logic := '0';
   signal level : levelT := to_unsigned(1, levelT'length);
   signal position : positionT := (others=> (others=> '0'));
   signal ball_radius : radiusT := (others => '0');

 	--Outputs
   signal rgb : rgbT;
   signal collision_vector : collision_vectorT;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.brick_space PORT MAP (
          clk => clk,
          rst => rst,
          game_clk => game_clk,
          level => level,
          rgb_for_position => position,
          rgb => rgb,
          ball_position => position,
          ball_radius => ball_radius,
          collision_vector => collision_vector
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clk_period;
		rst <= '1';
      wait for clk_period;
		rst <= '0';
--		position.x <= to_unsigned(4, x_pos'length);
--		position.y <= to_unsigned(32, y_pos'length);

      wait;
   end process;
	
	process(clk)
	begin
		if rising_edge(clk) then
			position.x <= position.x + 2;
			position.y <= position.y + 1;
		end if;
	end process;

END;
