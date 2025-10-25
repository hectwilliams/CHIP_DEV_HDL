

module question_histogram_shamed_tb;
  
	
  parameter MAX_SEQ_SIZE = 16;

  parameter HISTO_BIN_MAX = 1024;

  parameter N_512 = 512;

  parameter N_SEQUENCES = 5;
  
  parameter N_EVAL_ADDRES = 4 ;

  bit  [MAX_SEQ_SIZE - 1 : 0] bit_valid [N_SEQUENCES] ;

  bit  [MAX_SEQ_SIZE - 1 : 0] bit_seq [N_SEQUENCES] ;
	
  bit go, go_z,go_zz, valid_request, valid_request_z, valid_request_zz ;
  
  logic clk;
  
  bit [3:0] addr, addr_z;
  
  bit data_valid, data_valid_z, data_valid_send, data_valid_send_z;
  
  bit data_in;

  bit hist_int, hist_int_zz, hist_int_z;
    
  bit [$clog2(N_SEQUENCES) : 0] index_sequence;
  
  bit [$clog2(N_512): 0] counter;
  
  bit [$clog2(HISTO_BIN_MAX) ] hist_data;
  
  bit [3:0] rom_eval_indices [N_EVAL_ADDRES];
  
  typedef enum {
    
    IDLE, PULSE, SEND,  INCRE, REQUEST,  DONE} fsm_t;
  
  fsm_t state, state_z, state_zz , state_zzz;
  
  initial begin
    
    clk = 0;
    
    forever #(2) clk = ~clk;
    
  end
  
  initial begin
    
    bit_seq[0]  = 16'b0000_0000;
    
    bit_seq[1]  = 16'b0000_0000;
    
    bit_seq[2]  = 16'b0000_0000;
    
    bit_seq[3]  = 16'b0000_0000;

  end
  
  initial begin
    
    // 4 unique sequence lengths
    
    bit_valid[0]= 16'b0000_1100; // N = 2
        
    bit_valid[1]= 16'b0111_0000; // N = 3
    
    bit_valid[2]= 16'b0001_0000; // N = 1

    bit_valid[3]= 16'b1111_1111; // N = 8
    
    bit_valid[4]= 16'b1100_0000; // N = 2

    
    state = IDLE;
    
    rom_eval_indices[0] = 2;
    
    rom_eval_indices[1] = 3;

    rom_eval_indices[2] = 1;
    
    rom_eval_indices[3] = 8;

  end

  always @ (posedge clk)  begin
    
    hist_int_z <= hist_int;
       
    hist_int_zz <= hist_int_z;
 
    data_valid_z <= data_valid;
    
    data_valid_send_z <= data_valid_send;
    
    state_z <= state;
    
    valid_request_z <= valid_request;
    
    valid_request_zz <= valid_request_z;
    
    go_zz <= go_z;
    
    go_z <= go;
    
    addr_z <= addr;
    
    case(state) 
      
      IDLE: begin 
        addr <= 0;
        hist_int <= 0;
        data_in <= 0;
        data_valid <= 0;
        state <= PULSE;
        index_sequence <= 0;
        counter <= 0;
      end
      
      PULSE: begin
        
        hist_int <= 1;
        data_valid_send <= 0;
        counter <= 0;
        state <= SEND;
      end
      
      SEND: begin 
    	
        hist_int <= 0;
            
        if (counter == MAX_SEQ_SIZE - 1) begin

          data_valid_send <= 0;
          
        end else if ( hist_int_z ) begin

          data_valid_send <= 1;

        end
        
        if ( hist_int_zz  || (counter > 0 && counter < MAX_SEQ_SIZE - 1)) begin

          counter <= counter + 1;          
            
          data_valid <= bit_valid[index_sequence][counter];
                              
          data_in <= bit_seq[index_sequence][counter];
          
        end
      	
        if (data_valid_send_z & ~data_valid_send) begin
          
          state <= INCRE;
                  
          data_valid <=0;
			
          data_in <=0;
          
        end
      
      end
      
      INCRE: begin
        
        index_sequence <= index_sequence +1;

        if ( index_sequence   != N_SEQUENCES - 1) begin
          
          state <= PULSE;
          
        end  else begin 
          
          state <= REQUEST;
          index_sequence <= 0;
          
          go <= 1;
          
        end
        
      end
        
      REQUEST : begin
        
		go <= 0;
        
        if (go_z) 
          
          valid_request <= 1;
        
        if (index_sequence == N_EVAL_ADDRES - 1)
          
          valid_request <= 0;
        
		
        if ( go_zz || index_sequence > 0 && index_sequence < N_EVAL_ADDRES ) begin
          
          index_sequence <= index_sequence + 1;
          
          addr <= rom_eval_indices[index_sequence] ;
 
        end
        
        // valid_request --send request 
        // valid_request_z -- DUT processes request
        // valid_request_zz -- Data (histo tags ) are ready 
        
        if (valid_request_zz) 
          $display("prev_addr_ff [%0d] next_histo_ff [%0d] ", addr_z, hist_data);
          
        if (valid_request_zz & ~valid_request_z)
          state <= DONE;
        
      end
      
      DONE : begin 
                    
        $finish;
     
      end
      
      
    endcase 
    
    
  end
  

  always @ (hist_data )  begin

    //$display("addr  %d data  %d", addr , hist_data ) ;

  end

  
  question_histogram_shamed u0(
    .clk(clk),
    .data_in(data_in),
    .data_valid(data_valid),
    .hist_int(hist_int),
    .addr(addr),
    .hist_data(hist_data)
  
  );
  
endmodule;
