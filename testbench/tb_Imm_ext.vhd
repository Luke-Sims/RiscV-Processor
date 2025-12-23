library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_Imm_ext is
end entity;

architecture rtl of tb_Imm_ext is
    component Imm_ext
        generic (
            N : natural := 32
        );
        port (
            instr    : in std_logic_vector(N -1 downto 0);
            insType  : in std_logic_vector(1 downto 0); -- 00 si I, 01 si S, 10 si B
            immExt   : out std_logic_vector(N -1 downto 0)
        );
    end component;
    constant N		: natural:=32;
    signal instr_t  : std_logic_vector(N -1 downto 0);
    signal insType_t: std_logic_vector(1 downto 0);
    signal immExt_t : std_logic_vector(N -1 downto 0);
    signal clk_t    : std_logic:='0';
    signal finish   : std_logic:='0';
begin
    tb_imm_ext_port: Imm_ext
    generic map(
        N => N
    )
    port map(
        instr => instr_t,
        insType => insType_t,
        immExt => immExt_t
    );
    clk_t  <= not clk_t after 5 ns when finish='0' else '0';
	process
	begin
        insType_t <=  "00";
	    wait until RISING_EDGE(clk_t);
		instr_t <= "000000000011" & "00001" & "000" & "00010" & "0010011"; -- ADDI x2,x1,3
		wait for 10 ns;
        assert ImmExt_t = x"00000003" report "ADDI x2,x1,3 failed" severity error;
		instr_t <= "111111111100" & "00001" & "000" & "00010" & "0010011"; -- ADDI x2,x1,FFFFFFC (car nombre négatif)
		wait for 10 ns;
        assert ImmExt_t = x"FFFFFFFC" report "ADDI x2,x1,FFFFFC failed" severity error;

        insType_t <= "01";
		instr_t <= "0000000" & "00010" & "00001" & "000" & "00001" & "0100011"; -- SB x2,x1,1
		wait for 10 ns;
        assert ImmExt_t = x"00000001" report "SB x2,x1,1 failed" severity error;
		instr_t <= "0000001" & "00010" & "00001" & "001" & "00000" & "0100011"; -- SH x2,x1,20
		wait for 10 ns;
        assert ImmExt_t = x"00000020" report "SB x2,x1,20 failed" severity error;
		instr_t <= "1111111" & "00010" & "00001" & "010" & "00000" & "0100011"; -- SW x2,x1,FFFFFFE0
		wait for 10 ns;
        assert ImmExt_t = x"FFFFFFE0" report "SB x2,x1,FFFFFFE0 failed" severity error;

        insType_t <= "10";
        -- create test for B
        -- Test 1: BEQ with small positive offset (4)
        instr_t <= "0000000" & "00001" & "00000" & "000" & "01000" & "1100011"; -- BEQ x1,x0,4
        wait for 10 ns;
        assert immExt_t = x"00000004" report "BEQ x1,x0,4 failed" severity error;

        -- Test 2: BNE with negative offset (-8)
        instr_t <= "1111111" & "00001" & "00000" & "001" & "00001" & "1100011"; -- BNE x1,x0,-16
        wait for 10 ns;
        assert immExt_t = x"FFFFFFF0" report "BNE x1,x0,-8 failed" severity error;

        -- Test 3: BLT with larger positive offset (16)
        instr_t <= "0000001" & "00001" & "00000" & "100" & "00000" & "1100011"; -- BLT x1,x0,16
        wait for 10 ns;
        assert immExt_t = x"00000010" report "BLT x1,x0,16 failed" severity error;

        -- Test 4: BGE with negative offset (-12)
        instr_t <= "1111111" & "00001" & "00000" & "101" & "01001" & "1100011"; -- BGE x1,x0,-12
        wait for 10 ns;
        assert immExt_t = x"FFFFFFF4" report "BGE x1,x0,-12 failed" severity error;

        -- Test 5: BLTU with positive offset (4)
        instr_t <= "0000000" & "00001" & "00000" & "110" & "01000" & "1100011"; -- BLTU x1,x0,4
        wait for 10 ns;
        assert immExt_t = x"00000004" report "BLTU x1,x0,-12 failed" severity error;

        -- Test 6: BLTU with huge offset (2048)
        instr_t <= "1000000" & "00001" & "00000" & "110" & "00000" & "1100011"; -- BLTU x1,x0,2048
        wait for 10 ns;
        assert immExt_t = x"FFFFF800" report "BLTU x1,x0,2048 failed" severity error;

        -- Test 7: BGEU with positive offset (4)
        instr_t <= "0000000" & "00001" & "00000" & "111" & "01000" & "1100011"; -- BGEU x1,x0,4
        wait for 10 ns;
        assert immExt_t = x"00000004" report "BGEU x1,x0,-12 failed" severity error;

        -- Test 6: BGEU with huge offset (2048)
        instr_t <= "1000000" & "00001" & "00000" & "111" & "00000" & "1100011"; -- BGEU x1,x0,2048
        wait for 10 ns;
        assert immExt_t = x"FFFFF800" report "BGEU x1,x0,2048 failed" severity error;

        report "All tests passed!" severity note;
		finish <= '1';
	end process;
end rtl;
