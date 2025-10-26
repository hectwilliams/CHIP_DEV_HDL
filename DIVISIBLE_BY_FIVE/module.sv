module model #(parameter DATA_WIDTH_TUNNEL = 1, DIVISOR=5) (
  input clk,
  input resetn,
  input din,
  output logic dout
);
  
  
  bit prev_edge, din_z;
  
  bit [DATA_WIDTH_TUNNEL -1 : 0] accumulator, accumulator_z;
  
  typedef enum {
    MOD_0,
    MOD_1,
    MOD_2,
    MOD_3,
    MOD_4
  } fsm_t;
  
  fsm_t state, state_z; 
  
  function void debug_message(  bit [DATA_WIDTH_TUNNEL - 1: 0] current_acc, bit current_dout, fsm_t curr_state, prev_state, din);
 	            
    $display("prev_input[%d] curr-accum [%.2f] curr-accum_bin[%b] is_divisible-[%b] prev_state[%d] state [%d] " , din, real'(current_acc) / 5.0 , current_acc  , current_dout,  prev_state, curr_state);

  endfunction
  
  always @ (posedge clk or negedge resetn) begin
    
    debug_message( accumulator, dout, state,state_z, din_z);
  
    state <= MOD_0;
    
    state_z <= state_z;
    
    din_z <= din;
    
    accumulator <= (accumulator << 1) | din;
    
    accumulator_z <= accumulator;
    
    case(state)
      
      MOD_0: begin
        
        if ( ~din ) begin
          
          state <= MOD_0;
          
          dout <= 1;
          
        end else begin
          
          state <= MOD_1;
          
          dout <= 0;
          
        end
        
      end
      
      MOD_1: begin
         
        dout <= 0;
        
        if (~din) begin 
          
          state <= MOD_2;
          
        end else begin
          
          state <= MOD_3;
          
        end
        
      end
      
      
      MOD_2: begin
        
        if (~din) begin 
          
          state <= MOD_4;
        
          dout <= 0;
          
        end else begin
          
          state <= MOD_0;
          
          dout <= 1;
          
        end
        
      end
    
          
      MOD_3: begin
          
        dout <= 0;
    
        if (~din) begin 
          
          state <= MOD_1;
          
        end else begin
          
          state <= MOD_2;
          
        end
        
      end
     
      MOD_4: begin
          
        dout <= 0;
    
        if (~din) begin 
          
          state <= MOD_3;
          
        end else begin
          
          state <= MOD_4;
          
        end
        
      end
        
      default: state <= MOD_0;
      
    endcase
    
  end
  
endmodule
