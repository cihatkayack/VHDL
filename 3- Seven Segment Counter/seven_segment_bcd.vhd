library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity seven_segment_bcd is
  Port ( 
	bcd 		: in std_logic_vector(3 downto 0);  -- BCD değerleri maksimumu 4 bit oluyor 1001(9)
	seg : out std_logic_vector(7 downto 0)
  );
end seven_segment_bcd;

architecture Behavioral of seven_segment_bcd is

begin

	process (bcd) begin
		
		case bcd is
			when "0000" => seg <= "00000011";
		
			when "0001" => seg <= "10011111"; -- CACBCCCDCECFCGDP
			
			when "0010" => seg <= "00100101"; -- CACBCCCDCECFCGDP
				
			when "0011" => seg <= "00001101"; -- CACBCCCDCECFCGDP
				
			when "0100" => seg <= "10011001"; -- CACBCCCDCECFCGDP
				
			when "0101" => seg <= "01001001"; -- CACBCCCDCECFCGDP
				
			when "0110" => seg <= "01000001"; -- CACBCCCDCECFCGDP
				
			when "0111" => seg <= "00011111"; -- CACBCCCDCECFCGDP
				
			when "1000" => seg <= "00000001"; -- CACBCCCDCECFCGDP
				
			when "1001" => seg <= "00001001"; -- CACBCCCDCECFCGDP
				
			when others => seg <= "11111111"; -- CACBCCCDCECFCGDP
		end case;
   
   end process;

end Behavioral;
