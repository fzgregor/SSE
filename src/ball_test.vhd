--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:03:46 05/26/2012
-- Design Name:   
-- Module Name:   /home/live/workspace/sse/ball_test.vhd
-- Project Name:  brickout
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ball
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
use ieee.numeric_std.all;
use work.types.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ball_test IS
END ball_test;
 
ARCHITECTURE behavior OF ball_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ball
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         game_clk : IN  std_logic;
         rgb_for_position : IN  positionT;
         rgb : OUT  rgbT;
         set_ball_active : IN  std_logic;
         set_ball_position : IN  positionT;
         dead : OUT  std_logic;
         ball_position : OUT  positionT;
         ball_radius : OUT  radiusT;
         collision_vector : IN  collision_vectorT
        );
    END COMPONENT;
	 component clock_generator
	 PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         game_clk : OUT  std_logic;
         clk_25mhz : OUT  std_logic
        );
    END COMPONENT; 
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal game_clk : std_logic := '0';
   signal rgb_for_position : positionT;
   signal set_ball_active : std_logic := '0';
   signal set_ball_position : positionT;
   signal collision_vector : collision_vectorT;

 	--Outputs
   signal rgb : rgbT;
   signal dead : std_logic;
   signal ball_position : positionT;
   signal ball_radius : radiusT;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ball PORT MAP (
          clk => clk,
          rst => rst,
          game_clk => game_clk,
          rgb_for_position => rgb_for_position,
          rgb => rgb,
          set_ball_active => set_ball_active,
          set_ball_position => set_ball_position,
          dead => dead,
          ball_position => ball_position,
          ball_radius => ball_radius,
          collision_vector => collision_vector
        );
	cg : clock_generator PORT MAP (
			clk => clk,
			rst => rst,
			game_clk => game_clk,
			clk_25mhz => open
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
		set_ball_active <= '1';
		set_ball_position <= (x=>to_unsigned(10, x_pos'length), y=>to_unsigned(40, y_pos'length));
		wait for clk_period;
		set_ball_active <= '0';

      wait;
   end process;

END;
