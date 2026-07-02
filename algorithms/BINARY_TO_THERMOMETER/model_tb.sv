module model_tb;

  bit [7 : 0] din;
  
  bit [255 : 0] dout;
  
  initial begin
    
  	din = 8'b0000_0001;  
    
  end
	
  always @ (dout) begin
    $display("[%b]", dout) ;
  end
  
  model   u0(
  
    .din(din),
    
    .dout(dout)
    
  );
endmodule;
