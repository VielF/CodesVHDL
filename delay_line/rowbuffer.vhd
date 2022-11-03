------------------------------------------------
-- Design: Sliding Window
-- Entity: rowbuffer
-- Author: Douglas Santos
-- Rev.  : 1.0
-- Date  : 21/05/2020
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity rowbuffer is
  generic (
    IMAGE_WIDTH : integer;
    PIXEL_WIDTH : integer
  );
  port (
    i_VALID : in std_logic;
    i_PIX   : in std_logic_vector(PIXEL_WIDTH-1 downto 0);

    i_CLK   : in std_logic;

    o_PIX   : out std_logic_vector(PIXEL_WIDTH-1 downto 0)
  );
end entity;

architecture arch of rowbuffer is
  
  ---- TYPES DECLARATION ----
  type t_ROWBUF is array(0 to IMAGE_WIDTH-1) of std_logic_vector(PIXEL_WIDTH-1 downto 0);
  
  ---- SIGNALS DECLARATION ----
  signal r_ROWBUF : t_ROWBUF;
  
  ---- COMPONENTS DECLARATION ----
  component pixreg
    generic (
      PIXEL_WIDTH : integer
    );
    port (
      i_VALID : in std_logic;
      i_PIX   : in std_logic_vector(PIXEL_WIDTH-1 downto 0);
      i_CLK   : in std_logic;
      o_PIX   : out std_logic_vector(PIXEL_WIDTH-1 downto 0)
    );
  end component;
  
begin

  -- instancia um registrador para armazenamento do pixel de entrada
  u_PIXREG_INPUT : pixreg
  generic map ( PIXEL_WIDTH => PIXEL_WIDTH )
  port map (
    i_VALID => i_VALID,
    i_PIX   => i_PIX,
    i_CLK   => i_CLK,
    o_PIX   => r_ROWBUF(0)
  );
  
  -- gera IMAGE_WIDTH-2 registradores
  -- cada registrador tem como entrada o pixel do registrador n-1
  -- o buffer desloca o pixel inserido na posicao 0 para posicoes superiores
  gen_ROWBUF_SHIFT : for i in 1 to IMAGE_WIDTH-1 generate
  
    -- instancia um registrador para armazenamento dos pixels do buffer
    u_PIXREG : pixreg
    generic map ( PIXEL_WIDTH => PIXEL_WIDTH )
    port map (
      i_VALID => i_VALID,
      i_PIX   => r_ROWBUF(i-1),
      i_CLK   => i_CLK,
      o_PIX   => r_ROWBUF(i)
    );
    
  end generate;

  -- coloca como saida o pixel da posicao final do buffer
  o_PIX <= r_ROWBUF(IMAGE_WIDTH-1);
end architecture;
