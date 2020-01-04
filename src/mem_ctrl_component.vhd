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
        --type BUFFER_TYPE is (R1, R2); 

        signal FRONT_BUFFER:    BUFFER_TYPE := R1;
        signal BACK_BUFFER_RDY: BUFFER_TYPE := R2;
        signal BACK_BUFFER_BSY: BUFFER_TYPE := R3;

        signal NEW_IMG_RDY: std_logic := '0';
 
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




	READ: process(R_CLK, RESET)
	begin
		--if(RESET = '1') then
			--R_R <= (others=>'0');
			--R_G <= (others=>'0');
			--R_B <= (others=>'0');
		if(rising_edge(R_CLK)) then
            case FRONT_BUFFER is
                when R1 =>
					  R_R <= RAM_1_OUT & "000";
            --        R_R <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
            --        R_G <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
            --        R_B <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
                when R2 =>
					  R_R <= RAM_2_OUT & "000";
            --        R_R <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
            --        R_G <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
            --        R_B <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
                when R3 =>
				      R_R <= RAM_3_OUT & "000";
            --        R_R <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
            --        R_G <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
            --        R_B <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
            end case;
            --case FRONT_BUFFER is
            --    when R1 =>
            --        R_R <= RAM1(to_integer(unsigned(R_ADDR))) & "000";
                    --R_R <= RAM1(to_integer(unsigned(R_ADDR)))(3 downto 0);
                    --R_G <= RAM1(to_integer(unsigned(R_ADDR)))(7 downto 4);
                    --R_B <= RAM1(to_integer(unsigned(R_ADDR)))(11 downto 8);
            --    when R2 =>
            --        R_R <= RAM2(to_integer(unsigned(R_ADDR))) & "000";
                    --R_R <= RAM1(to_integer(unsigned(R_ADDR)))(3 downto 0);
                    --R_G <= RAM1(to_integer(unsigned(R_ADDR)))(7 downto 4);
                    --R_B <= RAM1(to_integer(unsigned(R_ADDR)))(11 downto 8);
                -- when R3 =>
                    --R_R <= RAM3(to_integer(unsigned(R_ADDR))) & "000";
                    --R_R <= RAM1(to_integer(unsigned(R_ADDR)))(3 downto 0);
                    --R_G <= RAM1(to_integer(unsigned(R_ADDR)))(7 downto 4);
                    --R_B <= RAM1(to_integer(unsigned(R_ADDR)))(11 downto 8);
            --end case;
		end if;
	end process READ;
	
	WRITE: process(RESET, W_CLK, BLANK, SYNC, NEW_IMG_RDY)
        variable BLANK_INDICATION: std_logic := '0';
	begin
        --if(RESET = '1') then
        --    RAM1 <= (others => (others => "000000000000"));
        --    RAM2 <= (others => (others => "000000000000"));
        --    RAM3 <= (others => (others => "000000000000"));
        --else
            if(rising_edge(W_CLK)) then
                --if(W_EN = '1') then
                    --case BACK_BUFFER_BSY is
                    case BACK_BUFFER_RDY is
                        when R1 =>
							RAM_1_IN <= W_R(0 downto 0);
                            --RAM1(to_integer(unsigned(W_ADDR))) <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(3 downto 0)  <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(7 downto 4)  <= W_G;
                            --RAM1(to_integer(unsigned(W_ADDR)))(11 downto 8) <= W_B;	
                        when R2 =>
							RAM_2_IN <= W_R(0 downto 0);
                            --RAM2(to_integer(unsigned(W_ADDR))) <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(3 downto 0)  <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(7 downto 4)  <= W_G;
                            --RAM1(to_integer(unsigned(W_ADDR)))(11 downto 8) <= W_B;	
                        when R3 =>
							RAM_3_IN <= W_R(0 downto 0);
                            --RAM3(to_integer(unsigned(W_ADDR))) <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(3 downto 0)  <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(7 downto 4)  <= W_G;
                            --RAM1(to_integer(unsigned(W_ADDR)))(11 downto 8) <= W_B;	
                    end case;
                    --case BACK_BUFFER_BSY is
                    --    when R1 =>
                    --       RAM1(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(3 downto 0)  <= W_R;
                    --        RAM1(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(7 downto 4)  <= W_G;
                    --        RAM1(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(11 downto 8) <= W_B;	
                    --    when R2 =>
                    --        RAM2(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(3 downto 0)  <= W_R;
                    --        RAM2(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(7 downto 4)  <= W_G;
                    --        RAM2(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(11 downto 8) <= W_B;	
                    --    when R3 =>
                    --        RAM3(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(3 downto 0)  <= W_R;
                    --        RAM3(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(7 downto 4)  <= W_G;
                    --        RAM3(to_integer(unsigned(W_ADDR(18 downto 10))))(to_integer(unsigned(W_ADDR(9 downto 0))))(11 downto 8) <= W_B;	
                    --end case;
                --end if;
            end if;
            -- prioritize frontbuffer changes to backbuffer changes, since reading is a lot slower
            -- than writing in our usecase.
            BLANK_INDICATION := '0';
            if(rising_edge(BLANK)) then
                if(NEW_IMG_RDY = '1') then
                    FRONT_BUFFER    <= BACK_BUFFER_RDY;
                    BACK_BUFFER_RDY <= FRONT_BUFFER;
                    BLANK_INDICATION := '1';
                    NEW_IMG_RDY <= '0';
                end if;
            end if;
            if(rising_edge(SYNC)) then
                if(BLANK_INDICATION = '0') then
                    BACK_BUFFER_RDY  <= BACK_BUFFER_BSY;
                    BACK_BUFFER_BSY  <= BACK_BUFFER_RDY;
                    NEW_IMG_RDY <= '1';
                end if;
            end if;
        --end if;
    end process WRITE;
end BEHAV;
