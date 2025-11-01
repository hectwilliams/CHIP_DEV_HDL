module tb;
  
  parameter DATA_WIDTH = 3; 
  
  logic  [ DATA_WIDTH -  1 : 0] gray;
  
  logic  [ DATA_WIDTH -  1 : 0] bin;
	logic test;
  
  initial begin 
    gray = 3'b111;
  end
  
  model #(DATA_WIDTH) u0 (
    .gray(gray),
    .bin(bin)
  );
  
  always @ (bin) begin
    $display(" gray code %b  MONITOR - %d", gray , bin);
  end
endmodule
