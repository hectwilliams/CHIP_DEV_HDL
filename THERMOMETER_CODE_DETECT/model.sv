module model #(parameter
    DATA_WIDTH = 8
) (
  
  input [DATA_WIDTH-1:0] codeIn,
    
  output reg isThermometer
  
);

  parameter [1:0] align = 2;
  
  
  
  always @ (codeIn) begin
  
    if (  ( ( (codeIn + (align - 1)) & ~( align - 1 ) ) ^ codeIn ) ==  ( codeIn * 2 + 1 ) ) begin
      
      isThermometer = 1;
      
    end else begin
      
      isThermometer = 0;
      
    end
    
  end
  
endmodule
