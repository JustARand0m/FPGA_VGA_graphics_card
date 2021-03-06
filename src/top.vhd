-- CREATOR: Michael Braun
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity TOP is
	port(
		CLK_IN: in std_logic;
	    PMOD_R, PMOD_G, PMOD_B: out std_logic_vector(3 downto 0);
	    PMOD_HS, PMOD_VS: out std_logic;
	    BTN0, BTN1, BTN2, BTN3: in std_logic
	);
end TOP;

architecture BEHAV of TOP is
	-- -------------------------- components -----------------------------------
	component SYNC_GEN is
		port(
			HS, VS: out std_logic;
			C_H: out std_logic_vector (9 downto 0);
			C_V: out std_logic_vector (8 downto 0);
			BLANK: out std_logic;
			PIXEL_CLK: in std_logic;
			RESET: in std_logic
		);
	end component;
	
	component BLANK_CHECK is
		port(
			R_R, R_G, R_B: out std_logic_vector(3 downto 0);
			W_R, W_G, W_B: in std_logic_vector(3 downto 0);
			BLANK: in std_logic
		);
	end component;

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
	end component;

	component IMG_CREATE is
		port(
            W_R, W_G, W_B: out std_logic_vector(3 downto 0);
            W_ADDR: out std_logic_vector(18 downto 0);
            W_CLK: in std_logic;
            SYS_CLK: in std_logic;
            RESET: in std_logic;
            SET_SEK: in std_logic;
            SET_MIN: in std_logic;
            SET_HOUR: in std_logic
		);
	end component;
	
	component clk_wiz_0
		port(
		-- Clock out ports
		clk_out1          : out    std_logic;
		clk_out2          : out    std_logic;
		clk_out3          : out    std_logic;
		-- Status and control signals
		reset             : in     std_logic;
		locked            : out    std_logic;
		clk_in1           : in     std_logic
		);
	end component;
	-- -------------------------- signals --------------------------------------
	signal BLANK: std_logic;

	-- From MEM_CTRL to BLANK_CHECK
	signal MEM_BLANK_R, MEM_BLANK_G, MEM_BLANK_B: std_logic_vector(3 downto 0);

	-- From IMG_CREATE to MEM_CTRL
	signal IMG_MEM_R, IMG_MEM_G, IMG_MEM_B: std_logic_vector(3 downto 0);
	signal W_ADDR, R_ADDR: std_logic_vector(18 downto 0);
	signal PIXEL_CLK, WRITE_CLK, SYS_CLK: std_logic;
	
	-- index conversion
	signal CONV_H: std_logic_vector(9 downto 0);
	signal CONV_V: std_logic_vector(8 downto 0);
	signal TOP_R_ADDR:std_logic_vector(18 downto 0);
	-- -------------------------- port maps ------------------------------------
begin
	-- convert 2d array index to 1d array index
	-- arr[v][h] <=> arr[v * COLUMNS + h]
    TOP_R_ADDR <= std_logic_vector(to_unsigned(to_integer(unsigned(CONV_V)) * 640 + to_integer(unsigned(CONV_H)), TOP_R_ADDR'length));

	INST_SYNC_GEN: SYNC_GEN port map(
		HS        => PMOD_HS,
		VS        => PMOD_VS,
		C_H       => CONV_H,
		C_V       => CONV_V,
		BLANK     => BLANK,
		PIXEL_CLK => PIXEL_CLK,
		RESET     => '0'
	);
	
	INST_BLANK_CHECK: BLANK_CHECK port map(
		R_R    => PMOD_R,
		R_G    => PMOD_G,
		R_B    => PMOD_B,
		W_R    => MEM_BLANK_R,
		W_G    => MEM_BLANK_G,
		W_B    => MEM_BLANK_B,
		BLANK  => BLANK
	);

	INST_MEM_CTRL: MEM_CTRL port map(
		R_R    => MEM_BLANK_R,
		R_G    => MEM_BLANK_G,
		R_B    => MEM_BLANK_B,
		R_ADDR => TOP_R_ADDR,
		R_CLK  => PIXEL_CLK,
		W_R    => IMG_MEM_R,
		W_G    => IMG_MEM_G,
		W_B    => IMG_MEM_B,
		W_ADDR => W_ADDR,
		W_CLK  => WRITE_CLK,
		RESET  => '0'
	);

	INST_IMG_CREATE: IMG_CREATE port map(
		W_R    => IMG_MEM_R,
		W_G    => IMG_MEM_G,
		W_B    => IMG_MEM_B,
		W_ADDR => W_ADDR,
		W_CLK  => WRITE_CLK,
        SYS_CLK => SYS_CLK,
        RESET   => BTN3,
        SET_SEK => BTN0,
        SET_MIN => BTN1,
        SET_HOUR => BTN2
    );

	INST_CLKWIZ: clk_wiz_0 port map(
		CLK_OUT1 => PIXEL_CLK,
		CLK_OUT2 => WRITE_CLK,
		CLK_OUT3 => SYS_CLK,
		RESET => '0',
		CLK_IN1 => CLK_IN
	);	
end BEHAV;