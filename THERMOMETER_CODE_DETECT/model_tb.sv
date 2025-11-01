module model_tb;

  parameter DATA_WIDTH = 16;
  
  bit [DATA_WIDTH-1: 0] codeIn;
  
  bit isThermometer;
  
  initial begin
    
    for ( int i = 0; i <= 2**DATA_WIDTH; i= i + 1) begin
      
      codeIn = i;
      
      #20; // model propagation delay
            
    end
    
  end
  
  always @ (isThermometer ) begin
    
    if (isThermometer)
    
      $display("code - %d  isThermometer - %d", codeIn, isThermometer);    
    
  end
	
  model #(.DATA_WIDTH(DATA_WIDTH) ) u0 (
  
    .codeIn( codeIn ),
    
    .isThermometer( isThermometer )
    
  );
  
endmodule
