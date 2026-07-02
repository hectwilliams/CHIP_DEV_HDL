module module_tb;

  parameter DATA_WIDTH = 5;
  
  wire [DATA_WIDTH-1: 0] din;
  
  wire dout;

  assign din = 'b01010;
    
  always @ (dout) begin
    
    $display(" is %b palindrome. [%d]", din, dout);
    
  end
  
  model #(DATA_WIDTH) u0 (
  
    .din(din),
    
    .dout(dout)
    
  );
  
endmodule
