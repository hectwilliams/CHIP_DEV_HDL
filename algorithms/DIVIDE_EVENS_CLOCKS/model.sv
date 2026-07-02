module model (
  input clk,
  input resetn,
  output logic div2,
  output logic div4,
  output logic div6
);

  bit clocks_running;
  
  bit [5:0] counter_2;
  bit [5:0] counter_4;
  bit [5:0] counter_6;
  

  always @ (posedge clk or negedge resetn) begin
	
    if (~resetn) begin
      
      div2 <= 0;
      
      div4 <= 0;
      
      div6 <= 0;
      
      clocks_running <= 0;
      
    end else if (~clocks_running) begin
      
      // sync start edge clocks 
		
      clocks_running <= 1;
      
      div2 <= 1;
      
      div4 <= 1;
      
      div6 <= 1;
      
      counter_2 <= 0;
      
      counter_4 <= 1;

      counter_6 <= 2;
      
    end else begin

      div2 <= ~div2;

      // handle clock edge events
        
        if (counter_2 == 0 ) begin 
          
          div2 <=  ~div2;
          
        end
      	
        if (counter_4 == 0 ) begin

          div4 <= ~div4;

          counter_4 <= 1;

        end else if( counter_4 > 0) begin

          counter_4 <= counter_4 - 1;	

        end

         
      if (counter_6 == 0 ) begin

          div6 <= ~div6;

          counter_6 <= 2;

      end else if( counter_6 > 0) begin

        counter_6 <= counter_6 - 1;	

      end

    end
    
  end
  
endmodule
