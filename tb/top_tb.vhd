-- CREATOR: Michael Braun

library ieee;
use ieee.std_logic_1164.all;

entity TOP_TB is
end TOP_TB;

architecture TESTBENCH of TOP_TB is
    component TOP is
        port(
            CLK_IN: in std_logic;
			PMOD_R, PMOD_G, PMOD_B: out std_logic_vector(3 downto 0);
			HS, VS: out std_logic
        );
    end component TOP;

    signal TB_CLK_IN:	   std_logic := '0';
    signal TB_PMOD_R:      std_logic_vector(3 downto 0)    := "0000"; 
    signal TB_PMOD_G:      std_logic_vector(3 downto 0)    := "0000"; 
    signal TB_PMOD_B:      std_logic_vector(3 downto 0)    := "0000";
	signal TB_HS:		   std_logic := '0';
	signal TB_VS:		   std_logic := '0';

begin
	INST_TOP: TOP port map(
		CLK_IN    => TB_CLK_IN,
		PMOD_R	  => TB_PMOD_R,
		PMOD_G	  => TB_PMOD_G,
		PMOD_B	  => TB_PMOD_B,
		HS		  => TB_HS,
		VS		  => TB_VS
	);

	TB_CLK_IN <= not TB_CLK_IN after 5 ns;

end TESTBENCH;
