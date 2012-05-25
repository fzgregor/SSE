--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:47:46 05/25/2012
-- Design Name:   
-- Module Name:   /home/live/workspace/sse/screen_test.vhd
-- Project Name:  brickout
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: screen
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
 
ENTITY screen_test IS
END screen_test;
 
ARCHITECTURE behavior OF screen_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT screen
    PORT(
         ball_position : IN  positionT;
         ball_radius : IN  radiusT;
         collision_vector : OUT  collision_vectorT
        );
    END COMPONENT;
    

   --Inputs
   signal ball_position : positionT;
   signal ball_radius : radiusT;

 	--Outputs
   signal collision_vector : collision_vectorT;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: screen PORT MAP (
          ball_position => ball_position,
          ball_radius => ball_radius,
          collision_vector => collision_vector
        );

 

   -- Stimulus process
   stim_proc: process
   begin
      wait for 10 ns;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(200, positionT.y'length));
		ball_radius <= to_unsigned(16, radiusT'length);
		
		assert collision_vector = "00"
		severity failure;
      wait for 10 ns;	


      wait;
   end process;

END;
