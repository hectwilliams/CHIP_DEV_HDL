module model (
    input [7:0] din,
    input [2:0] addr,
    input wr,
    input rd,
    input clk,
    input resetn,
    output logic [7:0] dout,
    output logic error
);

  bit [7:0] buffer [2**3] ;
  
  bit [2**3 - 1: 0] channel_loaded ;
  
  always @ (posedge clk or negedge resetn) begin
    
    if (!resetn) begin
      
      error <= 0;
      
      dout <= 0;
      
      channel_loaded <= 0;
      
    end else if (wr & rd) begin
      
      error <= 1;
      
      dout <= 0;
      
    end else if (wr) begin
      
      buffer[addr] <= din;
      
      channel_loaded[addr] <= 1;
      
      error <= 0;
      
    end else if (rd ) begin 
      
      if (channel_loaded[addr]) begin
        
        dout <= buffer[addr];
      
        error <= 0;
        
      end else begin
        
        error <= 1;
        
      end
          
    end else if (~rd | ~wr ) begin 
	
      error <= 0;
      
    end
    
  end
  
endmodule
