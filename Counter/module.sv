`timescale 1ns/1ps 


// interface (top-level)

module counter (
  
  input logic clk,
  input logic rstn , // active low  
  input logic[7:0] n_ticks, // range 0 - 255
  output logic[7:0] data_o, 
  output logic watch_o

);
  
  
// Constants 
  
  
// Regs 
  
  logic[7:0] count_reg; // not used 
  
  logic rstn_z;
  
// dataflow 
  
  always @ (posedge clk or negedge rstn) 
    
    begin 
      
      if (!rstn ) 
        
        begin
          data_o <= 0;
          count_reg <= 8'h00;
          watch_o <= 0;
        end 
      
      else 
        
        begin

          if (count_reg < n_ticks) begin 
            
            count_reg <= count_reg + 1;        
            
          end 
          
          data_o <= count_reg; 
          
          watch_o <= rstn ^ rstn_z;
          
        end
      
      rstn_z <= rstn; 
      
      
    end  
   

    
endmodule 
    


  
  

