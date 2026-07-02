#!/bin/bash 

docker run  --rm -it \
    -v "${PWD}/src:/workspace/src" \
    -v "${PWD}/tests:/workspace/src" \
    -w /workspace \
    vunit-icarus-sv \ 
    python3 run.py;   ls /usr/bin/
