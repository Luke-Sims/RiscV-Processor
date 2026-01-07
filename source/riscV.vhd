library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.RiscV_package.all;

entity riscV is
    generic(
        DATA_WIDTH      : natural;
        ADDR_WIDTH      : natural;
        MEM_DEPTH       : natural;
        INIT_FILE       : string;
        INIT_FILE_MEM   : string;
        REG_NUM         : natural
    );
    port (
        clk : std_logic := '0';
        reset : in boolean := false
    );
end entity;

architecture rtl of riscV is
    signal aluOp_t      : std_logic_vector(3 downto 0);
    signal opA_in_t	    : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal opB_in_t	    : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal opA_out_t    : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal opB_out_t    : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal res_t	    : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal instrIn_t    : std_logic_vector((ADDR_WIDTH -1) downto 0);
    signal we_t         : std_logic:= '0';
    signal load_t       : std_logic:= '0';
    signal dout_t       : std_logic_vector((ADDR_WIDTH - 1) downto 0);
    signal RI_sel_t     : std_logic;
    signal immExt_t     : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal loadAccJump_t: std_logic_vector(1 downto 0);
    signal wrMem_t      : std_logic_vector(3 downto 0);
    signal data_t       : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal busW_t       : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal DMEM_addr_t  : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal DMEM_in_t    : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal LM_instr_t   : std_logic_vector(2 downto 0);
    signal to_load_mux_t: std_logic_vector((DATA_WIDTH -1) downto 0);
    signal insType_t    : std_logic_vector(2 downto 0);
    signal SM_instr_t   : std_logic_vector(1 downto 0);
    signal Btype_t      : std_logic_vector(2 downto 0);
    signal Bres_t       : std_logic;
    signal Bsel_t       : std_logic_vector(1 downto 0);
    signal PC4_t        : std_logic_vector((DATA_WIDTH -1) downto 0);
    signal instrOut_t   : std_logic_vector((ADDR_WIDTH-1) downto 0);
    signal enable_t     : std_logic;

    alias funct7    : std_logic_vector(6 downto 0) is instrOut_t(31 downto 25);
   	alias funct3    : std_logic_vector(2 downto 0) is instrOut_t(14 downto 12);
   	alias opCode    : std_logic_vector(6 downto 0) is instrOut_t(6 downto 0);
    alias rw_t      : std_logic_vector(REG_NUM -1 downto 0) is instrOut_t(11 downto 7);
    alias ra_t      : std_logic_vector(REG_NUM -1 downto 0) is instrOut_t(19 downto 15);
    alias rb_t      : std_logic_vector(REG_NUM -1 downto 0) is instrOut_t(24 downto 20);
    alias imm       : std_logic_vector(11 downto 0) is instrOut_t(31 downto 20);
    alias LM_res_t  : std_logic_vector(1 downto 0) is res_t(1 downto 0);
begin
    alu_map: ALU
    generic map (
        N => DATA_WIDTH
    )
    port map (
        aluOp   => aluOp_t,
        opA     => opA_out_t,
        opB     => opB_out_t,
        res     => res_t
    );

    controleur_map: controleur
    generic map (
        N => DATA_WIDTH
    )
    port map(
        clk         => clk,
        instr       => instrOut_t,
        WriteEnable => we_t,
        aluOp       => aluOp_t,
        PC          => load_t,
        RI_sel      => RI_sel_t,
        loadAccJump => loadAccJump_t,
        wrMem       => wrMem_t,
        res         => LM_res_t,
        LM_instr    => LM_instr_t,
        insType     => insType_t,
        SM_instr    => SM_instr_t,
        Bres        => Bres_t,
        Btype       => Btype_t,
        Bsel        => Bsel_t,
        reset       => reset,
        enable      => enable_t
    );

    pc_map: PC
    generic map (
        N => ADDR_WIDTH
    )
    port map(
        clk   => clk,
        data  => res_t,
        we    => load_t,
        reset => reset,
        PC4   => PC4_t,
        q     => dout_t
    );

    imem_map: IMEM
    generic map (
        DATA_WIDTH  => DATA_WIDTH,
        ADDR_WIDTH  => ADDR_WIDTH,
        MEM_DEPTH   => MEM_DEPTH,
        INIT_FILE   => INIT_FILE
    )
    port map(
        addr => dout_t,
        clk  => clk,
        q    => instrIn_t
    );

    register_map: REG
    generic map (
        N => DATA_WIDTH,
        REG_NUM => REG_NUM
    )
    port map(
        clk     => clk,
        data    => busW_t,
        we      => we_t,
        rw      => rw_t,
        ra      => ra_t,
        rb      => rb_t,
        busA    => opA_in_t,
        busB    => opB_in_t,
        reset   => reset
    );

    Imm_ext_map: Imm_ext
    generic map (
        N => DATA_WIDTH
    )
    port map(
        instr   => instrOut_t,
        insType => insType_t,
        immExt  => immExt_t
    );

    RI_mux_map: RI_mux
    generic map (
        N => DATA_WIDTH
    )
    port map(
        busBin  => opB_in_t,
        immExt  => immExt_t,
        RI_sel  => RI_sel_t,
        busBout => opB_out_t
    );

    DMEM_addr_t <= res_t(31 downto 2) & "00";
    DMEM_map: DMEM
     generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH,
        MEM_DEPTH  => MEM_DEPTH,
        INIT_FILE  => INIT_FILE_MEM
    )
     port map(
        addr => DMEM_addr_t,
        data => DMEM_in_t,
        q    => data_t,
        clk  => clk,
        we   => wrMem_t
    );

    load_mux_map: load_jump_mux
     generic map(
        N => DATA_WIDTH
    )
     port map(
        busA => res_t,
        busB => to_load_mux_t,
        PC4 => PC4_t,
        load => loadAccJump_t,
        res  => busW_t
    );

    LM_map: LM
    generic map(
        N => DATA_WIDTH
    )
    port map(
        LM_res      => LM_res_t,
        data        => data_t,
        funct3      => LM_instr_t,
        to_load_mux => to_load_mux_t
    );

    SM_map: SM
    generic map(
        N => DATA_WIDTH
    )
    port map(
        SM_res  => LM_res_t,
        BusB    => opB_in_t,
        funct3  => SM_instr_t,
        q       => data_t,
        data_out=> DMEM_in_t
    );

    BC_map: BC
    generic map(
   		N => DATA_WIDTH
   	)
   	port map(
   		busA	=> opA_in_t,
   		busB	=> opB_in_t,
   		Btype	=> Btype_t,
   		Bres	=> Bres_t
   	);

    B_mux_map: B_mux
     generic map(
        N => DATA_WIDTH
    )
     port map(
        busA => opA_in_t,
        dout => dout_t,
        Bsel => Bsel_t,
        busAout => opA_out_t
    );

    registre_instruction_map: registre_instruction
    generic map(
        N => ADDR_WIDTH
    )
    port map(
        enable    => enable_t,
        instr_in  => instrIn_t,
        instr_out => instrOut_t
    );
end architecture rtl;
