/*
  

  Divisible by three 

  Took a while to wrap my head around this problem. But simple state machine once your realize the link between modulus and cyclic patterns :) 
  
  --HW-- 
  

*/
module model #(parameter DATA_WIDTH_TUNNEL = 32, DIVISOR = 3) (
  input clk,
  input resetn,
  input din, // handle pulse and persistent signal
  output logic dout
);
  
  bit din_z;
  
  bit prev_edge;
  
  bit [DATA_WIDTH_TUNNEL - 1: 0] buffer;
  
  bit resetn_z;
  
  typedef enum {ZERO, ONE, TWO} fsm_t;
  
  fsm_t state; 

  function void debug_message(  bit [DATA_WIDTH_TUNNEL - 1: 0] buffer , bit dout, bit din , fsm_t state);
 	            
    $display("next-input [%d] acc_dec[%d] acc_binary[%b] [is divisible %d] [%f] [current state %d] " , din, buffer, buffer  , dout,  real'(buffer) / 3.0 , state);

  endfunction
  
  always @ (posedge clk or negedge resetn) begin
    
    din_z <= din;
    
    state <= ZERO;
    
    resetn_z <= resetn;
    
    if (!resetn) begin
  
      state <= ZERO;
      
      dout <= 0;
      
      prev_edge <= 0;
      
      buffer <= 0;
      
    end else begin
    
      // Mealy Machine Euerka :)
      
      case(state) 
        
        ZERO: begin
          
          // low-edge or low signal
          
          if (  (~din & din_z)  | (~prev_edge & ~din) ) begin
                  
            buffer <= (buffer << 1) | 1'b0;
                   
            debug_message(buffer, dout, din, state);

			dout <= 1;
	
            prev_edge <= 0;
            
            state <= ZERO;
            
         // high-edge or high signal

          end else if (  (din & ~din_z)  | (prev_edge & din)  ) begin
              		
            buffer <= (buffer << 1) | 1'b1;
            
            debug_message(buffer, dout, din, state );
            
            dout <= 0;
            
            state <= ONE;
            
            prev_edge <= 1;
            
          end
          
        end
        
        ONE: begin
   
          if ( (~din & din_z) | (~prev_edge & ~din) ) begin
                 
            buffer <= (buffer << 1) | 1'b0;
            
            debug_message(buffer, dout, din,  state );

			dout <= 0;
            
            state <= TWO;
                     
            prev_edge <= 0;

          end else if ((din & ~din_z) | (prev_edge & din) ) begin
             		
            buffer <= (buffer << 1) | 1'b1;
                   
            debug_message(buffer, dout, din, state );

            dout <= 1;
            
            state <= ZERO;
                   
            prev_edge <= 1;
     
          end
        
        end
        
        TWO: begin
      
          if ((~din & din_z) | (~prev_edge & ~din) ) begin
         
            buffer <= (buffer << 1) | 1'b0;

            dout <=0;
            
            state <= ONE;
              
            prev_edge <= 0;
            
            debug_message(buffer, dout, din, state );
        
          end else if ((din & ~din_z) | (prev_edge & din) ) begin

            buffer <= (buffer << 1) | 1'b1;
                  
            dout <= 0;
            
            state <= TWO;
                     
            prev_edge <= 1;
            
            debug_message(buffer, dout, din, state );
   
          end
          
        end
        
        default : state <= ZERO; 
        
      endcase 
      
    end
  end

endmodule 
