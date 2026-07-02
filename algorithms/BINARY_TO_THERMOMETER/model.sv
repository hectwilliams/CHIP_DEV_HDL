module thermometer_mux #(parameter DATA_WIDTH = 8, DECODE_WIDTH=256, ID = 1) (

  input wire [DATA_WIDTH-1: 0] din,
  
  output wire [DECODE_WIDTH - 1: 0] decoded
  
);

  assign decoded = (din == ID) ? { {(255-ID){1'b0}} , {(256 -(255-ID)){1'b1}} } : 'z;
  
endmodule 

module model (
    input [7:0] din,
    output reg [255:0] dout
);

  wire [255:0] decode_bus;
  
  genvar i;
 
  for (i = 0; i < 256; i = i + 1)  begin :AA
  
    thermometer_mux #(.ID(i)) thermometer_mux_inst (
    
      .din(din),
      
      .decoded(decode_bus)
      
    );
    
  end
  
  always @ (decode_bus) begin
    
    dout <= decode_bus;
    
  end
  
  
endmodule
