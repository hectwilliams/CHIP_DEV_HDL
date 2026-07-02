
module gen_gray_vector #(parameter DATA_WIDTH = 1, ID = 1) (
	
  output logic [2**DATA_WIDTH - 1: 0] out
 
);
 	
  parameter WIDTH = 2**DATA_WIDTH;
  
  parameter delay_size = 2**ID;
  
  parameter on_or_off_size = 2**(ID+1) ;
  
  parameter on_off_size = on_or_off_size * 2;

  parameter delay_seq = {delay_size{1'b0}};
  
  parameter on_seq = {on_or_off_size{1'b1}};
  
  parameter off_seq = {on_or_off_size{1'b0}};
  
  parameter on_off_seq = {{off_seq}, {on_seq} }; // lsb on right side
	
  parameter k = WIDTH - delay_size;
  
  parameter k_aligned = (on_off_size + (k - 1) ) & ~(k - 1); // aligned to nearest even number :) 
  
  parameter factor = ((k_aligned > k)  == 0) ? ( k / on_off_size ) : ( k  / on_off_size ) + 1; // make sure we CEIL() correctly
  
  parameter logic[WIDTH -1 :0] code_seq = {{factor{on_off_seq}}, delay_seq}  & {WIDTH{1'b1}}; 
	
  assign out = code_seq;
  
endmodule

module serialize_vectors # (parameter DATA_WIDTH = 1, ID = 1) (
  
  input logic [DATA_WIDTH - 1: 0] gray, 
  
  input logic [( 2**DATA_WIDTH) - 1: 0] din,
  
  
  input logic [( 2**DATA_WIDTH)*DATA_WIDTH - 1: 0] prev,
  
  output logic [( 2**DATA_WIDTH)*DATA_WIDTH - 1: 0] out,
  
  output logic [( 2**DATA_WIDTH)*DATA_WIDTH - 1: 0] gray_extend_o,
  
  input logic [( 2**DATA_WIDTH)*DATA_WIDTH - 1: 0] gray_extend_i
  
);
  
  parameter wide_width = (2**DATA_WIDTH)*DATA_WIDTH;
	
  always @ (prev or din or gray_extend_i) begin
    
    out = (prev  | (din << (2**DATA_WIDTH * ID) )) ;
    
    gray_extend_o = gray_extend_i | ({(2**DATA_WIDTH){gray[ID]}} << (ID * 2**DATA_WIDTH));
    
  end
  
endmodule
  
module find_match_seq #(parameter DATA_WIDTH = 1, ID = 1)(
  
  input logic [DATA_WIDTH - 1:0] expect_code, 
  
  input logic [( DATA_WIDTH) - 1: 0] din,
  
  output logic out

);
   
  always @ ( din) begin
    
    if ( expect_code == din) begin
      
      out = 1;
      
    end else begin
      
        out = 0;
      
    end

  end
  
endmodule
 
module find_index #(parameter DATA_WIDTH = 1, ID = 1) (

  input logic [(2**DATA_WIDTH) * DATA_WIDTH - 1: 0] flatten_gray,

  input logic [(2**DATA_WIDTH) * DATA_WIDTH - 1: 0] flatten_gray_expect_extend,
	
  output wire [2**DATA_WIDTH - 1: 0] one_hot_index
  
);
  
  parameter logic [2**DATA_WIDTH   -1:0] one_hot = (1 << ID);
  
  parameter logic [(2**DATA_WIDTH) * DATA_WIDTH - 1: 0]  one_hot_sel = {DATA_WIDTH{one_hot}};
  
  logic [2**DATA_WIDTH * DATA_WIDTH -1 :0] data;
	
  bit [2**DATA_WIDTH - 1: 0]  counter_reg ;
  
  always @ (flatten_gray or  flatten_gray_expect_extend or data) begin

    data = ~(flatten_gray ^ (flatten_gray_expect_extend)) & (one_hot_sel) ;
    
    //$display(" %b. %b ID %d  %b.  %b    %b", one_hot, one_hot_sel, ID, flatten_gray,  flatten_gray_expect_extend , data);
    
    for (int i = 0; i <  2**DATA_WIDTH * DATA_WIDTH ; i++ ) begin
      
        counter_reg = counter_reg + data[i] ;
      
    end
    
   // $display(" %d ", counter_reg);
    
  end
  
  assign one_hot_index = (counter_reg == DATA_WIDTH) ? ID :'z;
  
endmodule 

module model #(parameter
               
  DATA_WIDTH = 16
) (
  input [DATA_WIDTH-1:0] gray,
  
  output logic [DATA_WIDTH-1:0] bin
  
);
  
  parameter wide_width = (2**DATA_WIDTH)*DATA_WIDTH;
  
  parameter zeros = {(wide_width) {1'b0}};
  
  logic [DATA_WIDTH-1:0] ret;
  
  wire [2**DATA_WIDTH - 1: 0] code_vectors[DATA_WIDTH];
  
  wire [2**DATA_WIDTH - 1: 0] match;
  
  wire   [( 2**DATA_WIDTH)*DATA_WIDTH - 1: 0] ser_wire [DATA_WIDTH];
    
  wire   [( 2**DATA_WIDTH)*DATA_WIDTH - 1: 0] ser_wire_gray_extend [DATA_WIDTH];
  
  //wire [2**DATA_WIDTH - 1: 0] count[DATA_WIDTH];
  
  wire [2**DATA_WIDTH - 1: 0] index_result; 

  genvar i, j;
  
  for ( i = 0; i < DATA_WIDTH; i = i + 1) begin
    
    gen_gray_vector #(DATA_WIDTH, i) u0 (
    
      .out(code_vectors[i])
      
    );
    
  end
  
  /* flatten code_vectors */
  
  for (i = 0; i < DATA_WIDTH; i = i + 1) begin
    
    if ( i == 0) begin
      serialize_vectors #(DATA_WIDTH, 0) u0 (
        .din(code_vectors[0]),
        .prev(zeros),
        .out(ser_wire[0]),
        .gray(gray),
        .gray_extend_i(0),
        .gray_extend_o(ser_wire_gray_extend[0])
      );
    end else begin
       serialize_vectors #(DATA_WIDTH, i) u0 (
         .din(code_vectors[i]),
         .prev(ser_wire[i - 1]),
         .out(ser_wire[i]),
         .gray(gray),
         .gray_extend_i(ser_wire_gray_extend[ i -1 ]),
         .gray_extend_o(ser_wire_gray_extend[i])
      );
    end
    
  end
    
   
  /* find index  */

  for (i = 0; i < 2**DATA_WIDTH; i = i + 1) begin

    find_index # (DATA_WIDTH , i) u2 (
      .flatten_gray(ser_wire[DATA_WIDTH - 1]),
      .flatten_gray_expect_extend(ser_wire_gray_extend[DATA_WIDTH - 1]),
      .one_hot_index(index_result)
    );

  end  
  
    /* capture when index is ready */
 	
  always @ (index_result) begin
    
   // $display("gray code %b  index %d", gray, index_result);
    bin = index_result;
  end

	
  
endmodule


