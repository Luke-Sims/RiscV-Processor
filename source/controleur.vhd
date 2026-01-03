library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controleur is

	generic
	(
		N : natural := 32
	);

	port
	(
		clk			: in  std_logic;
		instr		: in  std_logic_vector((N -1) downto 0);
		res         : in  std_logic_vector(1 downto 0);
		Bres        : in  std_logic;
		reset       : in  boolean;
		WriteEnable	: out std_logic:= '0';
		aluOp		: out std_logic_vector(3 downto 0);
		PC			: out std_logic:= '0';
		RI_sel      : out std_logic;
		loadAccJump : out std_logic_vector(1 downto 0);
		wrMem       : out std_logic_vector(3 downto 0);
		LM_instr    : out std_logic_vector(2 downto 0);
		insType     : out std_logic_vector(2 downto 0);
		SM_instr    : out std_logic_vector(1 downto 0);
		Btype       : out std_logic_vector(2 downto 0);
		Bsel        : out std_logic
	);
end entity;

architecture rtl of controleur is
    impure function wrmem_case(
        store_instr:std_logic_vector(1 downto 0);
        res_store  :std_logic_vector(1 downto 0))
        return std_logic_vector is
        begin
            case store_instr is
    			when "00" =>
    					case res_store is
                            when "00" => return "0001";
                            when "01" => return "0010";
                            when "10" => return "0100";
                            when others => return "1000";
    					end case;
    			when "01" =>
    					if res_store(1) = '0' then
    						return "0011";
    					else return "1100";
    					end if;
    			when "10" =>
    					return "1111";
    			when others =>
    				return "0000";
    		end case;
    end function;

    alias funct7: std_logic_vector(6 downto 0) is instr(31 downto 25);
	alias funct3: std_logic_vector(2 downto 0) is instr(14 downto 12);
	alias opCode: std_logic_vector(6 downto 0) is instr(6 downto 0);
begin
    --wrMem_in(3 downto 0) <= funct3(1 downto 0) & res(1 downto 0);
	process(opCode,funct7,funct3,res,reset) -- add reset
	begin
	    if reset then -- reset
			PC          <= '1'; -- have to reset PC
			WriteEnable <= '0';
			RI_sel      <= '0';
			loadAccJump <= "00";
			wrMem       <= "0000";
			insType     <= "000";
			LM_instr    <= "000";
			SM_instr    <= "00";
			Btype       <= "000";
			Bsel        <= '0';
		elsif (opCode = "0110011") then -- R
			aluOp 		<= funct7(5) & funct3;
			PC 			<= '0';
			WriteEnable <= '1';
			RI_sel      <= '0';
			loadAccJump <= "00";
			wrMem       <= "0000";
			Bsel        <= '0';
		elsif (opCode = "0010011") then -- I
		    aluOp 		<= '0' & funct3;
			PC          <= '0';
			WriteEnable <= '1';
			RI_sel      <= '1';
			loadAccJump <= "00";
			wrMem       <= "0000";
			insType     <= "000";
			Bsel        <= '0';
		elsif (opCode = "0000011") then -- load
            aluOp 		<= "0000"; -- réalise un add avec le registre d'offset (RB)
            PC          <= '0';
            WriteEnable <= '1';
            RI_sel      <= '1';
            loadAccJump <= "01";
            insType     <= "000"; -- peut être inutile
            wrMem       <= "0000"; -- n'écrit pas en mémoire car ne fait que la lire
            LM_instr    <= funct3;
            Bsel        <= '0';
        elsif (opCode = "0100011") then -- Store
            aluOp 		<= "0000"; -- réalise un add avec le registre d'offset (RB)
            PC          <= '0';
            WriteEnable <= '0';
            RI_sel      <= '1';
            loadAccJump <= "01";
            wrMem       <= wrmem_case(store_instr => funct3(1 downto 0), res_store => res);
            insType     <= "001";
            SM_instr    <= funct3(1 downto 0);
            Bsel        <= '0';
        elsif (opCode = "1100011") then -- Branch
            aluOp 		<= "0000"; -- réalise un add avec le registre d'offset (RB)
            PC          <= Bres;
            WriteEnable <= '0';
            RI_sel      <= '1';
            loadAccJump <= "00";
            wrMem       <= "0000";
            insType     <= "010";
            Bsel        <= '1';
            Btype       <= funct3;
        elsif (opCode = "1101111") then -- JAL
            aluOp 		<= "0000"; -- réalise un add avec le registre d'offset (RB)
            PC          <= '1';
            WriteEnable <= '1';
            RI_sel      <= '1';
            loadAccJump <= "10";
            wrMem       <= "0000";
            insType     <= "011";
            Bsel        <= '1';
        elsif (opCode = "1100111") then -- JALR
            aluOp 		<= "0000"; -- réalise un add avec le registre d'offset (RB)
            PC          <= '1';
            WriteEnable <= '1';
            RI_sel      <= '1';
            loadAccJump <= "10";
            wrMem       <= "0000";
            insType     <= "000";
            Bsel        <= '0';
		else
			aluOp		<= "1111";
			PC 			<= '0';
			WriteEnable <= '0';
			RI_sel      <= '0';
			loadAccJump <= "00";
			wrMem       <= "0000";
			Bsel        <= '0';
		end if;
	end process;
end rtl;
