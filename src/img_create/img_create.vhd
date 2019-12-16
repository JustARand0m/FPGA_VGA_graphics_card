library ieee;
use ieee.std_logic_1164.all;

entity IMG_CREATE is
	port(W_R, W_G, W_B: out std_logic_vector(3 downto 0);
	     W_ADDR: out std_logic_vector(18 downto 0);
	     W_CLK: in std_logic;
	     SYS_CLK: in std_logic;
	     RESET: in std_logic);
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

signal RST_GLOBAL: std_logic;													--predefined signals from lcd controller
signal CHAR0, CHAR1, CHAR2, CHAR3: std_logic_vector(7 downto 0);				--char in ascii from clockmachine
signal CHAR4, CHAR5, CHAR6, CHAR7: std_logic_vector(7 downto 0);
signal SEK, MIN, HOUR: std_logic_vector(5 downto 0);
signal MIN_1, MIN_0, SEK_1, SEK_0, HOUR_1, HOUR_0: std_logic_vector(3 downto 0);
signal TICK_SEK: std_logic;

signal Count_Char: std_logic_vector (2 downto 0) := '000';			-- 8 signs in a row
signal Count_Zeile : std_logic_vector (3 downto 0) := '0000'; 		-- 16 rows
signal Count_Convert: std_logic_vector (2 downto 0) := '000'; 		-- 8 signs of Data_Input
signal Count_Clk: std_logic_vector (3 downto 0) := '0000';			-- 8 bit counter to get a slower Clock for address finding
signal DATA_Input: in std_logic_vector(7 downto 0);					-- 8-bit Data Input from charmaps
signal ADDR: out std_logic_vector(10 downto 0);  					-- 11-bit Address Output to charmaps
signal COUNT_Zeile_write: std_logic_vector (3 downto 0):= '0000';	-- 16 row counter for writing to memory
signal Count_Char_write: std_logic_vector(2 downto 0) := '000';		-- char counter for writing to memory

constant OFFSET: std_logic_vector (10 downto 0) = 01100000000; 	--Offset wegen charmaps 768 (Sign "0" row 1 starts at address 768)
constant OFFSETMEM:

begin

--------------------------port maps------------------------------

	INST_CLOCK_MACHINE: CLOCK_MACHINE
		port map(SYS_CLK => CLK,
				RST_GLOBAL => RST_GLOBAL,
				SET_SEK => BTN1,
				SET_MIN => BTN2,
				SET_HOUR => BTN3,
				TICK_SEK => TICK_SEK,
				SEK => SEK,
				MIN => MIN,
				HOUR => HOUR);
  
  	INST_CONV_SEK: CONVERT
		port map(SYS_CLK => CLK,
				HEX => SEK,
				DIGIT_0 => SEK_0 ,
				DIGIT_1 => SEK_1 );
  
  	INST_CONV_MIN: CONVERT
		port map(SYS_CLK => CLK,
				HEX => MIN,
				DIGIT_0 => MIN_0 ,
				DIGIT_1 => MIN_1 );
  
  	INST_CONV_HOUR: CONVERT
		port map(SYS_CLK => CLK,
				HEX => HOUR,
				DIGIT_0 => HOUR_0 ,
				DIGIT_1 => HOUR_1 );

  	INST_charmaps_ROM
		port map (CLK => i_clock,
				Enable => i_EN,
				ADDR => i_ADDR,
				Data_Output => o_DO);
  
  --convert BCD to ASCII
  CHAR0 <= x"3" & HOUR_1;
  CHAR1 <= x"3" & HOUR_0;
  CHAR2 <= x"3A";         -- colon
  CHAR3 <= x"3" & MIN_1;
  CHAR4 <= x"3" & MIN_0;
  CHAR5 <= x"3A";         -- colon
  CHAR6 <= x"3" & SEK_1;
  CHAR7 <= x"3" & SEK_0;

  --maybe helpful: https://stackoverflow.com/questions/33584342/how-to-add-two-different-sized-vectors-vhdl
-- -------------------process to find the correct address for charmaps ----------------------

Addr_finding: process (CLK)
	begin	
		if CLK = '1' and CLK'event then
			Count_Clk <= Count_Clk +1;
			if Count_Clk(3) = "1"; then
				case Count_Char is
					when "000" => 
						ADDR <= OFFSET+('00000' & CHAR0 (5 downto 0)*16)+('0000000' & Count_Zeile); 	-- ('0' & Variable) becaus eof different sized vectors
						Count_Char <= "001";
						i_EN <= '1';
						
					when "001" => 
						ADDR <= OFFSET+(CHAR1 (5 downto 0)*16)+Count_Zeile;
						Count_Char <= "010";
						i_EN <= '1';
						
					when "010" => 
						ADDR <= OFFSET+(CHAR2 (5 downto 0)*16)+Count_Zeile;
						Count_Char <= "011";
						i_EN <= '1';
						
					when "011" => 
						ADDR <= OFFSET+(CHAR3 (5 downto 0)*16)+Count_Zeile;
						Count_Char <= "100";
						i_EN <= '1';
						
					when "100" => 
						ADDR <= OFFSET+(CHAR4 (5 downto 0)*16)+Count_Zeile;
						Count_Char <= "101";
						i_EN <= '1';
						
					when "101" => 
						ADDR <= OFFSET+(CHAR5 (5 downto 0)*16)+Count_Zeile;
						Count_Char <= "110";
						i_EN <= '1';
						
					when "110" => 
						ADDR <= OFFSET+(CHAR6 (5 downto 0)*16)+Count_Zeile;
						Count_Char <= "111";
						i_EN <= '1';
						
					when "111" => 
						ADDR <= OFFSET+(CHAR7 (5 downto 0)*16)+Count_Zeile;
						Count_Char <= "000";
						i_EN <= '1';
						Count_Zeile <= Count_Zeile +1;
						if Count_Zeile = "1111" then
							Count_Zeile <= "0000";
						end if;
					when others ADDR <= "0000000000";
				end case;
			end if;			
		end if;
	end process Addr_finding;


-------------------------process to convert incoming data from charmaps to 12 bit output for Memory -------------------------
--			640
--		-------------------------
--		|			64			|
--		|	288	|text|		288	|			erste Addresse: 64 * 640 + 288 = 41248
--		|			400			|			
--		|						|	480		zeile 288- 352
--		|						|			
--		|						|			vOFFSET = 64
--		|						|			hOFFSET = 288
--		-------------------------			h_max = 640
--
-- TODO Zeilen und Char Counter hochsetzen

	Convert: process (CLK)
	begin	
		if CLK = '1' and CLK'event then
			if DATA_Input (Count_Convert) = '1' then
				W_R <= "0000";
				W_G <= "1111";
				W_B <= "0000";
				W_ADDR <= ((vOFFSET+COUNT_Zeile_write)* h_max)+ hOFFSET+ Count_Convert+(Count_Char_write*8);				--pixeladdr = vOFFSET+Count_Zeile*(h_max)+hOFFSET+Count_Convert(Count_Char*8)  
			elsif DATA_Input (Count_Convert = '0') then
				W_R <= "0000";
				W_G <= "0000";
				W_B <= "0000";
				W_ADDR <= ((vOFFSET+COUNT_Zeile_write)* h_max)+ hOFFSET+ Count_Convert+(Count_Char_write*8);				--pixeladdr = vOFFSET+Count_Zeile*(h_max)+hOFFSET+Count_Convert(Count_Char*8)  
			end if;
			
			Count_Convert <= Count_Convert +1;
			if (Count_Convert = "111") then 
			Count_Convert <= "000";
			
			end if;

		end if;

	end process Convert;
end BEHAV;
