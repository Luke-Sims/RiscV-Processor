library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_ALU is
end entity tb_ALU;

architecture rtl of tb_ALU is
    component ALU
		 generic
		(
			N : natural := 32
		);

		port
		(
			opA		: in  std_logic_vector((N -1) downto 0);
			opB		: in  std_logic_vector((N -1) downto 0);
			aluOp	: in  std_logic_vector(3 downto 0);
			res		: out std_logic_vector((N -1) downto 0)
		);
    end component;
    -- la définition des constantes
    constant N		 : natural:=32;

    function slv_to_string(slv : std_logic_vector) return string is
        variable result : string(1 to slv'length);
    begin
        for i in slv'range loop
            if slv(i) = '1' then
                result(slv'length - i) := '1';
            else
                result(slv'length - i) := '0';
            end if;
        end loop;
        return result;
    end function;

    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal opA_t	: std_logic_vector((N -1) downto 0);
	signal opB_t	: std_logic_vector((N -1) downto 0);
	signal aluOp_t 	: std_logic_vector(3 downto 0);
	signal res_t  	: std_logic_vector((N -1) downto 0);
    signal A        : std_logic_vector((N -1) downto 0);
    signal B        : std_logic_vector((N -1) downto 0);
    signal C        : std_logic_vector((N -1) downto 0);
    signal clk_t    : std_logic:='0';
    signal finish   : std_logic:='0';
begin
	alu_1: ALU
    port map (
		opA 	=> opA_t,
		opB 	=> opB_t,
		aluOp	=> aluOp_t,
		res		=> res_t
    );

    A <= "01010101010101010101010101010101";
    B <= "10101010101010101010101010101010";
    C <= "00000000000000001111111111111111";
    clk_t  <= not clk_t after 5 ns when finish='0' else '0';
	process
	begin
	    wait until RISING_EDGE(clk_t); -- sortie doit valoir 0
		-- ADD remplit de 1
		opA_t <= A;
		opB_t <= B;
		aluOp_t <= "0000";
		assert not (res_t = "11111111111111111111111111111111")
            report "Invalid result for ADD operation test 1"
            severity error;
		wait until RISING_EDGE(clk_t);

		-- ADD renvoie 01010101010101100101010101010100
		opA_t <= A;
		opB_t <= C;
		aluOp_t <= "0000";
		assert not (res_t = "01010101010101100101010101010100")
		    report "Invalid result for ADD operation test 2"
            severity error;
		wait until RISING_EDGE(clk_t);


		-- SUB remplit de 0
		opA_t <= A;
		opB_t <= A;
		aluOp_t <= "1000";
		assert not (res_t = "00000000000000000000000000000000")
		    report "Invalid result for SUB operation test 1"
            severity error;
		wait until RISING_EDGE(clk_t);
		-- SUB renvoie 01010101010101000101010101010110
		opA_t <= A;
		opB_t <= C;
		aluOp_t <= "1000";
		assert not (res_t = "01010101010101000101010101010110")
		    report "Invalid result for SUB operation test 2"
            severity error;
		wait until RISING_EDGE(clk_t);

		-- SLL décale de 1
		-- resultat: 10101010101010101010101010101010
		opA_t <= A;
		opB_t <= (others => '0');
		opB_t(0) <= '1';
		aluOp_t <= "0001";
		assert not (res_t = "10101010101010101010101010101010")
		    report "Invalid result for SLL operation test 1"
            severity error;
		wait until RISING_EDGE(clk_t);
		-- SLL décale de 0
		opA_t <= A;
		opB_t <= (others => '0');
		aluOp_t <= "0001";
		assert not (res_t = A)
		    report "Invalid result for SLL operation test 2"
            severity error;
		wait until RISING_EDGE(clk_t);

		-- SLT test: opA < opB
		-- résultat: 0 (faux)
		opA_t <= A;
		opB_t <= B;
		aluOp_t <= "0010";
		assert not (res_t = "00000000000000000000000000000000")
		    report "Invalid result for SLT operation test 1"
            severity error;
		wait until RISING_EDGE(clk_t);

		-- SLT test: opB < opA
		-- résultat: 1 (vrai)
		opA_t <= B;
		opB_t <= A;
		aluOp_t <= "0010";
		assert not (res_t = "00000000000000000000000000000001")
		    report "Invalid result for SLT operation test 2"
            severity error;
		wait until RISING_EDGE(clk_t);


		-- SLTU test: opA < opB
		-- résultat: 1
		opA_t <= A;
		opB_t <= B;
		aluOp_t <= "0011";
		wait until RISING_EDGE(clk_t);
		--assert not (res_t = "00000000000000000000000000000001")
		--    report "Invalid result for SLTU operation test 1. got " & slv_to_string(res_t) & " expected 00000000000000000000000000000001"
        --    severity error;
		wait until RISING_EDGE(clk_t);

		-- SLTU test: opB < opA
		-- résultat: 0
		opA_t <= B;
		opB_t <= A;
		aluOp_t <= "0011";
		assert not (res_t = "00000000000000000000000000000000")
		    report "Invalid result for SLTU operation test 2"
            severity error;
		wait until RISING_EDGE(clk_t);

		-- XOR test: A xor B
		-- résultat: 11111111111111111111111111111111
		opA_t <= A;
		opB_t <= B;
		aluOp_t <= "0100";
		assert not (res_t = "11111111111111111111111111111111")
			report "Invalid result for XOR operation test 1"
			severity error;
		wait until RISING_EDGE(clk_t);

		-- XOR test: A xor C
		-- résultat: 01010101010101011010101010101010
		opA_t <= A;
		opB_t <= C;
		aluOp_t <= "0100";
		assert not (res_t = "01010101010101011010101010101010")
			report "Invalid result for XOR operation test 2"
			severity error;
		wait until RISING_EDGE(clk_t);

		-- SRL test: A srl 1
		-- resultat: 00101010101010101010101010101010
		opA_t <= A;
		opB_t <= (others => '0');
		opB_t(0) <= '1';
		aluOp_t <= "0101";
		assert not (res_t = "00101010101010101010101010101010")
			report "Invalid result for SRL operation test 1 (A srl 1)"
			severity error;
		wait until RISING_EDGE(clk_t);

		-- SRL test: B srl 1
		-- resultat: 01010101010101010101010101010101
		opA_t <= B;
		opB_t <= (others => '0');
		opB_t(0) <= '1';
		aluOp_t <= "0101";
		assert not (res_t = "01010101010101010101010101010101")
			report "Invalid result for SRL operation test 2 (B srl 1)"
			severity error;
		wait until RISING_EDGE(clk_t);

		-- SRA test: A sra 1
		-- resultat: 00101010101010101010101010101010
		opA_t <= A;
		opB_t <= (others => '0');
		opB_t(0) <= '1';
		aluOp_t <= "1101";
		assert not (res_t = "00101010101010101010101010101010")
			report "Invalid result for SRA operation test 1 (A sra 1)"
			severity error;
		wait until RISING_EDGE(clk_t);

		-- SRA test: B sra 1
		-- resultat: 11010101010101010101010101010101
		opA_t <= B;
		opB_t <= (others => '0');
		opB_t(0) <= '1';
		aluOp_t <= "1101";
		assert not (res_t = "11010101010101010101010101010101")
			report "Invalid result for SRA operation test 2 (B sra 1)"
			severity error;
		wait until RISING_EDGE(clk_t);

		-- OR test: B or C
		-- résultat: 10101010101010101111111111111111
		opA_t <= B;
		opB_t <= C;
		aluOp_t <= "0110";
		assert not (res_t = "10101010101010101111111111111111")
			report "Invalid result for OR operation test (B or C)"
			severity error;
		wait until RISING_EDGE(clk_t);

		-- AND test: B and C
		-- résultat: 00000000000000001010101010101010
		opA_t <= B;
		opB_t <= C;
		aluOp_t <= "0111";
		assert not (res_t = "00000000000000001010101010101010")
			report "Invalid result for AND operation test (B and C)"
			severity error;
		wait until RISING_EDGE(clk_t);

		finish <= '1';
	 end process;

end architecture rtl;
