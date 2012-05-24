--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:20:21 05/24/2012
-- Design Name:   
-- Module Name:   /home/live/workspace/sse/combiner_test.vhd
-- Project Name:  brickout
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: combiner
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
 
ENTITY combiner_test IS
END combiner_test;
 
ARCHITECTURE behavior OF combiner_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT combiner
	generic (
		set_number : natural; -- eg. number of rgba inputs
		set_length : natural -- eg. for rgba 4 for collision_vector 2
	);
	port (
		clk : in std_logic;
		rst : in std_logic;
		game_clk : in std_logic;
		input : in std_logic_vector(set_number*set_length-1 downto 0);
		output : out std_logic_vector(set_length-1 downto 0)
	);
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal game_clk : std_logic := '0';
   signal my_input : std_logic_vector(19 downto 0) := (others => '0');

 	--Outputs
   signal my_output : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant game_clk_period : time := 2000 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: combiner 
	GENERIC MAP (
		set_number => 10,
		set_length => 2
	)
	PORT MAP (
          clk => clk,
          rst => rst,
          game_clk => game_clk,
          input => my_input,
          output => my_output
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   game_clk_process :process
   begin
		game_clk <= '0';
		wait for game_clk_period/2;
		game_clk <= '1';
		wait for game_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
	   my_input <= "01000000000000000000";
		wait for clk_period*11;
		assert my_output = "01"
		report "wrong combination!"
		severity failure;

      wait;
   end process;

END;
