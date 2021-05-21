library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 
use ieee.std_logic_unsigned.all;
-- use ieee.numeric_std.all;

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

    component generic_adder is
        generic (n: natural :=16);
        port (
            input_a : in std_logic_vector (n-1 downto 0);
            input_b : in std_logic_vector (n-1 downto 0);
            output_sum : out std_logic_vector (n-1 downto 0);
            carry : out std_logic
        );
    end component;

    component generic_nand is
        generic (n: natural :=16);
        port (
            input_a : in std_logic_vector (n-1 downto 0);
            input_b : in std_logic_vector (n-1 downto 0);
            output_nand : out std_logic_vector (n-1 downto 0)
        );
    end component;

    signal temp_result_sum :  std_logic_vector(n-1 downto 0);
    signal temp_result_nand : std_logic_vector(n-1 downto 0);
    signal temp_output_alu : std_logic_vector(n-1 downto 0);
    signal temp_c : std_logic;
    signal temp_z : std_logic;

begin

    temp_c <= '0';
    temp_z <= '0';
 
    adder : generic_adder port map (input_a => in_a, input_b => in_b, output_sum => temp_result_sum, carry => temp_c);
    naand : generic_nand port map (input_a => in_a, input_b => in_b, output_nand => temp_result_nand);
    
    process (operation, temp_result_sum, temp_result_nand)
    begin
        case operation is
            when '0' =>
                temp_output_alu <= temp_result_sum;
                c_out <= temp_c and not operation;   
                -- operation 0, means addition and 1 means nand
            when others =>
                temp_output_alu <= temp_result_nand;
        end case;
    
        if temp_output_alu =  x"0000" then
            temp_z <= '1';
        end if;
    
        output_alu <= temp_output_alu;
        z_out <= temp_z;    

    end process;

end alu_arch;
