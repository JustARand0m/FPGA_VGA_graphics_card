library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CONVERT is
  port(CLK: in std_logic;
       HEX: in std_logic_vector(5 downto 0);
       DIGIT_0: out std_logic_vector(3 downto 0);
       DIGIT_1: out std_logic_vector(3 downto 0));
end entity;

architecture BEHAV of CONVERT is

begin

  -- convert hex to bcd
  CONV_HEX: process (HEX)
    variable HEXVAR: std_logic_vector(5 downto 0):="000000";
  begin
      if    ((HEX >= "000000") and (HEX <= "001001")) then -- 0X
        HEXVAR:=HEX;
        DIGIT_0 <= HEXVAR(3 downto 0);
        DIGIT_1 <= x"0";
      elsif ((HEX >= "001010") and (HEX <= "010011")) then -- 1X
        HEXVAR := (HEX - "001010");
        DIGIT_0 <= HEXVAR(3 downto 0);
        DIGIT_1 <= x"1";
      elsif ((HEX >= "010100") and (HEX <= "011101")) then -- 2X
        HEXVAR := (HEX - "010100");
        DIGIT_0 <= HEXVAR(3 downto 0);
        DIGIT_1 <= x"2";
      elsif ((HEX >= "011110") and (HEX <= "100111")) then -- 3X
        HEXVAR := (HEX - "011110");
        DIGIT_0 <= HEXVAR(3 downto 0);
        DIGIT_1 <= x"3";
      elsif ((HEX >= "101000") and (HEX <= "110001")) then -- 4X
        HEXVAR := (HEX - "101000");
        DIGIT_0 <= HEXVAR(3 downto 0);
        DIGIT_1 <= x"4";
      elsif ((HEX >= "110010") and (HEX <= "111011")) then -- 5X
        HEXVAR := (HEX - "110010");
        DIGIT_0 <= HEXVAR(3 downto 0);
        DIGIT_1 <= x"5";
      else -- if values are not valid display zero
        HEXVAR := "000000";
        DIGIT_0 <= HEXVAR(3 downto 0);
        DIGIT_1 <= x"0";
      end if;
  end process;
end BEHAV;

