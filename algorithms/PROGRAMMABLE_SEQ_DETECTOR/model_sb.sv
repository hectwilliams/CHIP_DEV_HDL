module model_tb;
  
  parameter D_WIDTH = 5;

  parameter BIT_STREAM_SIZE = 10;
  
  parameter [D_WIDTH - 1: 0] TARGET1 = 'b11011;
  
  parameter [D_WIDTH - 1: 0] TARGET2 = 'b11110;
  
  bit clk, resetn, reset_tb, din , seen;
  
  bit [D_WIDTH - 1: 0] init, buffer, buffer_z;
  
  bit [$clog2(BIT_STREAM_SIZE): 0] counter;
  
  bit [ 0 :  BIT_STREAM_SIZE- 1 ] bitstream = 'b1011111011;
    
  bit [ 0 : BIT_STREAM_SIZE- 1 ] rbitstream = 'b1011111111;

  bit valid, valid_z, valid_zz, valid_zzz;
  
  bit [D_WIDTH - 1: 0] targets [BIT_STREAM_SIZE];
  
  bit go, go_z, go_zz;
  
  bit din_z;
  
  initial begin 
    clk = 0;
    forever #1 clk = ~clk;
    
  end
  
  initial begin 
    
    reset_tb = 0;
    
    resetn = 1;
    
    #4
    
    reset_tb = 1;
    
  end
  
  initial begin
    
    $display("TARGETS [%b]  [%b] ", TARGET1, TARGET2);
    
    for ( int i = 0; i < BIT_STREAM_SIZE; i= i + 1) begin
    
      if (i == 0) begin
      
        targets[i] =  TARGET1;
        
      end else begin
    
        targets[i] = TARGET2;
        
      end
      
    end
    
  end
  
  always @ (posedge clk or negedge reset_tb ) begin
    
    go_zz <= go_z;
    
    go_z <= go;
    
    valid_z  <= valid;
    
    valid_zz <= valid_z;
    
    valid_zzz <= valid_zz;
    
    buffer_z <= buffer;
    
    din_z <= din;
    
    if (!reset_tb) begin
    
      resetn <= 0;

      counter <= 0;
    
      go <= 1;
      
    end else begin
    
      go <= 0;
    
      if (counter == BIT_STREAM_SIZE - 1 ) begin

        valid <= 0;
          
      end if (~go & go_z) begin
        
        valid <= 1;
        
      end
    
      if ( (go_zz & ~go_z) || (counter > 0 && counter < BIT_STREAM_SIZE) ) begin
        
        counter <= counter + 1;
        
        resetn <= rbitstream[counter];
        
        din <= bitstream[counter];
        
        init <= targets[counter];
        
      end 
      
      if (valid_z) begin

        // accumulator

        buffer <= (buffer << 1) | din;
        
      end
      
      if ( valid_zz ) begin
                
        // response   

        $display("Input %b Response %b", buffer, seen);
        
        
      end
      
      if (valid_zzz & ~valid_zz) begin
        
        $finish;
        
      end
        
    end
    
  end
    
    
  
  model u0 (
    .clk(clk),
    .resetn(resetn),
    .init(init),
    .din(din),
    .seen(seen)
  );
  
  
  
endmodule;
