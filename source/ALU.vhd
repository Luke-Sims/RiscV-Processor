library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is

	generic
	(
		N : natural := 32
	);

	port
	(
		opA			: in  std_logic_vector((N -1) downto 0);
		opB			: in  std_logic_vector((N -1) downto 0);
		aluOp			: in  std_logic_vector(3 downto 0);
		res			: out std_logic_vector((N -1) downto 0)
	);

end entity;

architecture rtl of ALU is

begin
	process(opA,opB,aluOp)
	begin

		if (aluOp = "0000") then -- ADD
			res <= std_logic_vector(unsigned(opA)+unsigned(opB));
		elsif (aluOp = "1000") then -- SUB
			res <= std_logic_vector(unsigned(opA)-unsigned(opB));
		elsif (aluOp = "0001") then -- SLL
			res <= std_logic_vector(shift_left(unsigned(opA),to_integer(unsigned(opB))));
		elsif (aluOp = "0010") then -- SLT
			res <= (others => '0');
			if (signed(opA) < signed(opB)) then
				res(0) <= '1';
			end if;
		elsif (aluOp = "0011") then -- SLTU
			res <= (others => '0');
			if (unsigned(opA) < unsigned(opB)) then
				res(0) <= '1';
			end if;
		elsif (aluOp = "0100") then -- XOR
			res <= opA xor opB;
		elsif (aluOp = "0101") then -- SRL
			res <= std_logic_vector(shift_right(unsigned(opA),to_integer(unsigned(opB))));
		elsif (aluOp = "1101") then -- SRA
			res <= std_logic_vector(shift_right(signed(opA),to_integer(unsigned(opB))));
		elsif (aluOp = "0110") then -- OR
			res <= opA or opB;
		elsif (aluOp = "0111") then -- AND
			res <= opA and opB;
		else
			res <= (others => '0');
		end if;
	end process;
end rtl;
