-- CREATOR: Michael Braun

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 
use ieee.std_logic_unsigned.all;

entity MEM_CTRL is
	port(-- OUTPUT
         BLANK: in std_logic;
	     R_R, R_G, R_B : out std_logic_vector(3 downto 0) := "0000";
	     R_ADDR: in std_logic_vector (18 downto 0);
	     R_CLK: in std_logic;
	     -- INPUT
         SYNC: in std_logic;
	     W_R, W_G, W_B : in std_logic_vector(3 downto 0) := "0000";
	     W_ADDR: in std_logic_vector (18 downto 0);
	     W_CLK: in std_logic;
	     RESET: in std_logic);
end MEM_CTRL;

architecture BEHAV of MEM_CTRL is
	-- type declarations
    type BUFFER_TYPE is (R1, R2, R3); 
	--type ram_line_type	is array (0 to 639) of std_logic_vector(11 downto 0);
	--type ram_type		is array (0 to 479) of ram_line_type;
	type RAM_LINE_TYPE	is array (0 to 0) of std_logic_vector(11 downto 0);
	type RAM_TYPE		is array (0 to 0) of RAM_LINE_TYPE;
	-- signals
    signal FRONT_BUFFER:    BUFFER_TYPE := R1;
    signal BACK_BUFFER_RDY: BUFFER_TYPE := R2;
    signal BACK_BUFFER_BSY: BUFFER_TYPE := R3;

	signal RAM1: RAM_TYPE := (others => (others => "111100000000")); 
	signal RAM2: RAM_TYPE := (others => (others => "000011110000")); 
	signal RAM3: RAM_TYPE := (others => (others => "000000001111")); 
	--signal RAM1, RAM2, RAM3: RAM_TYPE := (others => (others => "000011110000")); 
    signal cnt: std_logic_vector (31 downto 0) := (others => '0');
begin
	READ: process(R_CLK, RESET)
	begin
		if(RESET = '1') then
			R_R <= (others=>'0');
			R_G <= (others=>'0');
			R_B <= (others=>'0');
		elsif(rising_edge(R_CLK)) then
            case FRONT_BUFFER is
                when R1 =>
                    R_R <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
                    R_G <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
                    R_B <= RAM1(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
                when R2 =>
                    R_R <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
                    R_G <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
                    R_B <= RAM2(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
                when R3 =>
                    R_R <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0);
                    R_G <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4);
                    R_B <= RAM3(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8);
            end case;
		end if;
	end process READ;
	
	WRITE: process(BLANK, RESET)
	begin
		if(RESET = '1') then
            RAM1 <= (others => (others => (others => '0')));
            RAM2 <= (others => (others => (others => '0')));
            RAM3 <= (others => (others => (others => '0')));

		elsif(rising_edge(BLANK)) then
            cnt <= cnt + 1;
            if(cnt = 480 * 300) then
                case FRONT_BUFFER is
                    when R1 => FRONT_BUFFER <= R2;
                    when R2 => FRONT_BUFFER <= R3;
                    when R3 => FRONT_BUFFER <= R1;
                end case;
                cnt <= (others => '0');
            end if;
            
		--	RAM(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(3 downto 0)  <= W_R;
		--	RAM(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(7 downto 4)  <= W_G;
		--	RAM(to_integer(unsigned(R_ADDR(18 downto 10))))(to_integer(unsigned(R_ADDR(9 downto 0))))(11 downto 8) <= W_B;	
		end if;
	end process WRITE;
end BEHAV;
