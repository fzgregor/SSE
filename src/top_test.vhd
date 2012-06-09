--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:25:54 05/28/2012
-- Design Name:   
-- Module Name:   /home/live/workspace/sse/top_test.vhd
-- Project Name:  brickout
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: brickout_game
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
 
ENTITY top_test IS
END top_test;
 
ARCHITECTURE behavior OF top_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT brickout_game
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ps2_data_raw : INOUT  std_logic;
         ps2_clk : INOUT  std_logic;
         rgb_to_screen : OUT  std_logic_vector(2 downto 0);
         h_sync : OUT  std_logic;
         v_sync : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

	--BiDirs
   signal ps2_data_raw : std_logic;
   signal ps2_clk : std_logic;

 	--Outputs
   signal rgb_to_screen : std_logic_vector(2 downto 0);
   signal h_sync : std_logic;
   signal v_sync : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant ps2_clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: brickout_game PORT MAP (
          clk => clk,
          rst => rst,
          ps2_data_raw => ps2_data_raw,
          ps2_clk => ps2_clk,
          rgb_to_screen => rgb_to_screen,
          h_sync => h_sync,
          v_sync => v_sync
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   ps2_clk_process :process
   begin
		ps2_clk <= '0';
		wait for ps2_clk_period/2;
		ps2_clk <= '1';
		wait for ps2_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		rst <= '1';
      wait for clk_period;
		rst <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
