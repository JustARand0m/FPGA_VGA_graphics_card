library ieee;
use ieee.std_logic_1164.all;

entity SYNC_GEN is
	port(HS, VS: out std_logic;
	     C_H: out std_logic_vector (9 downto 0);
	     C_V: out std_logic_vector (8 downto 0);
		 BLANK: out std_logic;
	     PIXEL_CLK: in std_logic;
	     RESET: in std_logic);
end SYNC_GEN;

architecture BEHAV of SYNC_GEN is
begin
end BEHAV;
