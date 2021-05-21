library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity generic_nand is
    generic (n: natural :=16);
    port (
        input_a : in std_logic_vector (n-1 downto 0);
        input_b : in std_logic_vector (n-1 downto 0);
        output_nand : out std_logic_vector (n-1 downto 0)
    );
end generic_nand; 

architecture generic_nand_arch of generic_nand is
begin
    output_nand <= input_a nand input_b;
end generic_nand_arch;
