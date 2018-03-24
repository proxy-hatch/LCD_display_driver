-- Lab1 Testbench.  A test bench is a file that describes the commands that should
-- be used when simulating the design.  The test bench does not describe any hardware,
-- but is only used during simulation.  In Lab 1, you can use this test bench directly,
-- and do *not need to modify it* (in later labs, you will have to write test benches).
-- Therefore, you do not need to worry about the details in this file (but you might find
-- it interesting to look through anyway).
-- ***Remember: This HDL is ONLY for simulation- it is NOT synthesizable.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

-- Testbenches don't have input and output ports.  We'll talk about that in class
-- later in the course.

entity lab1_tb is
end lab1_tb;


architecture stimulus of lab1_tb is

	--Declare the device under test (DUT)
	component lab1 is

	  port(key : in std_logic_vector(3 downto 0);  -- pushbutton switches
               sw : in std_logic_vector(8 downto 0);  -- slide switches
               ledg : out std_logic_vector(7 downto 0);
               lcd_rw : out std_logic;
               lcd_en : out std_logic;
               lcd_rs : out std_logic;
               lcd_on : out std_logic;
               lcd_blon : out std_logic;
               lcd_data : out std_logic_vector(7 downto 0);
               hex0 : out std_logic_vector(6 downto 0));  -- one of the 7-segment diplays
 
	end component;

	--Signals that connect to the ports of the DUT. The inputs would be 
	--driven inside the testbench according to different test cases, and
	--the output would be monitored in the waveform viewer.

        signal clk: std_logic := '0';
	signal resetb : std_logic := '1';
        signal dir : std_logic := '0';
        signal key : std_logic_vector(3 downto 0);
        signal sw : std_logic_vector(8 downto 0);
	signal out_lcd_rw : std_logic;
        signal out_lcd_en : std_logic;
        signal out_lcd_rs : std_logic;
        signal out_lcd_on : std_logic;
        signal out_lcd_blon : std_logic;
        signal out_lcd_data : std_logic_vector(7 downto 0);
        	

	--Declare a constant of type 'time'. This would be used to cause delay
       -- between clock edges

	constant HALF_PERIOD : time := 20ns;

begin

	key <= resetb & "00" & clk;
	sw <= "00000000" & dir;
	
	DUT: lab2 port map (key => key,
                    sw => sw,
                    lcd_rw => out_lcd_rw,
                    lcd_en => out_lcd_en,
                    lcd_rs => out_lcd_rs,
                    lcd_on => out_lcd_on,
                    lcd_blon => out_lcd_blon,
                    lcd_data => out_lcd_data);
    
        -- set the clock to toggle

        clk <= not clk after HALF_PERIOD;
 
        -- pulse reset for a little while

        resetb <= '0' after HALF_PERIOD, '1' after HALF_PERIOD*3;

        -- put in a pattern for DIR.  You can make this more complicated if you like
        -- to increase the effectiveness of your simulation tests.

        dir <= '0', 
               '1' after HALF_PERIOD*20,
               '0' after HALF_PERIOD*26;

end stimulus;
