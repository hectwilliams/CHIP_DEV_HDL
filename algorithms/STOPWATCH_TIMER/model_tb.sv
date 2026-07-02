`timescale 1ns/1ps

module model_tb;
  
  parameter DATA_WIDTH = 16;
  
  parameter SEQ_WIDTH = 23;
  
  parameter CLK_PERIOD = 4;
  
  parameter CLK_PERIOD_DIV_2 = CLK_PERIOD / 2;
  
  logic clk, clk_z;
 
  logic rst, reset_tb;
  
  logic start;
  
  logic stop;
  
  logic [DATA_WIDTH-1:0] count;
  
  logic [0:SEQ_WIDTH-1] start_seq = 23'b00100001001010100000100;
    
  logic [0 : SEQ_WIDTH-1] rst_seq =  23'b00001000000010000000000;
  
  logic [0:SEQ_WIDTH-1] stop_seq =  23'b00000001000010010010000;
  
  logic [2:0] rdy;
  
  logic go, go_z, finish_edge;
  
  logic [$clog2(SEQ_WIDTH)+ 3:0] counter, counter_z;
  
  logic rst_z, start_z, stop_z, count_z; 
   
  logic rst_zz, start_zz, stop_zz, count_zz; 

  initial begin 
    
    clk = 0;
    
    forever #(CLK_PERIOD_DIV_2) clk = ~clk;
    
  end
    
  initial begin
    
    reset_tb = 0;
    
    #4 reset_tb = 1;
    
  end
  
  initial begin 
       
    counter = 0;
       
    rst = 1;

    go = 1;
    
    rdy = 0;
    
  end

  always @ (posedge clk or negedge reset_tb) begin
    
    if (! reset_tb) begin

      counter <= 0;

      rst <= 0;

      go <= 1;

      rdy <= 0;  
      
    end else begin
      
      finish_edge <= rdy[0];
      
      go_z <= go;
    
    go <= 0;
    
    counter_z <= counter;

    clk_z <= clk;
    
    rst_z <= rst;
    
    start_z <= start;
    
    stop_z <= stop;
    
    rst_zz <= rst_z;
    
    start_zz <= start_z;
    
    stop_zz <= stop_z;
    
    
    if (go_z & ~go) begin

      rdy[2] <=1;
      
    
    end else if (counter == SEQ_WIDTH - 1 ) begin
      
      rdy[2] <= 0;
    
    end
    
      rdy[1] <= rdy[2];
    
      rdy[0] <= rdy[1];
    
      if( rdy[2] || (counter > 0 && counter < SEQ_WIDTH) ) begin

      counter <= counter + 1;
      	
      rst <= rst_seq[counter];
      
      start <= start_seq[counter];
      
      stop <= stop_seq[counter];
    
    end
      
      if ( ( finish_edge & ~rdy[0] )  ) begin
      
        $finish;
    
      end
    
      // rcvd by module
      
      if (rdy[1] || (~rdy[1] & rdy[0]) ) begin
      
    
     	$display("[%d] Button Press: reset[%d] start[%d] stop[%d]  return - %d", counter_z, rst, start, stop, count);
      
      end

    end

  end
  
  model #(DATA_WIDTH) u0 (
  	
    .clk(clk),
    .reset(rst),
    .start(start),
    .stop(stop),
    .count(count)
    
  );
endmodule;
