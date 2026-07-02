// Code your design here
`timescale 1ns/1ps

module SecondLargest #(
  parameter DATA_WIDTH = 32
) (
  input clk,
  input resetn,
  input [DATA_WIDTH-1:0] din ,
  output logic [DATA_WIDTH-1:0] dout
);
  
  // Regs
  
  logic [DATA_WIDTH-1:0]  regs  [1:0]; // # array 2 32bit values
  logic [DATA_WIDTH-1:0] tick; 
  
  // Data Flow
  
  assign dout = (tick > 1) ? regs[0] : 32'd0 ;
  
  always @ (posedge clk or negedge resetn) begin
    
    if (!resetn) begin
    	
      regs[0] <= 0;
      
      regs[1] <= 0;
      
     
    end else if (tick == 0) begin
      
      regs[0] <= din;
      
    end else if (tick == 1) begin 
      
      if (din > regs[0]) begin
        
        regs[1] <= din;

      end else begin 
        
        regs[1] <= regs[0];
        
        regs[0] <= din; 
        
      end
    
    end else begin 
      
      if (din > regs[1]  && din > regs[0]) begin
		
        regs[0] <= regs[1];
        
        regs[1] <= din; 
        
      end else if ( din > regs[0] ) begin
      
        regs[0] <= din; 
        
      end
    
    end
	
    if (!resetn) begin 
	
      tick <= 0;
    
    end else begin
    	
      tick <= tick + 1; 
      
 	end
    
  end

endmodule
