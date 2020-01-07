-- CREATOR: Korbinian Federholzner
library ieee;
use ieee.std_logic_1164.all;

entity BLANK_CHECK_TB is
end BLANK_CHECK_TB;

architecture TESTBENCH of BLANK_CHECK_TB is
	component BLANK_CHECK is
		port(
			W_R, W_G, W_B: in std_logic_vector(3 downto 0);	
			R_R, R_G, R_B: out std_logic_vector(3 downto 0);
			BLANK: std_logic
		);
	end component BLANK_CHECK;

	signal TB_W_R, TB_W_G, TB_W_B: std_logic_vector(3 downto 0) := "1111";
	signal TB_R_R, TB_R_G, TB_R_B: std_logic_vector(3 downto 0);
	signal TB_BLANK: std_logic := '0';
begin
	INST_BLANK: BLANK_CHECK
		port map(
				W_R => TB_W_R, W_G => TB_W_G, W_B => TB_W_B,
				R_R => TB_R_R, R_G => TB_R_G, R_B => TB_R_B,
			   	BLANK => TB_BLANK
			);

	TB_BLANK <= not TB_BLANK after 20 ns;
end TESTBENCH;
