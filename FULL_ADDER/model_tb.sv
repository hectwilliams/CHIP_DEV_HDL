module model_tb;

  bit a, b, cin;
  bit sum, cout;
  
  bit [7:0] a_bits =   'b11110000;
  
  bit [7:0] b_bits =   'b11001100;
    
  bit [7:0] cin_bits = 'b10101010;

  integer index;
 

  initial begin
    

    for ( int i =0; i < 8; i = i + 1) begin
    
      cin = cin_bits[i];
      
      b = b_bits[i];
      
      a = a_bits[i];

      #10 // model metastable endpoints using delay  
      
      $display("a - %d  b - %d. cin - %d sum - %d  cout - %d",a, b, cin, sum, cout );

    end
    
  end
  
  model u0(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum)  ,
    .cout(cout)
    
  
  );
  
  
endmodule
