
module muxy #(parameter DATA_WIDTH =1, ID = 1) (

  input [DATA_WIDTH - 1:0] din,
  
  output [DATA_WIDTH - 1:0] dout,
     
  input [$clog2(DATA_WIDTH) : 0] select

);
  
  logic [DATA_WIDTH - 1: 0] dout_reg;
  
  always @(select) begin

    if (ID == 0) begin
    	
      dout_reg <= 0;
      
    end else begin
      
      dout_reg <= { din[DATA_WIDTH - 1 - ID:0],  din[DATA_WIDTH - 1 : (DATA_WIDTH - 1) - (ID - 1)  ] }; 
      
    end
    
  end
  
  assign dout = (select == ID) ? dout_reg  : 'z;
  
endmodule

module xor_rrot #(parameter DATA_WIDTH = 1) (

  input [DATA_WIDTH - 1:0] A,
  
  input [DATA_WIDTH - 1:0] B,
  
  input [$clog2(DATA_WIDTH): 0] SELECT,

  output [DATA_WIDTH - 1:0] out

);
  
  wire [DATA_WIDTH - 1:0]  A_XOR_b, DOUT;

  genvar i;
  
  for (i = 0; i < DATA_WIDTH; i = i + 1) begin
    
    muxy #(DATA_WIDTH, i) u (
      .din(A_XOR_b),
      .select(SELECT),
      .dout(DOUT)
      
    );
    
  end
  
  assign A_XOR_b = A ^ B;
  assign out = DOUT;
  
endmodule
