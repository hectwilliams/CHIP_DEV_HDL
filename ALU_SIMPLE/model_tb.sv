module model_tb;
  
  parameter DATA_WIDTH = 16;
  
  bit [DATA_WIDTH-1:0]  operand_a , operand_b, a_plus_b, a_minus_b, not_a, a_and_b, a_or_b, a_xor_b;
  
  
  initial begin
    
    operand_a = 'd5;
    operand_b = 'd6;
    
    # 10
    
    $display("a = %b  b = %b a_plus_b = %b a_minus_b = %b not_a = %b  a_and_b = %b a_or_b = %b  a_xor_b = %b", operand_a , operand_b, a_plus_b, a_minus_b, not_a, a_and_b, a_or_b, a_xor_b);
    
  end
  
  model #(DATA_WIDTH) u0 (
    
    .a(operand_a),
    
    .b(operand_b),

    .a_plus_b(a_plus_b),
    
    .a_minus_b(a_minus_b),
    
    .not_a(not_a), 
    
    .a_and_b(a_and_b),
    
    .a_or_b(a_or_b),
    
    .a_xor_b(a_xor_b)
    
  );
  
endmodule
