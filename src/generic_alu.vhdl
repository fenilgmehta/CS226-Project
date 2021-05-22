library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;
-- use ieee.numeric_std.all;

-- REFER: https://www.fpga4student.com/2017/06/vhdl-code-for-arithmetic-logic-unit-alu.html

entity alu is
    generic(n: natural :=16);
    port (
        in_a : in std_logic_vector(n-1 downto 0);
        in_b : in std_logic_vector(n-1 downto 0);
        operation  : in std_logic;
        z_out   : out std_logic;
        c_out   : out std_logic;
        output_alu  : out std_logic_vector(n-1 downto 0)
    );
end alu; 

architecture alu_arch of alu is

    signal temp_result_sum :  std_logic_vector(n-1 downto 0) := (others => '0');
    signal temp_result_nand : std_logic_vector(n-1 downto 0) := (others => '0');
    signal temp_c : std_logic := '0';
    signal temp_z : std_logic := '0';

    signal temp_output_alu : std_logic_vector(n-1 downto 0) := (others => '0');
    signal temp_for_carry : std_logic_vector(n downto 0) := (others => '0');

begin

    -- temp_c <= '0';
    -- temp_z <= '0';
 
    process (operation, in_a, in_b, temp_result_sum, temp_result_nand)
    begin
 
        case operation is
            when '0' =>
                temp_output_alu <= in_a + in_b;
            when '1' =>
                temp_output_alu <= in_a nand in_b;
            when others =>
                temp_output_alu <= (others => 'Z');  -- Z denotes high impedance
        end case;
    
        if (temp_output_alu = 0) then
            z_out <= '0';
        end if;

    end process;

    temp_for_carry <= ('0' & in_a) + ('0' & in_b);
    c_out <= temp_for_carry(n);
    output_alu <= temp_output_alu;

end alu_arch;
