------------------------------------------------
-- Design: Sliding Window
-- Entity: slidingwindow_valid
-- Author: Douglas Santos
-- Rev.  : 1.0
-- Date  : 21/05/2020
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real."ceil";
use IEEE.math_real."floor";
use IEEE.math_real."log2";
use IEEE.std_logic_unsigned.all;

entity slidingwindow_valid is
  generic (
    IMAGE_WIDTH   : integer;
    IMAGE_HEIGHT  : integer;
    WINDOW_WIDTH  : integer;
    WINDOW_HEIGHT : integer
  );
  port (
    i_VALID : in std_logic;
    i_RSTN  : in std_logic;
    i_CLK   : in std_logic;
    o_VALID : out std_logic
  );
end entity;

architecture arch of slidingwindow_valid is
  -- calcula o tamanho do registrador necessário para armazenar uma contagem do tamanho da imagem
  constant REPR_SIZE : integer := integer(ceil(log2(real(IMAGE_WIDTH * IMAGE_HEIGHT))));
  signal r_COUNTER : std_logic_vector(REPR_SIZE-1 downto 0);
  signal w_MOD     : std_logic_vector(REPR_SIZE-1 downto 0);
  signal r_VALID   : std_logic;
begin

  -- cria um contador grande o suficiente para armazenar
  p_COUNTER : process(i_RSTN, i_CLK)
  begin
    if i_RSTN = '0' then
      -- reseta o contador para início da operação
      r_COUNTER <= (others => '0');
      
    elsif rising_edge(i_CLK) then
      if i_VALID = '1' then
        -- incrementa somente quando há um pixel valido na entrada
        r_COUNTER <= std_logic_vector(unsigned(r_COUNTER) + 1);
      end if;
    end if;
  end process;
  
  -- adiciona um delay de um ciclo de clock ao sinal valid, para utilizacao na saida desse bloco
  p_DELAYED_VALID : process(i_CLK)
  begin
    if i_RSTN = '0' then
      r_VALID <= '0';
    elsif rising_edge(i_CLK) then
      r_VALID <= i_VALID;
    end if;
  end process;
  
  -- calcula a posicao na coluna do ultimo pixel
  w_MOD <= std_logic_vector((unsigned(r_COUNTER)-1) mod IMAGE_WIDTH);
  
  -- seta a saida valida quando o contador obedecer as duas condicoes:
  --   contador passou das linhas iniciais invalidas
  --   contador nao esta nas colunas iniciais invalidas
  o_VALID <= r_VALID when unsigned(r_COUNTER) >= ((WINDOW_HEIGHT-1) * IMAGE_WIDTH + WINDOW_WIDTH) and
                          unsigned(w_MOD)     >= (WINDOW_WIDTH-1)
             else '0';
  
  
end architecture;