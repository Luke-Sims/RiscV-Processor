-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG is

	generic
	(
		N       : natural := 32;
		REG_NUM : natural := 5
	);

	port
	(
		clk		: in std_logic;
		data	: in std_logic_vector((N - 1) downto 0);
		we		: in std_logic := '1';
		rw      : in std_logic_vector(REG_NUM-1 downto 0);
		ra      : in std_logic_vector(REG_NUM-1 downto 0);
		rb      : in std_logic_vector(REG_NUM-1 downto 0);
		reset   : in boolean;
		busA	: out std_logic_vector((N - 1) downto 0);
		busB	: out std_logic_vector((N - 1) downto 0)
	);

end entity;

architecture rtl of REG is
	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((N-1) downto 0);
	type memory_t is array(2**REG_NUM-1 downto 0) of word_t;

	function init_register
		return memory_t is
		variable tmp : memory_t := (others => (others => '0'));
	begin

		for addr_pos in 0 to 2**REG_NUM - 1 loop
			-- Initialize each address with 0
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, N));
		end loop;
		return tmp;
	end init_register;

	-- Declare the ROM signal and specify a default value.	Quartus Prime
	-- will create a memory initialization file (.mif) based on the
	-- default value.
	signal registers : memory_t := init_register;
begin
	process(clk,reset)
	begin
	    if reset then
            registers(31 downto 0) <= init_register;
		elsif(rising_edge(clk)) then
			if (we = '1') then
			    registers(to_integer(unsigned(rw))) <= data;
				registers(0) <= std_logic_vector(to_unsigned(0, N));
			end if;
		end if;
	end process;
	busA <= registers(to_integer(unsigned(ra)));
	busB <= registers(to_integer(unsigned(rb)));
end rtl;
