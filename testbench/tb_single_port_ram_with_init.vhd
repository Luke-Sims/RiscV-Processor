library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_single_port_ram_with_init is
end entity tb_single_port_ram_with_init;

architecture rtl of tb_single_port_ram_with_init is
    component single_port_ram_with_init 
		 generic 
		(
			DATA_WIDTH : natural := 8;
			ADDR_WIDTH : natural := 6
		);

		port 
		(
			clk		: in std_logic;
			addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
			data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
			we		: in std_logic := '1';
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
		);
    end component;
    -- la définition des constantes
    constant ADDR_WIDTH: natural:=8;
    constant DATA_WIDTH: natural:=8;
    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal        clk_t  :   std_logic:='0';
    signal        addr_t :   natural range 0 to (2**ADDR_WIDTH - 1);
	 signal        data_t :   std_logic_vector((DATA_WIDTH-1) downto 0);
	 signal        we_t   :   std_logic := '1';
    signal        q_t    :   std_logic_vector((DATA_WIDTH-1) downto 0);
    
begin
	 ram_1: single_port_ram_with_init
    port map (
            clk => clk_t, 
            addr=> addr_t,
				data=> data_t,
				we  => we_t,
            q   => q_t
    );

    -- définition d'une horloge dont la période de 10 ns 
    clk_t  <= not clk_t after 5 ns;
	 process
	 begin
	   we_t <= '0';
		for addr_pos in 0 to 7 loop
			addr_t <= addr_pos;
			wait for 10 ns;
		end loop;
		
		we_t <= '1';
		for addr_pos in 0 to 7 loop
			addr_t <= addr_pos;
			data_t <= std_logic_vector(to_unsigned(7-addr_pos, DATA_WIDTH));
			wait for 10 ns;
		end loop;
		
		we_t <= '0';
		for addr_pos in 0 to 7 loop
			addr_t <= addr_pos;
			wait for 10 ns;
		end loop;
	 end process;
	 
end architecture rtl;
