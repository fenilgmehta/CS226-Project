library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;	 
use ieee.std_logic_unsigned.all;

library std;
use std.standard.all;


-- since The Memory is asynchronous read, there is no read signal.
-- this memory is word addressible
-- word size = 16 bits

entity Memory_asyncread_syncwrite is 
	port (addr,mem_data_in: in std_logic_vector(15 downto 0); clk,mem_wr: in std_logic;
				mem_data_out: out std_logic_vector(15 downto 0));
end entity;

architecture MemoryArch of Memory_asyncread_syncwrite is 

type regarray is array(31 downto 0) of std_logic_vector(15 downto 0);   -- defining a new type
signal SimulatedRAM: regarray:=(
	0 => x"4054",
	1 => x"6000",
	2 => x"c042",
	3 => x"0210",
	4 => x"c4c3",
	7 => x"13be",
	8 => x"2128",
	9 => x"0a32",
	10 => x"c982",
	11 => x"212a",
	12 => x"3caa",
	13 => x"5044",
	14 => x"8202",
	16 => x"91c0",
	18 => x"7000",
	19 => x"f000",
	20 => x"0014",
	21 => x"0002",
	23 => x"0016",
	24 => x"ffff",
	26 => x"ffff",
	27 => x"0012",
	others => x"0000");
	

begin
mem_data_out <= SimulatedRAM(conv_integer(addr));
mem_write:
process (mem_wr,mem_data_in,addr,clk)
	begin
	if(mem_wr = '1') then
		if(rising_edge(clk)) then
			SimulatedRAM(conv_integer(addr)) <= mem_data_in;
		end if;
	end if;
	end process;
end MemoryArch;
