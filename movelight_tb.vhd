----------------------------------------------------------------------------------
-- Engineer:        Kartik Ramesh
-- Description:    Movelight test bench
----------------------------------------------------------------------------------

	LIBRARY IEEE ;
	USE IEEE.STD_LOGIC_1164.ALL ;
	
	ENTITY movelight_tb IS
	END movelight_tb ;
	
	ARCHITECTURE Behavioral OF movelight_tb IS
	COMPONENT movelight IS
		PORT ( 	clk : IN STD_LOGIC ; --clock input
				btnl : IN STD_LOGIC ; --rotate to left
				btnr : IN STD_LOGIC ; --rotate to right
				btnc : IN STD_LOGIC ; --stop rotation
				btnd : IN STD_LOGIC ; --load pattern from switches
				switches : IN STD_LOGIC_VECTOR (7 DOWNTO 0) ;
				leds : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
			) ;
	END COMPONENT movelight ;
	
	SIGNAL clk : STD_LOGIC := '0' ;
	SIGNAL btnl : STD_LOGIC := '0' ;
	SIGNAL btnr : STD_LOGIC := '0' ;
	SIGNAL btnc : STD_LOGIC := '0' ;
	SIGNAL btnd : STD_LOGIC := '0' ;
	SIGNAL switches : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"15" ;
	SIGNAL leds : STD_LOGIC_VECTOR(7 DOWNTO 0) := x"05" ;
	
	CONSTANT clock_period : TIME := 10 ns ;
	BEGIN 
		uut : movelight
		PORT MAP ( 	clk => clk ,
						btnl => btnl ,
						btnr => btnr ,
						btnc => btnc ,
						btnd => btnd ,
						switches => switches ,
						leds => leds
				) ;
		clk_p : PROCESS
		BEGIN
			clk <='0';
			WAIT FOR clock_period/2 ;
			clk <='1';
			WAIT FOR clock_period/2 ;
		END PROCESS clk_p;
		
		sim_p: PROCESS
		BEGIN
			WAIT FOR clock_period  * 15 ;
			btnd <= '1';
			WAIT FOR clock_period  * 15 ;
			btnd <= '0';
			WAIT FOR clock_period * 15 ;
			btnl <= '1';
			WAIT FOR clock_period * 15 ;
			btnl <= '0';
			WAIT FOR clock_period * 15 ;
			btnr <= '1';
			WAIT FOR clock_period * 15 ;
			btnr <= '0';
			WAIT FOR clock_period * 15 ;
			btnc <= '1';
			WAIT FOR clock_period * 15 ;
			btnc <= '0';
			switches<= x"F0";
			WAIT FOR clock_period ;
			btnd <= '1';
			WAIT FOR clock_period  ;
			REPORT " movelight simulation done. " ;
			WAIT;
		END PROCESS sim_p;
	END Behavioral;
