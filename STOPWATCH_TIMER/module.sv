`timescale 1ns/1ps
module model #(parameter
  DATA_WIDTH = 16,
  MAX = 99
) (
    input clk,
    input reset, start, stop,
    output logic [DATA_WIDTH-1:0] count
);
  
  logic [DATA_WIDTH -1 : 0] counter_reg;
  bit paused, running, start_z, stop_z, reset_z;

  always @ (posedge clk ) begin

    reset_z <= reset;

    stop_z <= stop;

    start_z <= start;
    
    if (~reset_z & reset  ) begin
      count <= 0;
		
      running <= 0;
      
      paused <= 0;

    end else if (  (~stop_z & stop) || (paused & ~start)  )  begin 

      paused <= 1;
		
      running <= 0;
      
    end else if (   (~start_z & start) || running  )  begin 

      paused <= 0;
		
      running <= 1;
      
      count <= count + 1;
      
    end
  end
   
  
endmodule
