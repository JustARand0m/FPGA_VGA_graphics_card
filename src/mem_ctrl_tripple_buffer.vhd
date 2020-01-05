-- CREATOR: Michael Braun

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity MEM_CTRL is
	port(-- OUTPUT
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
end MEM_CTRL;

architecture BEHAV of MEM_CTRL is
	-- type declarations
        type BUFFER_TYPE is (R1, R2, R3);

        signal FRONT_BUFFER:    BUFFER_TYPE := R1;
        signal BACK_BUFFER_RDY: BUFFER_TYPE := R2;
        signal BACK_BUFFER_BSY: BUFFER_TYPE := R3;

        signal NEW_IMG_RDY: std_logic := '0';
        
        attribute DONT_TOUCH : string;
        attribute DONT_TOUCH of RAM1: label is "TRUE";
        attribute DONT_TOUCH of RAM2: label is "TRUE";
        attribute DONT_TOUCH of RAM3: label is "TRUE";
 
 component DUAL_RAM is
	port(-- OUTPUT
	     D_O : out std_logic_vector(0 downto 0);
	     R_ADDR: in std_logic_vector (18 downto 0);
	     R_CLK: in std_logic;
	     -- INPUT
         W_EN: in std_logic;
		 D_I: in std_logic_vector(0 downto 0);
	     W_ADDR: in std_logic_vector (18 downto 0);
	     W_CLK: in std_logic
     );
end component;
	    
	    --signal RAM1, RAM2, RAM3: RAM_TYPE := (others => (others => "000000000000"));
		signal RAM_1_OUT, RAM_2_OUT, RAM_3_OUT: std_logic_vector(0 downto 0);
		signal RAM_1_IN, RAM_2_IN, RAM_3_IN: std_logic_vector(0 downto 0);
		
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


	READ_PROCESS: process(R_CLK, RAM_1_OUT, RAM_2_OUT, RAM_3_OUT)
	begin
		if(rising_edge(R_CLK)) then
            case FRONT_BUFFER is
                when R1 =>
					  R_R <= RAM_1_OUT & "000";
                when R2 =>
					  R_R <= RAM_2_OUT & "000";
                when R3 =>
				      R_R <= RAM_3_OUT & "000";
            end case;
		end if;
	end process READ_PROCESS;
	
	WRITE_PROCESS: process(W_CLK, W_R)
	begin
        if(rising_edge(W_CLK)) then
			case BACK_BUFFER_BSY is
				when R1 =>
					RAM_1_IN <= W_R(0 downto 0);	
				when R2 =>
					RAM_2_IN <= W_R(0 downto 0);	
				when R3 =>
					RAM_3_IN <= W_R(0 downto 0);
            end case;
        end if;
    end process WRITE_PROCESS;
	
	N_SYNC <= ((not BLANK) and SYNC);
	
	BLANK_PROCESS: process(BLANK, N_SYNC) 
	begin
			if(rising_edge(BLANK)) then
                     FRONT_BUFFER    <= BACK_BUFFER_RDY;
                     BACK_BUFFER_RDY <= FRONT_BUFFER;
			 elsif(rising_edge(N_SYNC)) then
                    BACK_BUFFER_RDY  <= BACK_BUFFER_BSY;
                    BACK_BUFFER_BSY  <= BACK_BUFFER_RDY;
            end if;
	end process BLANK_PROCESS;
	
	-- SYNC_PROCESS: process(SYNC)
	-- begin
            -- if(rising_edge(SYNC)) then
                -- if(BLANK_INDICATION = '0') then
                    -- BACK_BUFFER_RDY  <= BACK_BUFFER_BSY;
                    -- BACK_BUFFER_BSY  <= BACK_BUFFER_RDY;
                    -- NEW_IMG_RDY <= '1';
                -- end if;
            -- end if;
	-- end process SYNC_PROCESS;
end BEHAV;