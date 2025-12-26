library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_riscV is
    generic(
        DATA_WIDTH      : natural := 32;
        ADDR_WIDTH      : natural := 32;
        MEM_DEPTH	    : natural := 1000;
        INIT_FILE       : string  := "scripts/bltu_02.hex";
        INIT_FILE_MEM   : string  := "scripts/init_mem.hex";
        REG_NUM         : natural := 5
    );
end entity;

architecture rtl of tb_riscV is

    constant N : natural := 32;

    signal clk_tb   : std_logic := '0';
    signal reset_tb : boolean := false;
    signal finish   : std_logic   := '0';

    component riscV
        generic(
            DATA_WIDTH      : natural;
            ADDR_WIDTH      : natural;
            MEM_DEPTH       : natural;
            INIT_FILE       : string;
            INIT_FILE_MEM   : string;
            REG_NUM         : natural
        );
        port (
            clk   : in std_logic := '0';
            reset : in boolean := false
        );
    end component;

begin
    tb_riscV_map: riscV
    generic map(
        DATA_WIDTH      => DATA_WIDTH,
        ADDR_WIDTH      => ADDR_WIDTH,
        MEM_DEPTH       => MEM_DEPTH,
        INIT_FILE       => INIT_FILE,
        INIT_FILE_MEM   => INIT_FILE_MEM,
        REG_NUM         => REG_NUM
    )
    port map(
        clk   => clk_tb,
        reset => reset_tb
    );
    clk_tb  <= not clk_tb after 5 ns when finish='0' else '0';
    process
    begin
        --wait until RISING_EDGE(clk_tb);
        reset_tb <= true;
        wait until RISING_EDGE(clk_tb);
        reset_tb <= false;

        wait for 500 ns;
        reset_tb <= true;
        wait for 30 ns;
        finish <= '1';
    end process;

end rtl;
