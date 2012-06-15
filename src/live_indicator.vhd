----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:07 06/15/2012 
-- Design Name: 
-- Module Name:    live_indicator - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use work.types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity live_indicator is
	port (lives : in livesT;
			rgb_for_position : in positionT;
			rgb : out rgbT
	);
end live_indicator;

architecture Behavioral of live_indicator is

begin

rgb_writer : process(lives, rgb_for_position)
begin
   if lives >= to_unsigned(7,lives'length) then
		if rgb_for_position.x > to_unsigned(290,rgb_for_position.x'length) and rgb_for_position.x < to_unsigned(294,rgb_for_position.x'length) and rgb_for_position.y > to_unsigned(4,rgb_for_position.y'length) and rgb_for_position.y < to_unsigned(8,rgb_for_position.y'length) then
			rgb <= "101";
		end if;
	end if;
	if lives >= to_unsigned(5,lives'length) then
		if rgb_for_position.x > to_unsigned(296,rgb_for_position.x'length) and rgb_for_position.x < to_unsigned(300,rgb_for_position.x'length) and rgb_for_position.y > to_unsigned(4,rgb_for_position.y'length) and rgb_for_position.y < to_unsigned(8,rgb_for_position.y'length) then
			rgb <= "101";
		end if;
	end if;
	if lives >= to_unsigned(3,lives'length) then
		if rgb_for_position.x > to_unsigned(302,rgb_for_position.x'length) and rgb_for_position.x < to_unsigned(306,rgb_for_position.x'length) and rgb_for_position.y > to_unsigned(4,rgb_for_position.y'length) and rgb_for_position.y < to_unsigned(8,rgb_for_position.y'length) then
			rgb <= "101";
		end if;
	end if;
	if lives >= to_unsigned(1,lives'length) then
		if rgb_for_position.x > to_unsigned(308,rgb_for_position.x'length) and rgb_for_position.x < to_unsigned(312,rgb_for_position.x'length) and rgb_for_position.y > to_unsigned(4,rgb_for_position.y'length) and rgb_for_position.y < to_unsigned(8,rgb_for_position.y'length) then
			rgb <= "101";
		end if;
	end if;
end process;

end Behavioral;

