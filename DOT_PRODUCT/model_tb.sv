module model_tb;
  
  parameter DATA_WIDTH = 8;
  
  parameter N_SAMPLES = 18;
  
  bit [DATA_WIDTH -1 : 0] din;
  
  bit clk, resetn, resetn_tb;
  
  bit [17: 0] dout;
  
  bit run;
  
  bit [DATA_WIDTH -1 : 0] din_strean [N_SAMPLES];
    
  bit [0 : N_SAMPLES - 1 ] reset_strean;
  
  bit go, go_z, go_zz;
  
  bit valid, valid_z, valid_zz;
  
  bit [$clog2(N_SAMPLES) : 0 ] counter;
  
  initial begin
 
    forever #1 clk = ~clk;
    
  end
  
  initial begin
    
    resetn_tb = 0;
    
    #4
    
    resetn_tb = 1;
    
  end
  
  initial begin
	
    for (int i = 0; i < N_SAMPLES; i = i + 1) begin
          

    end

    reset_strean = 'b000001111111111111;
    
          
    din_strean[0] = 0;

    din_strean[1] = 0;
   
    din_strean[2] = 0;
    
    din_strean[3] = 0;
    
    din_strean[4] = 0;
    
    din_strean[5] = 1;

    din_strean[6] = 2;
    
    din_strean[7] = 3;

    din_strean[8] = 4;
    
    din_strean[9] = 5;

    din_strean[10] = 6;

    din_strean[11] = 7;

    din_strean[12] = 8;
    
    din_strean[13] = 9;
    
    din_strean[14] = 10;
   
    din_strean[15] = 11;

    din_strean[16] = 12;
    
    din_strean[17] = 13;

    
    
    
    
    
    

  end
  
  
  always @ (posedge clk  or negedge resetn_tb) begin
	
    go_z <= go;
    
    go_zz <= go_z;
    
    valid_z <= valid;
    
    valid_zz <= valid_z;
    
    if (~resetn_tb) begin
      
      counter <= 0;
      
      resetn <= 1;
      
      go <= 1;
      
    end else begin
      
      go <= 0;

      if (go_z & ~go) begin
        
        valid <= 1;
        
      end else if (counter == N_SAMPLES - 1) begin

        valid <= 0;

      end
      
      if ( (go_zz & ~go_z) || (counter > 0 && counter < N_SAMPLES ) ) begin
					
        counter <= counter + 1;
           
        din <= din_strean[counter];
        
        resetn <= reset_strean[counter];
                
        //$display("rst - %d. din - %d  counter %d", reset_strean[counter], din_strean[counter], counter);

      end
      
      if (valid_zz) begin
        
             
        $display("dout - %h. run - %d  ",  dout, run );

        
        
      end
      
      if (valid_zz & ~valid_z) begin
      
        $finish;
        
      end
      
    end
    
    
  end
  
  model u0 (
 
    .din (din),
    
    .clk(clk),
    
    .resetn(resetn),
    
    .dout(dout), 
    
    .run(run)
    
  );
  
endmodule;
