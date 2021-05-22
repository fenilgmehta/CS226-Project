library ieee;
USE ieee.std_logic_1164.ALL;

-- REFER: https://www.seas.upenn.edu/~ese171/vhdl/vhdl_primer.html#:~:text=another%20example%20using%20the%20case%20construct%20is%20a%204-to-1%20mux.
-- REFER: https://stackoverflow.com/questions/25550244/what-does-others-0-mean-in-an-assignment-statement#:~:text=The%20statement%20%22Others%20%3D%3E%20',are%20set%20to%20'0'.

entity mux_n_bit_2_to_1  is
    generic (n: natural :=16);
    port(
        i0, i1: in std_logic_vector(n-1 downto 0);
        s0: in STD_LOGIC;
        O: out std_logic_vector(n-1 downto 0)
    );
end mux_n_bit_2_to_1;

architecture mux_n_bit_2_to_1_arch of mux_n_bit_2_to_1 is
begin

    process(s0, i0, i1)
    begin
        case s0 is
            when '0' => O <= i0;
            when '1' => O <= i1;
            when others => O <= (others => 'Z');  -- unused
        end case;
    end process;

end mux_n_bit_2_to_1_arch;
