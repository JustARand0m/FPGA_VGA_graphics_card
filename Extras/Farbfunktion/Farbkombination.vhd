--CREATOR: Michael Schmidt


-- code not tested, because current memory is only one bit per pixel and here 12 bits get set

--to be entered into signals of img creation
signal Count_colour: std_logic_vector (1 downto 0) := "00";			-- Counter for different colours
signal W_R_Colour: std_logic_vector (3 downto 0) := "0100";			-- Signal for colour changing
signal W_G_Colour: std_logic_vector (3 downto 0) := "0100";
signal W_B_Colour: std_logic_vector (3 downto 0) := "0100";


-- Variant with every Pixel a different colour
-- to be entered into the Schreiben State into the if Data_input (Count_Convert) = '1' statement
	case Count_colour is
		when "00" => 
			W_B_Colour <= "0100";
			W_G_Colour <= "0100";
			W_R_Colour <= W_R_Colour + "0001";
			if W_R_Colour = "1111" then
				W_R_Colour <=  "0100";
				Count_colour <= Count_colour + "01";
			end if;
		when "01" =>
			W_B_Colour <= "0100";
			W_R_Colour <= "0100";
			W_G_Colour <= W_G_Colour + "0001";
			if W_G_Colour = "1111" then
				W_G_Colour <=  "0100";
				Count_colour <= Count_colour + "01";
			end if;
		when "10" =>
			W_R_Colour <= "0100";
			W_G_Colour <= "0100";
			W_B_Colour <= W_B_Colour + "0001";
			if W_B_Colour = "1111" then
				W_B_Colour <=  "0100";
				Count_colour <= Count_colour + "01";
			end if;
			if Count_colour = "10" then 
				Count_colour <= "00";
			end if;
		when others => 
			W_R_Colour <= "1111";
			if Count_colour = "11" then 
				Count_colour <= "00";
			end if;
		end case;
	W_R <= W_R_Colour;
	W_G <= W_G_Colour;
	W_B <= W_B_Colour;

-- Variant with every Pixel of a different colour of the rainbow
-- to be entered into the Schreiben State into the if Data_input (Count_Convert) = '1' statement
	case Count_Convert is
		when 0 =>						--violett		--last Char
			W_R_Colour <= "1111";		--168
			W_G_Colour <= "0000";		--0
			W_B_Colour <= "0000";		--185
		
		when 1 =>						--indigo
			W_R_Colour <= "1000";		--128
			W_G_Colour <= "0000";		--0
			W_B_Colour <= "1000";		--128
		
		when 2 =>						--blau
			W_R_Colour <= "0000";		--0
			W_G_Colour <= "0100";		--68
			W_B_Colour <= "1101";		--220
		
		when 3 =>						--hellblau
			W_R_Colour <= "0000";		--0
			W_G_Colour <= "1010";		--160
			W_B_Colour <= "1101";		--232
		
		when 4 =>						--grün
			W_R_Colour <= "0000";		--0
			W_G_Colour <= "1111";		--255
			W_B_Colour <= "0000";		--0
		
		when 5 =>						--gelb
			W_R_Colour <= "1111";		--255
			W_G_Colour <= "1111";		--255
			W_B_Colour <= "0000";		--0
		
		when 6 =>						--orange
			W_R_Colour <= "1111";		--255
			W_G_Colour <= "1001";		--146
			W_B_Colour <= "0000";		--0
		
		when 7 =>						--rot			--first Char
			W_R_Colour <= "1111";		--255
			W_G_Colour <= "0000";		--0
			W_B_Colour <= "0000";		--0
			
		when others => W_R_Colour <= "1111";
	end case;
	
	W_R <= W_R_Colour;
	W_G <= W_G_Colour;
	W_B <= W_B_Colour;




