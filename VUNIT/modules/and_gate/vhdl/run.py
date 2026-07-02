"""
VHDL AND GATE

Showcasing usage of vunit on a module 
"""
def post_check(test_case):
    # read_results_file()
    print(test_case)
    return True


from pathlib import Path
from vunit import VUnit

vu = VUnit.from_argv()
vu.add_vhdl_builtins()
# * Use `from_argv(compile_builtins=False)` or `from_args(compile_builtins=False)`.
# * Add an explicit call to 'add_vhdl_builtins'.
# vu.add_osvvm() # open source vhdl verification 
# vu.add_verification_components()

SRC_PATH = Path(__file__).parent / "src"
SRC_FILES_PATH = SRC_PATH  / "*.vhd"
SRC_TESTS_PATH = SRC_PATH / "tests" / "*.vhd"
lib1 = vu.add_library("vhd_lib").add_source_files(SRC_FILES_PATH,  file_type='vhdl')
lib2 = vu.add_library("vhd_tb_lib").add_source_files(SRC_TESTS_PATH, file_type='vhdl')

# vu.add_source_files(SRC_PATH / "tests" / "tb_andgate.vhd","vhd_lib", no_parse=True)
# vu.add_source_files(SRC_PATH / "tests" / "tb_callback_andgate.vhd","vhd_lib", no_parse=True)

vu.main()

# tb = lib1.add_testbench("my_tb"); 
# print(SRC_TESTS_PATH)
# print('hello world')
# tb.set_post_check(post_check)
# /Users/hectorwilliams/Documents/Dev/repos/CHIP_DEV_HDL/VUNIT/modules/and_gate/src/and_gate.vhd
# /Users/hectorwilliams/Documents/Dev/repos/CHIP_DEV_HDL/VUNIT/modules/and_gate/src/

