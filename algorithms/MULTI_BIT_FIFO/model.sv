module model #(parameter
    DATA_WIDTH=8
) (
    input clk,
    input resetn,
    input [DATA_WIDTH-1:0] din,
    input wr,
    output logic [DATA_WIDTH-1:0] dout,
    output logic full,
    output logic empty
);

  parameter N_ENTRIES = 2;
  
  bit [DATA_WIDTH - 1: 0] buffer [0: N_ENTRIES - 1];
  
  bit [$clog2(N_ENTRIES):0] index; 
  
  typedef enum {EMPTY, INTERMEDIATE, FULL} fsm_t;
  
  fsm_t state;
  
  always @ (posedge clk or negedge resetn) begin

    state <= EMPTY;
    
    if (!resetn) begin
      
      state <= EMPTY;
                
      dout <= 0;

      full <= 0;
          
      empty <= 1;
      
      index <= N_ENTRIES - 1 ;  // ( = 1 )
               

    end else begin
      
      case (state)

        EMPTY: begin

          if (wr) begin
          
            dout <= din; // first write 
            
            state <= INTERMEDIATE;
            
            index <= index - 1;
            
            empty <= 0;
          
          end else begin
            
            dout <= 0;
            
          end
	
        end

        INTERMEDIATE: begin

          if (wr) begin

            if (index == 0) begin

              state <= FULL;

              full <= 1;

            end else  begin

              index <= index - 1;

            end

            buffer[index] <= din;

          end

        end

        FULL: begin

          if (wr) begin
            
            dout <= buffer[N_ENTRIES - 1 - 1];
            
            buffer[1] <= buffer[0];
            
            buffer[0] <= din;
            
          end

        end
        
        default: state <= EMPTY;

      endcase
      
    end
    
  end
    
    
endmodule
