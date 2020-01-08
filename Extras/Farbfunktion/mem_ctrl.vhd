-- CREATOR: Michael Braun

library ieee;
use ieee.std_logic_1164.all;

entity MEM_CTRL is
	port(
        -- OUTPUT
	     R_R, R_G, R_B : out std_logic_vector(3 downto 0);
	     R_ADDR: in std_logic_vector (18 downto 0);
	     R_CLK: in std_logic;
	     -- INPUT
	     W_R, W_G, W_B : in std_logic_vector(3 downto 0);
	     W_ADDR: in std_logic_vector (18 downto 0);
	     W_CLK: in std_logic;
	     RESET: in std_logic
     );
end MEM_CTRL;

architecture BEHAV of MEM_CTRL is
	-- type declarations
    -- to prevent decloning of RAM components
    attribute DONT_TOUCH : string;
    attribute DONT_TOUCH of RAM1: label is "TRUE";
 
    component DUAL_RAM is
        port(-- OUTPUT
            D_O : out std_logic_vector(11 downto 0);
            R_ADDR: in std_logic_vector (18 downto 0);
            R_CLK: in std_logic;
            -- INPUT
            D_I: in std_logic_vector(11 downto 0);
            W_ADDR: in std_logic_vector (18 downto 0);
            W_CLK: in std_logic
        );
    end component;
	    
    signal RAM_1_OUT: std_logic_vector(11 downto 0);
    signal RAM_1_IN: std_logic_vector(11 downto 0);
    
begin
	RAM1: DUAL_RAM port map (
		-- OUTPUT
		D_O => RAM_1_OUT,
	    R_ADDR => R_ADDR,
	    R_CLK => R_CLK,
	    -- INPUT
		D_I => RAM_1_IN,
	    W_ADDR => W_ADDR,
	    W_CLK => W_CLK
	);

	R_R <= RAM_1_OUT(11 downto 8);
	R_G <= RAM_1_OUT(7 downto 4);
	R_B <= RAM_1_OUT(3 downto 0);

	RAM_1_IN(11 downto 8) <= W_R;
	RAM_1_IN(7 downto 4)  <= W_G;
	RAM_1_IN(3 downto 0)  <= W_B;
end BEHAV;