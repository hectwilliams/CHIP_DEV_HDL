
`timescale 10ns/100ps 

module log2_tb;
  
  logic clk;
  logic rst;
  logic [7:0] datax, datax_dly;
  logic [7:0] datay;
  logic [3:0] tick, tick_dly;
  logic validx, validy, validy_dly;
  
  parameter CLK_PERIOD = 2;
  parameter CLK_PERIOD_2 = CLK_PERIOD / 2;
  parameter N_DATA_TX = 6;
  
  initial begin
  	rst = 0;
    #4 rst = 1;
  end 
  
  initial begin
  	clk = 0;
    forever #(CLK_PERIOD_2) clk = ~clk;
  end
 	
  always @ (posedge clk) begin 
  
    if(tick >= 1 && tick <=6) begin 
      
	  validx <= 1;
      
    end else begin
      
      validx <= 0;
      
    end
    
    if (validx) begin
    	
      $display("VECTOR SENT [%0d] - [%0d] -  [%0d]  time- %0t", tick_dly, datax_dly, datay, ($time));

    end
    
    if (validy) begin 
    
      $display("VECTOR RCVD [%0d] ",  datay);

    end
    
    if (~validy && validy_dly) begin
      $finish;
    end
    
    validy_dly <= validy;

  end
  
  always @ (posedge clk ) begin
    
    if(!rst) begin
      
      tick <= 0;
      
      datax <= 0;
      
    end else if (tick <= N_DATA_TX) begin
      
      tick <= tick + 1;
      
      datax <= $urandom() & 8'hFF;
      
    end else begin
      
      validx <= 0;
      
    end
    
    tick_dly <= tick;
    
    datax_dly <= datax;
    
  end
 
  
  log2 u0(
    .clk(clk),
    .rst_n(rst),
    .x(datax_dly),
    .y(datay),
    .validy(validy),
    .validx(validx)
  );
 
  
endmodule 
