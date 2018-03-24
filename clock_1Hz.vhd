library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity clock_1Hz is
	port(
				CLOCK_50 : in std_logic;
            clk : out std_logic);  -- one of the 7-segment diplays
end entity clock_1Hz ;

architecture behavioural of clock_1Hz is
signal slowclock_arr : unsigned(24 downto 0) := "1011111010111100001000000";		-- 25 bits give 1.490Hz, by 50MHz/(2^25)=1.490.
signal output_clk : std_logic := '0';
begin
	slowclock_process: process(CLOCK_50)
	begin
		if(rising_edge (CLOCK_50)) then
			if (slowclock_arr = "00000000000000000000000000" ) then
				slowclock_arr <= "1011111010111100001000000"; 
				output_clk <= not(output_clk);
				clk <= output_clk;
			else
				slowclock_arr <= slowclock_arr - 1; 
			end if;
		end if;
	end process slowclock_process;
 
end behavioural;