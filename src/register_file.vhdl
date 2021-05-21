
library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;


entity register_file is 
	port (	A1, A2,	A3: in std_logic_vector(2 downto 0);        --because we have 8 register
			reg_data_in_A3: in std_logic_vector(15 downto 0); 
			clk, register_write_bar: in std_logic;
			reg_data_out_A1, reg_data_out_A2: out std_logic_vector(15 downto 0)
        );
end entity;

architecture register_file_arch of register_file is 

    type regarray is array(7 downto 0) of std_logic_vector(15 downto 0);   
    signal RegisterFile: regarray:= (others => x"0000");


    begin
        reg_data_out_A1 <= RegisterFile(conv_integer(A1));
        reg_data_out_A2 <= RegisterFile(conv_integer(A2));

    A:process (register_write_bar,reg_data_in_A3,A3,clk)
        begin
        if(register_write_bar = '0') then

            if(rising_edge(clk)) then

                RegisterFile(conv_integer(A3)) <= reg_data_in_A3;

            end if;

        end if;
      end process;

end register_file_arch;