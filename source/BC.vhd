library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BC is

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

end entity;

architecture rtl of BC is
    signal Bres_t : boolean;
begin
	process(busA,busB,Btype)
	begin
	    case Btype is
			when "000" => Bres_t <= busA = busB;                     -- BEQ
			when "001" => Bres_t <= not(busA = busB);                -- BNE
			when "100" => Bres_t <= signed(busA) < signed(busB);     -- BLT (TODO: erreur)
			when "101" => Bres_t <= signed(busA) >= signed(busB);    -- BGE
			when "110" => Bres_t <= unsigned(busA) < unsigned(busB); -- BLTU
			when "111" => Bres_t <= unsigned(busA) >= unsigned(busB);-- BGEU
			when others => Bres_t <= false;
		end case;
	end process;
	process(Bres_t)
	begin
	    if (Bres_t) then
	        Bres <= '1';
		else
		    Bres <= '0';
		end if;
	end process;
end rtl;
