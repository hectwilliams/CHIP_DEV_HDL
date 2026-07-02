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

module model #(parameter
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
