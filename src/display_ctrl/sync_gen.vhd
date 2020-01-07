library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.ALL;

entity SYNC_GEN is
	generic(
	       C_H_LENGTH: integer := 10;
	       C_V_LENGTH: integer := 9
	);

	port(
		HS: out std_logic := '0';
		VS: out std_logic := '0';
		C_H: out std_logic_vector (C_H_LENGTH - 1 downto 0);
		C_V: out std_logic_vector (C_V_LENGTH - 1 downto 0);
		BLANK: out std_logic;
		PIXEL_CLK: in std_logic;
		RESET: in std_logic
	);
end SYNC_GEN;

architecture BEHAV of SYNC_GEN is

	---------constants---------

	constant INT_RANGE_TIMER_H: integer := 3000000;
	constant INT_RANGE_TIMER_V: integer := 3000000;
	constant CLK_FRQ: integer := 25000000;

	-- waiting times in ns on the right side (comment) the count;
	constant WAIT_H_SYNC: integer := 3840; --96
	constant WAIT_H_FPORCH: integer := 640; --16
	constant WAIT_H_DISPL: integer := 25600; --640
	constant WAIT_H_BPORCH: integer := 1920; --48
	
	constant WAIT_V_SYNC: integer := 64000; --1600
	constant WAIT_V_FPORCH: integer := 928000; --23200
	constant WAIT_V_DISPL: integer := 15360000; --384000
	constant WAIT_V_BPORCH: integer := 320000; --8000

    constant CONV_TO_COORD: integer := 800;
	---------components---------
	
	component WAIT_TIMER is
		generic(INT_RANGE: integer);
		port(
			CLK, RESET: in std_logic;
			Q: out integer range 0 to INT_RANGE);
	end component WAIT_TIMER;

	---------functions---------

	-- Function that converts time into clock cycles, depending on the CLK FRQ
	-- Also it accounts for the rounding error of division:
	-- +1 for if error like 100 / 40 => 2.5 => 2
	function convertTime(NANO_SEC: integer := 0) 
		return integer is variable CLK_CYCLES : integer;
	begin
		CLK_CYCLES := NANO_SEC / (1000000000 / CLK_FRQ);
		return CLK_CYCLES - 1; 
	end function;

	---------singals---------

	-- reset signals for counters and timer, resets internal counters
	signal RESET_TIMER_H, RESET_TIMER_V: std_logic;
	signal RESET_V_H, RESET_H_H: std_logic;

	-- internal count of timer and counter components
	signal CURR_TIME_H: integer range 0 to INT_RANGE_TIMER_H;
	signal CURR_TIME_V: integer range 0 to INT_RANGE_TIMER_V;

begin
	TIMER_H: WAIT_TIMER
		generic map(INT_RANGE => INT_RANGE_TIMER_H)
		port map(CLK => PIXEL_CLK, RESET => RESET_TIMER_H, Q => CURR_TIME_H);
	TIMER_V: WAIT_TIMER
		generic map(INT_RANGE => INT_RANGE_TIMER_V)
		port map(CLK => PIXEL_CLK, RESET => RESET_TIMER_V, Q => CURR_TIME_V);

    -- -----____--------------------------____ ...
    -- |   |    |  |                 |   |    |
    --  FP  SYNC BP       Display     FP  SYNC ...		
    VERTICAL: process(PIXEL_CLK)
    begin
        if(PIXEL_CLK = '1' and PIXEL_CLK'event) then
            RESET_TIMER_V <= '0';
            if((CURR_TIME_V >= convertTime(WAIT_V_DISPL + WAIT_V_FPORCH)) and (CURR_TIME_V < convertTime(WAIT_V_DISPL + WAIT_V_FPORCH + WAIT_V_BPORCH))) then
                VS <= '0';
            else
                VS <= '1';
            end if;
            if(CURR_TIME_V = convertTime(WAIT_V_DISPL + WAIT_V_FPORCH + WAIT_V_BPORCH + WAIT_V_SYNC)) then
                RESET_TIMER_V <= '1';
            end if;
        end if;
    end process;
    
    HORIZONTAL: process(PIXEL_CLK)
    begin
        if(PIXEL_CLK = '1' and PIXEL_CLK'event) then
            RESET_TIMER_H <= '0';
            if((CURR_TIME_H >= convertTime(WAIT_H_DISPL + WAIT_H_FPORCH)) and (CURR_TIME_H < convertTime(WAIT_H_DISPL + WAIT_H_FPORCH + WAIT_H_BPORCH))) then
                HS <= '0';
            else
                HS <= '1';
            end if;
            if(CURR_TIME_H = convertTime(WAIT_H_DISPL + WAIT_H_FPORCH + WAIT_H_BPORCH + WAIT_H_SYNC)) then
                RESET_TIMER_H <= '1';
            end if;
        end if;
    end process;
    
    -- BLANK:
    -- -------------__________________----------
    --  HS and VS
    -- -----____--------------------------____ ...
    -- |   |    |  |                 |   |    |
    --  BP  SYNC FP       Display     BP  SYNC ...
    BLANKING: process(PIXEL_CLK)
    begin
        if(PIXEL_CLK = '1' and PIXEL_CLK'event) then
            if(((CURR_TIME_H >= 0) and (CURR_TIME_H < convertTime(WAIT_H_DISPL))) and ((CURR_TIME_V >= 0) and (CURR_TIME_V < convertTime(WAIT_V_DISPL)))) then
                BLANK <= '0';
            else
                BLANK <= '1';
            end if;
        end if;
    end process;
    
    C_V <= std_logic_vector(to_unsigned(CURR_TIME_V / CONV_TO_COORD, C_V_LENGTH));
    C_H <= std_logic_vector(to_unsigned(CURR_TIME_H, C_H_LENGTH));
end BEHAV;
