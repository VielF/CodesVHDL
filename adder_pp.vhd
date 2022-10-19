------------------------------------------------
-- Design: Adder
-- Entity: reg_8bit
-- Author: Felipe Viel
-- Rev.  : 1.0
-- Date  : 10/17/2022
------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all

entity adder_pp is
generic(
	   DATA_WIDTH : natural := 8);
port ( 
       i_X : in  std_logic_vector(DATA_WIDTH-1 downto 0);  
       i_Y : in  std_logic_vector(DATA_WIDTH-1 downto 0);  
       
       o_D : out std_logic_vector(DATA_WIDTH-1 downto 0)); -- data output
end adder_pp;


architecture arch_1 of adder_pp is
	signal w_ADD_EXTEND : std_logic_vector(DATA_WIDTH downto 0);
begin
  w_ADD_EXTEND <= ('0' & i_X) + ('0' & i_Y);
  o_D <= w_ADD_EXTEND(DATA_WIDTH-1 downto 0);
end arch_1;
