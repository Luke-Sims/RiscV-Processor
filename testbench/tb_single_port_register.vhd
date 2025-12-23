library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_single_port_register is
end entity tb_single_port_register;

architecture rtl of tb_single_port_register is
    component single_port_register 
		 generic 
		(
			N       : natural := 32;
			REG_NUM : natural := 5
		);

		port 
		(
			clk		: in std_logic;
			data	: in std_logic_vector((N - 1) downto 0);
			we		: in std_logic := '1';
			rw    : in natural range 0 to 2**REG_NUM - 1;
			ra    : in natural range 0 to 2**REG_NUM - 1;
			rb    : in natural range 0 to 2**REG_NUM - 1;
			busA	: out std_logic_vector((N - 1) downto 0);
			busB	: out std_logic_vector((N - 1) downto 0)
		);
    end component;
    -- la définition des constantes
    constant N: natural:=32;
    constant REG_NUM: natural:=5;
    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal        clk_t  :   std_logic:='0';
	 signal        data_t :   std_logic_vector((N-1) downto 0);
	 signal        we_t   :   std_logic := '1';
	 signal        rw_t   :   natural range 0 to (2**REG_NUM - 1);
	 signal        ra_t   :   natural range 0 to (2**REG_NUM - 1);
	 signal        rb_t   :   natural range 0 to (2**REG_NUM - 1);
    signal        busA_t :   std_logic_vector((N-1) downto 0);
	 signal        busB_t :   std_logic_vector((N-1) downto 0);
    
begin
	 reg_1: single_port_register
    port map (
            clk => clk_t,
				data=> data_t,
				we  => we_t,
				rw  => rw_t,
				ra  => ra_t,
				rb  => rb_t,
				busA=> busA_t,
				busB=> busB_t
    );

    -- définition d'une horloge dont la période de 10 ns 
    clk_t  <= not clk_t after 5 ns;
	 process
	 begin
	   we_t <= '1';
		for valeur in 0 to 2**REG_NUM-1 loop
			rw_t <= valeur;
			data_t <= std_logic_vector(to_unsigned(31-valeur, N));
			wait for 10 ns;
		end loop;
		
		we_t <= '0';
		for valeur in 0 to 2**(REG_NUM-1)-1 loop
			ra_t <= valeur;
			rb_t <= 2**(REG_NUM-1) + valeur;
			wait for 10 ns;
		end loop;
		
		we_t <= '0';
		for valeur in 0 to 2**REG_NUM-1 loop
			rw_t <= valeur;
			data_t <= std_logic_vector(to_unsigned(valeur, N));
			wait for 10 ns;
		end loop;
		
		we_t <= '0';
		for valeur in 0 to 2**(REG_NUM-1)-1 loop
			ra_t <= valeur;
			rb_t <= 2**(REG_NUM-1) + valeur;
			wait for 10 ns;
		end loop;
	 end process;
	 
end architecture rtl;
