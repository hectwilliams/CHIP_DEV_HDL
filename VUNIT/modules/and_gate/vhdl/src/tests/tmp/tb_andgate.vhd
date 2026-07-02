library IEEE;
use IEEE.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context; -- vunit context 
--context vunit_lib.vc_context;

library vhd_lib;

use vhd_lib.globals.all;

entity tb_andgate is
	generic(runner_cfg: string); 
end tb_andgate;

architecture sim of tb_andgate is 
	
    component andgate is 
    	port(
    		a: in std_logic;
        	b: in std_logic;
        	c: out std_logic
    	);
    end component;
    
    constant CLK_PERIOD: time := 20 ns;
    constant CLK_PERIOD_DIV2 : time  := CLK_PERIOD / 2;
    
	signal clk: std_logic := '0';
	signal a: std_logic := '0';
	signal b: std_logic := '0';
	signal c: std_logic := '0';
    
begin
    
  traffic_logger: process  is
    
    begin
        
        -- conditional debug flags 
        -- debug(" hello world");

        wait on a;
      --  trace(logger, "Got new data set");
    end process traffic_logger;


    stim: process is
        constant logger : logger_t := get_logger("Process  a input");
		constant mychecker : checker_t := new_checker(logger, warning);
		variable bool_state: boolean := true;
	begin
    	
		test_runner_setup(runner, runner_cfg); -- wrap main process 
		
		while test_suite loop

			if run("Test0") then 
			
				report("This test passed");

			elsif run("Test1") then 

				-- set inputs
				a <= '1';
				b <= '1';
				
				-- wait 
				wait for CLK_PERIOD_DIV2;
				
				-- check result 
				check(c = '0', "This should fail but the stop level is set to a warning", warning);
				
				-- wait 
				wait for CLK_PERIOD_DIV2;
				
				-- check result ( notice the first param uses a custom checker object)
				check_equal(mychecker,  c, '0', result("for AND gate") );

				-- wait 
				wait for CLK_PERIOD_DIV2;


			elsif run("Test2") then 

				-- set inputs

				a <= '0';
				
				b <= '0';

				-- wait 
				wait for CLK_PERIOD_DIV2;
				
				-- check result 
				
				check(c = '0', "Expect");


			elsif run("Test3") then 

				-- set inputs

				a <= '1';
				
				b <= '1';

				-- wait 
				wait for CLK_PERIOD_DIV2;
				
				-- check result 
				check(c = '1', "Expect");

			elsif  run("Test4") then 

				-- set inputs

				a <= '1';
				
				b <= '1';
				
				-- wait 
				wait for CLK_PERIOD_DIV2;
				
				-- check result 
				check(c = '1', "Expect");

			elsif  run("Test5") then 

				-- set inputs

				a <= '0';
				
				b <= 'X';
				
				-- wait 
				wait for CLK_PERIOD_DIV2;
				
				-- check result  ( failed check returns  a boolean; DOES NOT STOP SIMULATION)
				
				check(bool_state, c = '0', "Expect" ) ;

				if bool_state = true then
					show(get_logger(default_checker), display_handler, pass); -- force pass messages to print 
					check(true, "Test failed but simulation continues"); -- true assertion; effectively passing  (boolean, string)
				end if;

				
				-- wait 
				wait for CLK_PERIOD_DIV2;
				

			end if;
	
		end loop;

		test_runner_cleanup(runner); 

		-- assert false report "simuation finished" severity failure; ( remove tb termination code)

		wait;
	end process;

	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD_DIV2;
		clk <= '1';
		wait for CLK_PERIOD_DIV2;
	end process;
	
	loggerz : process
	begin
		if rising_edge(clk) then 
		--	report "Your warning message here";
		--	severity warning;                
		end if;
		wait;
	end process;

	uut:  entity vhd_lib.andgate
		port map (
			a => a,
			b => b,
			c => c
		);

end sim;