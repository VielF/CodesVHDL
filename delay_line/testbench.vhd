------------------------------------------------
-- Design: Testbench to inject data from/to file
-- Entity: testbench
-- Author: Douglas Santos
-- Rev.  : 1.2
-- Modificado: Felipe Viel
-- Date  : 10/16/2022
------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- library de leitura e escrita de arquivo
use std.textio.all;
use ieee.std_logic_textio.all;

entity testbench is
end entity;

architecture arch of testbench is
  constant period : time := 10 ns;
  signal rstn : std_logic := '0';
  signal clk : std_logic := '1';
  file fil_in : text;
  //file fil_in_2: text;
  file fil_out : text;

  signal valid : std_logic := '0';
  signal pix   : std_logic_vector(7 downto 0);
  
  signal valid_o : std_logic;
  signal pix_o : std_logic_vector(7 downto 0);
begin

  clk <= not clk after period/2;
  rstn <= '1' after period/2;

  p_INPUT : process
    variable v_line : line;
    variable v_data : std_logic_vector(7 downto 0);
  begin
    wait for period/2;
    file_open(fil_in, "img.dat", READ_MODE);
    valid <= '1';
    while not endfile(fil_in) loop
      readline(fil_in, v_LINE);
      read(v_LINE, v_data);
      pix <= v_data;
      wait for period;
    end loop;
    valid <= '0';
    wait;
  end process;
  //pode criar um segundo processo de leitura igual o acima
  //como os processos são paralelo, a injeção de dados é paralela


  p_RESULT : process
    variable v_line : line;
  begin
    file_open(fil_out, "img_out.dat", WRITE_MODE);

    while true loop
      wait until rising_edge(clk);
      if valid_o = '1' then
        write(v_line, pix_o);
        writeline(fil_out, v_line);
      end if;
    end loop;
    wait;
  end process;
  
  design_inst : entity work.design
  generic map (
    ?
  )
  port map (
   ?
  );
end architecture;