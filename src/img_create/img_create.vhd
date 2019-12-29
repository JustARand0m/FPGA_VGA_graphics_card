library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity IMG_CREATE is
	port(
         W_R: out std_logic_vector(3 downto 0) := (others => '1');
         W_G: out std_logic_vector(3 downto 0) := (others => '0');
         W_B: out std_logic_vector(3 downto 0) := (others => '0');
	     W_ADDR: out std_logic_vector(18 downto 0);
	     W_CLK: in std_logic;
	     SYS_CLK: in std_logic;
	     RESET: in std_logic;
         SYNC: out std_logic := '0');
end IMG_CREATE;

architecture BEHAV of IMG_CREATE is
    signal cnt_color: std_logic_vector(40 downto 0) := (others => '0');
    signal cnt_sync : std_logic_vector(18 downto 0) := (others => '0');
    signal W_R_TMP: std_logic_vector(3 downto 0) := (others => '1');
    signal W_G_TMP: std_logic_vector(3 downto 0) := (others => '0');
begin
    WRITE: process(SYS_CLK, RESET)
    begin
        if(RESET = '1') then
            cnt_color <= (others => '0');
        elsif(rising_edge(SYS_CLK)) then
            if(cnt_color = 1000 * 1000 * 100 * 2) then
                W_R_TMP <= not W_R_TMP;
                W_G_TMP <= not W_G_TMP;
                cnt_color <= (others => '0');
            else
                cnt_color <= cnt_color + 1;
            end if;
        end if;
    end process WRITE;

    SYNCING: process(W_CLK, RESET, cnt_sync)
    begin
        if(RESET = '1') then
            cnt_sync <= (others => '0');
            W_ADDR <= (others => '0');
        elsif(rising_edge(W_CLK)) then
            if(cnt_sync = 15) then
                SYNC <= '1';
                cnt_sync <= (others => '0');

                W_R <= W_R_TMP;
                W_G <= W_G_TMP;
            else
                SYNC <= '0';
                cnt_sync <= cnt_sync + 1;
            end if;
        end if;
        W_ADDR <= cnt_sync;
    end process SYNCING;
end BEHAV;
