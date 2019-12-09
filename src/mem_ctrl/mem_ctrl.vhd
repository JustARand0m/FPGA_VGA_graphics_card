library ieee;
use ieee.std_logic_1164.all;

entity MEM_CTRL is
	port(-- OUTPUT
	     R_R, R_G, R_B : out std_logic_vector(3 downto 0);
	     R_ADDR: in std_logic_vector (18 downto 0);
	     R_CLK: in std_logic;
	     -- INPUT
	     W_R, W_G, W_B : in std_logic_vector(3 downto 0);
	     W_ADDR: in std_logic_vector (18 downto 0);
	     W_CLK: in std_logic;
	     RESET: in std_logic);
end MEM_CTRL;

architecture BEHAV of MEM_CTRL is
begin
end BEHAV;
