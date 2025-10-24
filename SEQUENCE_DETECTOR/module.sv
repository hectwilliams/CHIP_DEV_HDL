module model #(parameter WIDTH=4, CODE=4'b1010)(
  input clk,
  input resetn,
  input din,
  output logic dout
);

  logic [WIDTH-1: 0] shift_buffer;
  
  bit [ $clog2(WIDTH) : 0 ] counter;
  
  bit din_z, prev_edge;
  
  always @ (posedge clk or negedge resetn) begin
	 
    din_z <= din;
    
    if(!resetn) begin

      dout <= 0;
      
      shift_buffer <= 0;
      
      prev_edge <= 0;
      
      din_z <= 0;
      
      counter <= 0;
      
    end else begin
      
      if (counter < WIDTH) begin
        
        counter <= counter + 1 ;
        
      end
      
      if (din & ~din_z) begin
        
        // rising edge 
        
        prev_edge <= 1;
        
        shift_buffer <= {shift_buffer[2:0], 1'b1};
        
      end else if (~din & din_z) begin
        
        // falling edge 
        
        prev_edge <= 0;
        
        shift_buffer <= {shift_buffer[2:0], 1'b0};
        
      end else  begin
        
        shift_buffer <= {shift_buffer[2:0], prev_edge};
      
      end
    
    	
      // test 
      
      if (counter >= WIDTH - 1) begin
       
        if (  (din & ~din_z)  &&  ({shift_buffer[2:0], 1'b1} == CODE) ) begin
        
          dout <= 1;
          
        end else if  ( (~din & din_z) && ({shift_buffer[2:0], 1'b0} == CODE)  ) begin

          dout <= 1;

        end else if ( {shift_buffer[2:0], prev_edge} == CODE ) begin
          
          dout <= 1;
          
        end else begin

          dout <= 0;

        end
        

      end
  end
      
    
  end
  
endmodule
