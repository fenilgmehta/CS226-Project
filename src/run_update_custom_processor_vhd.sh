#!/bin/bash
ghdl -s --ieee=synopsys -fexplicit *.vhdl
ghdl -a --ieee=synopsys -fexplicit *.vhdl
# ghdl -c --ieee=synopsys -fexplicit *.vhdl
ghdl -e --ieee=synopsys -fexplicit customprocessor_tb  # This will execute the test bench

#ghdl -r --ieee=synopsys -fexplicit customprocessor_tb  # This will execute the test bench
ghdl -r --ieee=synopsys -fexplicit customprocessor_tb --vcd=custom_processor.vhd

