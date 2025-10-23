
module TrailingZeros #(parameter
  DATA_WIDTH = 32
) (
  input  [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);

  logic [0:$clog2(DATA_WIDTH)] n_ones_count; // counter
  
  logic rdy; // output event
  
  always @ (din ) begin
	
    n_ones_count = 0; 
    
    rdy = 0; 
    
    if (din == 0 || din[DATA_WIDTH-1 ] ) begin
      
      data_tmp = 0;
      
      rdy = 1;

    end else begin
      
      for ( int i = DATA_WIDTH - 1; i > 0; i = i - 1 ) begin

        if ( din[i] == 1) begin
          
          rdy = 1;
          
        end else begin 
          
          n_ones_count =  n_ones_count  + 1;

        end
      
      end
  
    end
    
  end
  
  always @ (rdy) begin
    
    dout = n_ones_count;
    
  end
  
endmodule
