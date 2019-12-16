library ieee;
use ieee.std_logic_1164.all;

entity TOP is
	port(CLK_IN: in std_logic;
	     PMOD_R, PMOD_G, PMOD_B: out std_logic_vector(3 downto 0);
	     HS, VS: out std_logic);
end TOP;

architecture BEHAV of TOP is
	-- -------------------------- components -----------------------------------
	component SYNC_GEN is
		port(
			HS, VS: out std_logic;
			C_H: out std_logic_vector(9 downto 0);
			C_V: out std_logic_vector(8 downto 0);
			BLANK: out std_logic;
			PIXEL_CLK: in std_logic;
			RESET: in std_logic
		);
	end component;

	component MEM_CTRL is
		port(
			R_R, R_G, R_B : out std_logic_vector(3 downto 0);
			R_ADDR: in std_logic_vector(18 downto 0);
			R_CLK: in std_logic;
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
			RESET: in std_logic
		);
	end component;
	
	component clk_wiz_0 is
	  port(
		clk : out STD_LOGIC;
		clk2 : out STD_LOGIC;
		reset : in STD_LOGIC;
		locked : out STD_LOGIC;
		clk_src : in STD_LOGIC
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
	-- -------------------------- port maps ------------------------------------
begin
	INST_SYNC_GEN: SYNC_GEN port map(
		HS        => HS,
		VS        => VS,
		C_H       => R_ADDR(9 downto 0),
		C_V       => R_ADDR(18 downto 10),
		BLANK     => BLANK,
		PIXEL_CLK => PIXEL_CLK,
		RESET     => '0'
	);

	INST_MEM_CTRL: MEM_CTRL port map(
		R_R    => MEM_BLANK_R,
		R_G    => MEM_BLANK_G,
		R_B    => MEM_BLANK_B,
		R_ADDR => R_ADDR,
		R_CLK  => PIXEL_CLK,
		W_R    => IMG_MEM_R,
		W_G    => IMG_MEM_G,
		W_B    => IMG_MEM_B,
		W_ADDR => W_ADDR,
		W_CLK  => SYS_CLK,
		RESET  => '0'
	);

	INST_IMG_CREATE: IMG_CREATE port map(
		W_R     => IMG_MEM_R,
		W_G     => IMG_MEM_G,
		W_B     => IMG_MEM_B,
		W_ADDR  => W_ADDR,
		W_CLK   => SYS_CLK,
		SYS_CLK => SYS_CLK,
		RESET   => 0
	);
		
	INST_CLKWIZ: clk_wiz_0 port map(
		CLK => SYS_CLK,
		CLK2 => PIXEL_CLK,
		reset => '0',
		LOCKED => open,
		CLK_SRC => CLK_IN
	);
			
end BEHAV;

