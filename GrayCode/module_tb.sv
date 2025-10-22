`timescale 1ns/1ps 


module model_tb;
  
  parameter CLK_PERIOD = 2;
  parameter CLK_PERIOD_DIV = CLK_PERIOD / 2;
  parameter DATA_WIDTH = 4;
  parameter N_GRAY_CODES = 20;
  
  logic rst;
  logic clk;
  logic [DATA_WIDTH - 1 : 0] out ;
  
  logic [31:0] counter, counter_z;
  
  initial begin
  	rst = 0; 
    #5 rst = 1;
  end
  
  initial begin
    clk = 0;
    forever #(CLK_PERIOD_DIV) clk = ~clk; 
  end
  
  always @ (posedge clk) begin
    
    counter_z <= counter;
    
    if (!rst) begin
      
      counter <= 0;
      
    end else begin 
		
      if (counter < N_GRAY_CODES) begin
        
	      counter <= counter + 1;
        
      end
      
      if (counter < N_GRAY_CODES ) begin
        
        $display("Gray Code %0b , %0d", out, counter);
        
      end
	
      if (counter == N_GRAY_CODES) begin
        
        $finish;
        
      end 
      
    end
    
  end
  
  
  top_graycode #(DATA_WIDTH) u0 (
  	
    .clk(clk),
    .resetn(rst),
    .out(out)
    
  );
endmodule
