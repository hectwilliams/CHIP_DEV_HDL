`timescale 1ns/1ps 

module counter_tb;
  
  logic clk_tb;
  logic rstn_tb;
  logic [7:0] n_ticks_tb; 
  logic [7:0] data_o_tb; 
  logic watch_tb; 
  
  parameter TICKS = 8'd10;
  parameter CLK_PERIOD = 2; // 2 ns
  parameter CLK_PERIOD_DIV_2 = CLK_PERIOD/2; // 1 ns

  
 // Stimuli 
  
 // Reset 
  initial begin
    rstn_tb = 0;
    #2 rstn_tb = 1;
  end 

 //Clock 
  
  initial begin 
  	clk_tb = 0;
    forever #(CLK_PERIOD_DIV_2) clk_tb = ~clk_tb;
  end 
  
  // Routine 
  initial begin 
  	
    n_ticks_tb = 8'd100;
    
    $display("Waiting for enable_signal to be high at time %0t", $time);

    wait (rstn_tb == 1);
    
    $display("Counter Enabled");
    
  end 
  
  // Monitor for every positive edge of signal_a
  always @(posedge clk_tb ) begin
    
    if (watch_tb ) begin       
      
      $display("posedge detected at time %0t", $time);
      
    end 
    
  end

  // Instantiate DUT
  
  counter u0(
    .clk(clk_tb), 
    .rstn(rstn_tb), 
    .n_ticks(n_ticks_tb), 
    .data_o(data_o_tb),
    .watch_o(watch_tb)
  );
  
endmodule 
