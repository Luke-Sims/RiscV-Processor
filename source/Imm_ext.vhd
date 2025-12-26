library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Imm_ext is
    generic (
        N : natural
    );
    port (
        instr    : in std_logic_vector(N -1 downto 0);
        insType  : in std_logic_vector(1 downto 0); -- 00 si I, 01 si S, 10 si B
        immExt   : out std_logic_vector(N -1 downto 0)
    );
end entity;

architecture rtl of Imm_ext is
    alias imm_I    : std_logic_vector(11 downto 0) is instr(31 downto 20);
    signal temp : std_logic_vector(19 downto 0);
begin

    temp <= (others => instr(31));

    with insType select
        immExt <= temp & imm_I when "00",
                  temp & instr(31 downto 25) & instr(11 downto 7) when "01",
                  temp(19 downto 1) & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & temp(0) when others;

end rtl;
