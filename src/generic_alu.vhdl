library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity alu is
    generic(n: natural :=16);
    port (
    
            in_a : in std_logic_vector(n-1 downto 0);
            in_b : in std_logic_vector(n-1 downto 0);
            operation  : in std_logic
            z_out   : out std_logic
            c_out   : out std_logic
            output_alu  : out std_logic_vector(n-1 downto 0)
        ) ;

end alu ; 

architecture alu_arch of alu is

    component generic_adder is
        generic map ( n => 16)
        port (
            input_a : in std_logic_vector (n-1 downto 0);
            input_b : in std_logic_vector (n-1 downto 0);
            output_sum : out std_logic_vector (n-1 downto 0);
            carry : out std_logic
            ) ;
    end component;

    component generic_nand is
        generic map ( n => 16)
        port (
            input_a : in std_logic_vector (n-1 downto 0);
            input_b : in std_logic_vector (n-1 downto 0);
            output_nand : out std_logic_vector (n-1 downto 0)
            ) ;
    end component;

    signal temp_result_sum :  std_logic_vector(n-1 downto 0);
    signal temp_result_nand : std_logic_vector(n-1 downto 0);
    signal temp_c : std_logic := 0;
    signal temp_z : std_logic := 0;

    begin

        adder : generic_adder port map (input_a => in_a, input_b => in_b, output_sum => temp_result_sum, carry => temp_c);
        naand : generic_nand port map (input_a => in_a, input_b => in_b, output_nand => temp_result_nand)

        case operation is
        
            when "0" =>
                output_alu = temp_result_sum
                c_out <= temp_c and not operation   
                -- operation 0, means addition and 1 means nand.

            when others =>
                output_alu = temp_result_nand
            
        end case ;


        if (output_alu and x"0000") /=  x"0000" then
            temp_z <= "1"

        end if ;

        z_out <= temp_z;

    end alu_arch ;