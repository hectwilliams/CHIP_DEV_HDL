library IEEE;
use IEEE.std_logic_1164.all;

module notgate (
    input logic a,
    output logic b
);
    assign b = ~a;
endmodule

