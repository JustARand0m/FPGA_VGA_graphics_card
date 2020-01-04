library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity COUNTER is
	generic(INT_RANGE: integer);
	port(
		CLK, RESET, EN: in std_logic;
		Q: out integer range 0 to INT_RANGE);
end COUNTER;

architecture BEHAV of COUNTER is
	signal CNT: integer range 0 to INT_RANGE := 0;
begin
	process(CLK, RESET)  
		begin      
			if (CLK='1' and CLK'event) then
			    if(RESET='1') then
			        CNT<= 1;
			    else
			        if('1' = EN) then
				        CNT<= CNT+1;
				    end if;
				end if;
			end if;
	end process;
	Q <= CNT;
end BEHAV;
