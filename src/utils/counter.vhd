library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity COUNTER is
	generic(LENGTH: integer);
	port(
		CLK, RESET, EN: in std_logic;
		Q: out std_logic_vector(LENGTH-1 downto 0));
end COUNTER;

architecture BEHAV of COUNTER is
	signal CNT: std_logic_vector(LENGTH-1 downto 0):=(others=>'0');
begin
	process(CLK, RESET)  
		begin
			if (RESET='1') then
				CNT<=(others=>'0');      
			elsif (EN = '1') then 
				if(CLK='1' and CLK'event) then
					CNT<= CNT+1;
				end if;
			end if;
	end process;
	Q <= CNT;
end BEHAV;

