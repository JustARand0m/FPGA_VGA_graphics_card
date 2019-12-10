library ieee;
use ieee.std_logic_1164.all;

entity SYNC_GEN is
	generic(
	       C_H_LENGTH: integer := 10;
	       C_V_LENGTH: integer := 9
	);

	port(
		HS, VS: out std_logic;
		C_H: out std_logic_vector (C_H_LENGTH - 1 downto 0);
		C_V: out std_logic_vector (C_V_LENGTH - 1 downto 0);
		BLANK: out std_logic;
		PIXEL_CLK: in std_logic;
		RESET: in std_logic
	);
end SYNC_GEN;

architecture BEHAV of SYNC_GEN is

	---------constants---------

	constant INT_RANGE_TIMER: integer := 3000000;
	constant CLK_FEQ: integer := 25000000;

	-- waiting times in ns
	constant WAIT_H_SYNC: integer := 3840;
	constant WAIT_H_FPORCH: integer := 640;
	constant WAIT_H_DISPL: integer := 25600;
	constant WAIT_H_BPORCH: integer := 1920;
	
	constant WAIT_V_SYNC: integer := 64000;
	constant WAIT_V_FPORCH: integer := 928000;
	constant WAIT_V_DISPL: integer := 15360000;
	constant WAIT_V_BPORCH: integer := 320000;


	---------components---------

	component COUNTER is
		generic(LENGTH: integer);
		port(
			INC, RESET: in std_logic;
			Q: out std_logic_vector(LENGTH-1 downto 0));
	end component;
	
	entity WAIT_TIMER is
		generic(INT_RANGE: integer);
		port(
			CLK, RESET: in std_logic;
			Q: out integer range 0 to INT_RANGE);
	end WAIT_TIMER;
	
	
	---------types---------
	
	type H_STATE is (H_WAIT_FOR_V, H_SYNC, H_F_PORCH, H_DISPL, H_B_PORCH);
	type V_STATE is (V_SYNC, V_F_PORCH, V_DISPL, V_B_PORCH);

	---------functions---------

	-- Function that converts time into clock cycles, depending on the CLK FRQ
	-- Also it accounts for the rounding error of division:
	-- +1 for if error like 100 / 40 => 2.5 => 2
	function convertTime(NANO_SEC: integer := 0) 
		return integer is variable CLK_CYCLES : integer;
	begin
		CLK_CYCLES = NANO_SEC / (1000000000 / CLK_FRQ);
		return CLK_CYCLES + 1; 
	end function;


	---------singals---------

	-- counter increment signals, on a rising edge on 1 the counter will increment
	signal INC_V, INC_H

	-- reset signals for counters and timer, resets internal counters
	signal RESET_V, RESET_H, RESET_TIMER: std_logic;

	-- internal count of timer and counter components
	signal COUNT_H: std_logic_vector(C_H_LENGTH - 1 downto 0);
	signal COUNT_V: std_logic_vector(C_V_LENGTH - 1 downto 0);
	signal CURR_TIME: integer range 0 to INT_RANGE;

	signal CURR_STATE: STATE := H_SYNC;

begin
	COUNTER_V: COUNTER
		generic map(LENGTH => C_V_LENGTH)
		port map(INC => INC_V, RESET => RESET_V, Q => COUNT_V);
	COUNTER_H: COUNTER
		generic map(LENGTH => C_H_LENGTH)
		port map(INC => INC_H, RESET => RESET_H, Q => COUNT_H);
	TIMER: H_WAIT_TIMER
		generic map(INT_RANGE => INT_RANGE_TIMER)
		port map(CLK => PIXEL_CLK, RESET => RESET_TIMER, Q => CURR_TIME);
	
	process(CLK, RESET) 
	begin

	end process
	
	process(CLK, RESET)
	begin
		RESET_V <= '0';
		RESET_H <= '0';
		RESET_TIMER <= '0';

		if(RESET = '1') then
			RESET_V <= '1';
			RESET_H <= '1';
			RESET_TIMER <= '1';
			CURR_STATE <= H_SYNC;
		elsif (CLK = '1' and CLK'event) then
			case CURR_STATE is 
				when H_SYNC => 
					HS <= 0;
					if(CURR_TIME = convertTime(WAIT_H_SYNC)) then 
						CURR_STATE <= H_F_PORCH;
						RESET_TIMER <= '1';
					end if;
				when H	
		end if;
		
	end process
end BEHAV;
