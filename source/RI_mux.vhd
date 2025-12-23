library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RI_mux is
    generic(
        N : natural := 32
    );
    port (
        busBin : in std_logic_vector(N-1 downto 0);
        immExt : in std_logic_vector(N-1 downto 0);
        RI_sel : in std_logic;
        busBout: out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of RI_mux is
begin
    process (RI_sel, immExt, busBin)
    begin
        if (RI_sel = '1') then
            busBout <= immExt;
        else
            busBout <= busBin;
        end if;
    end process;

end architecture;
