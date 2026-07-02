module model (
  input clk,
  input resetn,
  input [4:0] init,
  input din,
  output logic seen
);
  
  parameter D_WIDTH = 5;
  
  bit [D_WIDTH-1: 0] buffer;
  
  bit [$clog2(D_WIDTH): 0] counter;
  
  always @ (posedge clk or negedge resetn) begin
    
    if (!resetn) begin
      
      counter <= 0;
      
      buffer <= 0;
      
      seen <= 0;

    end else begin
      
      buffer <= (buffer << 1) | din;
      
      if ( ((buffer << 1) | din ) == init) begin
        
        seen <= 1;
        
      end else begin
        
        seen <= 0;
        
      end
      
    end
    
  end
  
endmodule
