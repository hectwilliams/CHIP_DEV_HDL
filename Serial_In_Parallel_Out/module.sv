// Code your design here
`timescale 1ns / 1ps

module model #(parameter
  DATA_WIDTH = 16
) (
  input clk,
  input resetn,
  input din,
  output logic [DATA_WIDTH-1:0] dout
);
  
  logic [DATA_WIDTH-1:0] buffer, store;
  
  logic [31: 0] index;
  
  always @ (posedge clk or negedge resetn) begin 

    if (!resetn) begin
      
      index <= 0;
      
      store <= 0;
    
      dout <= 0;
      
    end else begin
      
		store <= ((store << 1) & ~(1'b1)) | din ;
        
        dout <= ((store << 1) & ~(1'b1))  | din;

    end
    
  end

endmodule
