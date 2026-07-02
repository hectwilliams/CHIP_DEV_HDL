module half_adder (
  input a,
  input b,
  output logic sum,
  output logic cout
);
  
  assign sum = a ^ b;
  
  assign cout = a & b;
  
endmodule

module model (
    input a,
    input b,
    input cin,
    output logic sum,
    output logic cout
);

  bit sum_prev, cout_prev, cout_next, sum_next;
	
  assign cout = cout_next | cout_prev;
  
  assign sum = sum_next;
    
  half_adder u0 (
    .a(a),
    .b(b),
    .sum(sum_prev),
    .cout(cout_prev)
  );
  
    half_adder u1 (
    .a(sum_prev),
    .b(cin),
    .sum(sum_next),
    .cout(cout_next)
  );
endmodule
