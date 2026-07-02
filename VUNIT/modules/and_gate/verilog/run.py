"""
Verilog AND GATE

Showcasing usage of vunit on a module 
"""

from pathlib import Path
from vunit import VUnit

vu = VUnit.from_argv()
vu.add_verilog_builtins()
# vu.add_osvvm() # open source vhdl verification 
# vu.add_verification_components()

lib = vu.add_library("design_lib")

PARENT_DIR = Path(__file__).parent
SRC_FILES_PATH = PARENT_DIR  / "src"/ "*.sv"
SRC_TESTS_PATH = PARENT_DIR / "tests" / "*.sv"

lib.add_source_files(SRC_FILES_PATH) # rtl files 
lib.add_source_files(SRC_TESTS_PATH) # testbench files 

vu.main()

