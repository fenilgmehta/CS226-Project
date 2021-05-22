library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity register_file is
    port (
        A1, A2,	A3: in std_logic_vector(2 downto 0);  -- because we have 8 register
        D3_in: in std_logic_vector(15 downto 0);
        clk, register_write: in std_logic;
        D1_out, D2_out: out std_logic_vector(15 downto 0)
    );
end entity;

architecture register_file_arch of register_file is

    type regarray is array(7 downto 0) of std_logic_vector(15 downto 0);
    signal RegisterFile: regarray:= (others => x"0000");

begin

    D1_out <= RegisterFile(conv_integer(A1));
    D2_out <= RegisterFile(conv_integer(A2));

    A:process (register_write,D3_in,A3,clk)
    begin
        if(register_write = '1') then
            if(rising_edge(clk)) then
                RegisterFile(conv_integer(A3)) <= D3_in;
            end if;
        end if;
    end process;

end register_file_arch;