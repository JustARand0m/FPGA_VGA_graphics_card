-- CREATOR: Michael Braun

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity MEM_CTRL is
	port(-- OUTPUT
         BLANK: in std_logic;
	     R_R, R_G, R_B : out std_logic_vector(3 downto 0);
	     R_ADDR: in std_logic_vector (18 downto 0);
	     R_CLK: in std_logic;
	     -- INPUT
         SYNC: in std_logic;
         W_EN: in std_logic;
	     W_R, W_G, W_B : in std_logic_vector(3 downto 0);
	     W_ADDR: in std_logic_vector (18 downto 0);
	     W_CLK: in std_logic;
	     RESET: in std_logic
     );
end MEM_CTRL;

architecture BEHAV of MEM_CTRL is
	-- type declarations
        type BUFFER_TYPE is (R1, R2, R3);

        signal FRONT_BUFFER: BUFFER_TYPE	:= R1;
		signal BACK_BUFFER: BUFFER_TYPE		:= R2;
		signal BACK_BUFFER_BSY: BUFFER_TYPE	:= R3;

        -- to prevent decloning of RAM component
        attribute DONT_TOUCH : string;
        attribute DONT_TOUCH of RAM1: label is "TRUE";
        attribute DONT_TOUCH of RAM2: label is "TRUE";
        attribute DONT_TOUCH of RAM3: label is "TRUE";
 
 component DUAL_RAM is
	port(-- OUTPUT
	     D_O : out std_logic_vector(3 downto 0);
	     R_ADDR: in std_logic_vector (18 downto 0);
	     R_CLK: in std_logic;
	     -- INPUT
         W_EN: in std_logic;
		 D_I: in std_logic_vector(3 downto 0);
	     W_ADDR: in std_logic_vector (18 downto 0);
	     W_CLK: in std_logic
     );
end component;
	    
		signal RAM_1_OUT, RAM_2_OUT, RAM_3_OUT: std_logic_vector(3 downto 0);
		signal RAM_1_IN, RAM_2_IN, RAM_3_IN: std_logic_vector(3 downto 0);
		
		signal N_SYNC: std_logic;
begin
	RAM1: DUAL_RAM port map (
		-- OUTPUT
		D_O => RAM_1_OUT,
	    R_ADDR => R_ADDR,
	    R_CLK => R_CLK,
	    -- INPUT
        W_EN => W_EN,
		D_I => RAM_1_IN,
	    W_ADDR => W_ADDR,
	    W_CLK => W_CLK
	);
	
	RAM2: DUAL_RAM port map (
		-- OUTPUT
		D_O => RAM_2_OUT,
	    R_ADDR => R_ADDR,
	    R_CLK => R_CLK,
	    -- INPUT
        W_EN => W_EN,
		D_I => RAM_2_IN,
	    W_ADDR => W_ADDR,
	    W_CLK => W_CLK
	);

	RAM3: DUAL_RAM port map (
		-- OUTPUT
		D_O => RAM_3_OUT,
	    R_ADDR => R_ADDR,
	    R_CLK => R_CLK,
	    -- INPUT
        W_EN => W_EN,
		D_I => RAM_3_IN,
	    W_ADDR => W_ADDR,
	    W_CLK => W_CLK
	);

	READ_PROCESS: process(RAM_1_OUT, RAM_2_OUT)
	begin
		case FRONT_BUFFER is
			when R1 =>
					R_R <= RAM_1_OUT;
			when R2 =>
					R_R <= RAM_2_OUT;
			when R3 =>
					R_R <= RAM_3_OUT;
		end case;
	end process READ_PROCESS;
	
	WRITE_PROCESS: process(W_R)
	begin
		case BACK_BUFFER_BSY is
			when R1 =>
				RAM_1_IN <= W_R;	
			when R2 =>
				RAM_2_IN <= W_R;	
			when R3 =>
				RAM_3_IN <= W_R;	
		end case;
    end process WRITE_PROCESS;
	
	-- prioritize BLANK over SYNC
	N_SYNC <= ((not BLANK) and SYNC);
	
	BLANK_PROCESS: process(BLANK, N_SYNC, SYNC) 
	begin
		-- Only switch frontbuffer after full frame was displayed
		if(rising_edge(BLANK)) then
			if(unsigned(R_ADDR) = 0) then
					FRONT_BUFFER    <= BACK_BUFFER;
					BACK_BUFFER	 <= FRONT_BUFFER;
			end if;
		end if;
	end process BLANK_PROCESS;

	SYNC_PROCESS: process(BLANK, N_SYNC, SYNC) 
	begin
		if(rising_edge(N_SYNC)) then
					BACK_BUFFER <= BACK_BUFFER_BSY;
					BACK_BUFFER_BSY <= BACK_BUFFER;
		end if;
	end process SYNC_PROCESS;
end BEHAV;
