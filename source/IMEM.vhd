-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity IMEM is

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
		clk     : in std_logic;
		q		: out std_logic_vector((ADDR_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of IMEM is

	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((ADDR_WIDTH-1) downto 0);
 --type    memType is array (0 to 2**ADDR_WIDTH - 1) of std_logic_vector(ADDR_WIDTH - 1 downto 0);
    type    memType is array (0 to MEM_DEPTH - 1) of std_logic_vector(ADDR_WIDTH - 1 downto 0);

    -- fonction conversion chaîne hexadecimale en std_logic_vector
    function str_to_slv(str : string) return std_logic_vector is
        -- Create normalized string alias with 1-based indexing
        alias str_norm : string(1 to str'length) is str;
        variable char_v : character;           -- Current character being processed
        variable val_of_char_v : natural;       -- Numeric value of current character (0-15)
        variable res_v : std_logic_vector(4 * str'length - 1 downto 0);  -- Result vector (4 bits per char)
    begin
        -- Process each character in the input string
        for str_norm_idx in str_norm'range loop
            char_v := str_norm(str_norm_idx);
            -- Convert hexadecimal character to numeric value
            case char_v is
                when '0' to '9' => val_of_char_v := character'pos(char_v) - character'pos('0');
                when 'A' to 'F' => val_of_char_v := character'pos(char_v) - character'pos('A') + 10;
                when 'a' to 'f' => val_of_char_v := character'pos(char_v) - character'pos('a') + 10;
                when others => report "str_to_slv: Invalid characters for convert" severity ERROR;
            end case;
            -- Place 4-bit binary value in appropriate position of result vector
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
        variable instr_str : string(1 to 8);
        variable inst_num : integer := 0;
        variable instr_init      :   std_logic_vector(31 downto 0);
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
        instr_init := str_to_slv("00000000");
        mem_tmp(inst_num) := instr_init;
        inst_num := inst_num + 1;
        return mem_tmp;
    end function;

    signal  mem      : memType:=memInit(INIT_FILE);
begin


    ---- synchronous reading
    process (clk)
    begin
        if rising_edge(clk)  then
            if to_integer(unsigned(addr)/4) < MEM_DEPTH then
                q   <=  mem(to_integer(unsigned(addr(ADDR_WIDTH-1 downto 2))));
            else
                q   <=  (others => '0');
            end if;
        end if;
    end process;

    -- asynchronous reading

    --q   <=  mem(to_integer(unsigned(addr)/4)) when to_integer(unsigned(addr)/4) < MEM_DEPTH else (others => '0');
end rtl;
