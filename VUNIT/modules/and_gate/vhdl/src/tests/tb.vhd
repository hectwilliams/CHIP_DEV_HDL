library IEEE;
use IEEE.std_logic_1164.all;

library vunit_lib;
context vunit_lib.vunit_context; -- vunit context 

library vhd_lib; -- hdl files 

use vunit_lib.event_common_pkg.all; -- events

use vhd_lib.globals.all; -- custom package 

entity tb is
	generic(runner_cfg: string); 
end tb;

architecture sim of tb is 
	
    component nandgate is 
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

                -- wait                 
                wait until falling_edge(clk);

                -- set inputs 
                a <= '0';
                b <= '0';

                -- wait 
                wait until rising_edge(clk);
                check(c = '1', "Expect 1");

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

	uut2: entity vhd_lib.nandgate
	    port map (
			a => a,
			b => b,
			c => c
		);

end sim;