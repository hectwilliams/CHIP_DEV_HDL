module tb;
  
  parameter DATA_WIDTH_STREAM = 32;
  
  parameter logic[0 : DATA_WIDTH_STREAM - 1] bit_stream = 32'b1010_1111_0101_0101_1010_1111_0000_0000;
  
  logic clk, rst, din , dout;

  bit [$clog2(DATA_WIDTH_STREAM) + 1:0] counter, counter_z;
  
  bit valid, valid_z, valid_zz, valid_zzz, go, go_z;

  initial begin

    clk = 0;
    
    forever #(2) clk = ~clk;
  
  end
  
  initial begin
  
    rst = 0;
    
    #4 rst = 1;
  
  end
  
  
  always @ (posedge clk or negedge rst) begin
    
    valid_z <= valid;
    
    valid_zz <= valid_z;

    valid_zzz <= valid_zz;
    
    counter_z <= counter;

    go_z <= go;
    
    if (!rst) begin
    
      valid <= 0;
      
      counter <= 0;
      
      go <= 1;
      
      din <= 0;
    
    end else begin
	
      go <= 0;
      
      
      if ((go_z & ~go) || (counter > 0 && counter <= DATA_WIDTH_STREAM ) )  begin
      
        counter <= counter + 1;
        
        din <= bit_stream[counter]; 

      end
	
      if (counter == DATA_WIDTH_STREAM - 1 ) begin

     	valid <= 0;
        
      end else if  (counter < DATA_WIDTH_STREAM  ) begin
        
        valid <= 1;
        
      end 
      
      if (valid_zzz & ~valid_zz) begin
        
		$finish;
        
      end
      
      
      if (valid || valid_z) begin
        $display("[%d] in - %d.   out - %d   rst - %d", counter_z, din, dout, rst);
      end
     
      
    end
    
  end
  
  
  model  u0( 
    .clk(clk), 
    .resetn(rst),
    .din(din), 
    .dout(dout)  
  );
endmodule
