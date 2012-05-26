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
	   --- none collision tests
	   --- somewhere on the screen
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(200, positionT.y'length));
		ball_radius <= to_unsigned(16, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "00"
		severity failure;
		
		--- upper boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(1, positionT.y'length));
		ball_radius <= to_unsigned(0, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "00"
		severity failure;
		
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(2, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "00"
		severity failure;
		
		--- lower boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(479, positionT.y'length));
		ball_radius <= to_unsigned(0, radiusT'length);
		
		assert collision_vector = "00"
		severity failure;
		
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(478, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "00"
		severity failure;
		
		--- left boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(1, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(0, radiusT'length);
		
		assert collision_vector = "00"
		severity failure;
		
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(2, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "00"
		severity failure;
		
		--- right boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(638, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(0, radiusT'length);
		
		assert collision_vector = "00"
		severity failure;
		wait for 1 ps;
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(637, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		
		assert collision_vector = "00"
		severity failure;
		
		--- collision tests
		--- upper boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(0, positionT.y'length));
		ball_radius <= to_unsigned(0, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "10"
		severity failure;
		
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(100, positionT.x'length), y=>to_unsigned(1, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "10"
		severity failure;
		
		--- left boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(0, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(0, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "01"
		severity failure;
		
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(1, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "01"
		severity failure;
		
		--- right boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(639, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(0, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "01"
		severity failure;
		
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(638, positionT.x'length), y=>to_unsigned(100, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "01"
		severity failure;
		
		-- left upper boundary
      wait for 10 ps;	
		ball_position <= (x=>to_unsigned(1, positionT.x'length), y=>to_unsigned(1, positionT.y'length));
		ball_radius <= to_unsigned(1, radiusT'length);
		wait for 1 ps;
		assert collision_vector = "11"
		severity failure;


      wait;
   end process;

END;
