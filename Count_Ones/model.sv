
module adderz #(parameter DATA_WIDTH = 1, ID = 1) (
	
  input din,
  	
  input  [$clog2(DATA_WIDTH) : 0]  prev,
  
  output logic [$clog2(DATA_WIDTH) : 0] out
  
);

  always @ (din or prev or ID or DATA_WIDTH) begin
    
    out = din + prev;

  end
  
endmodule

module model #(parameter
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] din,
  output logic [$clog2(DATA_WIDTH):0] dout
);
  
  parameter MAX_WIDTH = $clog2(DATA_WIDTH);
  
  parameter logic [ MAX_WIDTH : 0] ZERO = 0; 
  
  wire [ MAX_WIDTH : 0] wirey[DATA_WIDTH];

  genvar i;
  
  generate 
  
    for ( i = 0; i < DATA_WIDTH; i = i + 1) begin
          
      if (i == 0) begin
    
        adderz #(DATA_WIDTH, 0) adderz_inst(
          .din(din[0]),
          .prev( ZERO ),
          .out(wirey[0])
        ); 
   
      end else begin 
        
        adderz #(DATA_WIDTH, i) adderz_inst(
          .din(din[i]),
          .prev( wirey[i - 1] ),
          .out(wirey[i])
        ); 
      
      end
      
    end
    
  endgenerate 
  
  	
  assign dout = wirey[DATA_WIDTH - 1];
    
  
endmodule
