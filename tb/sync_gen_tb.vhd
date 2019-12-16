library ieee;
use ieee.std_logic_1164.all;

entity SYNC_GEN_TB is
end SYNC_GEN_TB;

architecture TESTBENCH of SYNC_GEN_TB is
	component SYNC_GEN is
		generic(
			   C_H_LENGTH: integer := 10;
			   C_V_LENGTH: integer := 9
		);

		port(
			HS, VS: out std_logic;
			C_H: out std_logic_vector (C_H_LENGTH - 1 downto 0);
			C_V: out std_logic_vector (C_V_LENGTH - 1 downto 0);
			BLANK: out std_logic;
			PIXEL_CLK: in std_logic;
			RESET: in std_logic
		);
	end component SYNC_GEN;
	
	signal TB_CLK: std_logic := '0';
	signal TB_RESET, TB_BLANK: std_logic;
	signal TB_HS, TB_VS: std_logic;	
	signal TB_C_H: std_logic_vector (10 - 1 downto 0);
	signal TB_C_V: std_logic_vector (9 - 1 downto 0);

begin
	GEN: SYNC_GEN
		port map(HS => TB_HS, VS => TB_VS, C_H => TB_C_H, C_V => TB_C_V, BLANK => TB_BLANK,
				   PIXEL_CLK => TB_CLK, RESET => TB_RESET);

	TB_CLK <= not TB_CLK after 20 ns;
	TB_RESET <= '0';

end TESTBENCH;
