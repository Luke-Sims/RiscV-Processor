library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity tb_single_port_rom is
end entity tb_single_port_rom;

architecture rtl of tb_single_port_rom is
    component single_port_rom
    generic(
        DATA_WIDTH  :   natural:=32;
        ADDR_WIDTH  :   natural:=8;
        MEM_DEPTH   :   natural:=200;
        INIT_FILE   :   string
           );
    port (
        addr	: in std_logic_vector((ADDR_WIDTH - 1) downto 0);
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
    );
    end component;
    -- la définition des constantes
    constant ADDR_WIDTH: natural:=8;
    constant DATA_WIDTH: natural:=32;
    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal        clk_t :   std_logic:='0';
    signal        finish: std_logic := '0';
    signal        addr_t :   std_logic_vector(ADDR_WIDTH - 1 downto 0);
    signal        q_t     :   std_logic_vector((DATA_WIDTH-1) downto 0);

begin
    rom_1: single_port_rom
    generic map (
        DATA_WIDTH  => DATA_WIDTH,
        ADDR_WIDTH  => ADDR_WIDTH,
        MEM_DEPTH   => 200,
        INIT_FILE   => "scripts/add_02.hex"
    )
    port map (
            addr=> addr_t,
            q   => q_t
    );

    -- définition d'une horloge dont la période de 10 ns
    clk_t <= not clk_t after 5 ns when finish='0' else '0';
    process
    begin
        addr_t <= (others => '0');
        wait until RISING_EDGE(clk_t);
        finish <= '1';
    end process;
end architecture rtl;
