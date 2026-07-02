`timescale 1ns/1ps
module SecondLargest_tb;
  
  parameter DATA_WIDTH = 8'd32;
  parameter CLK_PERIOD = 2;
  parameter CLK_PERIOD_DIV_2 = CLK_PERIOD / 2;
  
  logic clk;
  logic rst;
  logic [DATA_WIDTH-1:0] data;
  logic [DATA_WIDTH-1:0] dout;
  
  logic [7:0] counter;
  
  initial begin
    rst = 0;
    #2 rst = 1;
  end
  
  initial begin 
    clk = 0;
    forever #(CLK_PERIOD_DIV_2) clk = ~clk; 
  end
	
  always @ (posedge clk or negedge rst) begin

    if (!rst) begin
      
      counter <= 0;
      
      data <= 0;
      
    end else begin
      
      data <= $urandom() & 8'h0xFF;
      
      counter <= counter +1; 
	
      $display("input - %0d\t output - %0d", data, dout);
     

    end
	
    if (counter == 30) begin
      
		$finish;

    end
    
  end
   
  SecondLargest #(DATA_WIDTH) u0 (
     .clk(clk),
     .resetn(rst), 
     .din(data),
     .dout(dout)
  );
  
endmodule
