--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:27:03 02/24/2014
-- Design Name:   
-- Module Name:   /home/florent/work/projects/Papilio_pro_fpga/pong/pong_bench.vhd
-- Project Name:  pong
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pong
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
USE ieee.numeric_std.ALL;
 
ENTITY pong_bench IS
END pong_bench;
 
ARCHITECTURE behavior OF pong_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT pong
    PORT(
         VGA_HSYNC : OUT  std_logic;
         VGA_VSYNC : OUT  std_logic;
         VGA_BLUE : OUT  std_logic_vector(1 downto 0);
         VGA_GREEN : OUT  std_logic_vector(2 downto 0);
         VGA_RED : OUT  std_logic_vector(2 downto 0);
         CLK : IN  std_logic;
         SWITCH0 : IN  std_logic;
         LED0 : OUT  std_logic;
         LED1 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal SWITCH0 : std_logic := '0';

 	--Outputs
   signal VGA_HSYNC : std_logic;
   signal VGA_VSYNC : std_logic;
   signal VGA_BLUE : std_logic_vector(1 downto 0);
   signal VGA_GREEN : std_logic_vector(2 downto 0);
   signal VGA_RED : std_logic_vector(2 downto 0);
   signal LED0 : std_logic;
   signal LED1 : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 31.25 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: pong PORT MAP (
          VGA_HSYNC => VGA_HSYNC,
          VGA_VSYNC => VGA_VSYNC,
          VGA_BLUE => VGA_BLUE,
          VGA_GREEN => VGA_GREEN,
          VGA_RED => VGA_RED,
          CLK => CLK,
          SWITCH0 => SWITCH0,
          LED0 => LED0,
          LED1 => LED1
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 
		SWITCH0 <= '1';
		wait for 100 us;	
		SWITCH0 <= '0';
		wait for 4 ms;	
		SWITCH0 <= '1';
		
		wait for 1000 ms;	
   end process;

END;
