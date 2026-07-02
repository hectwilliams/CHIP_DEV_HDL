module module_tb;
  
  parameter SAMPLES = 11;
  
  logic clk;
  
  logic resetn, resetn_tb;
  
  logic din;
  
  logic cen;
  
  logic doutx;
  
  logic douty;
 
  bit go, go_z, go_zz;
  
  bit valid, valid_z, valid_zz, valid_zzz;
  
  bit [$clog2(SAMPLES):0 ] counter, counter2; 
  
  bit  [0 :SAMPLES -1 ] cen_stream;

  bit  [0 : SAMPLES -1 ] din_stream;

  bit  [0 : SAMPLES -1 ] resetn_stream;

    
  bit  [0 : SAMPLES -1 ] x_result;
  
  bit  [0 : SAMPLES -1 ] y_result;

  initial begin
    
    cen_stream =    'b11111111011;

    din_stream =    'b01111111010;
    
    resetn_stream = 'b11111110111;
    
  end
  
  initial begin
    clk = 0;
    
    forever #1 clk = ~clk;
    
  end
  
  initial begin
    
    resetn_tb = 0;
    
    #2
    
    resetn_tb = 1;
    
  end
  
  initial begin 

    resetn = 0; 

    cen = 1;
    
    din = 0;
    
  end
  
  function void print_douts( bit [SAMPLES - 1 : 0]  collection);
    
    
    for (int i = 0; i < SAMPLES; i= i + 1) begin
      
      $write("[%d]", collection[i]);
      
    end
    
    $write("\n");
    
  endfunction
    
  always @ ( posedge clk or negedge resetn_tb) begin
    
    go_z <= go;

    go_zz <= go_z;
	
    valid_z <= valid;
    
    valid_zz <= valid_z;
    
    valid_zzz <= valid_zz;
    
    if (~resetn_tb) begin

      go <= 1;

      counter <= 0;
      
      counter2 <= 0;

    end else begin

      go <= 0;  

      if ((go_z & ~go) ) begin

        valid <= 1;

      end else if(counter == SAMPLES - 1) begin

        valid <= 0;

      end

      if ( (go_zz & ~go_z) ||  (counter > 0 && counter < SAMPLES) ) begin

        counter <= counter + 1;
        
        resetn <= resetn_stream[counter];
                
        din <= din_stream[counter];
        
        cen <= cen_stream[counter];

      end

      if ( valid_zz) begin
        
        /* store verification  */
        
        counter2 <= counter2 + 1;
        
        x_result[counter2] <= doutx;
        
        y_result[counter2] <= douty;

      end
      
      if (valid_zzz && ~valid_zz) begin
               
        /* enjoy */
        
        $display ("DOUTX  [%b]", x_result);

        $display ("DOUTY  [%b]", y_result);

        $finish;
      end

    end
    
  end
  
  model  model_inst (
  	
    .clk(clk),
    
    .resetn(resetn) ,
    
    .din(din) ,

    .cen(cen) ,
    
    .doutx(doutx) ,
    
    .douty(douty) 

  );
  
endmodule
