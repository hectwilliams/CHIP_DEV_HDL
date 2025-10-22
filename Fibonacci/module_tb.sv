// Code your testbench here
// or browse Examples

module fibonacci_tb;
  
  parameter CLK_PERIOD = 2;
  parameter CLK_PERIOD_DIV_2 = CLK_PERIOD / 2;
  parameter DATA_WIDTH = 32;
  
  logic clk, rst, rst_z;
  logic [DATA_WIDTH - 1 : 0] out;
  logic  [DATA_WIDTH - 1 : 0] counter, counter_z;
  
  initial begin
    
    rst = 0;
    
    #4 rst = 1;
    
  end
  
  initial begin
    
    clk = 0;
    
    forever #(CLK_PERIOD_DIV_2) clk = ~clk;
    
  end
  
  always @ ( posedge clk  or negedge rst) begin
    
    rst_z <= rst;
    counter_z <= counter;
    
    if ( !rst ) begin 
      
      counter <= 0;
      
      
    end else begin
      
      counter <= counter + 1;
      
    end
    
    
    if (counter_z < 20) begin
      
      $display(" prev_index - %d   dout - %d", counter_z, out);
      
    end
    
    if (counter_z == 20 ) begin
      $finish;
    end
	
  end
  
	
  fibonacci #(DATA_WIDTH) u0 (
    .clk(clk),
    .resetn(rst),
    .out(out)
  );
  
  
  
endmodule
