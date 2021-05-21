library ieee;
use ieee.std_logic_1164.all;


entity mux_n_bit_8_to_1  is
	
port(	I7: 	in std_logic_vector(n-1 downto 0);
		I6: 	in std_logic_vector(n-1 downto 0);
		I5: 	in std_logic_vector(n-1 downto 0);
		I4: 	in std_logic_vector(n-1 downto 0);
		I3: 	in std_logic_vector(n-1 downto 0);
		I2: 	in std_logic_vector(n-1 downto 0);
		I1: 	in std_logic_vector(n-1 downto 0);
		I0: 	in std_logic_vector(n-1 downto 0);
		S:	in std_logic_vector(2 downto 0);
		O:	out std_logic_vector(n-1 downto 0)
	);
end mux_n_bit_8_to_1;  


architecture mux_n_bit_8_to_1_arch of mux_n_bit_8_to_1 is
begin
    process(I3,I2,I1,I0,S)

    begin
        case S is
	    when "000" =>	
			O <= I0;
	    when "001" =>	
			O <= I1;
	    when "010" =>	
			O <= I2;
	    when "011" =>	
			O <= I3;
		when "100" =>	
			O <= I4;
	    when "101" =>	
			O <= I5;
	    when "110" =>	
			O <= I6;
	    when "111" =>	
			O <= I7;
	end case;

    end process;
end mux_n_bit_8_to_1_arch;
