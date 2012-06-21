--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:30:07 06/21/2012
-- Design Name:   
-- Module Name:   /home/sse12c/brickout/src/game_logic_test.vhd
-- Project Name:  brickout
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: game_logic
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
 
ENTITY game_logic_test IS
END game_logic_test;
 
ARCHITECTURE behavior OF game_logic_test IS     

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rgb_x_639 : unsigned(9 downto 0) := (others => '0');
   signal rgb_y_479 : unsigned(8 downto 0) := (others => '0');
   signal ps2_data : std_logic_vector(7 downto 0) := (others => '0');
   signal ps2_strobe : std_logic := '0';
   signal space_empty : std_logic := '0';
   signal dead : std_logic := '0';

 	--Outputs
   signal rgb : rgbT;
   signal catch_ball : std_logic;
   signal rst_level : std_logic;
   signal rgb_decider : std_logic;
   signal level_nr : levelT;
   signal lives : livesT;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.game_logic PORT MAP (
          clk => clk,
          rst => rst,
          rgb_x_639 => rgb_x_639,
          rgb_y_479 => rgb_y_479,
          rgb => rgb,
          ps2_data => ps2_data,
          ps2_strobe => ps2_strobe,
          space_empty => space_empty,
          dead => dead,
          catch_ball => catch_ball,
          rst_level => rst_level,
          rgb_decider => rgb_decider,
          level_nr => level_nr,
          lives => lives
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
		ps2_data <= x"5A";
		ps2_strobe <= '1';
      wait for clk_period;
		ps2_strobe <= '0';
      wait for clk_period;
      wait for clk_period;
		dead <= '1';
      wait for clk_period;
      wait for clk_period;
		dead <= '0';
		
      wait;
   end process;

END;
