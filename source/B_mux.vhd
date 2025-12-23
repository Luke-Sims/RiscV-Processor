library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity B_mux is
    generic(
        N : natural := 32
    );
    port (
        busA : in std_logic_vector(N-1 downto 0);
        dout : in std_logic_vector(N-1 downto 0);
        Bsel : in std_logic;
        busAout  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of B_mux is
begin
    process (busA, dout, Bsel)
    begin
        if (Bsel = '1') then
            busAout <= dout;
        else
            busAout <= busA;
        end if;
    end process;

end architecture;
