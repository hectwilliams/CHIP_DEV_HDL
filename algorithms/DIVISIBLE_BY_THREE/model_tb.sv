module module_tb;

  parameter BIT_STREAM_WIDTH = 32;
  
  bit [0 : BIT_STREAM_WIDTH - 1 ] seq ;
  
  bit [0 : BIT_STREAM_WIDTH - 1 ] rseq;
  
  bit clk;
  
  bit rst, rst_z;
  
  bit dout;
  
  bit din, din_z;
  
  bit go, go_z, valid, valid_dut, valid_response, valid_response_z, valid_response_zz;
  
  bit [$clog2(BIT_STREAM_WIDTH) : 0] counter ;
  
  bit reset_tb;
  
  bit[BIT_STREAM_WIDTH-1:0] rand_value;
  
  bit rand_bit;
  
  real threshold_factor, byte_value , normal_value;
  
  typedef enum {IDLE, RUN} fsm_t;
  
  fsm_t state;
  
  initial begin

    reset_tb = 0;
    
    #4 reset_tb = 1;

  end
  
  initial begin
    
    clk = 0;
    
    forever #(1) clk = ~clk;

  end
  
  initial begin
    
    threshold_factor = 0.2;
    
    for (int i = 0; i < BIT_STREAM_WIDTH; i = i + 1) begin
      
      rand_value = $urandom();
      
      normal_value = real'(rand_value) / 2**BIT_STREAM_WIDTH;
      
      seq[i]  = rand_value & 1'b1;
      
      if (normal_value < threshold_factor) begin
        
        rseq[i] = 0;
        
      end else begin
        
        rseq[i] = 1;
        
      end
      
    end
    
    //rseq = 12'b1111_0111_1111;
       
    //seq =  12'b1110_1001_1000;
  end
  
  always @ (posedge clk or negedge reset_tb) begin
          
    valid_dut <= valid;
    
    valid_response <= valid_dut;
    
    valid_response_z <= valid_response;
    
    valid_response_zz <= valid_response_z;
    
    din_z <= din;
    
    rst_z <= rst;
      
    go_z <= go;

    if (!reset_tb) begin
		
      valid <= 0; 
      
      go <= 1;

      counter <= 0;
      
      
    end else begin
      
      go <= 0;

      if ( counter == BIT_STREAM_WIDTH - 1  ) begin
	 
        valid <= 0;
        
      end else if (go_z) begin

        valid <= 1;
        
      end
      
      if (valid) begin
        
        counter <= counter + 1;
        
        rst <= rseq[counter];

        din <= seq[counter];

      end
      
   //   if (valid_response || valid_response_z) begin
        
        //$display("prev din [ %d ] prev rst [ %d ] next out [ %d ] " , din_z, rst_z, dout);
        
   //   end
      
      if ((valid_response_zz & ~valid_response_z)  ) begin
        
        $finish;
        
      end
    
    end
 
  end
  
  model #(BIT_STREAM_WIDTH) u0(
	
    .clk(clk),
    
    .resetn(rst),
    
    .din(din),
    
    .dout(dout)
    
  );
    

endmodule
