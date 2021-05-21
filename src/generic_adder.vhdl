library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all ;

-- REFER: http://esd.cs.ucr.edu/labs/tutorial/adder.vhd
-- For performing arithmetic directly

entity generic_adder is
    generic(n: natural :=16);
    port (
        input_a : in std_logic_vector (n-1 downto 0);
        input_b : in std_logic_vector (n-1 downto 0);
        output_sum : out std_logic_vector (n-1 downto 0);
        carry : out std_logic
    ) ;
end generic_adder ; 

architecture generic_adder_arch of generic_adder is
    signal temp_n_bit_result : std_logic_vector(n downto 0);
    -- Storing result in n bit and will use the nth bit as carry
begin
    temp_n_bit_result <= ('0' & input_a) + ('0' & input_b);
    output_sum <= temp_n_bit_result(n-1 downto 0);
    carry <= temp_n_bit_result(n);
end generic_adder_arch;
