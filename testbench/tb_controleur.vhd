library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_controleur is
end entity tb_controleur;

architecture rtl of tb_controleur is
    component controleur
		 generic
		(
			N : natural := 32
		);

		port
		(
			clk			: in  std_logic;
			instr		: in  std_logic_vector((N -1) downto 0);
			WriteEnable	: out std_logic;
			aluOp		: out std_logic_vector(3 downto 0);
			PC			: out std_logic
		);
    end component;
    -- la définition des constantes
    constant N		    : natural:=32;
	 constant REG_NUM   : natural:=4;
    -- la déclaration des signaus locaux à utiliser pour le cablage
    signal clk_t    : std_logic:='0';
	signal instr_t  : std_logic_vector((N-1) downto 0);
	signal we_t     : std_logic := '1';
	signal aluOp_t  : std_logic_vector(3 downto 0);
	signal PC_t     : std_logic:='0';
	signal finish   : std_logic:='0';
begin
	contr_1: controleur
    port map (
        clk 		=> clk_t,
		instr		=> instr_t,
		WriteEnable => we_t,
		aluOp 		=> aluOp_t,
		PC 			=> PC_t
    );

    -- définition d'une horloge dont la période de 10 ns
    clk_t  <= not clk_t after 5 ns when finish='0' else '0';
	process
	begin
		instr_t <= "0000000" & "00010" & "00001" & "000" & "00011" & "0110011"; -- ADD R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0100000" & "00010" & "00001" & "000" & "00011" & "0110011"; -- SUB R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0000000" & "00010" & "00001" & "001" & "00011" & "0110011"; -- SLL R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0000000" & "00010" & "00001" & "010" & "00011" & "0110011"; -- SLT R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0000000" & "00010" & "00001" & "011" & "00011" & "0110011"; -- SLTU R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0000000" & "00010" & "00001" & "100" & "00011" & "0110011"; -- XOR R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0000000" & "00010" & "00001" & "101" & "00011" & "0110011"; -- SRL R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0100000" & "00010" & "00001" & "101" & "00011" & "0110011"; -- SRA R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0000000" & "00010" & "00001" & "110" & "00011" & "0110011"; -- OR R3, R2, R1
		wait until RISING_EDGE(clk_t);
		instr_t <= "0000000" & "00010" & "00001" & "111" & "00011" & "0110011"; -- AND R3, R2, R1
		wait until RISING_EDGE(clk_t);
		finish <= '1';
	 end process;
end architecture rtl;
