library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SM is
    generic(
        N : natural
    );
    port (
        BusB     : in std_logic_vector(N-1 downto 0);
        SM_res   : in std_logic_vector(1 downto 0);
        funct3   : in std_logic_vector(1 downto 0);
        q        : in std_logic_vector(N-1 downto 0);
        data_out : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of SM is
    signal m_h : std_logic_vector(3 downto 0);
    signal m_b : std_logic_vector(3 downto 0);
    signal m   : std_logic_vector(3 downto 0);
begin

    with SM_res(1) select  -- m_h(15:0)
        m_h(3 downto 0) <= x"3" when '1',
                           x"c" when others;

    with SM_res select
        m_b(3 downto 0) <= x"e" when "00",
                           x"d" when "01",
                           x"b" when "10",
                           x"7" when others;

    with funct3 select
        m(3 downto 0) <= m_b(3 downto 0) when "00",
                         m_h(3 downto 0) when "01",
                         x"0" when others;

    process(BusB,SM_res,funct3,m)
    begin
        if m(0)='1' then -- data_out(7:0)
            data_out(7 downto 0) <= q(7 downto 0);
        else
            data_out(7 downto 0) <= BusB(7 downto 0);
        end if;

        if m(1)='1' then -- data_out(15:8)
            data_out(15 downto 8) <= q(15 downto 8);
        elsif funct3(0)='1' or funct3(1)='1' then
            data_out(15 downto 8) <= BusB(15 downto 8);
        else
            data_out(15 downto 8) <= BusB(7 downto 0);
        end if;

        if m(2)='1' then -- data_out(23:16)
            data_out(23 downto 16) <= q(23 downto 16);
        elsif funct3(1)='1' then
            data_out(23 downto 16) <= BusB(23 downto 16);
        else
            data_out(23 downto 16) <= BusB(7 downto 0);
        end if;

        if m(3)='1' then -- data_out(31:24)
            data_out(31 downto 24) <= q(31 downto 24);
        else
            case funct3 is
                when "00" =>
                    data_out(31 downto 24) <= BusB(7 downto 0);
                when "01" =>
                    data_out(31 downto 24) <= BusB(15 downto 8);
                when others =>
                    data_out(31 downto 24) <= BusB(31 downto 24);
            end case;
        end if;
    end process;

end architecture;
