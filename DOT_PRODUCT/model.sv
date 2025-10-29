module model (
    input [7:0] din,
    input clk,
    input resetn,
    output reg [17:0] dout,
    output reg run
);

  
  parameter DATA_WIDTH = 8;
  
  parameter VECTOR_SIZE = 6;
  
  parameter VECTOR_SIZE_DIV_2 = VECTOR_SIZE / 2;
  
  bit [$clog2(6):0] counter;
  
  bit [DATA_WIDTH*2 -1: 0] reg0;
  
  bit [DATA_WIDTH*2 -1: 0] reg1;
    
  bit [DATA_WIDTH*2 -1: 0] regs [VECTOR_SIZE_DIV_2];
	
  always @ (counter) begin
  
    run = counter == 0;
    
  end
  
  always @ (posedge clk) begin
    
    if (!resetn) begin
      
      counter <= 0;
      
      reg0 <= 0;
      
      reg1 <= 0;
      
      dout <= 0;
		      
    end else begin
      
      if (counter == VECTOR_SIZE - 1) begin
        
        counter <= 0;
        
      end else if (counter < VECTOR_SIZE) begin
        
        counter <= counter + 1;
        
      end
      
      if (counter < VECTOR_SIZE_DIV_2) begin
        
        regs[counter] <=  din;
        
      end else begin

        if (counter + 1  == VECTOR_SIZE) begin
 	
          dout <= regs[0] + regs[1] +  (regs[2] * din) ; // A_0 * B_0 + A_1 * B_1  + A_2 * B_2
          
        end else begin
                  
          regs[counter - VECTOR_SIZE_DIV_2] <= regs[counter - VECTOR_SIZE_DIV_2 ]  * din ;  // A_0 * B_0 
          
        end
        
      end
      
    end
    
  end
  
endmodule






