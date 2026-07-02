library IEEE;
use IEEE.std_logic_1164.all;

module andgate (
    input logic a,
    input logic b,
    output logic c
);


    assign c = a & b;

endmodule

