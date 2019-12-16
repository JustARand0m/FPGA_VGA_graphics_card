library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- RST is supposed to be high active !!!

entity RESETGEN is
    port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           RST_GLOBAL : out  STD_LOGIC);
end RESETGEN;

architecture BEHAV of RESETGEN is
signal RST_LOC : std_logic :='1';
begin

RSTGEN:process(CLK)
    begin
      if CLK ='1' and  CLK'event then 
         if RST_LOC = '1' then --self initialted reset at startup            
            RST_LOC  <= '0';
            RST_GLOBAL <='1';            
         elsif RST ='1' then -- manually initiated reset via button
            RST_GLOBAL <='1';
         else
            RST_GLOBAL <='0';
         end if;
       end if;
    end process;
end BEHAV;

