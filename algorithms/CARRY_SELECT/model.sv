module model (
    input [23:0] a,
    input [23:0] b,
    output logic [24:0] result
);

  parameter N_STAGES = 4;
  
  parameter BITS_PER_STAGE = 6;
  
  wire [BITS_PER_STAGE*N_STAGES -1 : 0] carry_bus;
    
  wire [BITS_PER_STAGE*N_STAGES  -1 : 0] sum_bus;

  genvar i;
  
  
  for(i = 0; i < N_STAGES; i = i + 1) begin: CSELECT
  
    
    if (i == 0) begin
          
      carry_select_multi_FA_stage #( .DATA_WIDTH(BITS_PER_STAGE)) u0(
    
        .cin(1'b0),
        
        .a(a[ (i + 1) * BITS_PER_STAGE - 1 : i * BITS_PER_STAGE] ),
        
        .b(b[ (i + 1) * BITS_PER_STAGE - 1 : i * BITS_PER_STAGE] ),

        .sum(sum_bus[ (i + 1) * BITS_PER_STAGE - 1 : i * BITS_PER_STAGE] ),

        .cout(carry_bus[0])
    
      );
    
    end else begin
      
    
      carry_select_multi_FA_stage #(.DATA_WIDTH(BITS_PER_STAGE))  u1(
    
        .cin(carry_bus[i-1]),
        
        .a(a[ (i + 1) * BITS_PER_STAGE - 1 : i * BITS_PER_STAGE] ),
        
        .b(b[ (i + 1) * BITS_PER_STAGE - 1 : i * BITS_PER_STAGE] ),

        .sum(sum_bus[ (i + 1) * BITS_PER_STAGE - 1 : i * BITS_PER_STAGE] ),

        .cout(carry_bus[i])

      );
    
      
    end
    
  end
  
  assign result = {carry_bus[BITS_PER_STAGE*N_STAGES -1 ], sum_bus};

endmodule


module carry_select_multi_FA_stage #(DATA_WIDTH = 6) (

  input cin,
  
  input [DATA_WIDTH - 1 : 0] a,
  
  input [DATA_WIDTH - 1 : 0] b,

  output [DATA_WIDTH - 1 : 0] sum,

  output cout

);
 
  wire [DATA_WIDTH - 1: 0] sum_bus;
  
  wire [DATA_WIDTH - 1: 0] carry_bus;
  
  genvar i;
  
  for (i = 0 ; i < DATA_WIDTH; i = i + 1) begin : FA_NODES
    
    if (i==0) begin
      
      full_adder full_adder_inst(
    
        .a(a[0]),
      	
        .b(b[0]),
        
        .cin(cin),
        
        .sum(sum_bus[0]),
        
        .cout(carry_bus[0])
        
      );
      
      
    end else begin
      
      full_adder full_adder_inst(
    
        .a(a[i]),
      	
        .b(b[i]),
        
        .cin(carry_bus[i-1]),
        
        .sum(sum_bus[i]),
        
        .cout(carry_bus[i])
        
      );
      
    end
      
    
    assign sum = sum_bus;
  
    assign cout = carry_bus[DATA_WIDTH - 1];

  end
  
endmodule
  
// Inlcude Full Adder modules 
module half_adder (
  input a,
  input b,
  output logic sum,
  output logic cout
);
  
  assign sum = a ^ b;
  
  assign cout = a & b;
  
endmodule

module full_adder (
    input a,
    input b,
    input cin,
    output logic sum,
    output logic cout
);

  bit sum_prev, cout_prev, cout_next, sum_next;
	
  assign cout = cout_next | cout_prev;
  
  assign sum = sum_next;
    
  half_adder u0 (
    .a(a),
    .b(b),
    .sum(sum_prev),
    .cout(cout_prev)
  );
  
    half_adder u1 (
    .a(sum_prev),
    .b(cin),
    .sum(sum_next),
    .cout(cout_next)
  );
endmodule

// Ripple Adder 

module ripple_adder #(parameter
    DATA_WIDTH=8
) (
    input [DATA_WIDTH-1:0] a,
    input [DATA_WIDTH-1:0] b,
    output logic [DATA_WIDTH-0:0] sum,
    output logic [DATA_WIDTH-1:0] cout_int
);

  wire  [DATA_WIDTH-0:0] sum_bus;
    
  wire  [DATA_WIDTH-1:0] cout_int_bus;
  
  assign sum = sum_bus;
  
  assign cout_int = cout_int_bus;
  
  genvar i;
  
  for ( i = 0; i <= DATA_WIDTH; i = i + 1)  begin : adder_instances // Named generate block
    
    if (i == 0) begin
        
      full_adder u_full_adder(
        
        .a(a[0]),
        
        .b(b[0]),
        
        .cin(1'b0), 
        
        .sum(sum_bus[0]), 
        
        .cout(cout_int_bus[0])
        
      );
    
      
      
    end else if ( i == DATA_WIDTH ) begin
         
      full_adder u_full_adder(
        
        .a(1'b0),
        
        .b(1'b0),
        
        .cin(cout_int_bus[i - 1]), 
        
        .sum(sum_bus[i]), 
        
        .cout()
        
      );
    
      
    
    end else begin
      
      full_adder u_full_adder(
        
        .a(a[i]),
          
        .b(b[i]),
          
        .cin(cout_int_bus[i - 1]), 
        
        .sum(sum_bus[i]), 
          
        .cout(cout_int_bus[i])
      
      );
      
    end
    
  end 
  
  

endmodule

