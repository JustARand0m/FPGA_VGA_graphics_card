-- CREATOR: Michael Braun
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity DUAL_RAM is
	port(-- OUTPUT
	     D_O : out std_logic_vector(3 downto 0);
	     R_ADDR: in std_logic_vector (18 downto 0);
	     R_CLK: in std_logic;
	     -- INPUT
         W_EN: in std_logic;
		 D_I: in std_logic_vector(3 downto 0);
	     W_ADDR: in std_logic_vector (18 downto 0);
	     W_CLK: in std_logic
     );
end DUAL_RAM;

architecture BEHAV of DUAL_RAM is
	 -- 640 * 480 - 1 = 307199
	 type ram_type is array (0 to 307199) of std_logic_vector(3 downto 0);
	 signal RAM: RAM_TYPE := (others => (others => '0'));
begin
	READ: process(R_CLK, W_EN, R_ADDR)
	begin
		if(rising_edge(R_CLK)) then
			--if(W_EN = '0') then
				D_O <= RAM(to_integer(unsigned(R_ADDR)));
			--end if;
		end if;
	end process READ;
	
	WRITE: process(W_CLK, W_EN, W_ADDR, D_I)
        variable BLANK_INDICATION: std_logic := '0';
	begin
        if(rising_edge(W_CLK)) then
            --if(W_EN = '1') then
                RAM(to_integer(unsigned(W_ADDR))) <= D_I;
            --end if;
        end if;
    end process WRITE;
end BEHAV;