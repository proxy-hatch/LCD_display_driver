
-- This is a simple design which connects the important LCD signals
-- to switches.  You can use this to play with the LCD and make sure
-- that you understand how it works, before downloading your Lab1 
-- design.  If you have any questions on this, you should talk to 
-- your TA.


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity test_lcd is
     port(
        key : in std_logic_vector(3 downto 0);  -- pushbutton switches
        sw : in std_logic_vector(8 downto 0);  -- slide switches
        ledg : out std_logic_vector(7 downto 0); -- green LED's (you might want to use
                                                 -- this to display your current state)
        lcd_rw : out std_logic;  -- R/W control signal for the LCD
        lcd_en : out std_logic;  -- Enable control signal for the LCD
        lcd_rs : out std_logic;  -- Whether or not you are sending an instruction or character
        lcd_on : out std_logic;  -- used to turn on the LCD
        lcd_blon : out std_logic; -- used to turn on the backlight
        lcd_data : out std_logic_vector(7 downto 0));  -- used to send instructions or characters
end test_lcd ;


architecture behavioural of test_lcd is
begin

        lcd_blon <= '1';   -- backlight is always on
        lcd_on <= '1';     -- LCD is always on
        lcd_en <= key(0);  -- connect the clock to the lcd_en input
        lcd_rw <= '0';     -- always writing to the LCD
        lcd_rs <= SW(8);   -- connect to slider switch 8
        lcd_data <= SW(7 downto 0);   -- connect to slider switches 7 to 0

        ledg(0) <= key(0);  -- send the clock to a green light, to help you debug 

end behavioural;
