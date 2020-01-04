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
        --type BUFFER_TYPE is (R1, R2, R3); 
        type BUFFER_TYPE is (R1, R2); 

       -- type RAM_PIXEL_TYPE is record
       --     R, G, B : std_logic_vector(3 downto 0);
       -- end record;

        --type ram_line_type	is array (0 to 639) of std_logic_vector(11 downto 0);
        --type ram_type		is array (0 to 479) of ram_line_type;
        
       -- type ram_type is array (0 to 307199) of std_logic_vector(11 downto 0);
       --type ram_type is array (0 to 307199) of std_logic_vector(0 downto 0);
       type ram_type is array (0 to 199999) of std_logic_vector(0 downto 0);
        
        --type RAM_LINE_TYPE	is array (0 to 3) of RAM_PIXEL_TYPE;
        --type RAM_TYPE		is array (0 to 3) of RAM_LINE_TYPE;
	-- signals
        signal FRONT_BUFFER:    BUFFER_TYPE := R1;
        signal BACK_BUFFER_RDY: BUFFER_TYPE := R2;
        --signal BACK_BUFFER_BSY: BUFFER_TYPE := R3;

        signal NEW_IMG_RDY: std_logic := '0';

        --signal RAM1: RAM_TYPE := (others => (others => ("0000", "0000", "0000"))); 
        --signal RAM2: RAM_TYPE := (others => (others => ("0000", "0000", "0000"))); 
        --signal RAM3: RAM_TYPE := (others => (others => ("0000", "0000", "0000"))); 
	    
	    --signal RAM1, RAM2, RAM3: RAM_TYPE := (others => (others => "000000000000"));
	    signal RAM1, RAM2: RAM_TYPE := (others => (others => '0'));
	    
	    attribute RAM_STYLE: string;
	    attribute RAM_STYLE of RAM1: signal is "block";
	    attribute RAM_STYLE of RAM2: signal is "block";
begin
	READ: process(R_CLK, RESET)
	begin
		if(RESET = '1') then
			--R_R <= (others=>'0');
			--R_G <= (others=>'0');
			--R_B <= (others=>'0');
		elsif(rising_edge(R_CLK)) then
            --case FRONT_BUFFER is
            --    when R1 =>
            --        R_R <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
            --        R_G <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
            --        R_B <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
            --    when R2 =>
            --        R_R <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
            --        R_G <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
            --        R_B <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
            --    when R3 =>
            --        R_R <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
            --        R_G <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
            --        R_B <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
            --end case;
            case FRONT_BUFFER is
                when R1 =>
                    R_R <= RAM1(to_integer(unsigned(R_ADDR))) & "000";
                    --R_R <= RAM1(to_integer(unsigned(R_ADDR)))(3 downto 0);
                    --R_G <= RAM1(to_integer(unsigned(R_ADDR)))(7 downto 4);
                    --R_B <= RAM1(to_integer(unsigned(R_ADDR)))(11 downto 8);
                when R2 =>
                    R_R <= RAM2(to_integer(unsigned(R_ADDR))) & "000";
                    --R_R <= RAM1(to_integer(unsigned(R_ADDR)))(3 downto 0);
                    --R_G <= RAM1(to_integer(unsigned(R_ADDR)))(7 downto 4);
                    --R_B <= RAM1(to_integer(unsigned(R_ADDR)))(11 downto 8);
                --when R3 =>
                    --R_R <= RAM3(to_integer(unsigned(R_ADDR))) & "000";
                    --R_R <= RAM1(to_integer(unsigned(R_ADDR)))(3 downto 0);
                    --R_G <= RAM1(to_integer(unsigned(R_ADDR)))(7 downto 4);
                    --R_B <= RAM1(to_integer(unsigned(R_ADDR)))(11 downto 8);
            end case;
		end if;
	end process READ;
	
	WRITE: process(RESET, W_CLK, BLANK, SYNC, NEW_IMG_RDY)
        variable BLANK_INDICATION: std_logic := '0';
	begin
        if(RESET = '1') then
        --    RAM1 <= (others => (others => "000000000000"));
        --    RAM2 <= (others => (others => "000000000000"));
        --    RAM3 <= (others => (others => "000000000000"));
        else
            if(rising_edge(W_CLK)) then
                if(W_EN = '1') then
                    --case BACK_BUFFER_BSY is
                    case BACK_BUFFER_RDY is
                        when R1 =>
                            RAM1(to_integer(unsigned(W_ADDR))) <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(3 downto 0)  <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(7 downto 4)  <= W_G;
                            --RAM1(to_integer(unsigned(W_ADDR)))(11 downto 8) <= W_B;	
                        when R2 =>
                            RAM2(to_integer(unsigned(W_ADDR))) <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(3 downto 0)  <= W_R;
                            --RAM1(to_integer(unsigned(W_ADDR)))(7 downto 4)  <= W_G;
                            --RAM1(to_integer(unsigned(W_ADDR)))(11 downto 8) <= W_B;	
                        --when R3 =>
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
                end if;
            end if;
            -- prioritize frontbuffer changes to backbuffer changes, since reading is a lot slower
            -- than writing in our usecase.
            BLANK_INDICATION := '0';
            if(rising_edge(BLANK)) then
                --if(NEW_IMG_RDY = '1') then
                    FRONT_BUFFER    <= BACK_BUFFER_RDY;
                    BACK_BUFFER_RDY <= FRONT_BUFFER;
                    --BLANK_INDICATION := '1';
                    --NEW_IMG_RDY <= '0';
                --end if;
            end if;
            --if(rising_edge(SYNC)) then
            --    if(BLANK_INDICATION = '0') then
            --        BACK_BUFFER_RDY  <= BACK_BUFFER_BSY;
            --        BACK_BUFFER_BSY  <= BACK_BUFFER_RDY;
            --        NEW_IMG_RDY <= '1';
            --    end if;
            --end if;
        end if;
    end process WRITE;
end BEHAV;
