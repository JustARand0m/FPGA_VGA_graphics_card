-- CREATOR: Michael Braun

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity INTEGRATION_TB is
end INTEGRATION_TB;

architecture TESTBENCH of INTEGRATION_TB is
    component MEM_CTRL is
        port(
            -- OUTPUT
            BLANK: in std_logic;
            R_R, R_G, R_B : out std_logic_vector(3 downto 0) := "0000";
            R_ADDR: in std_logic_vector (18 downto 0);
            R_CLK: in std_logic;
            -- INPUT
            SYNC: in std_logic;
            W_EN: in std_logic;
            W_R, W_G, W_B : in std_logic_vector(3 downto 0) := "0000";
            W_ADDR: in std_logic_vector (18 downto 0);
            W_CLK: in std_logic;
            RESET: in std_logic
        );
    end component MEM_CTRL;
	
	component IMG_CREATE is
	port(
         W_R: out std_logic_vector(3 downto 0) := (others => '1');
         W_G: out std_logic_vector(3 downto 0) := (others => '0');
         W_B: out std_logic_vector(3 downto 0) := (others => '0');
	     W_ADDR: out std_logic_vector(18 downto 0);
	     W_CLK: in std_logic;
         W_EN: out std_logic;
	     SYS_CLK: in std_logic;
	     RESET: in std_logic;
         SYNC: out std_logic := '0');
    end component IMG_CREATE;
    
    component SYNC_GEN is
	port(
		HS: out std_logic := '0';
		VS: out std_logic := '0';
		C_H: out std_logic_vector (9 downto 0);
		C_V: out std_logic_vector (8 downto 0);
		BLANK: out std_logic;
		PIXEL_CLK: in std_logic;
		RESET: in std_logic
	);
    end component SYNC_GEN;

    constant MAX_ADDR: integer := 20;

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

    signal TB_RESET, TB_W_EN: std_logic := '0';

    signal TB_FRAME_COUNTER: std_logic_vector(3 downto 0) := "0001";

    signal TB_HS, TB_VS: std_logic;
    signal TB_C_H: std_logic_vector(9 downto 0);
    signal TB_C_V: std_logic_vector(8 downto 0);

begin

    TB_R_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(TB_C_V)) * 480 + to_integer(unsigned(TB_C_H)), 19));

	INST_MEM_CTRL: MEM_CTRL port map(
        BLANK  => TB_BLANK,
		R_R    => TB_R_R,
		R_G    => TB_R_G,
		R_B    => TB_R_B,
        R_ADDR => TB_R_ADDR, 
        R_CLK  => TB_R_CLK,
        SYNC   => TB_SYNC,
        W_EN   => TB_W_EN,
		W_R    => TB_W_R,
		W_G    => TB_W_G,
		W_B    => TB_W_B,
		W_ADDR => TB_W_ADDR,
		W_CLK  => TB_W_CLK,
		RESET  => TB_RESET
	);
	
	ISNT_IMG_CREATE: IMG_CREATE port map(
         W_R	=> TB_W_R,
         W_G	=> TB_W_G,
         W_B	=> TB_W_B,
	     W_ADDR	=> TB_W_ADDR,
	     W_CLK	=> TB_W_CLK,
         W_EN	=> TB_W_EN,
	     SYS_CLK	=> TB_W_CLK,
	     RESET	=> '0',
         SYNC	=> TB_SYNC
    );
    
    INST_SYNC_GEN: SYNC_GEN port map(
		HS  => TB_HS,
		VS  => TB_VS,
		C_H => TB_C_H,
		C_V => TB_C_V,
		BLANK       => TB_BLANK,
		PIXEL_CLK   => TB_R_CLK,
		RESET       => '0'
	);

	TB_R_CLK <= not TB_R_CLK after 5 ns;
	TB_W_CLK <= not TB_W_CLK after 1 ns;


end TESTBENCH;
