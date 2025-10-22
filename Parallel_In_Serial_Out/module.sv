`timescale 1ns/1ps 

module parallel_to_serial #(parameter DATA_WIDTH = 16) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din,
  input din_en,
  output logic dout, 
  input rdy
);
  
  logic [DATA_WIDTH - 1: 0] buffer, buffer2;
  logic resetn_z;
  logic rdy_z;
  typedef enum {IDLE, SHIFT} fsm_t;
  
  fsm_t state;
  
  always @ (posedge clk or negedge resetn) begin 
    
    if (!resetn) begin
      
      dout <= 0;
	  
      buffer <= 0;

    end else if (din_en == 1) begin
      
      dout<= din[0];
      
      buffer <= din[3:1];
      
    end else begin
		
      dout <= buffer[0];
      
      buffer <= {1'b0, buffer[3:1]};

    end
  
  end
    
endmodule

