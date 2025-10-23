module xor_rrot_tb;
  
  parameter DATA_WIDTH = 32;
  
  logic [DATA_WIDTH - 1 : 0] A, B;
  
  logic [$clog2(DATA_WIDTH) : 0] SELECT;
	
  logic [DATA_WIDTH - 1:0] out;

  initial begin 
    
    A = 1;
    
    B = 4;
    
    SELECT = 31;
    
  end 
  
  xor_rrot #(DATA_WIDTH) u0 (
  
    .A(A),
    
    .B(B),
    
    .SELECT(SELECT),
    
    .out(out)
  );
  
  always @ (out) begin
    
    $display("[%b]", out);
    
  end
endmodule
