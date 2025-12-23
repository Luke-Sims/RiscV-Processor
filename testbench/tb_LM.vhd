library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_LM is
end entity tb_LM;

architecture rtl of tb_LM is
    component LM
        generic(
            N : natural
        );
        port (
            LM_res      : in std_logic_vector(1 downto 0);
            data        : in std_logic_vector(N-1 downto 0);
            funct3      : in std_logic_vector(2 downto 0);
            to_load_mux : out std_logic_vector(N-1 downto 0)
        );
    end component;
    -- la définition des constantes
    constant N		 : natural:=32;

    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal LM_res_t 	: std_logic_vector(1 downto 0);
	signal data_t   	: std_logic_vector(N-1 downto 0);
	signal funct3_t 	: std_logic_vector(2 downto 0);
	signal to_load_mux_t: std_logic_vector(N-1 downto 0);
    signal clk_t    : std_logic:='0';
    signal finish   : std_logic:='0';
begin
	LM_map: LM
	generic map (
	    N => 32
	)
    port map (
		LM_res 	=> LM_res_t,
		data   	=> data_t,
        funct3	=> funct3_t,
        to_load_mux => to_load_mux_t
    );

    -- 01 23 45 67
    data_t <= "00000001001000110100010101100111"; -- 00000001 00100011 01000101 01100111
    LM_res_t <= "10";
    -- funct3_t <= "000";
    clk_t  <= not clk_t after 5 ns when finish='0' else '0';
	process
	begin
	    wait until RISING_EDGE(clk_t);
	    funct3_t <= "000"; -- LB
	    wait until RISING_EDGE(clk_t); -- "00 00 00 23"
		funct3_t <= "000"; -- LB
        wait until RISING_EDGE(clk_t); -- "00 00 01 23"
        funct3_t <= "001"; -- LH
		wait until RISING_EDGE(clk_t); -- "01 23 45 67"
        funct3_t <= "010"; -- LW
	    wait until RISING_EDGE(clk_t);
		finish <= '1';
	 end process;

end architecture rtl;
