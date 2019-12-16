library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
  port( CLK: in std_logic;
        BTN0: in std_logic;  -- reset
        BTN1: in std_logic; -- set sek
        BTN2: in std_logic;  -- set min
        BTN3: in std_logic; -- set hour        
        LCD_D: out std_logic_vector(3 downto 0);
        LCD_RS: out std_logic; -- 0=CMD; 1=DATA
        LCD_E: out std_logic; -- enable signal low active
        LCD_RW: out std_logic); -- 0= write 1= read
        
end TOP;

architecture BEHAV of TOP is

component RESETGEN is
    port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           RST_GLOBAL : out  STD_LOGIC);
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

component LCD
  port(CLK: in std_logic;
       RST_GLOBAL: in std_logic;
       CHAR0: in std_logic_vector(7 downto 0);
       CHAR1: in std_logic_vector(7 downto 0);
       CHAR2: in std_logic_vector(7 downto 0);
       CHAR3: in std_logic_vector(7 downto 0);
       CHAR4: in std_logic_vector(7 downto 0);
       CHAR5: in std_logic_vector(7 downto 0);
       CHAR6: in std_logic_vector(7 downto 0);
       CHAR7: in std_logic_vector(7 downto 0);
       LCD_D: out std_logic_vector(3 downto 0);
       LCD_RS: out std_logic;
       LCD_E: out std_logic;
       LCD_RW: out std_logic);
end component;

signal RST_GLOBAL: std_logic;
signal CHAR0, CHAR1, CHAR2, CHAR3: std_logic_vector(7 downto 0);
signal CHAR4, CHAR5, CHAR6, CHAR7: std_logic_vector(7 downto 0);
signal SEK, MIN, HOUR: std_logic_vector(5 downto 0);
signal MIN_1, MIN_0, SEK_1, SEK_0, HOUR_1, HOUR_0: std_logic_vector(3 downto 0);
signal TICK_SEK: std_logic;

begin

INST_RESETGEN: RESETGEN
  port map(CLK => CLK,
           RST => BTN0,
           RST_GLOBAL => RST_GLOBAL);

INST_CLOCK_MACHINE: CLOCK_MACHINE
  port map(CLK => CLK,
           RST_GLOBAL => RST_GLOBAL,
           SET_SEK => BTN1,
           SET_MIN => BTN2,
           SET_HOUR => BTN3,
           TICK_SEK => TICK_SEK,
           SEK => SEK,
           MIN => MIN,
           HOUR => HOUR);

INST_CONV_SEK: CONVERT
  port map(CLK => CLK,
           HEX => SEK,
           DIGIT_0 => SEK_0 ,
           DIGIT_1 => SEK_1 );

INST_CONV_MIN: CONVERT
  port map(CLK => CLK,
           HEX => MIN,
           DIGIT_0 => MIN_0 ,
           DIGIT_1 => MIN_1 );

INST_CONV_HOUR: CONVERT
  port map(CLK => CLK,
           HEX => HOUR,
           DIGIT_0 => HOUR_0 ,
           DIGIT_1 => HOUR_1 );

--convert BCD to ASCII
CHAR0 <= x"3" & HOUR_1;
CHAR1 <= x"3" & HOUR_0;
CHAR2 <= x"3A";         -- colon
CHAR3 <= x"3" & MIN_1;
CHAR4 <= x"3" & MIN_0;
CHAR5 <= x"3A";         -- colon
CHAR6 <= x"3" & SEK_1;
CHAR7 <= x"3" & SEK_0;

INST_LCD: LCD
  port map(CLK => CLK,
           RST_GLOBAL => RST_GLOBAL,
           CHAR0 => CHAR0, --hour high
           CHAR1 => CHAR1,
           CHAR2 => CHAR2,
           CHAR3 => CHAR3,
           CHAR4 => CHAR4,
           CHAR5 => CHAR5,
           CHAR6 => CHAR6,
           CHAR7 => CHAR7, -- sek low
           LCD_D => LCD_D,
           LCD_RS => LCD_RS,
           LCD_E => LCD_E,
           LCD_RW => LCD_RW );
           
end BEHAV;

