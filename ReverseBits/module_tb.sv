
`timescale 1ns/1ps

module reverse_bits_tb;
  
  parameter DATA_WIDTH = 32;
  parameter CLK_PERIOD = 2;
  parameter CLK_PERIOD_DIV_2 = CLK_PERIOD / 2;
  parameter ARRAY_SIZE = 4;

  logic rst, clk;
  logic [DATA_WIDTH - 1 : 0] din;
  logic [DATA_WIDTH - 1 : 0] dout;
  logic [ARRAY_SIZE - 1 : 0] store [DATA_WIDTH - 1: 0];
  logic [DATA_WIDTH-1:0] tmp;
  
  bit pulse; 
  bit [7:0] counter, tick, index; 
  
  initial begin
    rst = 0;
    #2 rst = 1;
  end
  
  initial begin
    clk = 0;
    forever #(CLK_PERIOD_DIV_2) clk = ~clk;
  end
  
  initial begin 
    tmp = 1;
    for ( int i = 0; i < ARRAY_SIZE; i = i + 1 ) begin
      store[i] = (tmp << i)  ;
    end
  end
  
  typedef enum {IDLE, TRANSMIT,TICK, DONE} fsm_state_t;
  
  fsm_state_t current_state, current_state_z,  pulse_state;
  
  always_ff @(posedge clk or negedge rst) begin : transmit_controller
   	
    current_state <= IDLE;
	
    din <= 'z; 
	

    case (current_state) 
    	
      IDLE: begin

        if (pulse && index < ARRAY_SIZE) begin
          
          current_state <= TRANSMIT;
          
        end
        
      end
      
      TRANSMIT: begin
        
		current_state <= DONE;
        
        index <= index + 1;
        
        din <= store[index];
        
      end
      
      DONE: begin
        
		current_state <= IDLE;
		
        din <= 'z; 

      end
      
      default: current_state <= IDLE; 
      
    endcase
    
    current_state_z <= current_state;

  end
  
    
  always_ff @(posedge clk or negedge rst) begin : start_pulse
    
    pulse_state <= IDLE; 
    
    case (pulse_state)
      
      IDLE: begin
        
        if (rst) begin
          
	        pulse_state <= TRANSMIT;
          
        end
        
      end
      
      TRANSMIT: begin
    	
        pulse <= 1;
        
        pulse_state <= TICK; 
        
      end
      
      TICK: begin
        
        pulse <= 0;
        
        if(tick < 100) begin
          
          tick <= tick + 1;
          
        end else begin
          
          tick <= 0;
          
          if (counter == ARRAY_SIZE) begin
            
          	pulse_state <= DONE;
            
          end else begin
            
            pulse_state <= IDLE;
            
            counter <= counter + 1;
            
          end
          
        end
        
      end
      
      DONE: begin
        
      end
      
      default: pulse_state <= IDLE; 

    endcase
    
  end
  
  always @ (posedge clk) begin : Monitor 
    
    if (current_state_z == TRANSMIT) begin
    	
   		$display("TX [%32b]  RX [%32b] ", din , dout);
      
    end
    
    if (  index == ARRAY_SIZE ) begin 
      
      $finish;
      
    end
    
  end

  model #(DATA_WIDTH) u0 (
    
    .din(din),
    
    .dout(dout)
    
  );
  
endmodule;
