-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is

	generic
	(
		N : natural := 32
	);

	port
	(
		clk		: in std_logic;
		data	: in std_logic_vector((N - 1) downto 0);
		we		: in std_logic;
		reset   : in boolean;
		q		: out std_logic_vector((N - 1) downto 0)
	);

end entity;

architecture rtl of PC is
	 signal PC_val : std_logic_vector((N - 1) downto 0);
begin
	process(clk,reset)
	begin
        if reset then
            PC_val <= std_logic_vector(to_unsigned(0, N));
		elsif(rising_edge(clk)) then
			if(we = '1') then
				PC_val <= data;
			else
				PC_val <= std_logic_vector(to_unsigned(to_integer(signed(PC_val))+4, N));
			end if;

			-- Register the address for reading
		end if;
	end process;
	q <= PC_val;
end rtl;
