module one_hot_tb;
  
  parameter DATA_WIDTH = 6;
  
  parameter N_ELEMENTS = 6; 
  
  logic clk;

  logic go, go_z;
  
  logic [2:0] rdy;
	
  logic [DATA_WIDTH - 1: 0] rom[N_ELEMENTS];
  
  logic  [DATA_WIDTH-1:0] din; 
  
  logic onehot;
  
  logic [$clog2(DATA_WIDTH): 0] counter ;
  
  initial begin
    counter = 0;
    go = 1;
    
    rdy  = 0;
    
    rom[0] = 1;
    
    rom[1] = 2;
    
    rom[2] = 3;
    
    rom[3] =  5;
    
    rom[4] =  32;
    
    rom[5] =  33;

    
  end
    
  initial begin
    
    clk = 0;
    
    forever #1 clk = ~clk;
    
  end
  
  always @ (clk) begin
    
    go <= 0;
    
	go_z <= go;
    
    rdy[0] <= rdy[1];
    
    rdy[1] <= rdy[2];

    if (go_z & ~go) begin
      
      rdy[2] <= 1;

    end else if (counter  == N_ELEMENTS - 1) begin

      rdy[2] <= 0;

    end
    
    if (rdy[2] || (counter > 0 && counter < N_ELEMENTS) ) begin

      counter <= counter + 1;
      
      din <= rom[counter];
      
    end 

    if (rdy[0] & ~rdy[1] ) begin
      
      $finish;
      
    end
	   
    /* monitor rcvd data */
    
    if (rdy[1]) begin
      
      $display("sent %d rcvd %d", din, onehot);
      
    end
    
  end
  
  model #(DATA_WIDTH) u0 (
  
    .din(din),
    .onehot(onehot)
  );
      
        
endmodule;
