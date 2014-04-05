----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:41:12 02/20/2014 
-- Design Name: 
-- Module Name:    vga_ctrl - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 800x600@60Hz with pixel_clk=40MHz
--					 Hsync - pos polarity
--					 Vsync - pos polarity
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

entity vga_ctrl is
	port (
		vga_sync_h_o : out std_logic; 
		vga_sync_v_o : out std_logic; 
		vga_active_display_o : out std_logic;
		vga_row_o : out unsigned (10 downto 0);
		vga_column_o : out unsigned (10 downto 0);
		clk_i : in std_logic; 
		rst_n : in std_logic);
end vga_ctrl;

architecture Behavioral of vga_ctrl is	
	-- column
	constant counterMaxH_c : unsigned(10 downto 0) := to_unsigned(1055, 11);
	constant frontPorchTimeH_c : unsigned (10 downto 0) := to_unsigned(800, 11);
	constant syncTimeH_c : unsigned (10 downto 0) := to_unsigned(840, 11);
	constant backPorchTimeH_c : unsigned (10 downto 0) := to_unsigned(968, 11);

	-- row
	constant counterMaxV_c : unsigned(10 downto 0) := to_unsigned(627, 11);
	constant frontPorchTimeV_c : unsigned (10 downto 0) := to_unsigned(600, 11);
	constant syncTimeV_c : unsigned (10 downto 0) := to_unsigned(601, 11);
	constant backPorchTimeV_c : unsigned (10 downto 0) := to_unsigned(605, 11);

	signal counterH_s : unsigned(10 downto 0) := (others => '0');
	signal counterV_s : unsigned(10 downto 0) := (others => '0');
	signal colH_s : unsigned(10 downto 0) := (others => '0');
	signal rowV_s : unsigned(10 downto 0) := (others => '0');
	
	signal vgaSyncH_s : std_logic := '0';
	signal vgaSyncV_s : std_logic := '0';
	
	signal activH_s : std_logic := '0';
	signal activV_s : std_logic := '0';	
begin
	cntH_p: process (clk_i, counterH_s)
	begin
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				counterH_s <= (others => '0');
			elsif (counterH_s = counterMaxH_c) then
				counterH_s <= (others => '0');
			else
				counterH_s <= counterH_s + 1;
			end if;
		end if;
	end process cntH_p;
	
	cntV_p: process (clk_i, counterV_s)
	begin
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				counterV_s <= (others => '0');
			elsif (counterH_s = counterMaxH_c) then
				if (counterV_s = counterMaxV_c) then
					counterV_s <= (others => '0');
				else
					counterV_s <= counterV_s + 1;
				end if;
			end if;
		end if;
	end process cntV_p;	
	
	vgasynch_p : process (clk_i, vgaSyncH_s, counterH_s)
	begin	
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				vgaSyncH_s <= '1';
			elsif (counterH_s = syncTimeH_c) then 
				vgaSyncH_s <= '0';
			elsif (counterH_s = backPorchTimeH_c) then 
				vgaSyncH_s <= '1';
			elsif (counterH_s = 0) then
				vgaSyncH_s <= '1';
			end if;
		end if;
	end process vgasynch_p;
	
	vgasyncv_p : process (clk_i, vgaSyncV_s, counterV_s)
	begin	
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				vgaSyncV_s <= '1';
			elsif (counterV_s = syncTimeV_c) then
				vgaSyncV_s <= '0';
			elsif (counterV_s = backPorchTimeV_c) then
				vgaSyncV_s <= '1';
			elsif	(counterV_s = 0) then
				vgaSyncV_s <= '1';
			end if;
		end if;
	end process vgasyncv_p;
	
	col_p: process (clk_i, counterH_s)
	begin
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				colH_s <= (others => '0');
				activH_s <= '1';
			elsif (counterH_s >= frontPorchTimeH_c) then 
				colH_s <= (others => '0');
				activH_s <= '0';
			else 
				colH_s <= counterH_s;
				activH_s <= '1';
			end if;
		end if;
	end process col_p;

	row_p: process (clk_i, counterV_s)
	begin
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				rowV_s <= (others => '0');
				activV_s <= '1';
			elsif (counterV_s >= frontPorchTimeV_c) then 
				rowV_s <= (others => '0');
				activV_s <= '0';
			else 
				rowV_s <= counterV_s;
				activV_s <= '1';
			end if;
		end if;
	end process row_p;	
	
	vga_sync_h_o <= not vgaSyncH_s;
	vga_sync_v_o <= not vgaSyncV_s;
	vga_active_display_o <= activH_s and activV_s;	
	vga_column_o <= colH_s;
	vga_row_o <= rowV_s;
	
end Behavioral;

