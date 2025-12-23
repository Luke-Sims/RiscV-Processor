library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity load_mux is
    generic(
        N : natural := 32
    );
    port (
        busA : in std_logic_vector(N-1 downto 0);
        busB : in std_logic_vector(N-1 downto 0);
        load : in std_logic;
        res  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of load_mux is
begin
    process (load, busB, busA)
    begin
        if (load = '1') then
            res <= busB;
        else
            res <= busA;
        end if;
    end process;

end architecture;
