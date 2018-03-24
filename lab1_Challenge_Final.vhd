-- Filename: lab1.vhd
-- Author 1: Sheung Yau (Gary) Chung
-- Author 1 Student #: 301236546
-- Author 2: Yu Xuan (Shawn) Wang
-- Author 2 Student #: 301227972
-- Group Number: 40
-- Lab Section: LA04
-- Lab: ASB 10808
-- Task Completed: 1, 2, 3, Challenge
-- Date: January 19, 2018 
------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity lab1 is
	port(key : in std_logic_vector(3 downto 0);  -- pushbutton switches
            sw : in std_logic_vector(8 downto 0);  -- slide switches
            ledg : out std_logic_vector(7 downto 0);
			CLOCK_50 : in std_logic; --input clock 50MHz
            lcd_rw : out std_logic;
            lcd_en : out std_logic;
            lcd_rs : out std_logic;
            lcd_on : out std_logic;
            lcd_blon : out std_logic;
            lcd_data : out std_logic_vector(7 downto 0);
            hex0 : out std_logic_vector(6 downto 0));  -- one of the 7-segment diplays
end lab1 ;

architecture behavironal of lab1 is 
	type statetype is (reset0, reset1, reset2, reset3, reset4, reset5,
					   state0, state1, state2, state3, state4, state5
					 , clear
	);
	signal next_state, current_state: statetype := reset0;
	-- debounce circuit -- 19 bits gives 10.486ms with 50MHz clock
	signal debounced_key0 : std_logic;  --debounced signal
	signal flipflops : std_logic_vector(1 downto 0);
	signal counter_in : std_logic;  -- SCLR
	signal counter_out: std_logic_vector(19 downto 0) := (others => '0'); -- note 20 bits
	-- clock frequency divider
	signal slowclock_arr : std_logic_vector(24 downto 0);		-- 25 bits give 1.490Hz, since 50MHz/(2^25)=1.490
	signal clock_slow : std_logic;
	-- clear lcd screen
	signal counter_clr: std_logic_vector(3 downto 0) := "0000"; 
begin
	one_hz_clock : ENTITY work.slowclock port map (CLOCK_50 => CLOCK_50, debounce_clk => clock_slow);

	comb_process: process(clock_slow, key(3)) 
	
							-- a change in these signals will cause a process entry
							-- Note: process(all) cause everything to work on falling_edge(clk)
	begin
	  -- These will not change
	lcd_blon <= '1';
	lcd_on <= '1';
	lcd_rw <= '0';
	lcd_en <= clock_slow;
	  
	  -- Some notes: 
	  -- LCD accepts data on the falling edge of the clock
	  -- reset key(3) is asynchronous and also active low
	  -- state machine is positive-edge triggered
	  -- this is a Moore state machine
	  
	  -- Code for Task 2: Manually-Clocked State Machine --
	  
	case current_state is 							-- depending upon the current state
											-- set output signals and next state
	-- Set up the LCD
	when reset0 =>	-- 00111000 x"38"
		lcd_data <= "00111000";
		lcd_rs <= '0';
		next_state <= reset1;
		-- debug
		ledg <= "00000001";
	when reset1 =>	-- 00111000 x"38"
		lcd_data <= "00111000";
		lcd_rs <= '0';
		next_state <= reset2;
		-- debug
		ledg <= "00000010";
	when reset2 =>	-- 00001100 x"0C"
		lcd_data <= "00001100";
		lcd_rs <= '0';
		next_state <= reset3;
		-- debug
		ledg <= "00000011";
	when reset3 =>	-- 00000001 x"01"
		lcd_data <= "00000001";
		lcd_rs <= '0';
		next_state <= reset4;
		-- debug
		ledg <= "00000100";
	when reset4 =>	-- 00000110 x"06"
		lcd_data <= "00000110";
		lcd_rs <= '0';
		next_state <= reset5;
		-- debug
		ledg <= "00000101";
	when reset5 =>	-- 10000000 x"80"
		lcd_data <= "10000000";
		lcd_rs <= '0';
		next_state <= state0;
		-- debug
		ledg <= "00000110";
		
	when state0 =>	-- 01001100 "L"
		if sw(0) = '0' then
			next_state <= state1; 
		else
			next_state <= state5; 
		end if;
		lcd_data <= "01001100";
		lcd_rs <= '1';
		-- debug
		ledg <= "10000001";
	when state1 =>	-- 01100101 "e"
		if sw(0) = '0' then
			next_state <= state2; 
		else
			next_state <= state0; 
		end if;
		lcd_data <= "01100101";
		lcd_rs <= '1';
		-- debug
		ledg <= "10000010";
	when state2 =>	-- 01110011 "s"
		if sw(0) = '0' then
			next_state <= state3; 
		else
			next_state <= state1; 
		end if;
		lcd_data <= "01110011";
		lcd_rs <= '1';
		-- debug
		ledg <= "10000011";
	when state3 =>	-- 01101100 "l"
		if sw(0) = '0' then
			next_state <= state4; 
		else
			next_state <= state2; 
		end if;
		lcd_data <= "01101100";
		lcd_rs <= '1';
		-- debug
		ledg <= "10000100";
	when state4 =>	-- 01100101 "e"
		if sw(0) = '0' then
			next_state <= state5; 
		else
			next_state <= state3; 
		end if;
		lcd_data <= "01100101";                                                                                                                                                                                                                                                               
		lcd_rs <= '1';
		-- debug
		ledg <= "10000101";
	when state5 =>	-- 01111001 "y"
		if sw(0) = '0' then
			next_state <= state0; 
		else
			next_state <= state4; 
		end if;
		lcd_data <= "01111001";
		lcd_rs <= '1';
		-- debug
		ledg <= "10000110";
	
	when clear =>	
		lcd_data <= "00000001";
		lcd_rs <= '0';
		ledg <= "11111111";
		next_state <= state0;
	end case;
	end process comb_process;
	
	clk_process: process (key(3), clock_slow)
	begin
		if key(3) = '0' then	-- Asynchronous reset and initialize state
			current_state <= statetype'left;
		elsif(falling_edge(clock_slow)) then
		
			current_state <= next_state;
			-- Challenge Task
			if (counter_clr = "1111") then
				counter_clr <= "0000";
				current_state <= clear; -- Clear screen in single clock cycle
			else
				if (current_state = state0 or current_state = state1 
				or current_state = state2 or current_state = state3 
				or current_state = state4) then 
					counter_clr <= counter_clr + 1;
				end if;
			end if;
		end if;
	end process clk_process;
	
end behavironal;
