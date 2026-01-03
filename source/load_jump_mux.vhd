library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity load_jump_mux is
    generic(
        N : natural := 32
    );
    port (
        busA : in std_logic_vector(N-1 downto 0);
        busB : in std_logic_vector(N-1 downto 0);
        PC4  : in std_logic_vector(N-1 downto 0);
        load : in std_logic_vector(1 downto 0);
        res  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of load_jump_mux is
begin
    process (load, busB, busA)
    begin
        if (load = "01") then
            res <= busB;
        elsif (load = "10") then
            res <= PC4;
        else
            res <= busA;
        end if;
    end process;

end architecture;
