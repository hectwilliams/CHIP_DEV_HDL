module model #(parameter 
    DATA_WIDTH = 16
) (
    input [DATA_WIDTH-1:0] din,
    input [4:0] wad1,
    input [4:0] rad1, rad2,
    input wen1, ren1, ren2,
    input clk,
    input resetn,
    output logic [DATA_WIDTH-1:0] dout1, dout2,
    output logic collision
);

  bit [2**5 - 1 : 0] written;
  
  bit [DATA_WIDTH-1: 0] buffer[2**5];
  

  always @ (posedge clk or negedge resetn) begin
  
    if (~resetn) begin
      
      written <= 0;
      
      collision <= 0;
      
      dout1 <= 0;
      
      dout2 <= 0;
      
    end else begin
      
      // collision case
      
      if ( ( wen1 & ren1 & (rad1 == wad1) ) || ( wen1 & ren2 & (rad2 == wad1) ) || ( ren1 & ren2 & (rad1 == rad2) ) ) begin
        
        collision <= 1;
        
      end else begin

        collision <= 0;

        // concurrent or exclusive cases

        if (wen1) begin

          buffer[wad1] <= din;
          
          written[wad1] <= 1;
          
        end
        
        if (ren1 & written[rad1] ) begin
          
          dout1 <= buffer[rad1];
          
        end
        
        if (ren2 & written[rad2] ) begin
          
          dout2 <= buffer[rad2];
          
        end
        
      end
      
    end
    
  end
  
endmodule
