--CREATOR: Korbinian Federholzner

library ieee;
use ieee.std_logic_1164.all;

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


	---------components---------

	component COUNTER is
		generic(LENGTH: integer);
		port(
			CLK, RESET, EN: in std_logic;
			Q: out std_logic_vector(LENGTH-1 downto 0));
	end component COUNTER;
	
	component WAIT_TIMER is
		generic(INT_RANGE: integer);
		port(
			CLK, RESET: in std_logic;
			Q: out integer range 0 to INT_RANGE);
	end component WAIT_TIMER;
	
	
	---------types---------
	
	type H_STATE is (H_SYNC, H_F_PORCH, H_DISPL, H_B_PORCH);
	type V_STATE is (V_SYNC, V_F_PORCH, V_DISPL, V_B_PORCH);

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

	-- counter increment signals, on 1 the counter will increment with clk speed
	signal INC_V: std_logic := '0';
	signal INC_H: std_logic := '0';

	-- reset signals for counters and timer, resets internal counters
	signal RESET_V, RESET_H, RESET_TIMER_H, RESET_TIMER_V, RESET_COMP_H: std_logic;
	signal RESET_V_H, RESET_H_H: std_logic;

	-- internal count of timer and counter components
	signal COUNT_H: std_logic_vector(C_H_LENGTH - 1 downto 0);
	signal COUNT_V: std_logic_vector(C_V_LENGTH - 1 downto 0);
	signal CURR_TIME_H: integer range 0 to INT_RANGE_TIMER_H;
	signal CURR_TIME_V: integer range 0 to INT_RANGE_TIMER_V;

	signal CURR_STATE_H: H_STATE := H_SYNC;
	signal CURR_STATE_V: V_STATE := V_SYNC;

	signal CURR_BLANK_H: std_logic := '0';
	signal CURR_BLANK_V: std_logic := '0';

begin
	COUNTER_V: COUNTER
		generic map(LENGTH => C_V_LENGTH)
		port map(CLK => PIXEL_CLK, EN => INC_V, RESET => RESET_V, Q => COUNT_V);
	COUNTER_H: COUNTER
		generic map(LENGTH => C_H_LENGTH)
		port map(CLK => PIXEL_CLK, EN => INC_H, RESET => RESET_H, Q => COUNT_H);
	TIMER_H: WAIT_TIMER
		generic map(INT_RANGE => INT_RANGE_TIMER_H)
		port map(CLK => PIXEL_CLK, RESET => RESET_TIMER_H, Q => CURR_TIME_H);
	TIMER_V: WAIT_TIMER
		generic map(INT_RANGE => INT_RANGE_TIMER_V)
		port map(CLK => PIXEL_CLK, RESET => RESET_TIMER_V, Q => CURR_TIME_V);

	VERTICAL: process (PIXEL_CLK, RESET) 
	begin
		if(RESET = '1') then
			RESET_V <= '1';
			RESET_TIMER_V <= '1';
			CURR_STATE_V <= V_SYNC;

		elsif(PIXEL_CLK = '1' and PIXEL_CLK'event) then
			RESET_TIMER_V <= '0';
			RESET_V <= '0';
			RESET_V_H <= '0';
			RESET_COMP_H <= '0';
			case CURR_STATE_V is
				when V_SYNC => 
					if(CURR_TIME_V = convertTime(WAIT_V_SYNC)) then
						CURR_STATE_V <= V_F_PORCH;
						RESET_TIMER_V <= '1';
						CURR_BLANK_V <= '1';
						VS <= '1';
					end if;
				when V_F_PORCH =>
					if(CURR_TIME_V = convertTime(WAIT_V_FPORCH)) then 
						CURR_STATE_V <= V_DISPL;
						RESET_TIMER_V <= '1';
						RESET_V_H <= '1';
						RESET_V <= '1';
						CURR_BLANK_V <= '0';
						VS <= '1';
					end if;
				when V_DISPL => 
					if(CURR_TIME_V = convertTime(WAIT_V_DISPL)) then
						CURR_STATE_V <= V_B_PORCH;
						RESET_TIMER_V <= '1';
						RESET_V <= '1';
						CURR_BLANK_V <= '1';
						VS <= '1';
					end if;
				when V_B_PORCH => 
					if(CURR_TIME_V = convertTime(WAIT_V_BPORCH)) then
						CURR_STATE_V <= V_SYNC;
						RESET_TIMER_V <= '1';
						CURR_BLANK_V <= '1';
						VS <= '0';
					end if;
				when others => CURR_STATE_V <= V_SYNC;
			end case;
		end if;
	end process VERTICAL;
	
	HORIZONTAL: process(PIXEL_CLK, RESET_COMP_H, RESET)
	begin
		if(RESET = '1' or RESET_COMP_H = '1') then
			RESET_H_H <= '1';
			RESET_TIMER_H <= '1';
			CURR_STATE_H <= H_SYNC;

		elsif (PIXEL_CLK = '1' and PIXEL_CLK'event) then
			RESET_H_H <= '0';
			RESET_TIMER_H <= '0';
			case CURR_STATE_H is 
				when H_SYNC => 
					if(CURR_TIME_H = convertTime(WAIT_H_SYNC)) then 
						CURR_STATE_H <= H_F_PORCH;
						RESET_TIMER_H <= '1';
						CURR_BLANK_H <= '1';
						HS <= '1';
					end if;
				when H_F_PORCH => 
					if(CURR_TIME_H = convertTime(WAIT_H_FPORCH)) then
						CURR_STATE_H <= H_DISPL;
						RESET_TIMER_H <= '1';	
						INC_H <= '1';
						CURR_BLANK_H <= '0';
						HS <= '1';
					end if;
				when H_DISPL => 
					if(CURR_TIME_H = convertTime(WAIT_H_DISPL)) then
						INC_H <= '0';
						CURR_STATE_H <= H_B_PORCH;
						RESET_TIMER_H <= '1';
						CURR_BLANK_H <= '1';
						RESET_H_H <= '1';
						HS <= '1';
					end if;
				when H_B_PORCH => 
					if((CURR_TIME_H = convertTime(WAIT_H_BPORCH) - 1) and (CURR_STATE_V = V_DISPL)) then
						INC_V <= '1';
					end if;
					if(CURR_TIME_H = convertTime(WAIT_H_BPORCH)) then
						INC_V <= '0';
						CURR_STATE_H <= H_SYNC;
						RESET_TIMER_H <= '1';
						CURR_BLANK_H <= '1';
						HS <= '0';
					end if;
				when others => CURR_STATE_H <= H_SYNC;
			end case;
		end if;
	end process HORIZONTAL;
	RESET_H <= RESET_V_H or RESET_H_H;
	C_H <= COUNT_H;
	C_V <= COUNT_V;
	BLANK <= CURR_BLANK_H or CURR_BLANK_V;
end BEHAV;