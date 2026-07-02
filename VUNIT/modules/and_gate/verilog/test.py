import cocotb
from cocotb.triggers import FallingEdge, Timer, RisingEdge
from cocotb.clock import Clock

PERIOD_CLK= (1, "ns")


# """
#     Generate external clock for DUT
# """
# async def gen_clock(dut) :
#     for _ in range(100):
#         dut.clk.value = 0
#         await Timer(*PERIOD_CLK )
#         dut.clk.value = 1
#         await Timer(*PERIOD_CLK )



@cocotb.test()
async def test1(dut):

   clock = Clock(dut.sim_clk, *PERIOD_CLK).start() 

   cocotb.start_soon(clock)
   
   cocotb.log.info("signal; is (a=%s, b=%s)", dut.b.value, dut.b.value)
   

@cocotb.test()
async def test2(dut):

   clock = Clock(dut.sim_clk,  *PERIOD_CLK).start() 

   cocotb.start_soon(clock)
   
   # set at falling edge
   dut.a.value = 1
   dut.b.value = 1
   
   # wait for falling
   await FallingEdge(dut.sim_clk)
   
   # wait for rising 
   await RisingEdge(dut.sim_clk)

   # Evaluate (a = 1,  b = 1 ; NOT; == 0)
   expected = 0
   measured = dut.dut_not.b.value

   assert expected == measured, f"Expected { expected}, but received {measured}" 

#    cocotb.log.info("signal; is (a=%s, b=%s)", dut.b.value, dut.b.value)
    # run clocks 
    # cocotb.start_soon(clk)  # clock process 

    # # 5 cycle 
    # await Timer(5 , "ns") # wait a bit 
    # await FallingEdge(dut.sim_clk) # wait for falling edge/"negedge"

    # read inputs



    
