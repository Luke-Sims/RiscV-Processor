library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_BC is
end entity tb_BC;

architecture sim of tb_BC is
 component BC
	generic
	(
		N : natural := 32
	);

	port
	(
		busA	: in  std_logic_vector((N -1) downto 0);
		busB	: in  std_logic_vector((N -1) downto 0);
		Btype	: in  std_logic_vector(2 downto 0);
		Bres	: out std_logic
	);

 end component;

 constant N : natural := 32;
 signal busA_t : std_logic_vector((N -1) downto 0) := (others => '0');
 signal busB_t : std_logic_vector((N -1) downto 0) := (others => '0');
 signal Btype_t : std_logic_vector(2 downto 0) := "000";
 signal Bres_t : std_logic;
begin
    tb_imm_ext_port: BC
    generic map(
        N  => N
    )
    port map(
        busA => busA_t,
        busB => busB_t,
        Btype   => Btype_t,
        Bres  => Bres_t
    );
    process
    begin
        -- Test "000": equality
        busA_t <= std_logic_vector(to_unsigned(   5, N));
        busB_t <= std_logic_vector(to_unsigned(   5, N));
        Btype_t <= "000";
        wait for 10 ns;
        assert Bres_t = '1' report "BEQ: 5=5 failed" severity error;

        busA_t <= std_logic_vector(to_unsigned(   5, N));
        busB_t <= std_logic_vector(to_unsigned(   6, N));
        Btype_t <= "000";
        wait for 10 ns;
        assert Bres_t = '0' report "BEQ: 5=6 failed" severity error;

        -- Test "001": not equality
        busA_t <= std_logic_vector(to_unsigned(   5, N));
        busB_t <= std_logic_vector(to_unsigned(   5, N));
        Btype_t <= "001";
        wait for 10 ns;
        assert Bres_t = '0' report "BNE: 5=5 failed" severity error;

        busA_t <= std_logic_vector(to_unsigned(   5, N));
        busB_t <= std_logic_vector(to_unsigned(   6, N));
        Btype_t <= "001";
        wait for 10 ns;
        assert Bres_t = '1' report "BNE: 5!=6 failed" severity error;

        -- Test "100": signed < (note: code uses raw slv <, may not compile)
        busA_t <= std_logic_vector(to_signed(  -1, N)); -- 0xFFFFFFFF
        busB_t <= std_logic_vector(to_signed(   0, N));
        Btype_t <= "100";
        wait for 10 ns;
        assert Bres_t = '1' report "BLT: -1 < 0 failed" severity error;

        busA_t <= std_logic_vector(to_signed(   0, N));
        busB_t <= std_logic_vector(to_signed(  -1, N));
        Btype_t <= "100";
        wait for 10 ns;
        assert Bres_t = '0' report "BLT: 0 < -1 failed" severity error;

        busA_t <= std_logic_vector(to_signed( 16, N));
        busB_t <= std_logic_vector(to_signed( 0, N));
        Btype_t <= "100";
        wait for 10 ns;
        assert Bres_t = '0' report "BLT: -1 < 0 failed" severity error;

        busA_t <= std_logic_vector(to_signed( 0, N));
        busB_t <= std_logic_vector(to_signed( 16, N));
        Btype_t <= "100";
        wait for 10 ns;
        assert Bres_t = '1' report "BLT: 0 < -1 failed" severity error;
        -- Test "101": signed >=
        busA_t <= std_logic_vector(to_signed(  -1, N));
        busB_t <= std_logic_vector(to_signed(   0, N));
        Btype_t <= "101";
        wait for 10 ns;
        assert Bres_t = '0' report "BGT: -1 >= 0 failed" severity error;

        busA_t <= std_logic_vector(to_signed(   0, N));
        busB_t <= std_logic_vector(to_signed(  -1, N));
        Btype_t <= "101";
        wait for 10 ns;
        assert Bres_t = '1' report "BGT: 0 >= -1 failed" severity error;

        -- Test "110": unsigned <
        busA_t <= std_logic_vector(to_unsigned(   1, N));
        busB_t <= std_logic_vector(to_unsigned(   2, N));
        Btype_t <= "110";
        wait for 10 ns;
        assert Bres_t = '1' report "BLTU: 1 < 2 failed" severity error;

        busA_t <= std_logic_vector(to_unsigned(   2, N));
        busB_t <= std_logic_vector(to_unsigned(   1, N));
        Btype_t <= "110";
        wait for 10 ns;
        assert Bres_t = '0' report "BLTU: 2 < 1 failed" severity error;

        busA_t <= std_logic_vector(to_signed(   -1, N)); -- 0xFFFFFFFF
        busB_t <= std_logic_vector(to_unsigned(   0, N));
        Btype_t <= "110";
        wait for 10 ns;
        assert Bres_t = '0' report "BLTU: -1 < 0 failed" severity error;

        -- Test "111": unsigned >=
        busA_t <= std_logic_vector(to_unsigned(   1, N));
        busB_t <= std_logic_vector(to_unsigned(   2, N));
        Btype_t <= "111";
        wait for 10 ns;
        assert Bres_t = '0' report "BGTU: 1 >= 2 failed" severity error;

        busA_t <= std_logic_vector(to_unsigned(   2, N));
        busB_t <= std_logic_vector(to_unsigned(   1, N));
        Btype_t <= "111";
        wait for 10 ns;
        assert Bres_t = '1' report "BGTU: 2 >= 1 failed" severity error;

        busA_t <= std_logic_vector(to_signed(   -1, N)); -- 0xFFFFFFFF
        busB_t <= std_logic_vector(to_unsigned(   0, N));
        Btype_t <= "111";
        wait for 10 ns;
        assert Bres_t = '1' report "BGTU: -1 >= 0 failed" severity error;

        -- Test others: false
        Btype_t <= "010";
        wait for 10 ns;
        assert Bres_t = '0' report "Others failed" severity error;

        Btype_t <= "011";
        wait for 10 ns;
        assert Bres_t = '0' report "Others failed" severity error;

        report "All tests passed!" severity note;
        wait;
    end process;
end sim;
