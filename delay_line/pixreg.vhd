------------------------------------------------
-- Design: Sliding Window
-- Entity: pixreg
-- Author: Douglas Santos
-- Rev.  : 1.0
-- Date  : 21/05/2020
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity pixreg is
  generic (
    PIXEL_WIDTH : integer
  );
  port (
    i_VALID : in std_logic;
    i_PIX   : in std_logic_vector(PIXEL_WIDTH-1 downto 0);
    i_CLK   : in std_logic;
    o_PIX   : out std_logic_vector(PIXEL_WIDTH-1 downto 0)
  );
end entity;

architecture arch of pixreg is
  signal r_PIX : std_logic_vector(PIXEL_WIDTH-1 downto 0);
begin
  
  -- cria um process para armazenamento de um pixel
  p_PIX : process(i_CLK)
  begin
    if rising_edge(i_CLK) then
      -- o registrador atualiza seu valor somente quando há um pixel valido na entrada
      if i_VALID = '1' then
        r_PIX <= i_PIX;
      end if;
    end if;
  end process;
  
  -- a saida e o valor armazenado pelo registrador
  o_PIX <= r_PIX;
  
end architecture;