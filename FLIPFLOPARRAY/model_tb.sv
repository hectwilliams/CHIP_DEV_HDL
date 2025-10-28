module model_tb;
  parameter DATA_WIDTH=8;
  
  bit [DATA_WIDTH-1:0] a;
    
  bit [DATA_WIDTH-1:0] b;
    
  bit [DATA_WIDTH-0:0] sum;
    
  bit [DATA_WIDTH-1:0] cout_int;
  
  initial begin
  
    a = 'd3;
    b = 'd3;
    
    #20
    
    $display("a - %d b - %d  sum %b cout %b", a, b, sum, cout_int);
    
    
    a = 'd7;
    b = 'd10;
    
    #20
    
    $display("a - %d b - %d  sum %b(%d) cout %b", a, b, sum, sum, cout_int);
    
    
    a = 'd123;
    b = 'd189;
    
    #20
    
    $display("a - %d b - %d  sum %b(%d) cout %b", a, b, sum, sum, cout_int);
    
  end
  
  model #(DATA_WIDTH) u0 (
    .a(a),
    .b(b),
    .sum(sum),
    .cout_int(cout_int)
  );
  
endmodule 


