module fibonacci #(parameter
  DATA_WIDTH=32
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);

  logic [DATA_WIDTH - 1 : 0] rom [1:0];
  
  always @ (posedge clk or negedge resetn) begin
  
    if ( !resetn ) begin
      
      out <= 1;
      
      rom[0]  <= 1 ;
      
      rom[1]  <= 0 ;

    end else if (rom[1] == 0 ) begin
      
      out <= rom[0];
      
      rom[1] <= 1;
      
    end else begin 
      
      out <= rom[0] + rom[1];
      
      rom[1] <= rom[0] + rom[1];
      
      rom[0] <= rom[1];
      
    end
    
  end
  
endmodule
