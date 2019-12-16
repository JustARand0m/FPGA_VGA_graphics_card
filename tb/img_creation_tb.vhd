library ieee;
use ieee.std_logic_1164.all;

entity IMG_Create_TB is
end IMG_Create_TB;

architecture TESTBENCH of IMG_Create_TB is
    component IMG_Create is
        port(
            --Outputs
            W_R, W_G, W_B: out std_logic_vector(3 downto 0);
	        W_ADDR: out std_logic_vector(18 downto 0);
	        
            --Inputs
            W_CLK: in std_logic;
	        SYS_CLK: in std_logic;
	        RESET: in std_logic
        );
    end component IMG_Create;

	
    signal TB_W_R:      std_logic_vector(3 downto 0)    := "0000"; 
    signal TB_W_G:      std_logic_vector(3 downto 0)    := "0000"; 
    signal TB_W_B:      std_logic_vector(3 downto 0)    := "0000";
    signal TB_W_ADDR:   std_logic_vector(18 downto 0)   := (others => '0');
    signal TB_W_CLK:    std_logic := '0';
    signal TB_SYS_CLK: std_logic:= '0';

    signal TB_RESET: std_logic := '0';

begin
	INST_IMG_Create: IMG_Create port map(
	    
		W_R    => TB_W_R,
		W_G    => TB_W_G,
		W_B    => TB_W_B,
		W_ADDR => TB_W_ADDR,
		W_CLK  => TB_W_CLK,
        SYS_CLK => TB_SYS_CLK,
		RESET  => TB_RESET
	);
    CHAR0 <= 0x"34";

	TB_SYS_CLK <= not TB_SYS_CLK after 20 ns;
	TB_W_CLK <= not TB_W_CLK after 20 ns;

end TESTBENCH;
