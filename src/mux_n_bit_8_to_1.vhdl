library ieee;
use ieee.std_logic_1164.all;

-- REFER: https://www.seas.upenn.edu/~ese171/vhdl/vhdl_primer.html#:~:text=another%20example%20using%20the%20case%20construct%20is%20a%204-to-1%20mux.

entity mux_n_bit_8_to_1  is
    -- generic (n: natural :=16);
    port(
        I7, I6, I5, I4, I3, I2, I1, I0: in std_logic_vector(15 downto 0);
        S: in std_logic_vector(2 downto 0);
        O: out std_logic_vector(15 downto 0)
    );
end mux_n_bit_8_to_1;


architecture mux_n_bit_8_to_1_arch of mux_n_bit_8_to_1 is
begin

    process(S, I7, I6, I5, I4, I3, I2, I1, I0)
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
            when others => O <= "XXXXXXXXXXXXXXXX";
        end case;
    end process;

end mux_n_bit_8_to_1_arch;
