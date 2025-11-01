`timescale 1ns/1ps

module model #(parameter
  DATA_WIDTH=32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [DATA_WIDTH-1:0] dout
);

	
  genvar i;
  
  generate 
    
    for (i = 0; i < DATA_WIDTH / 2 ; i= i + 1) begin
    
      always @ (din[i] or din[DATA_WIDTH - 1 - i] ) begin
      
        dout[i] = din[DATA_WIDTH - 1 - i];
        
        dout[DATA_WIDTH - 1 - i] = din[i];

      end
      
    end
    
  endgenerate 
  

endmodule
