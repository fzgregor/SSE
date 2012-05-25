--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:02:37 05/25/2012
-- Design Name:   
-- Module Name:   /home/live/workspace/sse/clock_generator_test.vhd
-- Project Name:  brickout
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clock_generator
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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY clock_generator_test IS
END clock_generator_test;
 
ARCHITECTURE behavior OF clock_generator_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clock_generator
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

 	--Outputs
   signal game_clk : std_logic;
   signal clk_25mhz : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clock_generator PORT MAP (
          clk => clk,
          rst => rst,
          game_clk => game_clk,
          clk_25mhz => clk_25mhz
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
      assert clk_25mhz = '1' and game_clk = '1'
		severity failure;
		wait for clk_period;
      assert clk_25mhz = '1' and game_clk = '0'
		severity failure;
      assert clk_25mhz = '0' and game_clk = '0'
		severity failure;
      assert clk_25mhz = '0' and game_clk = '0'
		severity failure;
      assert clk_25mhz = '1' and game_clk = '0'
		severity failure;
		--wait for clk_period *4096 - 4 - 1;
		wait for clk_period*4091;
      assert game_clk = '0'
		severity failure;
      assert game_clk = '1'
		severity failure;
      assert game_clk = '0'
		severity failure;

      wait;
   end process;

END;
