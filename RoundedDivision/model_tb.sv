// Code your testbench here
// or browse Examples
`timescale 1ns/100ps

module RoundInteger_tb;
  
  parameter DATA_WIDTH = 32;
  
  parameter DIV_LOG2 = 3;
  
  parameter IN_WIDTH = DIV_LOG2 + DATA_WIDTH;
  
  parameter CLK_PERIOD = 2;
  
  parameter CLK_PERIOD_HALF = CLK_PERIOD / 2; 
  
  parameter ARRAY_SIZE = 5; 
  
  parameter BIN_1000 = 4'b1000;
  
  logic clk, rst;

  logic [DATA_WIDTH - 1: 0] data_o;
  
  logic [IN_WIDTH - 1: 0] data_in;

  logic [DATA_WIDTH - 1: 0] collection [DATA_WIDTH - 1: 0];
  
  logic [3:0] index; 
  
  logic [3:0] pulse_data;
  
    
  typedef enum {IDLE, TICK_3, NOOP, TX, DONE} fsm_state_t;

  fsm_state_t current_state, current_state_z, next_state; 
  
  
  initial begin
    
    rst = 0;
  	
    #4 rst = 1;
    
  end
  
  initial begin 
  	
    clk = 0;
    
    forever #(CLK_PERIOD_HALF) clk = ~clk;
    
  end
  
  initial begin : load_memory
    
    //for (int i = 1; i <= ARRAY_SIZE; i= i + 1) begin

   //   collection[i] = i;
      
   // end
    
    collection[0] = 11;

    collection[1] = 15;

    collection[2] = 37;

    collection[3] = 22;

    collection[4] = 19;

    collection[5] = 17;

  end
  
  initial begin
 
  
    
  end;

 
  always_ff @ (posedge clk or negedge rst) begin 
    
    if (!rst) begin 
      	
      current_state <= IDLE;
            
    end else begin 
      
      current_state <= next_state;
                 
    end
    
    current_state_z <= current_state;
    
  end
  
  
  always @ (clk ) begin 
	
    next_state = current_state;
    
    case (current_state)
      
      IDLE: begin
        
          next_state = TICK_3;
          
      end
      
      TICK_3: begin
        
        if (pulse_data[0]) begin
          
          next_state = NOOP; 
          
        end
        
      end
      
      NOOP: begin
        
        next_state = TX; 
        
      end
      
      TX: begin
        
        if ((index < ARRAY_SIZE)) begin
          
          if (pulse_data[0]) begin
            
	          next_state = IDLE;
            
          end
         
        end else begin 
          
          next_state = DONE; 
          
        end
        
      end
      
      DONE: begin
        
        
      end
      
      default: next_state = IDLE; 
      
    endcase
    
  end
  
  always @ (posedge clk or negedge rst) begin 
  
    data_in <= 0;
    
    case (current_state) 
      
      TX: begin
        
        data_in <= collection[index] ;
      
      end
      
    endcase
      
  end
      
  always @ (posedge clk or negedge rst) begin
	
    if (!rst) begin
      
      index <= 0;
      
    end else if( pulse_data[0] && current_state == TX ) begin
        
        index <= index + 1;
      
    end
    
    if ( (current_state == TICK_3)  || (current_state == TX) ) begin
        
		pulse_data <= {1'b0, pulse_data[3:1]};
      
    end else begin            
      
      pulse_data <= BIN_1000;
  
	end
    
  end
  
  always @ (posedge clk) begin
    
    if ( pulse_data[0]  && (current_state == TX)) begin
      
      $display("%0d / %0d = %0d", data_in, 2**DIV_LOG2, data_o);
      
    end
    
       
    if (index >= ARRAY_SIZE) begin 
      
      $finish;
      
    end
    
  end
                       

  model #(DIV_LOG2, DATA_WIDTH, IN_WIDTH) u0(
  
    .din(data_in)  ,
  
    .dout(data_o)

  );

     
endmodule 
