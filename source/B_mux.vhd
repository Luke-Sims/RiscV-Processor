library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity B_mux is
    generic(
        N : natural := 32
    );
    port (
        busA    : in std_logic_vector(N-1 downto 0);
        dout    : in std_logic_vector(N-1 downto 0);
        Bsel    : in std_logic_vector(1 downto 0);
        busAout : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of B_mux is
begin
    process (busA, dout, Bsel)
    begin
        if (Bsel = "01") then
            busAout <= dout;
        elsif (Bsel = "00") then
            busAout <= busA;
        else
            busAout <= x"00000000";
        end if;
    end process;

end architecture;
