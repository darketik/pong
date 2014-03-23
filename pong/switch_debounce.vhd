----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:45:16 02/21/2014 
-- Design Name: 
-- Module Name:    switch_debounce - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity switch_debounce is
    Port ( clk_i : in  STD_LOGIC;
           switch_i : in  STD_LOGIC; -- pull-up by default
			  reset_no : out STD_LOGIC); 
end switch_debounce;

architecture Behavioral of switch_debounce is
	signal counter_s : unsigned(15 downto 0) := (others => '0');
	
	signal switch_sync_s : std_logic_vector(1 downto 0);
--	attribute ASYNC_REG : string;
--	attribute ASYNC_REG of switch_sync_s : signal is "TRUE";
	
	signal debounce_s : std_logic := '0';	
	signal cnt_max_s: std_logic := '0';
	signal switch_state_s: std_logic := '0';
	
	constant all_one_c : std_logic_vector(15 downto 0) := (others => '1');

begin
	-- sync switch_i async signal with clk clock domain usign 2 FF's
	swi_s0_p: process (clk_i, switch_i, switch_sync_s)
		begin
		if (rising_edge(clk_i)) then
				switch_sync_s <= switch_sync_s(0) & switch_i;
		end if;
	end process;
		
	-- if switch value diff from switch state, a debounce is necessary
	debounce_s <= ((not switch_sync_s(1)) xor switch_state_s);

	-- 1 if counter reached max value
	cnt_max_s <= '1' when std_logic_vector(counter_s) = all_one_c
					else '0';

	-- when switch is pushed when , counter increments.
	-- if counter reaches max value, mean that switch really pushed.
	-- debounce_s is set
	cnt_p: process (clk_i, counter_s, debounce_s, cnt_max_s, switch_state_s)
		begin
		if (rising_edge (clk_i)) then
			if (debounce_s = '0') then
				counter_s <= (others => '0');
			else
				counter_s <= counter_s + 1;
				if (cnt_max_s = '1') then
					switch_state_s <= not switch_state_s;
				end if;
			end if;
		end if;
		end process cnt_p;
	
	reset_no <= not switch_state_s;
end Behavioral;

