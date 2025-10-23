module TrailingZeros_tb;
  
  parameter  DATA_WIDTH = 4;
  parameter N_SIM_VALUES = 5;
 
  logic clk;
  logic [DATA_WIDTH-1:0]  din, din_z;
  logic [$clog2(DATA_WIDTH):0]  dout;
  logic [DATA_WIDTH-1:0]  rom [5];
  logic [DATA_WIDTH - 1: 0] counter, counter_z, counter_zz;
  logic go, go_z, rdy, rdy_z, rdy_zz;
  ; 
  initial begin
    clk = 0;
    forever #(1) clk = ~clk;  
  end
  
  initial begin
    din = 'z;
    counter = 'z;
	counter_z = 'z;
    go = 1;
  end
  
  initial begin
    rom[0] = 4'b0000;
    rom[1] = 4'b1111;
    rom[2] = 4'b0110;
    rom[3] = 4'b0010;
    rom[4] = 4'b0001;
  end
  
  always @ (posedge clk) begin
    go_z <= go;
    go <= 0;
    counter_z <= counter;
    counter_zz <= counter_z;
    rdy_z <= rdy;
    rdy_zz <= rdy_z;
    
    counter <= 0;
    
     
    /* Start/Stop Valid Stream  */
    
    if (go_z && ~go  ) begin
      
      rdy <= 1;
      
    end else if (counter == N_SIM_VALUES - 1) begin
      
      rdy <= 0;
      
    end
    
    
    /* Read ROM Data  */
    if (rdy) begin
      
      counter <= counter + 1;
      
      din <= rom[counter];
    end

   
    /* Read Received Data  */

    if (rdy_z) begin
      
     $display("sent %d -- rcvd %d --", din, dout);
      
    end
    
	/* Terminate Testbench */
    if (rdy_zz & ~rdy_z ) begin
      
      $finish;
   	
    end
    
  end
  
  TrailingZeros #(DATA_WIDTH) u0 (
    .din(din),
    .dout(dout)
  );
endmodule

