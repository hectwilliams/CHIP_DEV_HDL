module lfsr_stage #(parameter ID = 1) (

  input clk,
  
  input resetn,
  
  input init_din,
  
  input feedback_din,
  
  output reg dout
  
);
  
  always @ (posedge clk or negedge resetn) begin
  
    if (~resetn) begin
      
      dout <= init_din;
      
    end else begin
      
      dout <= feedback_din;

    end
    
  end
  
endmodule

module lfsr_core_circuit (

  input [7:0] din,
  
  output wire dout
);
  
  assign dout = din[3] ^ din[2] ^ din[1];
  
endmodule 

module model (
    input  clk,
    input  resetn,
    input  [7:0] din,
    input  [7:0] tap,
    output reg [7:0] dout
);

  wire [7 : 0] lsfr_wire_out;
  
  wire lsfr_next;

  bit resetn_z, resetn_zz, resetn_zzz;
  
  always @ (lsfr_wire_out ) begin

    // latch 
    
    dout <= lsfr_wire_out ;
  
  end
    
  genvar i;

  for (i = 0; i < 8; i = i + 1) begin
    
    if (i == 0 ) begin
       
      lfsr_stage #(.ID(i) ) lfsr_stage_inst1(
    
        .clk(clk) ,
      
        .resetn(resetn), 
      
        .init_din(din[i]),

        .dout (lsfr_wire_out[i]),
         
        .feedback_din(lsfr_next)
    
      );
      
    end else begin
      
      lfsr_stage #(.ID(i) ) lfsr_stage_inst2(
    
         .clk(clk) ,

         .resetn(resetn), 
      
         .init_din(din[i]),
      
         .dout (lsfr_wire_out[i]),
         
        .feedback_din( lsfr_wire_out[i - 1] )
      
    );
    
    end
    
  end
  
  lfsr_core_circuit lfsr_core_circuit_inst1(
    
    .din(lsfr_wire_out),

    .dout(lsfr_next)

  );
  
endmodule
