


library IEEE;
use IEEE.std_logic_1164.all;

library vhd_lib; -- hdl files 
use vhd_lib.globals.all; -- custom package 

entity nandgate is 
	port(
      a: in std_logic;
      b: in std_logic;
      c: out std_logic 
    );
begin 

end entity nandgate;

architecture rtl of nandgate is
    signal data_bit : std_logic;
begin
    
    uut:  entity vhd_lib.andgate
    port map (
        a => a, -- i 
        b => b, -- i
        c => data_bit -- o
    );

        uut1:  entity vhd_lib.notgate
    port map (
        a => data_bit, -- i
        b => c -- o
    );

    
end rtl;