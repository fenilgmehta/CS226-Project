# CS226-Project


### References
- https://www.seas.upenn.edu/~ese171/vhdl/vhdl_primer.html
- https://www.ics.uci.edu/~jmoorkan/vhdlref/vhdl.html
- https://ghdl.readthedocs.io/en/stable/using/QuickStartGuide.html
- https://ghdl.readthedocs.io/en/latest/using/InvokingGHDL.html?highlight=synopsys#cmdoption-ghdl-fsynopsys
- https://youtu.be/lMw0ps1iTz0 - How to install and use GHDL on Ubuntu
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
