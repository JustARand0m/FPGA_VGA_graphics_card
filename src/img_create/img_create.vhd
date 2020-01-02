library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity IMG_CREATE is
	port(
         W_R: out std_logic_vector(3 downto 0) := (others => '1');
         W_G: out std_logic_vector(3 downto 0) := (others => '0');
         W_B: out std_logic_vector(3 downto 0) := (others => '0');
	     W_ADDR: out std_logic_vector(18 downto 0);
	     W_CLK: in std_logic;
         W_EN: out std_logic;
	     SYS_CLK: in std_logic;
	     RESET: in std_logic;
         SYNC: out std_logic := '0');
end IMG_CREATE;

architecture BEHAV of IMG_CREATE is

    constant MAX_ADDR: integer := 307200; -- 640 * 480

    signal cnt_color: std_logic_vector(40 downto 0) := (others => '0');
    signal cnt_sync : std_logic_vector(18 downto 0) := (others => '0');
    
    signal cnt_x: integer := 0;
    signal cnt_y: integer := 0;
    
    type BOX_DIR_TYPE is (LEFT, RIGHT);
    
    signal BOX_DIR: BOX_DIR_TYPE := RIGHT;
    
    signal BOX_X: integer := 100;
    signal BOX_Y: integer := 100;
    
    constant BOX_SIZE: natural := 20;
    constant X_MAX: natural := 640;
    constant Y_MAX: natural := 480;
begin
    W_EN <= '1';
    
    X_COUNTER: process(W_CLK, cnt_x)
    begin
        if(rising_edge(W_CLK)) then
            if(cnt_x = (X_MAX - 1)) then
                cnt_x <= 0;
            else
                cnt_x <= cnt_x + 1;
            end if;
        end if;
    end process X_COUNTER;
    
    Y_COUNTER: process(W_CLK, cnt_x, cnt_y)
    begin
        if(rising_edge(W_CLK)) then
            if(cnt_y = (Y_MAX - 1)) and (cnt_x = (X_MAX - 1)) then
                cnt_y <= 0;
                SYNC <= '1';
            elsif(cnt_x = (X_MAX - 1)) then
                cnt_y <= cnt_y + 1;
                SYNC <= '0';
            end if;
        end if;
    end process Y_COUNTER;

    SYNCING: process(W_CLK, RESET, cnt_sync)
    begin
        if(rising_edge(W_CLK)) then
            W_ADDR <= std_logic_vector(to_unsigned((cnt_y * Y_MAX + cnt_x), W_ADDR'length));
            --W_ADDR <= (others => '0');
                W_R <= "1111";
                W_G <= "0111";
                W_B <= "0111";
            --if(cnt_x < 200) then 
            --    W_R <= "1111";
            --    W_G <= "0000";
            --    W_B <= "0000";
            --elsif(cnt_x >= 200) and (cnt_x < 300) then 
            --    W_R <= "0000";
            --    W_G <= "1111";
            --    W_B <= "0000";
            --elsif(cnt_x >= 300) and (cnt_x < X_MAX) then 
            --    W_R <= "0000";
            --    W_G <= "0000";
            --    W_B <= "1111";
            --end if;
        end if;
    end process SYNCING;
end BEHAV;
