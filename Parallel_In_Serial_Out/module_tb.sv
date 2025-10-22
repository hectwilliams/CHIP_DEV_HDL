`timescale 1ns/1ps 

module parallel_to_serial_tb;
  
  parameter DATA_WIDTH = 4;
  parameter CLK_PERIOD = 2;
  parameter CLK_PERIOD_DIV_2 = CLK_PERIOD / 2;
  parameter N_PARALLEL_SAMPLES = 22;
  parameter RST_VECTOR = {{1'b1},{6{1'b0}}, {1'b1}, {14{1'b0}}};
  parameter ENABLE_VECTOR = {
    {1{1'b1}},
    {1{1'b0}}, 
    {1{1'b1}},
    {4{1'b0}},
    {2{1'b1}},
    {2{1'b0}},
    {1{1'b1}},
    {4{1'b0}},
    {1{1'b1}},
    {5{1'b0}}
  };

  logic [DATA_WIDTH - 1 : 0] rom [N_PARALLEL_SAMPLES-1:0];
  
  logic clk, rst, rst_testbench;
  
  bit [7:0] index;

  bit [7:0] tick;
  
  logic rdy, rdy_z, rdy_zz;

  typedef enum {IDLE, ON,WAIT, OFF} fsm_t;
  
  logic din_en, dout;
  
  logic [DATA_WIDTH-1:0] din;
  
  logic go, go_z; 
  
  fsm_t state, state_z;
  
  initial begin 
    rst_testbench = 0;
    #4 rst_testbench = 1;
  end
  
  initial begin
    clk = 0;
    forever #(CLK_PERIOD_DIV_2)  clk = ~clk;
  end
 
  // old verilog approach to init
  initial begin
      
    rom[0] = 4'b1010;
      
    rom[1] = 4'b0011;
   
    rom[2] = 4'b1111;
   
    rom[3] = 4'b0000;
    
    rom[4] = 4'b0000;
      
    rom[5] = 4'b0000;
    
    rom[6] = 4'b0000;
    
    rom[7] = 4'b0100;
    
    rom[8] = 4'b0001;
    
    rom[9] = 4'b0000;
    
    rom[10] = 4'b0000;
    
    rom[11] = 4'b1000;
    
    rom[12] = 4'b0000;
    
    rom[13] = 4'b0000;
    
    rom[14] = 4'b0000;
      
    rom[15] = 4'b0000;
	
    rom[16] = 4'b1100;
    
    rom[17] = 4'b0000;

    rom[18] = 4'b0000;
    
    rom[19] =  4'b0000;
    
    rom[20] = 4'b0000;
	
    rom[21] = 4'b0000;
    
  end
  
  always @ (posedge clk or negedge rst) begin
    
    state_z <= state;
    
    rdy_z <= rdy;
    
    rdy_zz <= rdy_z;
    
	go_z <= go;

    if (!rst_testbench) begin
     
      tick <= 0;
      
      din <= 'z;
      
      din_en <= 0;
      
      state <= IDLE;
      
      rdy<= 0;
      
      go <= 0; 
      
    end else begin 

      case (state) 
      
        IDLE: begin
        
          state <= WAIT;
          
          tick <= 0;
          
          rst <= 0;
          
          index <= 0;
          
		  rdy <=0;
          
        end
      
        WAIT: begin
          
          if (tick <  10 ) begin
          
            tick <= tick + 1;
        
          end else begin 
          
            state <= ON;
            
            go <= 1;
            
          end
        
        end
      
        ON: begin

          go <= 0;
    
          if (go) begin
            
          	rdy <= 1;
          
          end else if (index == N_PARALLEL_SAMPLES)begin
            
            rdy <= 0;
                          state <= OFF;
            din <= 'z;

          end
          
          if (go_z || index < N_PARALLEL_SAMPLES) begin
			
            index <= index + 1;

          end
          
          din_en <= ENABLE_VECTOR[N_PARALLEL_SAMPLES - 1 - index];
          
          din <= rom[index];
            
          index <= index + 1;
		
          rst <= ~RST_VECTOR[N_PARALLEL_SAMPLES - 1 - index];
    
        end
        
        OFF: begin
          
        
          if (rdy_z == 0 && rdy_zz == 1) begin
    
        	$finish;
        
          end     
        
        end
        
        default: state <= IDLE;
    
      endcase 
  
    end
    
  end
  
  always @ (posedge clk) begin 
    
    if (rdy_z || rdy_zz) begin
      
      $display("[%d]", dout) ;
      
    end
    
 
    
  end
  
  parallel_to_serial #(DATA_WIDTH) u0 (
    .clk(clk),
    .resetn(rst),
    .din(din),
    .din_en(din_en),
    .dout(dout),
    .rdy(rdy)
  );
endmodule
