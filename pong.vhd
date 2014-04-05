----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:24:10 02/21/2014 
-- Design Name: 
-- Module Name:    pong - Behavioral 
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

entity pong is
	port (
		VGA_HSYNC : out std_logic;
		VGA_VSYNC : out std_logic;
		VGA_BLUE : out std_logic_vector(1 downto 0);
		VGA_GREEN : out std_logic_vector(2 downto 0);
		VGA_RED : out std_logic_vector(2 downto 0);
		CLK : in std_logic; 
		SWITCH0: in std_logic;
		LED0: out std_logic;
		LED1: out std_logic);
end pong;

architecture Behavioral of pong is
	component clkgen_dcm
	port
	 (-- Clock in ports
	  CLK_IN1           : in     std_logic; -- 32 MHz
	  -- Clock out ports
	  CLK_OUT1          : out    std_logic -- 21.175MHz
	 );
	end component;
	
	component graphic_renderer is
	port (
		vga_row_i : in  unsigned (10 downto 0);
		vga_column_i : in unsigned (10 downto 0);
		activ_display_i: in std_logic;
		blue_o : out std_logic_vector(1 downto 0);
		green_o : out std_logic_vector(2 downto 0);
		red_o : out std_logic_vector(2 downto 0);
		clk_i : in std_logic; 
		rst_n : in std_logic);
	end component;
	
	component vga_ctrl is
	port (
		vga_sync_h_o : out std_logic; 
		vga_sync_v_o : out std_logic; 
		vga_active_display_o : out std_logic;
		vga_row_o : out unsigned (10 downto 0);
		vga_column_o : out unsigned (10 downto 0);
		clk_i : in std_logic; 
		rst_n : in std_logic);
	end component;
	
	component switch_debounce is
    Port ( clk_i : in  STD_LOGIC;
           switch_i : in  STD_LOGIC; -- pull-up by default
			  reset_no : out STD_LOGIC); 
	end component;
	
	signal clk_s : std_logic;
	signal rst_n : std_logic;
	signal activeDisplay_s : std_logic;
	signal col_s : unsigned (10 downto 0);
	signal row_s : unsigned (10 downto 0);	

begin
	LED0 <= rst_n;
	LED1 <= activeDisplay_s;
	
	U_switch_debounce : switch_debounce
		port map 
		( clk_i => clk_s,
        switch_i => SWITCH0,
		  reset_no => rst_n); 			  
	
	U_clkgen_dcm : clkgen_dcm
		port map
		(-- Clock in ports
		CLK_IN1 => CLK,
		-- Clock out ports
		CLK_OUT1 => clk_s);
	
	U_vga_ctrl : vga_ctrl
		port map
		(vga_sync_h_o =>  VGA_HSYNC,
		vga_sync_v_o => VGA_VSYNC,
		vga_active_display_o => activeDisplay_s,
		vga_row_o => row_s,
		vga_column_o => col_s,
		clk_i => clk_s,
		rst_n => rst_n);
		
	U_graphic_renderer : graphic_renderer
		port map 
	  (vga_row_i => row_s,
		vga_column_i => col_s,
		activ_display_i => activeDisplay_s,
		blue_o => VGA_BLUE,
		green_o => VGA_GREEN,
		red_o => VGA_RED,
		clk_i => clk_s,
		rst_n => rst_n);
	
end Behavioral;

