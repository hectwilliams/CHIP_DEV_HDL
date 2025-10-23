module model #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic onehot
);

  always @ (din) begin
    
    if(din == 0) 
      
      onehot = 0;
      
    else
      
      onehot =  ((din - 1) & din)  == 0;
    
  end
  
endmodule
