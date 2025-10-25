// Create a Verilog module that counts the lengths of bit sequences on the data_in input that are the same value and  
// implements a 16-bin histogram of how many of each sequence length is seen in a 1024-bit sequence. The longest  
// length of a sequence can be 16. The histogram value for a given bin should be readable from the hist_data port one  
// clock cycle after hist_addr is asserted to select the bin. Assume that hist_init is asserted to reset the histogram  
// and any other logic needed to create the histogram. Also, data_valid is never deasserted during the 1024-bit bitstream.  
//
//            __    __    __    __    __    __    __    __    _ //  __    __    __    __    __    __    __
// clk     __|  |__|  |__|  |__|  |__|  |__|  |__|  |__|  |__| // _|  |__|  |__|  |__|  |__|  |__|  |__|  |_
//                                                            //
//                              ____________________________ //____________________________
// data_valid _________________|                            //                             |_______________
//                                                         //
//                              _____       ___________   //        _________________
// data_in    _________________|     |_____|           | //________|                 |______________________
//                                                      //
//                  _____                              //
// hist_init  _____|     |___________________________ //____________________________________________________

module module #(parameter HISTOGRAM_SIZE=1024, MAX_SEQUENCE_LENGTH=16) 
  (
    input clk,
    input logic data_valid,
    input logic data_in,
    input logic hist_int,
    input logic [3:0] addr,
    output logic [9:0] hist_data
  );
  
  bit [HISTOGRAM_SIZE-1 : 0] binsz [16];
	
  bit [$clog2(MAX_SEQUENCE_LENGTH):0] seq_counter, seq_counter_z;
  
  bit data_valid_z;
  
  always @ (posedge clk) begin
    
    data_valid_z <= data_valid;
    
    seq_counter_z <= seq_counter;
    
    if (hist_int ) begin

      seq_counter <= 0;
    
    end else if (data_valid) begin

      seq_counter <= seq_counter + 1;
    
    end
    
    if (data_valid_z & ~data_valid) begin
      
      seq_counter <= 0; // reset after VALID EOF
      
      $display("HISTO_CIRCUIT RCVD SEQUENCE %d " , seq_counter ) ;

      binsz[seq_counter]  <= binsz[seq_counter] + 1;
        
      // fuzzy edge case with valid deasserted with a new addr assertion
		
      if (addr == seq_counter) begin
        
        hist_data <= binsz[addr]  + 1;
     
      end else begin 

        hist_data <= binsz[seq_counter] + 1 ;
      
      end
      
    end else begin
      
      hist_data <= binsz[addr]  ;
      
    end
    
  end
  
endmodule;
