library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_RegInstr is
end entity;

architecture rtl of tb_RegInstr is

    constant N : natural := 32;

    signal clk_tb   : std_logic := '0';
    signal reset_tb : boolean   := false;
    signal finish   : std_logic := '0';
    signal enable   : std_logic;
    signal instr_in : std_logic_vector(N-1 downto 0);
    signal instr_out: std_logic_vector(N-1 downto 0);

    component registre_instruction
        generic(
            N : natural := 32
        );
        port (
            enable    : in std_logic;
            instr_in  : in std_logic_vector(N-1 downto 0);
            instr_out : out std_logic_vector(N-1 downto 0)
        );
    end component;

begin
    tb_RegInstr: registre_instruction
    generic map(
        N => N
    )
    port map (
        enable    => enable,
        instr_in  => instr_in,
        instr_out => instr_out
    );
    clk_tb  <= not clk_tb after 5 ns when finish='0' else '0';
    process
    begin
        instr_in <= x"DEADBEEF";
        enable <= '0';
        wait until RISING_EDGE(clk_tb);
        instr_in <=x"CAFEBABE";
        wait until RISING_EDGE(clk_tb);
        wait until RISING_EDGE(clk_tb);
        enable <= '1';
        wait until RISING_EDGE(clk_tb);
        instr_in <= x"CAFECACA";
        wait until RISING_EDGE(clk_tb);
        wait until RISING_EDGE(clk_tb);
        finish <= '1';
    end process;

end rtl;
