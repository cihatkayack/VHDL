library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top is
    Port ( 
        UP          : in std_logic;                     -- UP butonu
        DOWN        : in std_logic;                     -- DOWN butonu
        clk         : in std_logic;                     -- Saat sinyali
        reset       : in std_logic;                     -- Reset sinyali
        seg         : out std_logic_vector (7 downto 0); -- 7-segment display
        an          : out std_logic_vector (7 downto 0) -- Anot sinyalleri
    );
end top;

architecture Behavioral of top is

	---------------------------------------------------------------------------------------
    -- COMPONENT DECLARATIONS
    ---------------------------------------------------------------------------------------
    -- Debounce modülü bileşeni tanımı
    component debounce
        generic (
            c_clkfreq : integer := 100_000_000;          -- Saat frekansı
            c_debtime : integer := 1000;                 -- Debounce süresi
            c_initval : std_logic := '0'                 -- Başlangıç değeri
        );
        port (
            clk       : in std_logic;                    -- Saat sinyali
            signal_i  : in std_logic;                    -- Giriş sinyali (buton)
            signal_o  : out std_logic                    -- Çıkış sinyali (debounced)
        );
    end component;
	
	
	component seven_segment_bcd is
	  Port ( 
		bcd 		: in std_logic_vector(3 downto 0);  -- BCD değerleri maksimumu 4 bit oluyor 1001(9)
		seg : out std_logic_vector(7 downto 0)
	  );
	end component;

	---------------------------------------------------------------------------------------
    -- SIGNALS
    ---------------------------------------------------------------------------------------
    signal UP_debounced   : std_logic := '0';           -- Debounce sonrası UP sinyali
    signal DOWN_debounced : std_logic := '0';           -- Debounce sonrası DOWN sinyali
    signal count          : std_logic_vector(7 downto 0) := "00000000"; -- 2 BCD değerini tutar
    signal clk_div        : std_logic_vector(23 downto 0) := (others => '0');
    signal active_digit   : std_logic_vector(1 downto 0) := "00"; -- 2 segment (0 veya 1)
	signal seg1, seg2 	: std_logic_vector(7 downto 0);


begin

---------------------------------------------------------------------------------------
-- INSTANTIATIONS
---------------------------------------------------------------------------------------
    -- UP butonu için debounce modülü
    debounce_UP : debounce
        generic map (
            c_clkfreq => 100_000_000,
            c_debtime => 1000,
            c_initval => '0'
        )
        port map (
            clk => clk,
            signal_i => UP,
            signal_o => UP_debounced
        );

    -- DOWN butonu için debounce modülü
    debounce_DOWN : debounce
        generic map (
            c_clkfreq => 100_000_000,
            c_debtime => 1000,
            c_initval => '0'
        )
        port map (
            clk => clk,
            signal_i => DOWN,
            signal_o => DOWN_debounced
        );
		
		
	seg_decoder_inst1 : seven_segment_bcd
		port map (
			bcd => count(3 downto 0),
			seg => seg1
		);

	seg_decoder_inst2 : seven_segment_bcd
		port map (
			bcd => count(7 downto 4),
			seg => seg2
		);
---------------------------------------------------------------------------------------
-- Clock divider
---------------------------------------------------------------------------------------
    -- Clock divider
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                clk_div <= (others => '0');
            else
                clk_div <= clk_div + 1;
            end if;
        end if;
    end process;
	
	
    process(clk_div(15)) -- Daha yüksek frekans seçimi
    begin
        if rising_edge(clk_div(15)) then
            if reset = '1' then
                active_digit <= "00";
            else
				if (active_digit = "10") or (active_digit = "11") then
					active_digit <= "00";
				else
					active_digit <= active_digit + 1; -- Segmentler arası geçiş yap
				end if;
            end if;
        end if;
    end process;
    ---------------------------------------------------------------------------------------
    -- Counter logic
    ---------------------------------------------------------------------------------------
    process(clk_div(23), reset)
    begin
        if reset = '1' then
            count <= "00000000"; -- İki BCD'yi sıfırla
        elsif rising_edge(clk_div(23)) then
            if UP_debounced = '1' and DOWN_debounced = '0' then
                if count(7 downto 4) = "1001" and count(3 downto 0) = "1001" then
                    count <= "00000000"; -- Reset to 00 after 99
                elsif count(3 downto 0) = "1001" then
                    count(7 downto 4) <= count(7 downto 4) + 1; 
                    count(3 downto 0) <= "0000";
                else
                    count(3 downto 0) <= count(3 downto 0) + 1; 
                end if;
            elsif DOWN_debounced = '1' and UP_debounced = '0' then
                if count(7 downto 4) = "0000" and count(3 downto 0) = "0000" then
                    count <= "10011001"; -- Wrap around to 99
                elsif count(3 downto 0) = "0000" then
                    count(7 downto 4) <= count(7 downto 4) - 1; 
                    count(3 downto 0) <= "1001"; 
                else
                    count(3 downto 0) <= count(3 downto 0) - 1; 
                end if;
            end if;
        end if;
    end process;
    ---------------------------------------------------------------------------------------
    -- Segment seçimi
    ---------------------------------------------------------------------------------------
    process(active_digit, seg1, seg2)
    begin
        case active_digit is
            when "00" => 
                seg <= seg1;       -- Sağ segment için veri
                an <= "11111110";  -- Sağ segmentin anodunu aktif et
            when "01" => 
                seg <= seg2;       -- Sol segment için veri
                an <= "11111101";  -- Sol segmentin anodunu aktif et
            when others =>
                seg <= (others => '0');
                an <= (others => '1'); -- Tüm segmentleri devre dışı bırak
        end case;
    end process;

end Behavioral;
