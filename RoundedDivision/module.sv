module model #(parameter
  DIV_LOG2=3,
  OUT_WIDTH=32,
  IN_WIDTH=OUT_WIDTH+DIV_LOG2
) (
  input [IN_WIDTH-1:0] din,
  output logic [OUT_WIDTH-1:0] dout
);

  parameter n_bits_align = 2**DIV_LOG2;
  
  always @ (din) begin
	   
    dout = (((din + (n_bits_align - 1 )) & ~(n_bits_align - 1) ) >> DIV_LOG2) & {OUT_WIDTH{1'b1}} ;
    
  end
  
endmodule
