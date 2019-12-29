-- CREATOR: Michael Braun

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity MEM_CTRL_TB is
end MEM_CTRL_TB;

architecture TESTBENCH of MEM_CTRL_TB is
    component MEM_CTRL is
        port(
            -- OUTPUT
            BLANK: in std_logic;
            R_R, R_G, R_B : out std_logic_vector(3 downto 0) := "0000";
            R_ADDR: in std_logic_vector (18 downto 0);
            R_CLK: in std_logic;
            -- INPUT
            SYNC: in std_logic;
            W_R, W_G, W_B : in std_logic_vector(3 downto 0) := "0000";
            W_ADDR: in std_logic_vector (18 downto 0);
            W_CLK: in std_logic;
            RESET: in std_logic
        );
    end component MEM_CTRL;

    constant MAX_ADDR: integer := 16;

    signal TB_BLANK:    std_logic := '0';
    signal TB_R_R:      std_logic_vector(3 downto 0)    := "0000"; 
    signal TB_R_G:      std_logic_vector(3 downto 0)    := "0000"; 
    signal TB_R_B:      std_logic_vector(3 downto 0)    := "0000"; 
    signal TB_R_ADDR:   std_logic_vector(18 downto 0)   := (others => '0');
    signal TB_R_CLK:    std_logic := '0';
	
    signal TB_SYNC:     std_logic := '0';
    signal TB_W_R:      std_logic_vector(3 downto 0)    := "1111"; 
    signal TB_W_G:      std_logic_vector(3 downto 0)    := "1111"; 
    signal TB_W_B:      std_logic_vector(3 downto 0)    := "1111";
    signal TB_W_ADDR:   std_logic_vector(18 downto 0)   := (others => '0');
    signal TB_W_CLK:    std_logic := '0';

    signal TB_RESET: std_logic := '0';

    signal TB_FRAME_COUNTER: std_logic_vector(3 downto 0) := "0001";

begin
	INST_MEM_CTRL: MEM_CTRL port map(
        BLANK  => TB_BLANK,
		R_R    => TB_R_R,
		R_G    => TB_R_G,
		R_B    => TB_R_B,
		R_ADDR => TB_R_ADDR,
		R_CLK  => TB_R_CLK,
        SYNC   => TB_SYNC,
		W_R    => TB_W_R,
		W_G    => TB_W_G,
		W_B    => TB_W_B,
		W_ADDR => TB_W_ADDR,
		W_CLK  => TB_W_CLK,
		RESET  => TB_RESET
	);

	TB_R_CLK <= not TB_R_CLK after 5 ns;
	TB_W_CLK <= not TB_W_CLK after 1 ns;

    TB_W_R <= TB_FRAME_COUNTER;
    TB_W_G <= TB_FRAME_COUNTER;
    TB_W_B <= TB_FRAME_COUNTER;


    WRITE_ADR: process(TB_W_CLK) begin
        if(rising_edge(TB_W_CLK)) then
            if(TB_W_ADDR = MAX_ADDR - 1) then
                TB_W_ADDR <= (others => '0');
                TB_SYNC <= '1';
                TB_FRAME_COUNTER <= TB_FRAME_COUNTER + 1;
            else
                TB_W_ADDR <= TB_W_ADDR + 1;
                TB_SYNC <= '0';
            end if;
            if(TB_FRAME_COUNTER = 15) then
                TB_FRAME_COUNTER <= (others=>'0');
            end if;
        end if;
    end process WRITE_ADR;

    READ_ADR: process(TB_R_CLK) begin
        if(rising_edge(TB_R_CLK)) then
            if(TB_R_ADDR = MAX_ADDR - 1) then
                TB_R_ADDR <= (others => '0');
                TB_BLANK  <= '1';
            else
                TB_R_ADDR <= TB_R_ADDR + 1;
                TB_BLANK  <= '0';
            end if;
        end if;
    end process READ_ADR;

end TESTBENCH;
