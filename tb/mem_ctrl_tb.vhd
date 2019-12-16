library ieee;
use ieee.std_logic_1164.all;

entity MEM_CTRL_TB is
end MEM_CTRL_TB;

architecture TESTBENCH of MEM_CTRL_TB is
    component MEM_CTRL is
        port(
            -- OUTPUT
            R_R, R_G, R_B : out std_logic_vector(3 downto 0);
            R_ADDR: in std_logic_vector(18 downto 0);
            R_CLK: in std_logic;
             -- INPUT
            W_R, W_G, W_B : in std_logic_vector(3 downto 0);
            W_ADDR: in std_logic_vector(18 downto 0);
            W_CLK: in std_logic;
            RESET: in std_logic
        );
    end component MEM_CTRL;

    signal TB_R_R:      std_logic_vector(3 downto 0)    := '000'; 
    signal TB_R_G:      std_logic_vector(3 downto 0)    := '000'; 
    signal TB_R_B:      std_logic_vector(3 downto 0)    := '000'; 
    signal TB_R_ADDR:   std_logic_vector(18 downto 0)   := (others => '0');
    signal TB_R_CLK:    std_logic := '0';
	
    signal TB_W_R:      std_logic_vector(3 downto 0)    := '000'; 
    signal TB_W_G:      std_logic_vector(3 downto 0)    := '111'; 
    signal TB_W_B:      std_logic_vector(3 downto 0)    := '000';
    signal TB_W_ADDR:   std_logic_vector(18 downto 0)   := (others => '0');
    signal TB_W_CLK:    std_logic := '0';

    signal TB_RESET: std_logic := '0';

begin
	INST_MEM_CTRL: MEM_CTRL port map(
		R_R    => TB_R_R,
		R_G    => TB_R_G,
		R_B    => TB_R_B,
		R_ADDR => TB_R_ADDR,
		R_CLK  => TB_R_CLK,
		W_R    => TB_W_R,
		W_G    => TB_W_G,
		W_B    => TB_W_B,
		W_ADDR => TB_W_ADDR,
		W_CLK  => TB_W_CLK,
		RESET  => TB_RESET
	);

	TB_R_CLK <= not TB_R_CLK after 20 ns;
	TB_W_CLK <= not TB_W_CLK after 20 ns;

end TESTBENCH;
