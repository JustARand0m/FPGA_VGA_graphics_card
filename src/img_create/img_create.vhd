--CREATOR: Michael Schmidt

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity IMG_CREATE is
	port(W_R, W_G, W_B: out std_logic_vector(3 downto 0);
	     W_ADDR: out std_logic_vector(18 downto 0);
	    -- SYNC: out std_logic;								--only needed for 2 buffer variant
		 
	     W_CLK: in std_logic;
	     SYS_CLK: in std_logic;
	     RESET: in std_logic;
	     SET_SEK: in std_logic;
         SET_MIN: in std_logic;
         SET_HOUR: in std_logic);
		-- W_EN: out std_logic;							--only needed for 2 buffer variant
end IMG_CREATE;

architecture BEHAV of IMG_CREATE is
	--------------------------components------------------------
component charmaps_ROM is
	port (
    i_EN    : in  std_logic;            -- RAM Enable Input
    i_clock : in  std_logic;            -- Clock
    i_ADDR  : in  std_logic_vector(10 downto 0);  -- 11-bit Address Input
    o_DO    : out std_logic_vector(7 downto 0)  -- 8-bit Data Output
	);
end component;

component CLOCK_MACHINE is
  port(CLK: in std_logic;
       RST_GLOBAL: in std_logic;
       SET_SEK: in std_logic;
       SET_MIN: in std_logic;
       SET_HOUR: in std_logic;
       TICK_SEK: out std_logic;
       SEK: out std_logic_vector(5 downto 0);
       MIN: out std_logic_vector(5 downto 0);
       HOUR: out std_logic_vector(5 downto 0));
end component;

component CONVERT
  port(CLK: in std_logic;
       HEX: in std_logic_vector(5 downto 0);
       DIGIT_0: out std_logic_vector(3 downto 0);
       DIGIT_1: out std_logic_vector(3 downto 0));
end component;

-------------------------------------signals-------------

--signals for componet communication
signal CHAR0, CHAR1, CHAR2, CHAR3: std_logic_vector(7 downto 0);				        --char in ascii from clockmachine
signal CHAR4, CHAR5, CHAR6, CHAR7: std_logic_vector(7 downto 0);
signal SEK, MIN, HOUR: std_logic_vector(5 downto 0);
signal MIN_1, MIN_0, SEK_1, SEK_0, HOUR_1, HOUR_0: std_logic_vector(3 downto 0);
signal TICK_SEK: std_logic;


---Signals for  process Addr_finding
signal Count_Char: std_logic_vector (2 downto 0) := "000";			-- 8 signs in a row
signal Count_Zeile : std_logic_vector (4 downto 0) := "00000"; 		-- 16 rows

--Signals for process Convert8to1
signal Count_Convert: integer range 0 to 8 := 8; 					-- 8 bit of Data_Input
signal Count_Convert2: std_logic_vector (2 downto 0) := "000";		-- 8 bit of Data_Input but now in verctor for Address 	
signal DATA_Input: std_logic_vector(7 downto 0);					-- 8-bit Data Input from charmaps
signal ADDR: std_logic_vector (10 downto 0);  						-- 11-bit Address Output to charmaps
signal Count_Zeile_write: std_logic_vector (4 downto 0):= "00000";	-- 16 row counter for writing to memory
signal Count_Char_write: std_logic_vector(3 downto 0) := "0000";		-- char counter for writing to memory

-- constant for process Convert8to1
constant vOFFSET: std_logic_vector (6 downto 0) := "0111111";		--64
constant hOFFSET: std_logic_vector (8 downto 0) := "100100000";		--288
constant h_max: std_logic_vector (9 downto 0):= "1010000000";		--640

type Process_STATE is (Schreiben, Lesen);

signal CURR_STATE: Process_STATE := Lesen;
begin

--------------------------port maps------------------------------
	INST_CLOCK_MACHINE: CLOCK_MACHINE
		port map(
				CLK => SYS_CLK,
				RST_GLOBAL => RESET,
				SET_SEK => SET_SEK,
				SET_MIN => SET_MIN,
				SET_HOUR => SET_HOUR,
				TICK_SEK => TICK_SEK,
				SEK => SEK,
				MIN => MIN,
				HOUR => HOUR);
  
  	INST_CONV_SEK: CONVERT
		port map(CLK => SYS_CLK,
				HEX => SEK,
				DIGIT_0 => SEK_0 ,
				DIGIT_1 => SEK_1 );
  
  	INST_CONV_MIN: CONVERT
		port map(CLK => SYS_CLK,
				HEX => MIN,
				DIGIT_0 => MIN_0 ,
				DIGIT_1 => MIN_1 );
  
  	INST_CONV_HOUR: CONVERT
		port map(CLK => SYS_CLK,
				HEX => HOUR,
				DIGIT_0 => HOUR_0 ,
				DIGIT_1 => HOUR_1 );

  	INST_charmaps_ROM: charmaps_ROM
		port map (i_clock => W_CLK,
				i_EN => '1',
				i_ADDR => ADDR,
				o_DO => DATA_Input );

  --convert BCD to ASCII
  CHAR0 <= x"3" & HOUR_1;
  CHAR1 <= x"3" & HOUR_0;
  CHAR2 <= x"3A";         -- colon
  CHAR3 <= x"3" & MIN_1;
  CHAR4 <= x"3" & MIN_0;
  CHAR5 <= x"3A";         -- colon
  CHAR6 <= x"3" & SEK_1;
  CHAR7 <= x"3" & SEK_0;

    State_Machine: process (W_CLK)
    begin
        if rising_edge (W_CLK) then
        
            case CURR_STATE is
            -----------------------process to find the correct address for charmaps ----------------------
                when Schreiben =>
        
                   if Count_Convert > 0 then
                    
                        if Data_Input(Count_Convert-1) =  '1' then
                            W_ADDR <= (vOFFSET * h_max + (("0000" & Count_Zeile_write) * h_max))+ hOFFSET + Count_Convert2 + (Count_Char_write * "1000");
                            W_R <= "1111";
                            W_G <= "0000";
                            W_B <= "0000";
                        elsif Data_Input(Count_Convert-1) =  '0' then
                            W_ADDR <= (vOFFSET * h_max + (("0000" & Count_Zeile_write) * h_max))+ hOFFSET + Count_Convert2 + (Count_Char_write * "1000");
                            W_R <= "0000";
                            W_G <= "0000";
                            W_B <= "0000";
                        end if;
                           
                        Count_Convert <= Count_Convert - 1;
                        Count_Convert2 <= Count_Convert2 +"001";
                    end if;
                    
                    if Count_Convert = 0 then
                        Count_Zeile_write<= Count_Zeile_write + "00001";             --new line
                        Count_Convert <= 8;
                        Count_Convert2 <= "000";
                        if Count_Zeile_write = "10000" then                          
                            Count_Zeile_write <= "00000";
                            Count_Char_write <= Count_Char_write + "0001";               --new character 
                            CURR_STATE <= Lesen;
                        end if;
                    CURR_STATE <= Lesen;
                    end if;
                    
                    if Count_Zeile_write = "10000" then
                        Count_Zeile_write<= "00000";
                        Count_Convert <= 8;
                        Count_Convert2<= "000";
                    end if;
                    
                    ----setting starting state for Lesen State
                    if Count_Zeile = "10000" then
                        Count_Zeile <= "00000";
                        Count_Char <= Count_Char+"001";
                    end if;
    
    -------------------------State to convert incoming data from charmaps to 12 bit output for Memory -------------------------
    --			640
    --		-------------------------
    --		|			63			|
    --		|	288 	|text|	288	|			erste Addresse: 64 * 640 + 288 = 41248
    --		|			 			|			
    --		|						|	480		zeile 288- 352
    --		|			400			|			
    --		|						|			vOFFSET = 64
    --		|						|			hOFFSET = 288
    --		-------------------------			h_max = 640
    --
                    
                when Lesen =>
                    --ADDR <= (CHAR0 (5 downto 0)*"10000")+ ("0000000" & Count_Zeile);
                    
                    case Count_Char is                                                             --switch case for different Characters
                        when "000" => 
                            ADDR <= (CHAR0 (5 downto 0)*"10000")+ ("000000" & Count_Zeile); 	
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";                            
                                Count_Char <= "001";
                            end if;

                            
                        when "001" => 
                            ADDR <= (CHAR1 (5 downto 0)*"10000")+ ("000000" & Count_Zeile);
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";
                                Count_Char <= "010";
                            end if;

                            
                        when "010" => 
                            ADDR <= (CHAR2 (5 downto 0)*"10000")+ ("000000" & Count_Zeile);
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";
                                Count_Char <= "011";
                            end if;

                            
                        when "011" => 
                            ADDR <= (CHAR3 (5 downto 0)*"10000")+ ("000000" & Count_Zeile);
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";
                                Count_Char <= "100";
                            end if;

                            
                        when "100" => 
                            ADDR <= (CHAR4 (5 downto 0)*"10000")+ ("000000" & Count_Zeile);
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";
                                Count_Char <= "101";
                            end if;

                            
                        when "101" => 
                            ADDR <= (CHAR5 (5 downto 0)*"10000")+ ("000000" & Count_Zeile);
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";
                                Count_Char <= "110";
                            end if;

                            
                        when "110" => 
                            ADDR <= (CHAR6 (5 downto 0)*"10000")+ ("000000" & Count_Zeile);
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";
                                Count_Char <= "111";
                            end if;

                            
                        when "111" => 
                            ADDR <= (CHAR7 (5 downto 0)*"10000")+ ("000000" & Count_Zeile);
                            Count_Zeile <= Count_Zeile +'1';
                            if Count_Zeile = "10000" then
                                Count_Zeile<= "00000";
                                Count_Char <= "000";
                            end if;

                        when others =>
                            Count_Char <= "000";
                    end case;
                  
                    
                    --setting starting state for Schreiben State
                    if Count_Zeile_write = "10000" then
                        Count_Zeile_write<= "00000";
                        Count_Char_write <= Count_Char_write + "0001";  
                        Count_Convert <= 8;
                        Count_Convert2<= "000";
                    end if;
                    if Count_Char_write = "1000" then
                        Count_Char_write <= "0000";
                    end if;
                    
                    CURR_STATE <= Schreiben;
                    
                    
                    when others => 
                        CURR_STATE <=Lesen;
                        
            end case;
       end if; 
    end process;
end BEHAV;
