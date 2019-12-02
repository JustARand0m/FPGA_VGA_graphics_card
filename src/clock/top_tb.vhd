LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY top_tb IS
END top_tb;

ARCHITECTURE behavior OF top_tb IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT TOP
	PORT(
		CLK : IN std_logic;
        BTN0: in std_logic;  -- reset
        BTN3: in std_logic; -- set hour
        BTN2: in std_logic;  -- set min
        BTN1: in std_logic; -- set sek
        LCD_D: out std_logic_vector(3 downto 0);
        LCD_RS: out std_logic; -- 0=CMD; 1=DATA
        LCD_E: out std_logic; -- enable signal low active
        LCD_RW: out std_logic -- 0= write 1= read
		);
	END COMPONENT;

	--Inputs
	SIGNAL CLK :  std_logic := '0';
	SIGNAL BTN0:  std_logic := '0';
	SIGNAL BTN1 :  std_logic := '0';
	SIGNAL BTN2:  std_logic := '0';
	SIGNAL BTN3 :  std_logic := '0';

	--Outputs
	SIGNAL LCD_D :  std_logic_vector(3 downto 0);
	SIGNAL LCD_RS :  std_logic;
	SIGNAL LCD_E :  std_logic;
	SIGNAL LCD_RW :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: TOP PORT MAP(
		CLK => CLK,
		BTN0 => BTN0,
		BTN1 => BTN1,
		BTN2 => BTN2,
		BTN3 => BTN3,
		LCD_D => LCD_D,
		LCD_RS => LCD_RS,
		LCD_E => LCD_E,
		LCD_RW => LCD_RW
	);

	tb : PROCESS
	BEGIN

	CLK <= '0';
    wait for 5 ns;
    CLK <= '1';
    wait for 5 ns;
		
	END PROCESS;
  

END;
