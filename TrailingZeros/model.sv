/* find unique channel with trailing zeros */

module one_hot_detect #(parameter DATA_WIDTH = 1, ID= 1) (

  input [DATA_WIDTH  : 0] din,
  
  output wire active
);
  
  parameter [DATA_WIDTH  : 0] VALUE = (2 ** ID) - 1;
    
  parameter ADD_PRECISION_WIDTH = DATA_WIDTH + 1;
  
  assign active =  (din[ID : 0] == 0) ?  0 : (VALUE & din) == 0;
    
endmodule 


/* adder train decodes one_hot enabled channel */

module adder_train #(parameter DATA_WIDTH=1, ID=1) (

  input logic en,

  input logic [ $clog2(DATA_WIDTH)  : 0] din,
  
  output wire [$clog2(DATA_WIDTH)  : 0] dout
  
);

  assign dout = en ? din + ID : din; 
  
endmodule
          

/* Top Level */

module TrailingZeros #(parameter
                       
  DATA_WIDTH = 32
                       
) (
  
  input  [DATA_WIDTH-1:0] din,
  
  output logic [$clog2(DATA_WIDTH):0] dout
  
);
  
  wire  [DATA_WIDTH-1:0] ones_bus;
  
  wire  [$clog2(DATA_WIDTH) :0] adder_bus [DATA_WIDTH];

  genvar i;
  
  for ( i = 0; i < DATA_WIDTH; i=i+1) begin
    
  one_hot_detect #(DATA_WIDTH, i) u0(

    .din ({1'b0, din}),
    
    .active (ones_bus[i])
  );
  
  end
  
  for ( i = 0; i < DATA_WIDTH; i++) begin
  
    if ( i == 0) begin
    
      adder_train  #(DATA_WIDTH, i) u2(
    
        .en(ones_bus[i]),
        
        .din({4'b0}),
        
        .dout(adder_bus[i])
        
        );
       
    end else begin
      
       adder_train  #(DATA_WIDTH, i) u2(
    
         .en(ones_bus[i]),
        
         .din(adder_bus[i- 1]),
        
         .dout(adder_bus[i])
      
        );
      
    end
 
  end
  
  always @ (adder_bus[DATA_WIDTH-1]) begin
    
    if ( din != 0 || din[0] != 1 ) begin
      
      dout = adder_bus[DATA_WIDTH-1];
    
    end
    
  end
  
endmodule
