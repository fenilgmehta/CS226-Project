# CS226-Project

- **Subject** - Digital Logic Design (CS 226)

- **Project** - Design a multi-cycle processor with a custom Instruction Set Architecture (ISA) called IITB-Proc
    - [Problem Statement PDF](./Project-Multicycle-RISC-IITB.pdf)
    - [Design Report](./Design%20Report.pdf)

- **Team Members**
    - 203050003 - Aditya Jain
    - 203050054 - Fenil Mehta
    - 203050110 - Vipin Mahawar
    - 203050008 - Sagar Tyagi
    - 203050115 - Amit Hari (Permission taken from Sir as he could not find a team)


### Execution Steps

```sh
cd src
./run.sh

# OR

ghdl -s --ieee=synopsys -fexplicit *.vhdl  # Check syntax
ghdl -a --ieee=synopsys -fexplicit *.vhdl  # Analyse the code
# ghdl -c --ieee=synopsys -fexplicit *.vhdl  # Compile
ghdl -e --ieee=synopsys -fexplicit customprocessor_tb  # Execute the code

# Launch gtkwave
ghdl -r --ieee=synopsys -fexplicit customprocessor_tb --vcd=custom_processor.vhd

gtkwave custom_processor.vhd
```


### Project Structure Description
- [`custom_processor_TestBench.vhdl`](./src/custom_processor_TestBench.vhdl) - code to test the custom processor
- [`custom_processor.vhdl`](./src/custom_processor.vhdl) - the primary processor manager
- [`fsm.vhdl`](./src/fsm.vhdl) - Contains the Finite State Machine (FSM)
- [`memory.vhdl`](./src/memory.vhdl) - Simulated RAM
- [`register_file.vhdl`](./src/register_file.vhdl) - Register file (made of 8 registers of 16 bits each)
- [`generic_register.vhdl`](./src/generic_register.vhdl) - Used to make Condition Control registers
- [`generic_alu.vhdl`](./src/generic_alu.vhdl) - Arithmetic and Logic Unit
- [`generic_adder.vhdl`](./src/generic_adder.vhdl) - Full Adder
- [`generic_nand.vhdl`](./src/generic_nand.vhdl) - NAND operator
- [`mux_n_bit_2_to_1.vhdl`](./src/mux_n_bit_2_to_1.vhdl) - 2:1 Multiplexer
- [`mux_n_bit_4_to_1.vhdl`](./src/mux_n_bit_4_to_1.vhdl) - 4:1 Multiplexer


### References

- https://www.seas.upenn.edu/~ese171/vhdl/vhdl_primer.html
- https://www.ics.uci.edu/~jmoorkan/vhdlref/vhdl.html
- https://ghdl.readthedocs.io/en/stable/using/QuickStartGuide.html
- https://ghdl.readthedocs.io/en/latest/using/InvokingGHDL.html?highlight=synopsys#cmdoption-ghdl-fsynopsys
- https://youtu.be/dvLeDNbXfFw - Getting Started with VHDL on Linux (GHDL & GTKWave)
- https://youtu.be/lMw0ps1iTz0 - How to install and use GHDL on Ubuntu
- https://www.youtube.com/watch?v=uMO1FxZ0LO8 - VHDL Process

    ```sh
    sudo apt install gnat checkinstall
    git clone https://github.com/ghdl/ghdl/
    cd ghdl
    ./configure --prefix=/usr/local
    make
    sudo checkinstall make install  # If you execute this command without "--install=no" flag, it will automatically create deb package and install it on your system.
    # sudo apt remove ghdl  # To uninstall GHDL

    ghdl -s filename.vhdl  # Check syntax
    ghdl -a filename.vhdl  # Analyze
    ghdl -s filename_tb.vhdl
    ghdl -a filename_tb.vhdl

    ghdl -e filename_tb

    ghdl -s --ieee=synopsys -fexplicit filename.vhdl
    ```

- https://askubuntu.com/a/1278739 - Use `checkinstall` to easily uninstall packages installed from source
    - https://medium.com/swlh/how-to-remove-a-package-installed-from-source-code-on-ubuntu-wsl2-dce36cc8086a#:~:text=sudo%20apt-get%20install%20checkinstall
- https://www.youtube.com/watch?v=5d2okyFNjkA&list=PLEdaowO6UzNENeQ2WHyGC6mlmggnnhMD6
    - https://youtu.be/v5nw4-kln28 - VHDL Tutorial: Half Adder using Behavioral Modeling
    - https://youtu.be/wORV_IT-Rao - VHDL Tutorial: Full Adder using Structural Modeling (port map)
    - https://youtu.be/IEUSUVw_CkQ - VHDL Tutorial: 4:1 Mux using With Select Statement (STD_LOGIC_vector, port map)
    - https://youtu.be/UMyFbuHKV2w - VHDL Tutorial: 2:4 Decoder using Behavioral Modeling (STD_LOGIC_vector)
    - https://youtu.be/JeEisPlMMiE - VHDL Tutorial: SISO Register using Structural Modeling
    - https://youtu.be/P56oe1ZkDF0 - VHDL Tutorial: Design of Finite State Machine
        - https://www.youtube.com/watch?v=P56oe1ZkDF0&list=PLEdaowO6UzNENeQ2WHyGC6mlmggnnhMD6&index=32
- https://stackoverflow.com/questions/11927144/what-s-the-difference-between-and-in-vhdl
- https://web.engr.oregonstate.edu/~sllu/vhdl/lec2f.html#:~:text=--%20had%20x%20been%20a%20variable%20(x%3A%3D%601%60)%2C%20its%20new%20value%2C%20%601%60%2C%20would%20be%20available%20(action_1%20would%20have%20been%20performed).
- https://www.nandland.com/vhdl/tips/variable-vs-signal.html#:~:text=Signals%20vs.,assigned%20in%20a%20single%20process.
