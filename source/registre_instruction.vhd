library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registre_instruction is
    generic(
        N : natural := 32
    );
    port (
        reset  : in boolean;
        enable    : in std_logic;
        instr_in  : in std_logic_vector(N-1 downto 0);
        instr_out : out std_logic_vector(N-1 downto 0);
        reset_EOF : out boolean
    );
end entity;

architecture rtl of registre_instruction is
begin
    instr_out <= instr_in when enable = '1';
    reset_EOF <= True when instr_in=x"00000000" else reset;
end architecture;
