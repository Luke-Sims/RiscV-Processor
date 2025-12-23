library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_DMEM is
end entity;

architecture rtl of tb_DMEM is
    component DMEM
        generic
        (
            DATA_WIDTH  :  natural;
            ADDR_WIDTH  :  natural;
            MEM_DEPTH   :  natural;
            INIT_FILE   :  string
        );

    	port
    	(
    		addr	: in std_logic_vector((ADDR_WIDTH - 1) downto 0);
            data    : in std_logic_vector((DATA_WIDTH -1) downto 0);
    		we      : in std_logic_vector(3 downto 0);
            clk     : in std_logic;
    		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
    	);
    end component;
    constant DATA_WIDTH	: natural:=32;
    constant ADDR_WIDTH	: natural:=32;
    constant MEM_DEPTH	: natural:=1000;
    constant INIT_FILE_MEM	: string := "scripts/init_mem.hex";

    signal addr_t   : std_logic_vector(ADDR_WIDTH -1 downto 0);
    signal data_t     : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal we_t     : std_logic_vector(3 downto 0);
    signal q_t      : std_logic_vector(DATA_WIDTH -1 downto 0);
    signal clk_t    : std_logic:='0';
    signal finish   : std_logic:='0';
begin
    tb_imm_ext_port: DMEM
    generic map(
        DATA_WIDTH  => DATA_WIDTH,
        ADDR_WIDTH  => ADDR_WIDTH,
        MEM_DEPTH   => MEM_DEPTH,
        INIT_FILE   => INIT_FILE_MEM
    )
    port map(
        addr => addr_t,
        data => data_t,
        we   => we_t,
        clk  => clk_t,
        q    => q_t
    );
    clk_t  <= not clk_t after 5 ns when finish='0' else '0';
	process
	begin
	    wait until RISING_EDGE(clk_t); -- read index 0 à 3
		data_t <= x"01234567";
		addr_t <= x"00000000";
		we_t   <= "0000";
		wait until RISING_EDGE(clk_t); -- read index 4 à 7
		addr_t <= x"00000004";
		wait until RISING_EDGE(clk_t); -- write index 3 with 01
		we_t   <= "1000";
		addr_t <= x"00000000";
		wait until RISING_EDGE(clk_t); -- write index 2 with 23
		we_t   <= "0100";
		addr_t <= x"00000000";
		wait until RISING_EDGE(clk_t); -- write index 1 with 45
		we_t   <= "0010";
		addr_t <= x"00000000";
		wait until RISING_EDGE(clk_t); -- write index 0 with 67
		we_t   <= "0001";
		addr_t <= x"00000000";
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t); -- write index 7-6 with 7654
		data_t <= x"76543210";
		we_t   <= "1100";
		addr_t <= x"00000004";
		wait until RISING_EDGE(clk_t); -- write index 5-4 with 3210
		data_t <= x"76543210";
		we_t   <= "0011";
		addr_t <= x"00000004";
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t); -- write index 11-8 with 76543210
		data_t <= x"76543210";
		we_t   <= "1111";
		addr_t <= x"00000008";
		wait until RISING_EDGE(clk_t);
		wait until RISING_EDGE(clk_t);
		finish <= '1';
	end process;
end rtl;
