module model_tb;

  parameter DATA_WIDTH = 24;
  
  bit [DATA_WIDTH - 1 :0 ] a;

  bit [DATA_WIDTH - 1 :0 ] b;
  
  bit [DATA_WIDTH  :0] result;
  
  initial begin
  
    for ( int i = 0; i < 32; i = i + 1) begin
    
      a = $urandom() & ( 2**24 - 1); // random 24 bit value 
      
      b = $urandom() & ( 2**24 - 1);
          
      # 20; // delay thread
            
      $display("MODEL %0d + %0d = %0d\t\tSYSTEM-ALU %d+%d=%d\t\tvalid=%b\t[%d]\t[%d]",a,b,result, a, b, a+b, real'(result) == (a+b), result, a+b);

    end
    

  end
  
  model model_inst (
  
    .a(a),
    
    .b(b),
    
    .result(result)
    
  );
  
  always @ (result) begin
    
    
  end


endmodule;
