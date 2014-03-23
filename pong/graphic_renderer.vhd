----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:39:11 02/28/2014 
-- Design Name: 
-- Module Name:    graphic_renderer - Behavioral 
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

entity graphic_renderer is
	port (
		vga_row_i : in  unsigned (10 downto 0);
		vga_column_i : in unsigned (10 downto 0);
		activ_display_i : in std_logic;
		blue_o : out std_logic_vector(1 downto 0);
		green_o : out std_logic_vector(2 downto 0);
		red_o : out std_logic_vector(2 downto 0);
		clk_i : in std_logic; 
		rst_n : in std_logic);
end graphic_renderer;

-- boder
--architecture Behavioral of graphic_renderer is
--	signal border : std_logic;
--begin
--	border <= '1' when (vga_column_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_column_i(10 downto 3) = to_unsigned(99,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(74,7)) else
--				 '0';
--				 
--	genblue : for i in 0 to 1 generate
--	begin
--		blue_o(i) <= activ_display_i and (border);
--	end generate;
--	genredgreen : for i in 0 to 2 generate
--	begin
--		red_o(i) <= activ_display_i and (border);
--		green_o(i) <= activ_display_i and (border);
--	end generate;
--end Behavioral;

-- fixed screen
--architecture Behavioral of graphic_renderer is
--	signal border : std_logic;
--begin
--	border <= '1' when (vga_column_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_column_i(10 downto 3) = to_unsigned(99,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(74,7)) else
--				 '0';
--				 
--	genblue : for i in 0 to 1 generate
--	begin
--		blue_o(i) <= activ_display_i and (border or (vga_column_i(4) or vga_row_i(3)));
--	end generate;
--	genredgreen : for i in 0 to 2 generate
--	begin
--		red_o(i) <= activ_display_i and (border or (vga_column_i(6) or vga_row_i(2)));
--		green_o(i) <= activ_display_i and (border or (vga_column_i(8) or vga_row_i(4)));
--	end generate;
--end Behavioral;

-- fixed screen
--architecture Behavioral of graphic_renderer is
--	signal border : std_logic;
--begin
--	border <= '1' when (vga_column_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_column_i(10 downto 3) = to_unsigned(99,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(74,7)) else
--				 '0';
--				 
--	genblue : for i in 0 to 1 generate
--	begin
--		blue_o(i) <= activ_display_i and (border or (vga_column_i(4+i) or vga_row_i(3+i)));
--	end generate;
--	genredgreen : for i in 0 to 2 generate
--	begin
--		red_o(i) <= activ_display_i and (border or (vga_column_i(6+i) or vga_row_i(2+i)));
--		green_o(i) <= activ_display_i and (border or (vga_column_i(8+i) or vga_row_i(4-i)));
--	end generate;
--end Behavioral;

-- mov right H
architecture Behavioral of graphic_renderer is
	signal border : std_logic;
	
	signal movRightCounter_s : unsigned (17 downto 0);

	signal movRightOffset_s : unsigned (10 downto 0);
	signal colBuffer_s : unsigned (10 downto 0);

	constant Max_c : unsigned (17 downto 0) := (others => '1');	
	constant colMax_c : unsigned (10 downto 0) := to_unsigned(799, 11);
begin
	movr_p: process (clk_i, rst_n, movRightCounter_s)
	begin
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				movRightCounter_s <= (others => '0');
			else
				movRightCounter_s <= movRightCounter_s + 1;
			end if;
		end if;
	end process movr_p;
	
	shiftr_p: process (clk_i, rst_n, movRightCounter_s)
	begin
		if (rising_edge(clk_i)) then
			if (rst_n = '0') then
				movRightOffset_s <= (others => '0');
			elsif (movRightCounter_s = Max_c) then
				if (movRightOffset_s = colMax_c) then
					movRightOffset_s <= (others => '0');
				else
					movRightOffset_s <= movRightOffset_s + 1;
				end if;
			end if;
		end if;
	end process shiftr_p;	
	
	colBuffer_s <= vga_column_i + movRightOffset_s;
	
	border <= '1' when (vga_column_i(10 downto 3) = to_unsigned(0,7)) else
				 '1' when (vga_column_i(10 downto 3) = to_unsigned(99,7)) else
				 '1' when (vga_row_i(10 downto 3) = to_unsigned(0,7)) else
				 '1' when (vga_row_i(10 downto 3) = to_unsigned(74,7)) else
				 '0';
				 
	genblue : for i in 0 to 1 generate
	begin
		blue_o(i) <= activ_display_i and (border or (colBuffer_s(4+i) or vga_row_i(3+i)));
	end generate;
	genredgreen : for i in 0 to 2 generate
	begin
		red_o(i) <= activ_display_i and (border or (colBuffer_s(6+i) or vga_row_i(2+i)));
		green_o(i) <= activ_display_i and (border or (colBuffer_s(8+i) or vga_row_i(4-i)));
	end generate;
end Behavioral;

-- mov right H + V shift
--architecture Behavioral of graphic_renderer is
--	signal border : std_logic;
--	
--	signal movRightCounter_s : unsigned (18 downto 0);
--	signal rowShiftCounter_s : unsigned (6 downto 0);
--
--	signal movRightOffset_s : unsigned (10 downto 0);
--	signal rowShiftOffset_s : unsigned (3 downto 0);
--	signal colBuffer_s : unsigned (10 downto 0);
--	signal rowBuffer_s : unsigned (10 downto 0);
--
--	constant Max_c : unsigned (18 downto 0) := (others => '1');	
--	constant colMax_c : unsigned (10 downto 0) := to_unsigned(799, 11);
--	constant rowShiftMax_c : unsigned (3 downto 0) := to_unsigned(10, 4);
--begin
--	movr_p: process (clk_i, rst_n, movRightCounter_s)
--	begin
--		if (rising_edge(clk_i)) then
--			if (rst_n = '0') then
--				movRightCounter_s <= (others => '0');
--			else
--				movRightCounter_s <= movRightCounter_s + 1;
--			end if;
--		end if;
--	end process movr_p;
--	
--	shiftr_p: process (clk_i, rst_n, movRightCounter_s, movRightOffset_s, rowShiftCounter_s)
--	begin
--		if (rising_edge(clk_i)) then
--			if (rst_n = '0') then
--				movRightOffset_s <= (others => '0');
--				rowShiftOffset_s <= (others => '0');
--				rowShiftCounter_s <= (others => '0');
--			elsif (movRightCounter_s = Max_c) then
--				if (movRightOffset_s = colMax_c) then
--					movRightOffset_s <= (others => '0');
--				else
--					movRightOffset_s <= movRightOffset_s + 1;
--				end if;
--				
--				if (rowShiftCounter_s = Max_c(6 downto 0)) then
--					rowShiftCounter_s <= (others => '0');
--					if (rowShiftOffset_s = rowShiftMax_c) then
--						rowShiftOffset_s  <= (others => '0');
--					else
--						rowShiftOffset_s <= rowShiftOffset_s + 1;
--					end if;
--				else
--					rowShiftCounter_s <= rowShiftCounter_s + 1;
--				end if;
--			end if;
--		end if;
--	end process shiftr_p;	
--	
--	rowshift_p: process (clk_i, rst_n, rowShiftOffset_s)
--	begin
--		if (rising_edge(clk_i)) then
--			case rowShiftOffset_s is 
--				when to_unsigned(0, 4) => rowBuffer_s <= vga_row_i;
--				when to_unsigned(1, 4) => rowBuffer_s <= vga_row_i(9 downto 0) & vga_row_i(10);
--				when to_unsigned(2, 4) => rowBuffer_s <= vga_row_i(8 downto 0) & vga_row_i(10 downto 9);
--				when to_unsigned(3, 4) => rowBuffer_s <= vga_row_i(7 downto 0) & vga_row_i(10 downto 8);
--				when to_unsigned(4, 4) => rowBuffer_s <= vga_row_i(6 downto 0) & vga_row_i(10 downto 7);
--				when to_unsigned(5, 4) => rowBuffer_s <= vga_row_i(5 downto 0) & vga_row_i(10 downto 6);
--				when to_unsigned(6, 4) => rowBuffer_s <= vga_row_i(4 downto 0) & vga_row_i(10 downto 5);
--				when to_unsigned(7, 4) => rowBuffer_s <= vga_row_i(3 downto 0) & vga_row_i(10 downto 4);
--				when to_unsigned(8, 4) => rowBuffer_s <= vga_row_i(2 downto 0) & vga_row_i(10 downto 3);
--				when to_unsigned(9, 4) => rowBuffer_s <= vga_row_i(1 downto 0) & vga_row_i(10 downto 2);
--				when to_unsigned(10, 4) => rowBuffer_s <= vga_row_i(0) & vga_row_i(10 downto 1);
--				when others => rowBuffer_s <= vga_row_i;
--			end case;
--		end if;
--	end process rowshift_p;
--	
--	colBuffer_s <= vga_column_i + movRightOffset_s;
--	
--	border <= '1' when (vga_column_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_column_i(10 downto 3) = to_unsigned(99,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(74,7)) else
--				 '0';
--				 
--	genblue : for i in 0 to 1 generate
--	begin
--		blue_o(i) <= activ_display_i and (border or (colBuffer_s(4+i) or rowBuffer_s(3+i)));
--	end generate;
--	genredgreen : for i in 0 to 2 generate
--	begin
--		red_o(i) <= activ_display_i and (border or (colBuffer_s(6+i) or rowBuffer_s(2+i)));
--		green_o(i) <= activ_display_i and (border or (colBuffer_s(8+i) or rowBuffer_s(4-i)));
--	end generate;
--end Behavioral;

-- mov right H + V shift + H Shift
--architecture Behavioral of graphic_renderer is
--	signal border : std_logic;
--	
--	signal movRightCounter_s : unsigned (18 downto 0);
--	signal rowShiftCounter_s : unsigned (6 downto 0);
--
--	signal movRightOffset_s : unsigned (10 downto 0);
--	signal rowShiftOffset_s : unsigned (3 downto 0);
--	signal colBuffer_s : unsigned (10 downto 0);
--	signal colBufferShift_s : unsigned (10 downto 0);
--	signal rowBuffer_s : unsigned (10 downto 0);
--
--	constant Max_c : unsigned (18 downto 0) := (others => '1');	
--	constant colMax_c : unsigned (10 downto 0) := to_unsigned(799, 11);
--	constant rowShiftMax_c : unsigned (3 downto 0) := to_unsigned(10, 4);
--begin
--	movr_p: process (clk_i, rst_n, movRightCounter_s)
--	begin
--		if (rising_edge(clk_i)) then
--			if (rst_n = '0') then
--				movRightCounter_s <= (others => '0');
--			else
--				movRightCounter_s <= movRightCounter_s + 1;
--			end if;
--		end if;
--	end process movr_p;
--	
--	shiftr_p: process (clk_i, rst_n, movRightCounter_s, movRightOffset_s, rowShiftCounter_s)
--	begin
--		if (rising_edge(clk_i)) then
--			if (rst_n = '0') then
--				movRightOffset_s <= (others => '0');
--				rowShiftOffset_s <= (others => '0');
--				rowShiftCounter_s <= (others => '0');
--			elsif (movRightCounter_s = Max_c) then
--				if (movRightOffset_s = colMax_c) then
--					movRightOffset_s <= (others => '0');
--				else
--					movRightOffset_s <= movRightOffset_s + 1;
--				end if;
--				
--				if (rowShiftCounter_s = Max_c(6 downto 0)) then
--					rowShiftCounter_s <= (others => '0');
--					if (rowShiftOffset_s = rowShiftMax_c) then
--						rowShiftOffset_s  <= (others => '0');
--					else
--						rowShiftOffset_s <= rowShiftOffset_s + 1;
--					end if;
--				else
--					rowShiftCounter_s <= rowShiftCounter_s + 1;
--				end if;
--			end if;
--		end if;
--	end process shiftr_p;	
--	
--	rowshift_p: process (clk_i, rst_n, rowShiftOffset_s)
--	begin
--		if (rising_edge(clk_i)) then
--			case rowShiftOffset_s is 
--				when to_unsigned(0, 4) => rowBuffer_s <= vga_row_i;
--				when to_unsigned(1, 4) => rowBuffer_s <= vga_row_i(9 downto 0) & vga_row_i(10);
--				when to_unsigned(2, 4) => rowBuffer_s <= vga_row_i(8 downto 0) & vga_row_i(10 downto 9);
--				when to_unsigned(3, 4) => rowBuffer_s <= vga_row_i(7 downto 0) & vga_row_i(10 downto 8);
--				when to_unsigned(4, 4) => rowBuffer_s <= vga_row_i(6 downto 0) & vga_row_i(10 downto 7);
--				when to_unsigned(5, 4) => rowBuffer_s <= vga_row_i(5 downto 0) & vga_row_i(10 downto 6);
--				when to_unsigned(6, 4) => rowBuffer_s <= vga_row_i(4 downto 0) & vga_row_i(10 downto 5);
--				when to_unsigned(7, 4) => rowBuffer_s <= vga_row_i(3 downto 0) & vga_row_i(10 downto 4);
--				when to_unsigned(8, 4) => rowBuffer_s <= vga_row_i(2 downto 0) & vga_row_i(10 downto 3);
--				when to_unsigned(9, 4) => rowBuffer_s <= vga_row_i(1 downto 0) & vga_row_i(10 downto 2);
--				when to_unsigned(10, 4) => rowBuffer_s <= vga_row_i(0) & vga_row_i(10 downto 1);
--				when others => rowBuffer_s <= vga_row_i;
--			end case;
--		end if;
--	end process rowshift_p;
--	
--	colshift_p: process (clk_i, rst_n, rowShiftOffset_s, vga_column_i)
--	begin
--		if (rising_edge(clk_i)) then
--			case rowShiftOffset_s is 
--				when to_unsigned(0, 4) => colBufferShift_s <= vga_column_i;
--				when to_unsigned(1, 4) => colBufferShift_s <= vga_column_i(9 downto 0) & vga_column_i(10);
--				when to_unsigned(2, 4) => colBufferShift_s <= vga_column_i(8 downto 0) & vga_column_i(10 downto 9);
--				when to_unsigned(3, 4) => colBufferShift_s <= vga_column_i(7 downto 0) & vga_column_i(10 downto 8);
--				when to_unsigned(4, 4) => colBufferShift_s <= vga_column_i(6 downto 0) & vga_column_i(10 downto 7);
--				when to_unsigned(5, 4) => colBufferShift_s <= vga_column_i(5 downto 0) & vga_column_i(10 downto 6);
--				when to_unsigned(6, 4) => colBufferShift_s <= vga_column_i(4 downto 0) & vga_column_i(10 downto 5);
--				when to_unsigned(7, 4) => colBufferShift_s <= vga_column_i(3 downto 0) & vga_column_i(10 downto 4);
--				when to_unsigned(8, 4) => colBufferShift_s <= vga_column_i(2 downto 0) & vga_column_i(10 downto 3);
--				when to_unsigned(9, 4) => colBufferShift_s <= vga_column_i(1 downto 0) & vga_column_i(10 downto 2);
--				when to_unsigned(10, 4) => colBufferShift_s <= vga_column_i(0) & vga_column_i(10 downto 1);
--				when others => colBufferShift_s <= vga_column_i;
--			end case;
--		end if;
--	end process colshift_p;	
--	colBuffer_s <= colBufferShift_s + movRightOffset_s;
--	
--	border <= '1' when (vga_column_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_column_i(10 downto 3) = to_unsigned(99,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(74,7)) else
--				 '0';
--				 
--	genblue : for i in 0 to 1 generate
--	begin
--		blue_o(i) <= activ_display_i and (border or (colBuffer_s(4+i) or rowBuffer_s(3+i)));
--	end generate;
--	genredgreen : for i in 0 to 2 generate
--	begin
--		red_o(i) <= activ_display_i and (border or (colBuffer_s(6+i) or rowBuffer_s(2+i)));
--		green_o(i) <= activ_display_i and (border or (colBuffer_s(8+i) or rowBuffer_s(4-i)));
--	end generate;
--end Behavioral;

-- mov right H + V shift + H Shift2
--architecture Behavioral of graphic_renderer is
--	signal border : std_logic;
--	
--	signal movRightCounter_s : unsigned (18 downto 0);
--	signal rowShiftCounter_s : unsigned (6 downto 0);
--
--	signal movRightOffset_s : unsigned (10 downto 0);
--	signal rowShiftOffset_s : unsigned (3 downto 0);
--	signal colBuffer_s : unsigned (10 downto 0);
--	signal colBufferShift_s : unsigned (10 downto 0);
--	signal rowBuffer_s : unsigned (10 downto 0);
--
--	constant Max_c : unsigned (18 downto 0) := (others => '1');	
--	constant colMax_c : unsigned (10 downto 0) := to_unsigned(799, 11);
--	constant rowShiftMax_c : unsigned (3 downto 0) := to_unsigned(10, 4);
--begin
--	movr_p: process (clk_i, rst_n, movRightCounter_s)
--	begin
--		if (rising_edge(clk_i)) then
--			if (rst_n = '0') then
--				movRightCounter_s <= (others => '0');
--			else
--				movRightCounter_s <= movRightCounter_s + 1;
--			end if;
--		end if;
--	end process movr_p;
--	
--	shiftr_p: process (clk_i, rst_n, movRightCounter_s, movRightOffset_s, rowShiftCounter_s)
--	begin
--		if (rising_edge(clk_i)) then
--			if (rst_n = '0') then
--				movRightOffset_s <= (others => '0');
--				rowShiftOffset_s <= (others => '0');
--				rowShiftCounter_s <= (others => '0');
--			elsif (movRightCounter_s = Max_c) then
--				if (movRightOffset_s = colMax_c) then
--					movRightOffset_s <= (others => '0');
--				else
--					movRightOffset_s <= movRightOffset_s + 1;
--				end if;
--				
--				if (rowShiftCounter_s = Max_c(6 downto 0)) then
--					rowShiftCounter_s <= (others => '0');
--					if (rowShiftOffset_s = rowShiftMax_c) then
--						rowShiftOffset_s  <= (others => '0');
--					else
--						rowShiftOffset_s <= rowShiftOffset_s + 1;
--					end if;
--				else
--					rowShiftCounter_s <= rowShiftCounter_s + 1;
--				end if;
--			end if;
--		end if;
--	end process shiftr_p;	
--	
--	rowshift_p: process (clk_i, rst_n, rowShiftOffset_s)
--	begin
--		if (rising_edge(clk_i)) then
--			case rowShiftOffset_s is 
--				when to_unsigned(0, 4) => rowBuffer_s <= vga_row_i;
--				when to_unsigned(1, 4) => rowBuffer_s <= vga_row_i(9 downto 0) & vga_row_i(10);
--				when to_unsigned(2, 4) => rowBuffer_s <= vga_row_i(8 downto 0) & vga_row_i(10 downto 9);
--				when to_unsigned(3, 4) => rowBuffer_s <= vga_row_i(7 downto 0) & vga_row_i(10 downto 8);
--				when to_unsigned(4, 4) => rowBuffer_s <= vga_row_i(6 downto 0) & vga_row_i(10 downto 7);
--				when to_unsigned(5, 4) => rowBuffer_s <= vga_row_i(5 downto 0) & vga_row_i(10 downto 6);
--				when to_unsigned(6, 4) => rowBuffer_s <= vga_row_i(4 downto 0) & vga_row_i(10 downto 5);
--				when to_unsigned(7, 4) => rowBuffer_s <= vga_row_i(3 downto 0) & vga_row_i(10 downto 4);
--				when to_unsigned(8, 4) => rowBuffer_s <= vga_row_i(2 downto 0) & vga_row_i(10 downto 3);
--				when to_unsigned(9, 4) => rowBuffer_s <= vga_row_i(1 downto 0) & vga_row_i(10 downto 2);
--				when to_unsigned(10, 4) => rowBuffer_s <= vga_row_i(0) & vga_row_i(10 downto 1);
--				when others => rowBuffer_s <= vga_row_i;
--			end case;
--		end if;
--	end process rowshift_p;
--	
--	colshift_p: process (clk_i, rst_n, rowShiftOffset_s, vga_column_i)
--	begin
--		if (rising_edge(clk_i)) then
--			case rowShiftOffset_s is 
--				when to_unsigned(0, 4) => colBufferShift_s <= colBuffer_s;
--				when to_unsigned(1, 4) => colBufferShift_s <= colBuffer_s(9 downto 0) & colBuffer_s(10);
--				when to_unsigned(2, 4) => colBufferShift_s <= colBuffer_s(8 downto 0) & colBuffer_s(10 downto 9);
--				when to_unsigned(3, 4) => colBufferShift_s <= colBuffer_s(7 downto 0) & colBuffer_s(10 downto 8);
--				when to_unsigned(4, 4) => colBufferShift_s <= colBuffer_s(6 downto 0) & colBuffer_s(10 downto 7);
--				when to_unsigned(5, 4) => colBufferShift_s <= colBuffer_s(5 downto 0) & colBuffer_s(10 downto 6);
--				when to_unsigned(6, 4) => colBufferShift_s <= colBuffer_s(4 downto 0) & colBuffer_s(10 downto 5);
--				when to_unsigned(7, 4) => colBufferShift_s <= colBuffer_s(3 downto 0) & colBuffer_s(10 downto 4);
--				when to_unsigned(8, 4) => colBufferShift_s <= colBuffer_s(2 downto 0) & colBuffer_s(10 downto 3);
--				when to_unsigned(9, 4) => colBufferShift_s <= colBuffer_s(1 downto 0) & colBuffer_s(10 downto 2);
--				when to_unsigned(10, 4) => colBufferShift_s <= colBuffer_s(0) & colBuffer_s(10 downto 1);
--				when others => colBufferShift_s <= colBuffer_s;
--			end case;
--		end if;
--	end process colshift_p;	
--	colBuffer_s <= vga_column_i + movRightOffset_s;
--	
--	border <= '1' when (vga_column_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_column_i(10 downto 3) = to_unsigned(99,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(0,7)) else
--				 '1' when (vga_row_i(10 downto 3) = to_unsigned(74,7)) else
--				 '0';
--				 
--	genblue : for i in 0 to 1 generate
--	begin
--		blue_o(i) <= activ_display_i and (border or (colBufferShift_s(4+i) or rowBuffer_s(3+i)));
--	end generate;
--	genredgreen : for i in 0 to 2 generate
--	begin
--		red_o(i) <= activ_display_i and (border or (colBufferShift_s(6+i) or rowBuffer_s(2+i)));
--		green_o(i) <= activ_display_i and (border or (colBufferShift_s(8+i) or rowBuffer_s(4-i)));
--	end generate;
--end Behavioral;