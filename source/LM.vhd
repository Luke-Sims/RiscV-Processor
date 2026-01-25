library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LM is
    generic(
        N : natural
    );
    port (
        LM_res : in std_logic_vector(1 downto 0);
        data : in std_logic_vector(N-1 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        to_load_mux  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture rtl of LM is
    signal res_h : std_logic_vector(N-1 downto 0);
    signal res_b : std_logic_vector(N-1 downto 0);
begin

    with LM_res(1) select  -- res_h(15:0)
        res_h(15 downto 0) <= data(31 downto 16) when '1',
                            data(15 downto 0)    when others;

    with LM_res(0) select
        res_b(7 downto 0) <= res_h(15 downto 8) when '1',
                             res_h(7 downto 0)   when others;

    process (res_h,res_b,LM_res,funct3)
    begin
        case funct3 is
            when "000" => -- LB
                if (res_b(7) = '1') then -- res_b(31:8)
                    res_b(31 downto 8) <= (others => '1');
                else
                    res_b(31 downto 8) <= (others => '0');
                end if;
                to_load_mux <= res_b;
            when "001" => -- LH
                if (res_h(15) = '1') then -- res_h(31:16)
                    res_h(31 downto 16) <= (others => '1');
                else
                    res_h(31 downto 16) <= (others => '0');
                end if;
                to_load_mux <= res_h;
            when "100" => -- LBU
                res_b(31 downto 8) <= (others => '0');
                to_load_mux <= res_b;
            when "101" => -- LHU
                res_h(31 downto 16) <= (others => '0');
                to_load_mux <= res_h;
            when others => -- LW
                to_load_mux <= data;
        end case;

    end process;

end architecture;
