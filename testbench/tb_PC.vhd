library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_PC is
end entity tb_PC;

architecture rtl of tb_PC is
    component PC
		 generic
		(
			N : natural := 32
		);

		port
		(
			clk		: in std_logic;
			data	: in std_logic_vector((N - 1) downto 0);
			we		: in std_logic;
			reset   : in boolean;
			enable  : in std_logic;
			PC4     : out std_logic_vector((N - 1) downto 0);
			q		: out std_logic_vector((N - 1) downto 0)
		);
    end component;
    -- la définition des constantes
    constant N: natural:=32;
    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal clk_t    : std_logic:='0';
    signal finish   : std_logic := '0';
    signal data_t   : std_logic_vector((N-1) downto 0) := (others => '0');
	signal we_t     : std_logic := '0';
	signal reset_t  : boolean := FALSE;
	signal enable_t : std_logic := '1';
	signal PC4_t    : std_logic_vector((N - 1) downto 0);
    signal q_t      : std_logic_vector((N-1) downto 0);

begin
	pc_1: PC
	generic map(
	    N => N
	)
    port map (
        clk     => clk_t,
		data    => data_t,
		we      => we_t,
        reset   => reset_t,
		enable  => enable_t,
		PC4     => PC4_t,
        q       => q_t
    );

    -- définition d'une horloge dont la période de 10 ns
    clk_t  <= not clk_t after 5 ns when finish='0' else '0';
	process
	begin
		wait for 20 ns;
	    we_t    <= '1';
		enable_t<= '1';
		data_t  <= std_logic_vector(to_unsigned(42, N));
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t);
		we_t    <= '0';
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t);
		data_t  <= std_logic_vector(to_unsigned(13, N));
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t);
		enable_t<= '0';
		we_t    <= '1';
		data_t  <= std_logic_vector(to_unsigned(12, N));
		wait until RISING_EDGE(clk_t);
		we_t    <= '0';
		reset_t   <= TRUE;
		wait until RISING_EDGE(clk_t);
		we_t    <= '1';
		data_t  <= std_logic_vector(to_unsigned(11, N));
		wait until RISING_EDGE(clk_t);
		reset_t   <= FALSE;
		enable_t<= '1';
		wait until RISING_EDGE(clk_t);
		we_t <= '0';
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t);
		we_t <= '1';
		data_t  <= std_logic_vector(to_unsigned(10, N));
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t);
		finish  <= '1';
	end process;

end architecture rtl;
