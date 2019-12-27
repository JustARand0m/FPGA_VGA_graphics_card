library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

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
--Sync Generation constants

--***640x480@60Hz***--  Requires 25 MHz clock
constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

constant H_FP : natural := 16; --H front porch width (pixels)
constant H_PW : natural := 96; --H sync pulse width (pixels)
constant H_MAX : natural := 800; --H total period (pixels)

constant V_FP : natural := 10; --V front porch width (lines)
constant V_PW : natural := 2; --V sync pulse width (lines)
constant V_MAX : natural := 525; --V total period (lines)

constant H_POL : std_logic := '0';
constant V_POL : std_logic := '0';

signal active : std_logic;

signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');

signal h_sync_reg : std_logic := not(H_POL);
signal v_sync_reg : std_logic := not(V_POL);

signal h_sync_dly_reg : std_logic := not(H_POL);
signal v_sync_dly_reg : std_logic :=  not(V_POL);

begin
 ------------------------------------------------------
 -------         SYNC GENERATION                 ------
 ------------------------------------------------------
  process (PIXEL_CLK)
  begin
    if (rising_edge(PIXEL_CLK)) then
      if (h_cntr_reg = (H_MAX - 1)) then
        h_cntr_reg <= (others =>'0');
      else
        h_cntr_reg <= h_cntr_reg + 1;
      end if;
    end if;
  end process;
  
  process (PIXEL_CLK)
  begin
    if (rising_edge(PIXEL_CLK)) then
      if ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) then
        v_cntr_reg <= (others =>'0');
      elsif (h_cntr_reg = (H_MAX - 1)) then
        v_cntr_reg <= v_cntr_reg + 1;
      end if;
    end if;
  end process;
  
  process (PIXEL_CLK)
  begin
    if (rising_edge(PIXEL_CLK)) then
      if (h_cntr_reg >= (H_FP + FRAME_WIDTH - 1)) and (h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1)) then
        h_sync_reg <= H_POL;
      else
        h_sync_reg <= not(H_POL);
      end if;
    end if;
  end process;
  
  
  process (PIXEL_CLK)
  begin
    if (rising_edge(PIXEL_CLK)) then
      if (v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
        v_sync_reg <= V_POL;
      else
        v_sync_reg <= not(V_POL);
      end if;
    end if;
  end process;
  
  
  BLANK <= '0' when ((h_cntr_reg < FRAME_WIDTH) and (v_cntr_reg < FRAME_HEIGHT))else
            '1';

  process (PIXEL_CLK)
  begin
    if (rising_edge(PIXEL_CLK)) then
      v_sync_dly_reg <= v_sync_reg;
      h_sync_dly_reg <= h_sync_reg;
    end if;
  end process;

  HS <= h_sync_dly_reg;
  VS <= v_sync_dly_reg;

  C_H <= (others=>'0');
  C_V <= (others=>'0');
end BEHAV;
