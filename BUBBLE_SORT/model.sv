module concat_me #(parameter BITWIDTH = 1, DEPTH = 1, ID = 1 ) (

  input sortit,
  
  input [BITWIDTH - 1 : 0]  data_in,

  output logic [BITWIDTH - 1 : 0] data_out
);
  
  always @ ( sortit) begin
    
    // latch
    
    if (sortit) begin
      
      data_out = data_in;
      
    end
    
  end

endmodule

module sort_stage #(parameter BITWIDTH = 1, ID = 1, DEPTH = 4) (

  input clk,
  
  input resetn,
  
  input enablen,  // inputs registered when enablen == 0

  input [BITWIDTH - 1:0] din,
  
  input [BITWIDTH - 1:0] feedback,

  output logic [BITWIDTH - 1:0] dout

);
     
  logic [BITWIDTH - 1:0] buffer;

  always @ (posedge clk or negedge resetn) begin
    
    if (~resetn) begin
    
      dout <= 0;
      
      buffer <= 0;
  
    end else begin
      
      if ( din >= buffer && ID == DEPTH - 1 ) begin
        
        // insert on gar right or high side
        
        // replace 
        
			
        if (~enablen) begin
          
          dout <= din;
        
          buffer <= din;
          
        end

      end else if ((din >= buffer) && (din < feedback)) begin
        
        if (~enablen) begin
          
          dout <= din;
        
          buffer <= din;
          
        end
        
      end else if (din >= buffer) begin
        
        // left shift 
        
        // replace with feedback value 
        
        if (~enablen) begin
          
          dout <= feedback;

          buffer <= feedback;
          
        end
        
      end
      
    end
    
  end
  
endmodule

module model #(parameter 
    BITWIDTH = 3, DEPTH = 4
) (
    input [BITWIDTH-1:0] din,
    input sortit,
    input clk,
    input resetn,
    output logic [DEPTH*BITWIDTH:0] dout
);

  bit [$clog2(DEPTH): 0] index;
  
  logic [BITWIDTH - 1 : 0] dout_bus [DEPTH];
  
  genvar i, j;
  
  for (i = 0; i < DEPTH; i = i + 1) begin

    if (i == DEPTH - 1) begin
      
      sort_stage #(.BITWIDTH(BITWIDTH) , .ID(i), .DEPTH(DEPTH) ) sort_stage_inst1(

        .clk(clk),

        .resetn(resetn),

        .enablen(sortit),
        
        .din(din),

        .feedback({BITWIDTH{1'b0}}),

        .dout(dout_bus[i])

      );

    end else begin

      sort_stage #(.BITWIDTH(BITWIDTH) , .ID(i) , .DEPTH(DEPTH)) sort_stage_inst0(

        .clk(clk),

        .resetn(resetn),
        
        .enablen(sortit),

        .din(din),
        
        .feedback(dout_bus[i + 1]),

        .dout(dout_bus[i])

      );
      
    end
 
  end
  
  for (j = 0; j < DEPTH; j = j + 1) begin
    
    concat_me #(BITWIDTH, DEPTH, j) concat_me_inst(
    	
      .sortit (sortit), 
      
      .data_in (dout_bus[j] ),
 
      .data_out( dout[ ( (DEPTH- 1 - j) + 1) * BITWIDTH - 1 : (DEPTH- 1 - j) * BITWIDTH] )
      
    );
    
  end
  
  
  always @ (posedge clk or negedge resetn) begin

    if (~resetn) begin

      index <= 0;

    end else begin

      if ( ~sortit) begin

        if (index < DEPTH - 1) begin

          index <= index -1;

        end

      end else begin
        
      end

    end

  end
  
endmodule
