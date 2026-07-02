library IEEE;
use IEEE.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context; -- vunit context 

library vhd_lib; -- hdl files 

use vunit_lib.event_common_pkg.all; -- events

use vhd_lib.globals.all; -- custom package 

entity tb_callback_andgate is
	generic(runner_cfg: string); 
end tb_callback_andgate;

architecture sim of tb_callback_andgate is 
	
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

    -- events 
    signal err_event : event_t := new_event; 
    
begin
    
    stim: process is

	begin
    	
		test_runner_setup(runner, runner_cfg); -- wrap main process 
		
		while test_suite loop

			if run("Test0") then 
                
                -- set inputs 

                a <= '0';
                b <= '0';

                -- create event 
                notify_if_fail( check(c = '1', "Check if output is High" ) , err_event); -- induce a failure 

                -- wait 
                wait for CLK_PERIOD_DIV2;

			end if;

		end loop;
    
		test_runner_cleanup(runner); 

		wait;

	end process;

	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD_DIV2;
		clk <= '1';
		wait for CLK_PERIOD_DIV2;
	end process;

    listener: process 
    begin 
        
        -- async await 
        wait until is_active(err_event);

        -- callback 
        report("Callback alerted!!");
        
        -- prevent infinite loop 
        wait; 

    end process listener; 


	uut:  entity vhd_lib.andgate
		port map (
			a => a,
			b => b,
			c => c
		);

end sim;