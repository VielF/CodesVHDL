------------------------------------------------
-- Design: Integration of add/sub with reg
-- Entity: AC_top
-- Author: Felipe Viel
-- Rev.  : 1.0
-- Date  : 10/17/2022
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity AC_top is
  generic (
    REG_WIDTH   : natural := 32;
    DATA_WIDTH  : natural := 32
  );
  port (
    i_CLK   : in std_logic;
    i_RSTN  : in std_logic;
    i_ENA_REG_IN   : in std_logic;
    i_ENA_REG_OUT  : in std_logic;

    i_X     : in std_logic_vector(DATA_WIDTH-1 downto 0);
    --i_Y     : in std_logic_vector(DATA_WIDTH-1 downto 0); -- caso queira mais um operando
    o_DATA  : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end entity;

architecture arch of AC_top is
   
  ---- SIGNALS DECLARATION ----
  signal w_REG_X_OUT      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal w_REG_Y_OUT      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal w_ADD_OUT      : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal w_REG_OUT      : std_logic_vector(DATA_WIDTH-1 downto 0);
  

  ---- COMPONENTS DECLARATION ----
  component adder_pp
    generic(
         DATA_WIDTH : natural := 8);
    port ( 
           i_X : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- clear/reset
           i_Y : in  std_logic_vector(DATA_WIDTH-1 downto 0);  -- clock
           
           o_D : out std_logic_vector(DATA_WIDTH-1 downto 0)); -- data output
  end component;

  component reg_8bit_pp
    generic(
         SIZE_REG : natural := 8;
           SIZE_SIGNAL: natural := 8);
    port ( i_CLR_n : in  std_logic;  -- clear/reset
           i_CLK   : in  std_logic;  -- clock
           i_ENA   : in  std_logic;  -- enable    
           i_D     : in  std_logic_vector(SIZE_REG-1 downto 0);  -- data input
           o_Q     : out std_logic_vector(SIZE_REG-1 downto 0)); -- data output
  end component;
  
begin



  -- instancia entidade responsavel o valor de entrada X
  u_REG_X_IN : reg_8bit_pp
  generic map(
       SIZE_REG => REG_WIDTH,
       SIZE_SIGNAL => REG_WIDTH)
  port ( i_CLR_n => i_CLK,
         i_CLK   => i_RST,
         i_ENA   => i_ENA_REG_IN,
         i_D     => i_X,
         o_Q     => w_REG_X_OUT
  );

  -- instancia entidade responsavel o valor de entrada Y
  u_REG_Y_IN : reg_8bit_pp
  generic map(
       SIZE_REG => REG_WIDTH,
       SIZE_SIGNAL => REG_WIDTH)
  port map( i_CLR_n => i_CLK,
         i_CLK   => i_RST,
         i_ENA   => i_ENA_REG_IN,
         i_D     => w_REG_OUT, -- ou i_Y
         o_Q     => w_REG_Y_OUT
  );
  
  
  u_ADD: adder_pp
    generic map(
         DATA_WIDTH => DATA_WIDTH)
    port map( 
           i_X => w_REG_X_OUT, 
           i_Y => w_REG_Y_OUT, 
           o_D => w_ADD_OUT
    );

  -- instancia entidade responsavel o valor de entrada Y
  u_REG_OUT_ADD : reg_8bit_pp
  generic map(
       SIZE_REG => REG_WIDTH,
       SIZE_SIGNAL => REG_WIDTH)
  port map( i_CLR_n => i_CLK,
         i_CLK   => i_RST,
         i_ENA   => i_ENA_REG_OUT,
         i_D     => w_ADD_OUT, -- ou i_Y
         o_Q     => w_REG_OUT
  );

  o_DATA <= w_REG_OUT;

end architecture;
