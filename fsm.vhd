library ieee;
use ieee.std_logic_1164.all;

entity fsm is
port ( i_CLR_n : in  std_logic;  -- clear/reset
       i_CLK   : in  std_logic;  -- clock
       i_GO    : in  std_logic;  -- input 1    
       i_BACK  : in  std_logic;  -- input 2    
       o_Q     : out std_logic); -- output
end fsm;


architecture arch_1 of fsm is
  type   t_STATE is (s_0, s_1); -- new FSM type
  signal r_STATE : t_STATE;     -- state register
  signal w_NEXT  : t_STATE;     -- next state

begin
  -- State register
  p_STATE: process(i_CLR_n,i_CLK) 
  begin
    if (i_CLR_n ='0') then
      r_STATE <= s_0;           -- initial state
    elsif (rising_edge(i_CLK)) then
      r_STATE <= w_NEXT;        -- next state
    end if;
  end process; 
  
  -- Next state funcion  
  p_NEXT: process(r_STATE, i_GO, i_BACK)
  begin
    case (r_STATE) is
      when s_0 => if (i_GO = '1') then 
                     w_NEXT <= s_1;
                   else
                     w_NEXT <= s_0;
                   end if;
                   
      when s_1 => if (i_BACK = '1') then 
                     w_NEXT <= s_0;
                   else
                     w_NEXT <= s_1;
                   end if;
                   
      when others => w_NEXT <= s_0;
    end case;  
  end process;

  -- Output funcion
  o_Q <= '1' when (r_STATE = s_1) else '0’;
