------------------------------------------------
-- Design: 8-bit register with enable
-- Entity: reg_8bit
-- Author: Cesar Zeferino
-- Rev.  : 1.0
-- Date  : 04/15/2020
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity reg_8bit is
generic(
	   SIZE_REG : natural := 8;
       SIZE_SIGNAL: natural := 8);
port ( i_CLR_n : in  std_logic;  -- clear/reset
       i_CLK   : in  std_logic;  -- clock
       i_ENA   : in  std_logic;  -- enable    
       i_D     : in  std_logic_vector(SIZE_REG-1 downto 0);  -- data input
       o_Q     : out std_logic_vector(SIZE_REG-1 downto 0)); -- data output
end reg_8bit;


architecture arch_1 of reg_8bit is
	signal w_EX_SIGNAL : std_logic_vector(SIZE_SIGNAL-1 downto 0);
begin
  process(i_CLR_n,i_CLK) 
  begin
    if (i_CLR_n ='0') then
      o_Q <= (others =>'0');
	elsif (rising_edge(i_CLK)) then
      if (i_ENA = '1') then
         o_Q <= i_D;
      end if;
    end if;
  end process;
end arch_1;
