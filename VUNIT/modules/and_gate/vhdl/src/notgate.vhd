library IEEE;
use IEEE.std_logic_1164.all;

entity notgate is 
	port(
      a: in std_logic;
      b: out std_logic
    );
begin 

end entity notgate;

architecture rtl of notgate is

begin
    b <= not a ;
end rtl;