module model_tb;
  
  parameter DATA_WIDTH = 16;
  
  parameter N_SAMPLES = 8;
  
  bit [DATA_WIDTH -1 : 0] din;
  
  bit [4:0] wad1;
  
  bit [4:0] rad1, rad2;
  
  bit wen1, ren1, ren2;
  
  bit clk;
  
  bit resetn;
  
  bit [DATA_WIDTH - 1 : 0] dout1, dout2;
  
  bit collision;
  
  bit [$clog2(N_SAMPLES): 0] counter;
  
  bit go, go_z, go_zz;
  
  bit valid, valid_z, valid_zz;
  
  bit[N_SAMPLES-1: 0] reset_stream;
  
  bit[DATA_WIDTH-1: 0] din_stream[N_SAMPLES];

  bit[N_SAMPLES-1: 0] wad1_stream[N_SAMPLES];


  bit[N_SAMPLES-1: 0] rad1_stream [N_SAMPLES];
  
  bit[N_SAMPLES-1: 0] rad2_stream [N_SAMPLES];

  bit[ 0: N_SAMPLES-1] ren1_stream;

  bit[0: N_SAMPLES-1] ren2_stream;
  
  bit[0 : N_SAMPLES-1] wen1_stream;

  initial begin
    
    reset_stream = {N_SAMPLES{1'b1}};
    
    din_stream[0] = 'd0; 
        
    din_stream[1] = 'd30;

    din_stream[2] = 'd100;
    
    din_stream[3] = 'd20;

    din_stream[4] = 'd0;

    din_stream[5] = 'd40;

    din_stream[6] = 'd29;
        
    din_stream[7] = 'd0;

    
    wad1_stream[0] = 'd0;
    
    wad1_stream[1] = 'd0;
    
    wad1_stream[2] = 'd0;
    
    wad1_stream[3] = 'd1;
    
    wad1_stream[4] = 'd0;
    
    wad1_stream[5] = 'd16;
    
    wad1_stream[6] = 'd17;
    
    wad1_stream[7] = 'd0;

        
    rad1_stream[0] = 'd0;

    rad1_stream[1] = 'd0;

    rad1_stream[2] = 'd1;
    
    rad1_stream[3] = 'd0;
        
    rad1_stream[4] = 'd1;
    
    rad1_stream[5] = 'd0;

    rad1_stream[6] = 'd0;

    rad1_stream[7] = 'd16;
    
    
    rad2_stream[0] = 'd0;
        
    rad2_stream[1] = 'd0;
    
    rad2_stream[2] = 'd1;
    
    rad2_stream[3] = 'd0;
    
    rad2_stream[4] = 'd0;

    rad2_stream[5] = 'd0;

    rad2_stream[6] = 'd0;

    rad2_stream[7] = 'd17;
    
    ren1_stream = 'b0010_1001;

    ren2_stream = 'b0010_0001;

    wen1_stream = 'b0001_0110;

  end
  

                                        
  
  initial begin
    
    forever #1 clk = ~clk;
    
  end
  
  initial begin
    
    resetn <= 1;
    
  end
  
  initial begin
    
    go= 1;
    
    counter =0;
    
  end

  always @ (posedge clk) begin
    
    go <= 0;
    
    go_z <= go;
    
    go_zz <= go_z;
    
    valid_z <= valid;
    
    valid_zz <= valid_z;
    
    if ( go_z & ~go) begin
      
      valid <= 1;
      
    end else if(counter == N_SAMPLES - 1) begin
      
      valid <= 0;
      
    end
    
    if ( (go_zz) || (counter > 0 && counter < N_SAMPLES) ) begin

      counter <= counter + 1;
      
      din <= din_stream[counter];
      
      wad1 <= wad1_stream[counter];
      
      rad1 <= rad1_stream[counter];
       
      rad2 <= rad2_stream[counter];
     
      wen1 <= wen1_stream[counter];
      
      ren1 <= ren1_stream[counter]; 
            
      ren2 <= ren2_stream[counter];

    end
    
    if (valid_zz) begin
      
      $display("dout1-%d dout2-%d collision-%d", dout1, dout2, collision);
      
      
    end
    
    if (valid_zz & ~valid_z) begin
      
      $finish;
      
    end
    
  end
  
  model u0 (
    
    .clk(clk),
    
    .din(din),
    
    .wad1 (wad1),
    
    .rad1(rad1),
    
    .rad2(rad2),
    
    .wen1(wen1),
    
    .ren1(ren1),
    
    .ren2(ren2),
    
    .resetn(resetn),
    
    .dout1(dout1),
    
    .dout2(dout2),
    
    .collision(collision)
    
  );
  
endmodule;
