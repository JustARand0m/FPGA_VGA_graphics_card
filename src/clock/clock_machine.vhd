library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CLOCK_MACHINE is
  port(CLK: in  std_logic;
       RST_GLOBAL: in  std_logic;
       SET_SEK: in  std_logic;
       SET_MIN: in  std_logic;
       SET_HOUR: in  std_logic;
       TICK_SEK: out std_logic;
       SEK: out std_logic_vector(5 downto 0);
       MIN: out std_logic_vector(5 downto 0);
       HOUR: out std_logic_vector(5 downto 0));
end CLOCK_MACHINE;

architecture BEHAV of CLOCK_MACHINE is

  signal CNT_1SEK: std_logic_vector(26 downto 0) := (others=>'0');
  signal TICK_1SEK: std_logic:= '0';

  signal CNT_SEK: std_logic_vector(5 downto 0) := (others=>'0');
  signal CNT_MIN: std_logic_vector(5 downto 0) := (others=>'0');
  signal CNT_HOUR: std_logic_vector(4 downto 0) := (others=>'0');


begin
  TICK_SEK<=TICK_1SEK;

  -- generating only a timer tick (not dutycyle 50/50) 
  -- for 1 sek clock signal from 100 MHz
  PROC_1SEK: process (CLK, RST_GLOBAL)
  begin
    if (RST_GLOBAL ='1') then
      CNT_1SEK <= (others=>'0');
    elsif (CLK'event) and (CLK='1') then      
      TICK_1SEK <='0'; 
      if (CNT_1SEK = x"5F5E100") then  --x"5F5E100" = 100 000 000 --x"C350" = 50000
        CNT_1SEK <= (others=>'0');
        TICK_1SEK <='1';
      else 
        CNT_1SEK <= CNT_1SEK + 1;        
      end if;
    end if;
  end process;
  
  -- clock counters
  PROC_CLOCK: process (CLK, RST_GLOBAL, SET_SEK)
  begin
  if (RST_GLOBAL ='1') then
      CNT_SEK<= (others=>'0');
      CNT_MIN<= (others=>'0');
      CNT_HOUR<= (others=>'0');
  elsif (CLK'event) and (CLK='1') then    
  -- handling the setting behavior
    if (SET_SEK ='1') then  -- kind of reset behavior!
      CNT_SEK<= (others => '0');
    elsif (TICK_1SEK='1') then
      if (SET_MIN ='1') then
        CNT_MIN<=CNT_MIN + 1;
        if (CNT_MIN = "111011") then -- 59
          CNT_MIN<= (others=>'0');
        end if;
      end if;
      if (SET_HOUR ='1') then
        CNT_HOUR <= CNT_HOUR + 1;
        if (CNT_HOUR = "10111") then -- 23
          CNT_HOUR <= (others=>'0');
        end if;
      end if;
    -- handling the counting
      if (CNT_SEK = "111011") then --59
        CNT_SEK <= (others=>'0');
        if (CNT_MIN = "111011") then --59
          CNT_MIN <= (others=>'0');
          if (CNT_HOUR = "10111") then --23
            CNT_HOUR <= (others=>'0');
          else
            CNT_HOUR <= CNT_HOUR + 1;
          end if;
        else
          CNT_MIN <= CNT_MIN + 1;
        end if;
      else
        CNT_SEK <= CNT_SEK + 1;
      end if;
    end if;
  end if;
  end process;
  
  SEK  <= CNT_SEK;
  MIN  <= CNT_MIN;
  HOUR <= "0" & CNT_HOUR;
  
end BEHAV;

