LIBRARY std;
USE std.standard.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY CustomProcessor_tb IS
END CustomProcessor_tb;

ARCHITECTURE test OF CustomProcessor_tb IS

    COMPONENT CustomProcessor
        PORT (
            in_clock, in_reset : IN STD_LOGIC;
            dataX : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL clock, reset : STD_ULOGIC;
    SIGNAL dataX : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    processor : CustomProcessor PORT MAP(in_clock => clock, in_reset => reset, dataX => dataX);

    PROCESS BEGIN
        reset <= '0';
        FOR ii IN 0 TO 100 LOOP
            clock <= '0';
            WAIT FOR 1 ms;
            clock <= '1';
            WAIT FOR 1 ms;
        END LOOP;
        ASSERT false REPORT "Reached end of test";
        WAIT;
    END PROCESS;
END test;
