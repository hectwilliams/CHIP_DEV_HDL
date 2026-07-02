module model #(parameter
  DATA_WIDTH=32
) (
  input [DATA_WIDTH-1:0] din,
  output logic dout
);

  parameter bit [$clog2(DATA_WIDTH):0] mid = DATA_WIDTH / 2;
  
  assign dout = ( (DATA_WIDTH & 1'b1) == 1 ?  
    
                 (((~(din >> (mid + 1) ))& {mid{1'b1}} )    == din[mid-1:0] ) 

    :
                          
                 ((~(din >> (mid ) )) & {mid{1'b1}}  )  == din[mid-1:0] 

    );
  
endmodule
