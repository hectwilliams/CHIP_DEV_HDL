module model #(parameter
    FIZZ=3,
    BUZZ=5,
    MAX_CYCLES=100
) (
    input clk,
    input resetn,
    output logic fizz,
    output logic buzz,
    output logic fizzbuzz
);

  bit [$clog2(MAX_CYCLES): 0] fizz_counter, buzz_counter;
  
  always @ (posedge clk or negedge resetn) begin
    
    if (!resetn) begin
      
      fizz <= 1;
      
      buzz <= 1;
      
      fizzbuzz <= 1;
      
      buzz_counter <= 0;
      
      fizz_counter <= 0;
      
    end else begin
      
      if ( (buzz_counter + 1 )== BUZZ  ) begin
        
        buzz_counter <= 0;
      
      end else begin
        
        buzz_counter <= buzz_counter + 1;
  
      end
      
      if ( (fizz_counter+ 1) == FIZZ ) begin
        
        fizz_counter <= 0;
      
      end else begin
        
        fizz_counter <= fizz_counter + 1;

      end
      
      fizz <=  (fizz_counter + 1) == FIZZ;

      buzz <= (buzz_counter + 1) == BUZZ;

      fizzbuzz <= ((buzz_counter + 1) == BUZZ) & ((fizz_counter + 1) == FIZZ);
      
    end
          
  end
  
endmodule
