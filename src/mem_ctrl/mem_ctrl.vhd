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
            D_O : out std_logic_vector(2 downto 0);
            R_ADDR: in std_logic_vector (18 downto 0);
            R_CLK: in std_logic;
            -- INPUT
            D_I: in std_logic_vector(2 downto 0);
            W_ADDR: in std_logic_vector (18 downto 0);
            W_CLK: in std_logic
        );
    end component;
	    
    signal RAM_1_OUT: std_logic_vector(2 downto 0);
    signal RAM_1_IN: std_logic_vector(2 downto 0);
    
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

	READ_PROCESS: process(RAM_1_OUT)
	begin
		if(RAM_1_OUT(0) = '1') then
			R_R <= "1111";
		else
			R_R <= "0000";
		end if;
		if(RAM_1_OUT(1) = '1') then
			R_G <= "1111";
		else
			R_G <= "0000";
		end if;
		if(RAM_1_OUT(2) = '1') then
			R_B <= "1111";
		else
			R_B <= "0000";
		end if;
	end process READ_PROCESS;
	
	WRITE_PROCESS: process(W_R)
	begin
		if(W_R = "1111") then
			RAM_1_IN(0) <= '1';
		else
			RAM_1_IN(0) <= '0';
		end if;
		if(W_G = "1111") then
			RAM_1_IN(1) <= '1';
		else
			RAM_1_IN(1) <= '0';
		end if;
		if(W_B = "1111") then
			RAM_1_IN(2) <= '1';
		else
			RAM_1_IN(2) <= '0';
		end if;
    end process WRITE_PROCESS;
end BEHAV;