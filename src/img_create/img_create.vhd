library ieee;
use ieee.std_logic_1164.all;

entity IMG_CREATE is
	port(W_R, W_G, W_B: out std_logic_vector(3 downto 0);
	     W_ADDR: out std_logic_vector(18 downto 0);
	     W_CLK: in std_logic;
	     SYS_CLK: in std_logic;
	     RESET: in std_logic);
end IMG_CREATE;

architecture BEHAV of IMG_CREATE is
begin
end BEHAV;
