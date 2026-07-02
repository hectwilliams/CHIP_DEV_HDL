module nandgate (
    input logic a,
    input logic b,
    output logic c
);
    logic sim_clk = 0; // needed for cocotb 
    logic sim_a = 0; // needed for cocotb 
    
    logic data;

andgate dut_and (
    .a (a),
    .b (b),
    .c (data)
);

notgate dut_not (
    .a (data),
    .b (c)
);

endmodule

