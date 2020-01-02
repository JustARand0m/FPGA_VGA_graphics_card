library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity IMG_CREATE is
	port(
         W_R: out std_logic_vector(3 downto 0) := (others => '0');
         W_G: out std_logic_vector(3 downto 0) := (others => '0');
         W_B: out std_logic_vector(3 downto 0) := (others => '0');
	     W_ADDR: out std_logic_vector(18 downto 0);
	     W_CLK: in std_logic;
         W_EN: out std_logic := '0';
	     SYS_CLK: in std_logic;
	     RESET: in std_logic;
         SYNC: out std_logic := '0');
end IMG_CREATE;

architecture BEHAV of IMG_CREATE is
    constant MAX_ADDR: integer := 16;

    type PIXEL is std_logic_vector(11 downto 0);
    type PIXEL_ARR is array (MAX_ADDR -1 downto 0) of PIXEL;

    constant WRITE_SEQ: PIXEL_ARR := (
        "000000000001", "000000000010", "000000000011", "000000000100", 
        "000000000101", "000000000110", "000000000111", "000000001000", 
        "000000001001", "000000001010", "000000001011", "000000001100", 
        "000000001101", "000000001110", "000000001111", "000000010000"); 

    signal cnt_sync : std_logic_vector(18 downto 0) := (others => '0');
begin
    WRITE: process(SYS_CLK, RESET)
    begin
        if(RESET = '1') then
            
        elsif(rising_edge(SYS_CLK)) then

        end if;
    end process WRITE;

    SYNCING: process(W_CLK, RESET, cnt_sync)
    begin
        if(RESET = '1') then
            cnt_sync <= (others => '0');
            W_ADDR <= (others => '0');
        elsif(rising_edge(W_CLK)) then
            if(cnt_sync = MAX_ADDR - 1) then
                -- one frame written
                SYNC <= '1';
                cnt_sync <= (others => '0');
            else
                SYNC <= '0';
                cnt_sync <= cnt_sync + 1;
            end if;
        end if;
        W_ADDR <= cnt_sync;
        W_R <= WRITE_SEQ(integer(unsigned(cnt_sync)))(3  downto 0);
        W_G <= WRITE_SEQ(integer(unsigned(cnt_sync)))(7  downto 4);
        W_B <= WRITE_SEQ(integer(unsigned(cnt_sync)))(11 downto 8);
    end process SYNCING;
end BEHAV;
