# Makefile

# defaults
SIM ?= icarus
TOPLEVEL_LANG ?= verilog

VERILOG_SOURCES += $(PWD)/src/nandgate.sv
VERILOG_SOURCES += $(PWD)/src/andgate.sv
VERILOG_SOURCES += $(PWD)/src/notgate.sv
VERILOG_SOURCES += $(PWD)/src/globals.sv

# COCOTB_TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
COCOTB_TOPLEVEL = nandgate

# COCOTB_TEST_MODULES is the basename of the Python test file(s)
COCOTB_TEST_MODULES = test

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim