module model_tb;

  parameter ARRAY_SIZE = 18;
  
  bit [ARRAY_SIZE-1:0] div2_capture;

  bit [ARRAY_SIZE-1:0] div4_capture;

  bit [ARRAY_SIZE-1:0] div6_capture;
    
  bit [ARRAY_SIZE-1:0] resetn_seq;

  bit div2, div4, div6;
  
  bit valid, valid_z, valid_zz, valid_zzz;
  
  bit resetn;
  
  bit resetn_tb;

  bit clk;
  
  bit go, go_z, go_zz;
  
  bit [$clog2(ARRAY_SIZE): 0] counter, write_counter;
  
  function void msg_debug ( bit [ARRAY_SIZE-1: 0] div2_array,  bit [ARRAY_SIZE-1: 0] div4_array,  bit [ARRAY_SIZE-1: 0] div6_array) ;

    for ( int i = 0; i < ARRAY_SIZE; i = i + 1) begin
     
      $write("%d", div2_array[i]);
      
    end
    
    $display();
     
    for ( int i = 0; i < ARRAY_SIZE; i = i + 1) begin
     
      $write("%d", div4_array[i]);
      
    end

    $display();
   
    for ( int i = 0; i < ARRAY_SIZE; i = i + 1) begin
     
      $write("%d", div6_array[i]);
      
    end
    
    $display();
      
  endfunction
    
  initial begin
    
    forever #(1) clk = ~clk;
    
  end
  
  initial begin
    resetn_tb = 0;
    
    #4
    
    resetn_tb = 1;
  end
  
  initial begin        
    resetn_seq='b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111101111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
  end
  
  always @ (posedge clk or negedge resetn_tb) begin
    go_z <= go;
    go_zz <= go_z;
    valid_z <= valid;
    valid_zz <= valid_z;
	valid_zzz <= valid_zz;
    
    if (!resetn_tb) begin
		
      counter <= 0;
      
      write_counter <= 0;
      
      resetn <= 0;
      
      go <= 1;
      
    end else begin
      
      go <= 0; 
      
      if (counter == ARRAY_SIZE -1) begin 
        
        valid <= 0;
      
      end else if (go_z) begin

        valid <= 1;
        
      end
      
      if (go_zz || (counter > 0 || counter <ARRAY_SIZE)) begin
        
        counter <= counter + 1;
        
        resetn <= resetn_seq[counter]; 
        
        end else begin
        
        resetn <= 1;
        
      end
      
      if (valid_z ) begin

        div2_capture[write_counter] <= div2;
                
        div4_capture[write_counter] <= div4;
        
        div6_capture[write_counter] <= div6;
        
        write_counter <= write_counter + 1;
        
      end
		
      if (valid_zzz & ~valid_zz) begin
        
        msg_debug(div2_capture, div4_capture, div6_capture);
        
        $finish;
        
      end
      
    end
      
    
  end
    
  model u0 (
    
    .clk(clk),
    
    .resetn(resetn),
    
    .div2(div2),
    
    .div4(div4),
    
    .div6(div6)
    
  );
  
endmodule
