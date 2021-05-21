library ieee;
use ieee.std_logic_1164.all;

-- REFER: https://www.seas.upenn.edu/~ese171/vhdl/vhdl_primer.html#:~:text=another%20example%20using%20the%20case%20construct%20is%20a%204-to-1%20mux.
-- REFER: https://stackoverflow.com/questions/25550244/what-does-others-0-mean-in-an-assignment-statement#:~:text=The%20statement%20%22Others%20%3D%3E%20',are%20set%20to%20'0'.

-- TODO: fix the number of occurrences of X based on the value of "n"

entity mux_n_bit_2_to_1  is
    generic (n: natural :=16);
    port(
        I0, I1: in std_logic_vector(n-1 downto 0);
        S: in std_logic_vector(1 downto 0);
        O: out std_logic_vector(n-1 downto 0)
    );
end mux_n_bit_2_to_1;


architecture mux_n_bit_2_to_1_arch of mux_n_bit_2_to_1 is
begin

    process(S, I0, I1)
    begin
        case S is
            when "0" => O <= I0;
            when "1" => O <= I1;
            when others => O <= (others => 'X');
        end case;
    end process;

end mux_n_bit_2_to_1_arch;

entity mux_n_bit_4_to_1  is
    generic (n: natural :=16);
    port(
        I0, I1, I2, I3: in std_logic_vector(n-1 downto 0);
        S: in std_logic_vector(1 downto 0);
        O: out std_logic_vector(n-1 downto 0)
    );
end mux_n_bit_4_to_1;


architecture mux_n_bit_4_to_1_arch of mux_n_bit_4_to_1 is
begin

    process(S, I0, I1, I2, I3)
    begin
        case S is
            when "00" => O <= I0;
            when "01" => O <= I1;
            when "10" => O <= I2;
            when "11" => O <= I3;
            when others => O <= (others => 'X');
        end case;
    end process;

end mux_n_bit_4_to_1_arch;


entity mux_n_bit_8_to_1  is
    -- generic (n: natural :=16);
    port(
        I0, I1, I2, I3, I4, I5, I6, I7: in std_logic_vector(15 downto 0);
        S: in std_logic_vector(2 downto 0);
        O: out std_logic_vector(15 downto 0)
    );
end mux_n_bit_8_to_1;


architecture mux_n_bit_8_to_1_arch of mux_n_bit_8_to_1 is
begin

    process(S, I0, I1, I2, I3, I4, I5, I6, I7)
    begin
        case S is
            when "000" => O <= I0;
            when "001" => O <= I1;
            when "010" => O <= I2;
            when "011" => O <= I3;
            when "100" => O <= I4;
            when "101" => O <= I5;
            when "110" => O <= I6;
            when "111" => O <= I7;
            when others => O <= (others => 'X');
        end case;
    end process;

end mux_n_bit_8_to_1_arch;
