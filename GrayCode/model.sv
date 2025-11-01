// Code your design here
`timescale 1ns/1ps 

module submodule_graycode #(parameter DATA_WIDTH = 1, ARRAY_SIZE = 1, ID) (input clk, input resetn, output out);
  
  parameter N_ACTIVE_BITS = ARRAY_SIZE / 2;
  
  parameter INIT_ARRAY = {N_ACTIVE_BITS{1'b1}};
  
  bit [ARRAY_SIZE-1:0] array;
  
  logic [31:0] counter;
  
  typedef enum {IDLE, ROTATE} fsm_state_t;
  
  fsm_state_t state;
  
  always @ (posedge clk or negedge resetn) begin
    
    if (!resetn) begin
      
      state <= IDLE; 
      
      array <= INIT_ARRAY;
      
    end else begin
      
      case (state)
        
        IDLE: begin
          
          if ( 2**ID == counter + 1 ) begin
            
            state <= ROTATE;
            
          end
          
        end
        
        ROTATE: begin
          
      		array <= {array[0], array[ ARRAY_SIZE - 1 : 1] };
          
        end
         
        default: state <= IDLE; 

      endcase

    end
  
  end
  
  always @ (posedge clk or negedge resetn) begin 
    
    if ( !resetn  ) begin
      
      counter <= 0;
      
    end else begin

      counter <= counter + 1; 
      
    end
    
  end
  
  assign out = array[0];
  
endmodule

module top_graycode #(parameter
  DATA_WIDTH = 4
) (
  input clk,
  input resetn,
  output logic [DATA_WIDTH-1:0] out
);

  genvar i;
  
  generate 
    
    for ( i = 0; i < DATA_WIDTH ; i = i + 1) begin
      
      submodule_graycode  #(DATA_WIDTH, 2**(i + 1)  * 2, i ) submodule_graycode_inst(
        .clk(clk),
        .resetn(resetn),
        .out(out[i])
      );
      
    end
    
  endgenerate 

endmodule
