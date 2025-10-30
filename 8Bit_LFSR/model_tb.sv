module model_tb;
  
  parameter TICKS = 11;
  
  bit clk;
  
  bit resetn, resetn_z, resetn_zz;
  
  bit [7:0] din;
  
  bit [7:0] tap;
  
  bit [7:0 ] dout;
  
  bit resetn_tb;
  
  bit [5:0] counter, counter_z;
  
  bit valid, valid_z;
  
  initial begin
  
    resetn = 1;  
    
  end
  
  initial begin
    resetn_tb = 0;
    #20
    resetn_tb = 1;
  end
  
  initial begin
    forever #4 clk = ~clk;
  end
  
  
  always @ (posedge clk or negedge resetn) begin

    resetn_zz <= resetn_z;
    
    resetn_z <= resetn;
    
    counter_z <= counter;
    
    if (~resetn_tb) begin
      
      tap <= 8'he;
      
      din <= 8'h1;
      
      resetn <= 0;
      
    end else begin
      
      resetn <= 1;
      
      if (counter < TICKS) begin
		
        counter <= counter + 1;

      end else begin
		
        $finish;
        
      end
      
      if (~resetn) begin
        
        valid <= 1;
        
      end else if (counter == TICKS - 1) begin
        
        valid<= 0;
        
      end
      
      if (valid) begin
        
        $display(" DUT LFSR - step - %d dout - %h " , counter_z , dout);
        
      end
      
    end
      
  end
  
  model A0(
    .clk(clk),
    .resetn(resetn),
    .din(din),
    .tap(tap),
    .dout(dout)
  );
endmodule
