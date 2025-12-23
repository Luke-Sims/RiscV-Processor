library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_single_port_pc is
end entity tb_single_port_pc;

architecture rtl of tb_single_port_pc is
    component single_port_pc
		 generic
		(
			N : natural := 8
		);

		port
		(
			clk		: in std_logic;
			data	: in std_logic_vector((N - 1) downto 0);
			we		: in std_logic := '1';
			res   : in std_logic := '0';
			q		: out std_logic_vector((N - 1) downto 0)
		);
    end component;
    -- la définition des constantes
    constant N: natural:=8;
    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal        clk_t  :   std_logic:='0';
    signal        data_t :   std_logic_vector((N-1) downto 0);
	signal        we_t   :   std_logic := '1';
	signal        res_t  :   std_logic := '0';
    signal        q_t    :   std_logic_vector((N-1) downto 0);

begin
	 pc_1: single_port_pc
    port map (
            clk => clk_t,
            res => res_t,
				data=> data_t,
				we  => we_t,
            q   => q_t
    );

    -- définition d'une horloge dont la période de 10 ns
    clk_t  <= not clk_t after 5 ns;
	 process
	 begin
		wait for 20 ns;
	   we_t <= '1';
		data_t <= std_logic_vector(to_unsigned(42, N));
		wait for 50 ns;
		we_t <= '0';
		wait for 10 ns;
		data_t <= std_logic_vector(to_unsigned(13, N));
		wait for 20 ns;
		we_t <= '1';
		data_t <= std_logic_vector(to_unsigned(12, N));
		wait for 10 ns;
		we_t <= '0';
		res_t <= '1';
		wait for 10 ns;
		we_t <= '1';
		data_t <= std_logic_vector(to_unsigned(11, N));
		wait for 10 ns;
		res_t <= '0';
		wait for 10 ns;
		data_t <= std_logic_vector(to_unsigned(10, N));
	 end process;

end architecture rtl;
