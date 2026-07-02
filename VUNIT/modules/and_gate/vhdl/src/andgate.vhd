library IEEE;
use IEEE.std_logic_1164.all;

entity andgate is 
	port(
      a: in std_logic;
      b: in std_logic;
      c: out std_logic 
    );
begin 


end entity andgate;

architecture rtl of andgate is

begin

        c <= a and b;
    
end rtl;