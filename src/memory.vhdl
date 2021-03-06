LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

LIBRARY std;
USE std.standard.ALL;

-- No reed signal is required as memory read operation is asynchronous.
-- this memory is word addressible
-- word size = 16 bits
-- Memory is ASYNC read and SYNC write

ENTITY SimulatedRAM IS
    PORT (
        addr, mem_data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        clock, mem_write : IN STD_LOGIC;
        mem_data_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE SimulatedRAMArch OF SimulatedRAM IS

    TYPE regarray IS ARRAY(65535 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0); -- defining a new type
    SIGNAL SimulatedRAMStorage : regarray := (
        0 => x"3100",  -- 3100, 0050, 5040
        1 => x"3300",
        2 => x"0050",
        3 => x"0052",
        4 => x"0051",
        5 => x"2050",
        6 => x"3210",
        7 => x"2052",
        8 => x"2051",
        9 => x"4058",
        10 => x"1040",
        11 => x"3020",
        12 => x"5040",
        13 => x"6200",
        OTHERS => x"0000"
    );

BEGIN
    mem_data_out <= SimulatedRAMStorage(conv_integer(addr));
    l_mem_write : PROCESS (addr, mem_data_in, clock, mem_write)
    BEGIN
        IF (mem_write = '1') THEN
            IF (rising_edge(clock)) THEN
                SimulatedRAMStorage(conv_integer(addr)) <= mem_data_in;
            END IF;
        END IF;
    END PROCESS;
END SimulatedRAMArch;
