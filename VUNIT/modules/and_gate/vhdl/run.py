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

SRC_PATH = Path(__file__).parent / "src"
SRC_FILES_PATH = SRC_PATH  / "*.vhd"
SRC_TESTS_PATH = SRC_PATH / "tests" / "*.vhd"
lib1 = vu.add_library("vhd_lib").add_source_files(SRC_FILES_PATH,  file_type='vhdl')
lib2 = vu.add_library("vhd_tb_lib").add_source_files(SRC_TESTS_PATH, file_type='vhdl')
# vu.add_source_files(SRC_PATH / "tests" / "tb_andgate.vhd","vhd_lib", no_parse=True)
# vu.add_source_files(SRC_PATH / "tests" / "tb_callback_andgate.vhd","vhd_lib", no_parse=True)

vu.main()

