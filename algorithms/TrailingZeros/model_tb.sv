module TrailingZeros_tb;
  
  parameter  DATA_WIDTH = 8;
  parameter N_SIM_VALUES = 5;
 
  logic clk;
  logic resetn_tb;
  logic [DATA_WIDTH-1:0]  din, din_z;
  logic [$clog2(DATA_WIDTH):0]  dout;
  logic [DATA_WIDTH-1:0]  rom [N_SIM_VALUES];
  logic [11: 0] counter;
  logic go, go_z, go_zz;
  logic valid, valid_z, valid_zz, valid_zzz;
  
  initial begin
    
    clk = 0;
    
    forever #(1) clk = ~clk;  
    
  end
  
  
  initial begin

    rom[0] = 8'b01010000;
    
    rom[1] = 8'b00000000;
    
    rom[2] = 8'b00000010;
    
    rom[3] = 8'b00001000;
    
    rom[4] = 8'b00100000;
    
  end
  
  initial begin
        
    resetn_tb = 0;
    
    #4
    
    resetn_tb = 1;

  end
  
  
  
  always @ (posedge clk) begin
    
    go_z <= go;
    
    go_zz <= go_z;
    
    valid_z <= valid;
            
    valid_zz <= valid_z;
    
    valid_zzz <= valid_zz;

    if (!resetn_tb) begin
    
      go <= 1;
      
      counter <= 0;
      
      din<= 0;
      
    end else begin 
          
      go <= 0;
      
      if (go_z && ~go  ) begin
      
        valid <= 1;
    
      end else if (counter == N_SIM_VALUES - 1) begin
      
       valid  <= 0;
      
      end
      
      if ( (go_zz & ~go_z) || (counter > 0 && counter < N_SIM_VALUES ) ) begin

        counter <= counter + 1;
        
        din <= rom[counter];
        
      end
      
      // NOTE: DUT IS READY ON NEXT CYCLE!!
      if ( valid_z) begin
        
       $display("DOUT %b", dout);
        
      end
      
      if ( valid_zzz & ~valid_zz) begin
        
        $finish;
        
      end
      
    end
    
  end
  
  TrailingZeros #(DATA_WIDTH) u0 (
    .din(din),
    .dout(dout)
  );
endmodule

