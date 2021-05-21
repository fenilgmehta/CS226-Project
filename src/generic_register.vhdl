library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity generic_register is
    generic(n: natural :=16);
    port(	
        input_reg: in std_logic_vector(n-1 downto 0);
        clock: in std_logic;
        load_reg: in std_logic;
        output_reg: out std_logic_vector(n-1 downto 0)
    );
end generic_register;


architecture generic_register_arch of generic_register is

    signal output_reg_temp: std_logic_vector(n-1 downto 0);

begin

    process(input_reg, clock, load_reg)
    begin
        if (clock = '1' and clock'event) then  -- positive edge trigger
            if load_reg = '1' then
                output_reg_temp <= input_reg;
            end if;
        end if;
    end process;

    output_reg <= output_reg_temp;

end generic_register_arch;
