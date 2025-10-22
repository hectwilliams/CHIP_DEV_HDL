// Code your testbench here
// or browse Examples

module model_tb;
  
  parameter CLK_PERIOD = 2;
  parameter CLK_PERIOD_DIV_2 = CLK_PERIOD / 2;
  parameter DATA_WIDTH = 16;
  parameter N_PACKETS = 3;
  
  logic clk;
  logic [DATA_WIDTH - 1: 0] rom [N_PACKETS];
  logic [$clog2(DATA_WIDTH) : 0] dout;
  logic [DATA_WIDTH - 1 : 0 ] din;
  logic [3:0] counter, counter_z;

  initial begin
    clk = 0;
    forever  #(CLK_PERIOD_DIV_2) clk = ~clk;
  end
  
  initial begin
    rom[0] = 3;
    rom[1] = 5;
    rom[2] = 8;
  end
	
  initial begin
    counter = 0;
  end
  
  always @ (posedge clk) begin
    
    counter_z <= counter;
    
    din <= rom[counter]; 

    if (counter < 3) begin
      
      counter <= counter + 1;
      
    end else if(counter_z == 3) begin 
    
      $finish;
      
    end
    
    if (counter_z != counter)
   
      $display("index - %d   input - %d   n_ones - %d", counter_z, din, dout);
  end
  
  model #(DATA_WIDTH) u0 (
    .din(din),
    .dout (dout)
  );
  
endmodule 
