----------------------------------------------------------------------------------
-- Engineer:  Kartik Ramesh      
-- Module Name: movelight - Behavioral Code
----------------------------------------------------------------------------------

	LIBRARY IEEE ;
	USE IEEE.STD_LOGIC_1164.ALL ;
	
	--entity declarations--
	ENTITY movelight IS
		PORT ( 	clk : IN STD_LOGIC ; --clock input
				btnl : IN STD_LOGIC ; --rotate to left
				btnr : IN STD_LOGIC ; --rotate to right
				btnc : IN STD_LOGIC ; --stop rotation
				btnd : IN STD_LOGIC ; --load pattern
				switches : IN STD_LOGIC_VECTOR (7 DOWNTO 0) ;
				leds : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
			) ;
	END movelight ;
	
	ARCHITECTURE Behavioral OF movelight IS
	
	SIGNAL led_reg : STD_LOGIC_VECTOR(7 downto 0) :=x"05" ;
	SIGNAL mv_left : STD_LOGIC := '0' ;
	SIGNAL mv_right : STD_LOGIC := '0' ;
	SIGNAL pulse : STD_LOGIC := '0' ;
	
	CONSTANT MAX_COUNT : INTEGER := 3 ;
	SUBTYPE Count_type IS INTEGER RANGE 0 TO MAX_COUNT-1 ;
	BEGIN
		leds <= led_reg;
		--generation of pulse--
		-- determines the speed of rotation--
		-- It is slowed down by factor of 3 from clock pulse to visualize rotation. 
		count_p : PROCESS(clk)
		VARIABLE cnt : Count_type := MAX_COUNT-1;
		BEGIN
			IF rising_edge(clk)  THEN
				pulse <= '0';
				IF cnt = 0 THEN
					pulse <= '1' ;
					cnt := MAX_COUNT-1 ;
				ELSE
					cnt := cnt - 1 ;
				END IF ;
			END IF ;
		END PROCESS count_p;
		--move logic--
		--mode of operation [ left - right - stop ]		
		mvlogic : PROCESS(clk)
		BEGIN
			IF rising_edge(clk) THEN
				IF pulse = '1' THEN
					IF btnl = '1' THEN  --move left
						mv_left <= '1'; 
						mv_right <= '0';
					ELSIF btnr = '1' THEN  --move right
						mv_right <= '1' ; 	
						mv_left <= '0';					
					ELSIF btnc = '1' THEN -- stop rotation 
						mv_left <= '0';
						mv_right <= '0';
					ELSE
						mv_left <= mv_left;
						mv_right <= mv_right;			
					END IF ;
				END IF ;
			END IF ;
		END PROCESS mvlogic ;
		
		--rotate operation--
		lr_rot : PROCESS (clk)
		BEGIN
			IF rising_edge(clk) THEN
				IF pulse = '1' THEN
					IF btnd = '1' THEN -- switches
						led_reg <= switches ;
					ELSIF mv_left = '1' THEN -- rotate left
						led_reg <= led_reg(6 DOWNTO 0) & led_reg(7) ;
					ELSIF mv_right = '1' THEN -- rotate right
						led_reg <= led_reg(0) & led_reg(7 DOWNTO 1) ;
					END IF ;
				END IF ;
			END IF ;
		END PROCESS lr_rot ;
	END Behavioral;
