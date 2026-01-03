library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Imm_ext is
    generic (
        N : natural
    );
    port (
        instr    : in std_logic_vector(N -1 downto 0);
        insType  : in std_logic_vector(2 downto 0); -- 000 si I ou JALR, 001 si S, 010 si B, 011 si JAL, 100 si U
        immExt   : out std_logic_vector(N -1 downto 0)
    );
end entity;

architecture rtl of Imm_ext is
    alias imm_I    : std_logic_vector(11 downto 0) is instr(31 downto 20);
    signal temp : std_logic_vector(19 downto 0);
begin

    temp <= (others => instr(31));

    with insType select
        immExt <= temp & imm_I when "000", -- I ou JALR
                  temp & instr(31 downto 25) & instr(11 downto 7) when "001", -- S
                  temp(19 downto 1) & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0' when "010", -- B
                  temp(19 downto 1) & instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0' when "011", -- JAL
                  instr(31 downto 12) & x"000" when others; -- U

end rtl;
