library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_SM is
end entity tb_SM;

architecture rtl of tb_SM is
    component SM
        generic(
            N : natural
        );
        port (
            BusB  : in std_logic_vector(N-1 downto 0);
            q     : in std_logic_vector(N-1 downto 0);
            SM_res   : in std_logic_vector(1 downto 0);
            funct3   : in std_logic_vector(1 downto 0);
            data_out : out std_logic_vector(N-1 downto 0)
        );
    end component;
    -- la définition des constantes
    constant N		 : natural:=32;

    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal q_t       : std_logic_vector(N-1 downto 0);
    signal SM_res_t  : std_logic_vector(1 downto 0);
    signal funct3_t  : std_logic_vector(1 downto 0);
    signal BusB_t    : std_logic_vector(N-1 downto 0);
    signal data_out_t: std_logic_vector(N-1 downto 0);
    signal clk_t     : std_logic:='0';
    signal finish    : std_logic:='0';
begin
    SM_map: SM
    generic map (
        N => 32
    )
    port map (
        q     => q_t,
        SM_res   => SM_res_t,
        funct3   => funct3_t,
        BusB  => BusB_t,
        data_out => data_out_t
    );

        -- 01 23 45 67
        q_t <= "00000001001000110100010101100111"; -- 00000001 00100011 01000101 01100111 = 01 23 45 67
        BusB_t <= "11110011111100101111000111110000"; -- 11110011 11110010 11110001 11110000 = F3 F2 F1 F0
        clk_t  <= not clk_t after 5 ns when finish='0' else '0';
    process
    begin
        wait until RISING_EDGE(clk_t); -- SW
        SM_res_t <= "00";
        funct3_t <= "10"; -- m = x"0"
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"F3 F2 F1 F0"

        wait until RISING_EDGE(clk_t); -- SB
        SM_res_t <= "00";
        funct3_t <= "00"; -- m = x"E" => (1110)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"01 23 45 F0"
        SM_res_t <= "01";
        funct3_t <= "00"; -- m = x"D" => (1101)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"01 23 F0 67"
        SM_res_t <= "10";
        funct3_t <= "00"; -- m = x"B" => (1011)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"01 F0 45 67"
        SM_res_t <= "11";
        funct3_t <= "00"; -- m = x"7" => (0111)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"F0 23 45 67"

        wait until RISING_EDGE(clk_t); -- SH
        SM_res_t <= "00";
        funct3_t <= "01"; -- m = x"C" => (1100)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"01 23 F1 F0"
        SM_res_t <= "01";
        funct3_t <= "01"; -- m = x"C" => (1100)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"01 23 F1 F0" (idem)
        SM_res_t <= "10";
        funct3_t <= "01"; -- m = x"3" => (0011)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"F1 F0 45 67"
        SM_res_t <= "11";
        funct3_t <= "01"; -- m = x"3" => (0011)
        wait until RISING_EDGE(clk_t); -- expect data_out_t = x"F1 F0 45 67"

        finish <= '1';
    end process;

end architecture rtl;
