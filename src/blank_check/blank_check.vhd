library ieee;
use ieee.std_logic_1164.all;

entity BLANK_CHECK is
	port(
		W_R, W_G, W_B: in std_logic_vector(3 downto 0);	
		R_R, R_G, R_B: out std_logic_vector(3 downto 0);	
		BLANK: in std_logic
	);
end BLANK_CHECK;

architecture BEHAV of BLANK_CHECK is 
begin
	--@TODO => better method for setting everthing less redundand
	R_R(0) <= W_R(0) and not BLANK;
	R_R(1) <= W_R(1) and not BLANK;
	R_R(2) <= W_R(2) and not BLANK;
	R_R(3) <= W_R(3) and not BLANK;
	R_G(0) <= W_G(0) and not BLANK;
	R_G(1) <= W_G(1) and not BLANK;
	R_G(2) <= W_G(2) and not BLANK;
	R_G(3) <= W_G(3) and not BLANK;
	R_B(0) <= W_B(0) and not BLANK;
	R_B(1) <= W_B(1) and not BLANK;
	R_B(2) <= W_B(2) and not BLANK;
	R_B(3) <= W_B(3) and not BLANK;
end BEHAV;
