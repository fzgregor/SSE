

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:27:25 05/06/2012 
-- Design Name: 
-- Module Name:    ps2_uart - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;




-- 

entity ps2_uart is
 port (
      rst, clk   : in    std_logic;

      ps2_clk    : inout std_logic;
      ps2_dat    : inout std_logic;

      snd_ready  : out   std_logic;
      snd_strobe : in    std_logic;
      snd_data   : in    std_logic_vector(7 downto 0);

      rcv_strobe : out   std_logic;
      rcv_data   : out   std_logic_vector(7 downto 0)
		
		
    );
end ps2_uart;

architecture Behavioral of ps2_uart is

type tState is (Idle,start,bit_0,bit_1,bit_2,bit_3,bit_4,bit_5,bit_6,bit_7,parity,stop);
signal State : tState := Idle;
signal NextState : tState ;

signal ps2_clk_1 :std_logic;
signal ps2_clk_2 :std_logic;
signal ps2_dat_1 :std_logic;
signal ps2_dat_2 :std_logic;
signal ps2_clk_fe :std_logic;
signal ps2_dat_fe :std_logic;

signal reg : std_logic_vector(8 downto 0):= "000000000";
signal shift_in : std_logic ;

begin

ps2_clk <= 'Z';
ps2_dat <= 'Z';
snd_ready <= '0';
rcv_data <= reg(7 downto 0);

process (clk,rst)
begin
  if rst = '1' then 
    State <= Idle;
	 reg <= "000000000";
	 ps2_clk_1 <= '0';
	 ps2_clk_2 <= '0';
	 ps2_dat_1 <= '0';
	 ps2_dat_2 <= '0';
  elsif rising_edge(clk) then 
    State <= NextState;
	 ps2_clk_2 <= ps2_clk_1;
	 ps2_clk_1 <= ps2_clk;
	 ps2_dat_2 <= ps2_dat_1;
	 ps2_dat_1 <= ps2_dat;
	 
	 if shift_in = '1' then  
	   reg <= ps2_dat_1 & reg(8 downto 1);
	 end if;
  end if;
  
end process;

process (State, ps2_clk_fe, ps2_dat_fe,reg, ps2_dat_1) 
begin 

  NextState <= State;
  shift_in <= '0';
  rcv_strobe <= '0';

  case State is 
  
    when Idle => 
	   shift_in <= '0';
		rcv_strobe <= '0';
	   if ps2_dat_fe = '1' then 
		  NextState <= start ;
		end if;
	 
    when start =>
	   if ps2_clk_fe = '1' then 
		  shift_in <= '1';
		  NextState <= bit_0;
		end if;

    when bit_0 =>	 
	   if ps2_clk_fe = '1' then
		  shift_in <= '1';
		  NextState <= bit_1;
		end if;

	
	 when bit_1 =>	
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= bit_2;
	   end if;
		
	 when bit_2 =>		
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= bit_3;
	   end if;
	 
	 when bit_3 =>	
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= bit_4;
	   end if;	
	 
	 when bit_4 =>	
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= bit_5;
	   end if;	
	 
	 when bit_5 =>		
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= bit_6;
	   end if;
	 
	 when bit_6 =>		
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= bit_7;
	   end if;
	 
	 when bit_7 =>		
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= parity;
	   end if;
		
	 when parity =>		
	   if ps2_clk_fe = '1' then
	     shift_in <= '1';
		  NextState <= stop;
	   end if;
		
	 when stop => 
	 
	   if ps2_clk_fe = '1' then
		  rcv_strobe <= '1';
		  shift_in <= '0';
		  NextState <= Idle;
		end if;
		
  end case;
end process;

ps2_clk_fe <= ps2_clk_2 and (not ps2_clk_1);
ps2_dat_fe <= ps2_dat_2 and (not ps2_dat_1);

end Behavioral;
