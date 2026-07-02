module model (
    input logic clk,
    input logic resetn,
    input logic din,
    input logic cen,
    output logic doutx,
    output logic douty 
);


  typedef enum {S0, S1, S2, S3, S4} fsm_t;
  
  fsm_t state, next_state;
  
  logic prev_din_S4 ;
  
  bit din_z, din_zz, din_zzz;
  
  bit resetn_z;
  
  always @ (posedge clk ) begin
    
    din_zzz <= din_zz;
    
    din_zz <= din_z;

    din_z <= din;
    
    resetn_z <= resetn;

    if (~resetn & resetn_z  ) begin
      
      state <= S0;
      
    end else begin
        
      state <= next_state;
      
    end
          
  end

  always @ (cen or din or state ) begin
     
    if (1) begin
                  
      case (state ) 

        S0: begin
                     
          prev_din_S4 = 0;
          
          if (din == 0) begin

            next_state = S2;

          end 
          
          if ( din == 1) begin

            next_state = S1;

          end
          
        end

		S1: begin
          
          if ( din == 0) begin
            
            next_state = S2;
            
          end 
          
          if ( din == 1) begin
            
            next_state = S3;
            
          end
                     
        end
        
        S2: begin
          
          if ( din == 1) begin
            
            next_state = S1;
            
          end 
          
          if ( din == 0) begin
            
            next_state = S4;
                  
            prev_din_S4 = 0;

          end
                        
        end
        
        S3: begin
          
          
          if ( din == 1) begin
            
            next_state = S4;
                      
            prev_din_S4 = 1;
            
          end 
          
          if ( din == 0 ) begin
            
            next_state = S2;
            
          end

        end
        
        S4: begin
                      
          if ( prev_din_S4 ^ din) begin
          
            if (din == 1) begin
              
              next_state = S1;
              
            end else if (din == 0) begin
              
              next_state = S2;
              
            end
            
          end

        end
        
      endcase

          
    end

  end
  
  
  always @ (state or din) begin
     
    doutx = 0;
    douty = 0;
    
    if (cen) begin
     
      case (state) 

        S0: begin 
    
        end

        S1: begin 
                
        end

        S2: begin 
                
        end

        S3:begin 
            
          doutx = 1; // ones repeated twice 

        end

        S4:begin
          
          douty = 1; // ones repeated three 

          doutx = 1; // ones repeated three 
            
        end

      endcase
    end

  end
  
  

endmodule
