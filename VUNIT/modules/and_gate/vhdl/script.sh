#!/bin/bash

docker run  -v "$(pwd)":/work -w /work ghdl/vunit:gcc python3 run.py; 
