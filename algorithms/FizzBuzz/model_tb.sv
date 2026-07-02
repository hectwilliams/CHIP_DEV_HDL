module model_tb;
  
  parameter CYCLES = 30;
    
  bit resetn, resetn_tb;
  
  bit [CYCLES -1 : 0] rbit_stream;
  
  bit [$clog2(CYCLES) : 0] counter, counter_z;
  
  bit fizz;
  
  bit buzz;
  
  bit fizzbuzz;
  
  bit clk;
  
  bit valid, valid_z, valid_zz, valid_zzz;
  
  bit go, go_z, go_zz;
  
  initial begin
    
	clk = 0;
    
    forever #1 clk = ~clk;    
    
  end
	
  initial begin
    
    resetn_tb = 0;
    
    #4
    
    resetn_tb = 1;
    
  end
  
  initial begin
    
    resetn <= 1;
    
  end
  
  always @ (posedge clk or negedge resetn_tb) begin
    
    valid_z <= valid;
    
    counter_z <= counter;
    
    go_z <= go;
    
    go_zz <= go_z;
    
    if (!resetn_tb) begin

      counter <= 0;   
      
      valid <= 0;
      
      go <= 1;
      
      resetn <= 0;
      
    end else begin
      
      resetn <= 1;
      
      go <= 0;
      
      if (counter == CYCLES - 1) begin

        valid <= 0;

      end else if (go_z) begin
        
        valid <= 1;
        
      end
 
      if ( go_zz || ( counter > 0 &&  counter < CYCLES ) ) begin
        
        counter <= counter + 1;
        
      end
      
      if ( valid) begin
        
        $display( "Time %d  fiss - %d. buzz - %d. fizzbuzz  %d", counter, fizz, buzz, fizzbuzz);
        
      end
      
      if (valid_z & ~valid) begin
        
        $finish;
        
      end
      
    end
    
  end

  model #(.MAX_CYCLES(30)) u0 (
    .clk(clk),
    .resetn(resetn),
    .fizz(fizz),
    .buzz(buzz),
    .fizzbuzz(fizzbuzz)
   
  );
endmodule
