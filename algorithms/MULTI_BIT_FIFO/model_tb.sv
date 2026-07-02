module model_tb;
  
  parameter DATA_WIDTH = 8;
  
  parameter N_SAMPLES = 7;
  
  bit clk, resetn, resetn_tb,  full, empty;
  
  bit [DATA_WIDTH-1: 0] dout, din, din_z;
  
  bit wr, wr_z;
  
  bit [DATA_WIDTH-1: 0] data_in [N_SAMPLES - 1: 0];
  
  bit [DATA_WIDTH-1: 0] wr_data ;

  bit valid, valid_z, valid_zz;
  
  bit go, go_z, go_zz;
  
  bit [10: 0] counter;

  
  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end
  
  initial begin
    
    data_in[0] = 'd0;
    
    data_in[1] = 'd5;

    data_in[2] = 'd3;

    data_in[3] = 'd6;

    data_in[4] = 'd6;
    

        
    wr_data[0] = 0;

    wr_data[1] = 1;

    wr_data[2] = 1;

    wr_data[3] = 1;

    wr_data[4] = 1;

  end
  
  initial begin
    
    resetn_tb = 0;
      
    #10    

    resetn_tb = 1;
    
  end
  
  initial begin
        
    resetn = 0;
      
    #4    

    resetn = 1;
    
  end
  
  initial begin
    
    counter = 0;
    
  end
  
  always @ (posedge clk or negedge resetn_tb) begin
    
    go_z <= go;
    
    go_zz <= go_z;
    
    valid_z <= valid;
    
    valid_zz <= valid_z;
    
    wr_z <= wr;
    
    din_z <= din;
    
    if (~resetn_tb) begin
      
      counter <= 0;
      
      go <= 1;
      
    end else begin
      
      go <= 0;
      
      if (go_z & ~go ) begin
        
        valid <= 1;
      
      end else if(counter == N_SAMPLES - 1) begin
        valid <= 0;
        
      end
      
      if ( (go_zz & ~go_z) || (counter > 0 && counter < N_SAMPLES ) ) begin
        
        counter <= counter + 1;
        
        wr <= wr_data[counter];
        
        din <= data_in[counter];
        
//       $display(counter, ". " , wr_data[counter], "  ", data_in[counter]);
        
      end
      
      if (valid_zz) begin
        
        $display("in - %d wr - %d empty %d full %d. dout %d", din_z, wr_z, empty, full, dout);  
        
      end
      
      if (valid_zz & ~valid_z ) begin
        
        $finish;
        
      end
      
    end
    
  end
	

  model #( DATA_WIDTH) u0 (
  	
    .clk(clk),
    
    .resetn(resetn),
    
    .din(din), 
    
    .wr(wr), 
    
    .dout (dout),
    
    .full (full),
    
    .empty(empty) 
    
  );
  
endmodule
