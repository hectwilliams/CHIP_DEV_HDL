
`timescale 10ns/100ps 

module log2 (
  input  clk,
  input rst_n, 

  output [7:0] y,
  input  [7:0] x,  
  output validy,
  input validx  
);
  
// Functions
  
  function  unsigned [7:0] log2_func(unsigned [7:0] x_in);  
    
    logic [7:0]  local_val;
    
    begin
      
      if (x_in <= 1) begin

        return 0;
        
      end else begin 
        
        local_val = x_in / 2;
        
        return log2_func(local_val) + 1;

      end
      
    end
      
  endfunction 
  
  function unsigned [7:0] ceil_log2_func(unsigned [7:0] x_in, unsigned [7:0] target);  
    
    if ( target > 2**x_in) begin

      return x_in + 1;
    
    end else begin
      
      return x_in ;
      
    end
      
  endfunction 

  

  // Constants 
  

  // Regs 
  
  logic validx_dly ;
  logic [7:0] x_reg;
  logic [7:0] rd_index, rd_index_dly;      
  logic [7:0] log2_data, log2_data_dly;
  logic [7:0] validy_reg, validy_reg_dly;
  logic wr_en;
  logic wr_valid, wr_valid_dly;
  logic [7:0] wr_data;
  logic [3:0] wr_index;
  logic [7:0] rd_count;
  logic [7:0] array_6x8 [6];
  logic [5:0] s;
  logic wr_pulse;
  


  // Dataflow 

  /*

	Handle external stimuli  (i.e. valid data bytes)
  
  */    
  assign y = wr_data;
  assign validy = wr_valid;

  always @ (posedge clk or negedge rst_n) 

    begin 

      if (!rst_n) begin

        rd_index <= 0;

        validy_reg <= 0;

        rd_count <= 0;

      end else if(validx) begin  

        // valid events are continuous: held for N cycles signal

        rd_index <= rd_index + 1;

        array_6x8[rd_index] <= ceil_log2_func(log2_func(x), x);

        rd_count <= rd_count + 1;

      end else begin

        validy_reg <= 0;

        rd_index <= 0; 

      end

      rd_index_dly <= rd_index;

    end
  
  
  /*

	Pulse to kickoff array reader
  
  */    
  always @ (posedge clk or negedge rst_n)  begin

    if (!rst_n ) begin
      
      wr_pulse <= 0;
      
    end else if(rd_index_dly > rd_index) begin 
      
      wr_pulse <= 1;      
    
    end else begin
      
      wr_pulse <= 0;      
      
    end 
   
  end
  
  
  /* 
  
  	Read Array
  
  */ 
  always @ (posedge clk or negedge rst_n) begin

    if(!rst_n) begin 
      
      s <= 0;
      
      wr_valid <= 0;

    end else if(wr_pulse) begin
      
      s[5] <= wr_pulse;
      
    end else if (s > 0) begin
    
      s <= {1'b0, s[5:1]}; 
      
      wr_valid <= 1;
      
      wr_data <= array_6x8[rd_count - log2_func(s) - 1]; // write stored data

    end else begin

      wr_valid <= 0;
      
      s <= 0;
      
    end
      
  end
  
endmodule 
