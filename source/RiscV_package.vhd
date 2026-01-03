library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package RiscV_package is
    component ALU is

    	generic
    	(
    		N : natural := 32
    	);

    	port
    	(
    		opA			: in  std_logic_vector((N -1) downto 0);
    		opB			: in  std_logic_vector((N -1) downto 0);
    		aluOp		: in  std_logic_vector(3 downto 0);
    		res			: out std_logic_vector((N -1) downto 0)
    	);

    end component;
    component controleur is

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
    		insType     : out std_logic_vector(1 downto 0);
    		SM_instr    : out std_logic_vector(1 downto 0);
    		Btype       : out std_logic_vector(2 downto 0);
            Bsel        : out std_logic
    	);
    end component;

    component PC is
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
    		PC4		: out std_logic_vector((N - 1) downto 0);
            q		: out std_logic_vector((N - 1) downto 0)
    	);
    end component;

    component IMEM is

        generic(
            DATA_WIDTH  :   natural;
            ADDR_WIDTH  :   natural;
            MEM_DEPTH   :   natural;
            INIT_FILE   :   string
        );
        port (
            addr	: in std_logic_vector((ADDR_WIDTH - 1) downto 0);
    		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
        );

    end component;

    component REG is
        generic
    	(
    		N       : natural := 32;
    		REG_NUM : natural := 5
    	);

    	port
    	(
    		clk		: in  std_logic;
    		data	: in  std_logic_vector((N - 1) downto 0);
    		we		: in  std_logic := '1';
    		rw      : in  std_logic_vector(REG_NUM-1 downto 0);
    		ra      : in  std_logic_vector(REG_NUM-1 downto 0);
    		rb      : in  std_logic_vector(REG_NUM-1 downto 0);
            reset   : in  boolean;
    		busA   	: out std_logic_vector((N - 1) downto 0);
    		busB	: out std_logic_vector((N - 1) downto 0)
    	);
    end component;

    component Imm_ext is
    generic (
        N : natural := 32
    );
    port (
        instr    : in std_logic_vector(N -1 downto 0);
        insType  : in std_logic_vector(1 downto 0); -- 00 si I, 01 si S, 10 si B
        immExt   : out std_logic_vector(N -1 downto 0)
    );
    end component;

    component RI_mux is
        generic(
            N : natural := 32
        );
        port (
            busBin : in std_logic_vector(N-1 downto 0);
            immExt : in std_logic_vector(N-1 downto 0);
            RI_sel : in std_logic;
            busBout: out std_logic_vector(N-1 downto 0)
        );
    end component;

    component load_jump_mux is
        generic(
            N : natural := 32
        );
        port (
            busA : in std_logic_vector(N-1 downto 0);
            busB : in std_logic_vector(N-1 downto 0);
            PC4  : in std_logic_vector(N-1 downto 0);
            load : in std_logic_vector(1 downto 0);
            res  : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component DMEM is
   	generic
    (
        DATA_WIDTH  :   natural;
        ADDR_WIDTH  :   natural;
        MEM_DEPTH   :   natural;
        INIT_FILE   :   string
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

    component LM is
    generic(
        N : natural
    );
    port (
        LM_res : in std_logic_vector(1 downto 0);
        data : in std_logic_vector(N-1 downto 0);
        funct3 : in std_logic_vector(2 downto 0);
        to_load_mux  : out std_logic_vector(N-1 downto 0)
    );
    end component;

    component SM is
        generic(
            N : natural
        );
        port (
            BusB     : in std_logic_vector(N-1 downto 0);
            SM_res   : in std_logic_vector(1 downto 0);
            funct3   : in std_logic_vector(1 downto 0);
            q        : in std_logic_vector(N-1 downto 0);
            data_out : out std_logic_vector(N-1 downto 0)
        );
    end component;

    component BC is
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

    component B_mux is
        generic(
            N : natural := 32
        );
        port (
            busA    : in std_logic_vector(N-1 downto 0);
            dout    : in std_logic_vector(N-1 downto 0);
            Bsel    : in std_logic;
            busAout : out std_logic_vector(N-1 downto 0)
        );
    end component;
end package;
