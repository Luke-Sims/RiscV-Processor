-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity DMEM is

    generic
    (
        DATA_WIDTH  :   natural;
        ADDR_WIDTH  :   natural;
        MEM_DEPTH   :   natural;
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

end entity;

architecture rtl of DMEM is

	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
 --type    memType is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    type    memType is array (0 to MEM_DEPTH - 1) of std_logic_vector(7 downto 0);

    -- fonction conversion chaîne hexadecimale en std_logic_vector
    function str_to_slv(str : string) return std_logic_vector is
        alias str_norm : string(1 to str'length) is str;
        variable char_v : character;
        variable val_of_char_v : natural;
        variable res_v : std_logic_vector(4 * str'length - 1 downto 0);
    begin
        for str_norm_idx in str_norm'range loop
            char_v := str_norm(str_norm_idx);
            case char_v is
                when '0' to '9' => val_of_char_v := character'pos(char_v) - character'pos('0');
                when 'A' to 'F' => val_of_char_v := character'pos(char_v) - character'pos('A') + 10;
                when 'a' to 'f' => val_of_char_v := character'pos(char_v) - character'pos('a') + 10;
                when others => report "str_to_slv: Invalid characters for convert" severity ERROR;
            end case;
            res_v(res_v'left - 4 * str_norm_idx + 4 downto res_v'left - 4 * str_norm_idx + 1) :=
            std_logic_vector(to_unsigned(val_of_char_v, 4));
        end loop;
        return res_v;
    end function;

    -- fonction de lecture du fichier texte hexadecimal (txt) pour initialiser la mémoire d'instructions
    function memInit(fileName : string) return memType is
        variable mem_tmp : memType;
        file filePtr : text;
        variable line_instr : line;
        variable instr_str : string(1 to 2);
        variable inst_num : integer := 0;
        variable instr_init      :   std_logic_vector(7 downto 0);
    begin
        file_open(filePtr, fileName, READ_MODE);
        while (inst_num < MEM_DEPTH and not endfile(filePtr)) loop
        --while (not endfile(filePtr)) loop
            readline (filePtr,line_instr);
            read (line_instr,instr_str);
            instr_init := str_to_slv(instr_str);
            mem_tmp(inst_num) := instr_init;
            inst_num := inst_num + 1;
        end loop;
        file_close(filePtr);
        return mem_tmp;
    end function;

    signal  mem      : memType := memInit(INIT_FILE);
    signal mem_0    : std_logic_vector(ADDR_WIDTH -1 downto 0) := (others => '0');
    signal temp     : natural range 0 to MEM_DEPTH-1;
begin
    mem_0 <= addr(ADDR_WIDTH -1 downto 2)&"00";
    temp  <= 0 when unsigned(mem_0) >= to_unsigned(MEM_DEPTH-4,32) else to_integer(unsigned(mem_0)); -- return index 0 if overflow memory
    -- create assertion warnings
    ---- asynchronous reading
    q   <=  mem(temp+3) &
            mem(temp+2) &
            mem(temp+1) &
            mem(temp+0);

    ---- synchronous reading
    process(clk)
    begin
    if rising_edge(clk) then
        if we="1111" then
            mem(temp+3) <= data(31 downto 24);
        elsif we(3 downto 2)= "11" then
            mem(temp+3) <= data(15 downto 8);
        elsif we(3)='1' then
            mem(temp+3) <= data(7 downto 0);
        end if;

        if we = "1111" then
            mem(temp+2) <= data(23 downto 16);
        elsif we(2)='1' then
            mem(temp+2) <= data(7 downto 0);
        end if;
        if we(1 downto 0) = "11" then
            mem(temp+1) <= data(15 downto 8);
        elsif we(1) = '1' then
            mem(temp+1) <= data(7 downto 0);
        end if;
        if we(0)='1' then
            mem(temp) <= data(7 downto 0);
        end if;
    end if;
    end process;
end rtl;
