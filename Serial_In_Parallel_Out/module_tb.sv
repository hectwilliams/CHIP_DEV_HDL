// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module ser_to_par_tb;
  
parameter DATA_WIDTH = 4;
parameter CLK_PERIOD = 2;
parameter CLK_PERIOD_DIV_2 = CLK_PERIOD / 2; 
parameter BIT_STREAM = 20'b1101_0110_0101_1100_0111;
parameter RST_STREAM = 20'b0000_0000_1001_0000_1000;
parameter N_SIGNALS = 20;
  
logic clk, rst_tb, din, din_z;
bit go, go_z, go_zz, rdy, rdy_z, rdy_zz, rst,rst_z;
  
  logic [DATA_WIDTH - 1: 0] dout, dout_prev;

integer index;

integer index_z, index_zz;

  typedef enum {IDLE, GO, SEND, DONE} fsm_t;
  
  fsm_t state;
  
  
initial begin
  index = 0;
  index_z = 0;
end

initial begin
  clk = 0;
  forever #(CLK_PERIOD_DIV_2) clk  = ~clk;
end
  
initial begin
  rst_tb = 0;
  #4 rst_tb = 1;
end
  
  initial begin
    rst = 1;
    din = 0;
    index = 0;
  end
  
  always @ (posedge clk or negedge rst_tb or negedge rst ) begin
  
	
  go_z <= go;
  go_zz <= go_z;
  rdy_zz <= rdy_z;
  index_zz <= index_z;
  index_z <= index;
  din_z <= din;
  rdy_z <= rdy;
  rst_z <= rst;
  
  if ( !rst_tb ) begin
    
    state <= IDLE;
    
  end else begin 
  
    case(state)
      
      IDLE: begin
        
		din <= 0;
        
        rst <= 0;
        
        index <=0;
        rdy <= 0;
        go <= 0;
        go_z <= 0;
        state <= GO;
      end
      
      GO: begin
        
        go <= 1;
        
        state <= SEND;
      end
      
      SEND: begin
        
        go<= 0;
        
        if (go) begin
          
          rdy <= 1;
        
        end else if (index == N_SIGNALS) begin
        
          rdy <=0;
          
        end
      
        //if (go_z ||    (index>=1 && index < N_SIGNALS) ) begin
             
        if ( rdy) begin
    
          index <= index + 1;
          
        end
        
        if (go) begin
          
          rst <= 0; // untracked state held active low 
          
          din <= 0;
          
        end else begin
			
          din <= BIT_STREAM[N_SIGNALS-1 - index];
	        
          rst <= ~RST_STREAM[N_SIGNALS-1 - index];
          
        end
        
        // Transmitted to Module 
        if (rdy_z  ) begin 
          
          dout_prev <= dout;

        end
        
        // Monitor Reads
        if (rdy_zz ) begin
         
          $display( "prev_index - %d  monitor_read_prev %b monitor_read - %b  prev_din - %b  prev_rst - %b ", index_zz, dout_prev, dout, din_z, rst_z );
     
        end
        
        if (index_z == N_SIGNALS) begin
          
          state <= DONE;
        end
        
      end
      
      
      DONE: begin
        
        $finish;
        
      end
      
      default: state <= IDLE;
      
    endcase
    
  end
  
  
  
  
  
    //$display( "index - %d module_rcvd - %b  rst-rcvd - %b  monitor_reads - %b    ", index_z, din_z, rst_z, dout );
      
  

end


model #(DATA_WIDTH) u0 (
  .clk (clk),
  .resetn(rst),
  .din(din),
  .dout(dout)
  
);

endmodule

