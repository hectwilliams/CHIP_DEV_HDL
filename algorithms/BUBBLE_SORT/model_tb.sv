module model_tb;
  

  parameter DEPTH = 4;
  parameter BITWIDTH = 3;
  
  bit sortit;
  
  bit clk;
  
  bit resetn, resetn_tb;
  
  bit [DEPTH*BITWIDTH:0] dout;
  
  bit [BITWIDTH-1:0] din;
  
  bit resetn_z, resetn_zz,resetn_zzz ;
  
  bit [0:11] sortit_stream = 12'b000000111111;

  bit [0:11]  resetn_stream = 12'b000111111111;
  
  bit [BITWIDTH - 1 : 0] data_in_stream [12];
  
  bit [$clog2(12): 0] counter;
  
  bit go, go_z, go_zz;
  
  bit valid, valid_z, valid_zz;
  
  bit [BITWIDTH - 1:0] din_z;
  
  initial begin
    
    data_in_stream[0] = 'h0;

    data_in_stream[1] = 'h0;

    data_in_stream[2] = 'h0;

    data_in_stream[3] = 'h2;

    data_in_stream[4] = 'h3;

    data_in_stream[5] = 'h1;

    data_in_stream[6] = 'h4;

    data_in_stream[7] = 'h5;

    data_in_stream[8] = 'h7;
    
    data_in_stream[9] = 'h7;

    data_in_stream[10] = 'h7;
    
    data_in_stream[11] = 'h7;

  end

  initial begin
    resetn_tb = 0;
    
    #10
    
    resetn_tb = 1;
  end
  
  initial begin
    resetn = 1;
  end
  
  initial begin
    forever #1 clk = ~clk;
  end
  
  initial begin
  
    din  = 'd5;
    
  end
  
  always @ ( posedge clk or negedge resetn_tb) begin
    
    go_z <= go;

    go_zz <= go_z;
	
    valid_z <= valid;
    
    valid_zz <= valid_z;
    
    din_z <= din;
    
    if (~resetn_tb) begin
      
      go <= 1;
      
      counter <= 0;
      
      valid <= 0;
      
    end else begin
      
      go <= 0;
      
      if ( go_z & ~go ) begin
                
        valid <= 1;
        
      end else if (counter == 11) begin
        
        valid <= 0;
        
      end
      
      if ( (go_zz & ~go_z) || (counter > 0 && counter < 12) ) begin

        counter <= counter + 1;
        
        sortit <= sortit_stream[counter];
        
        resetn <= resetn_stream[counter];
        
        din <= data_in_stream[counter];
        
      end
      
      if (valid_zz) begin
        
        $display("DOUT: h%H prev_in - %h", dout, din);
        
      end
      
      if (valid_zz & ~valid_z ) begin
      
        $finish;
        
      end
      
    end
    
  
  end
  
  model #(.BITWIDTH(BITWIDTH), .DEPTH(DEPTH) ) model_inst (
  
    .clk(clk),
    
    .resetn(resetn),
    
    .dout (dout),
    
    .sortit(sortit) ,
    
    .din(din) 
  );
  
endmodule;
