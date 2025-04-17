library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pixel_gen is
    Port (
        clk       : in  STD_LOGIC;
        video_on  : in  STD_LOGIC;
        x         : in  STD_LOGIC_VECTOR(9 downto 0);
        y         : in  STD_LOGIC_VECTOR(9 downto 0);
		renk_type : in  STD_LOGIC_VECTOR(2 downto 0);
		up 		  : in STD_LOGIC;	
		down      : in STD_LOGIC;
		lft       : in STD_LOGIC;
		rght      : in STD_LOGIC;
        rgb       : out STD_LOGIC_VECTOR(11 downto 0);
		led		  : out STD_LOGIC
    );
end pixel_gen;

architecture Behavioral of pixel_gen is

    -- Renkler
    constant RED     : STD_LOGIC_VECTOR(11 downto 0) := x"00F";
    constant BLACK   : STD_LOGIC_VECTOR(11 downto 0) := x"000";
	constant WHITE   : STD_LOGIC_VECTOR(11 downto 0) := x"FFF";

    -- Gökkuşağı paleti
    constant LIGHT_GREEN   : STD_LOGIC_VECTOR(11 downto 0) := x"3F0";
    constant DARK_GREEN    : STD_LOGIC_VECTOR(11 downto 0) := x"0A0";
    constant PALE_GREEN    : STD_LOGIC_VECTOR(11 downto 0) := x"7F0";
    constant SEA_GREEN     : STD_LOGIC_VECTOR(11 downto 0) := x"1F0";
    constant LIME_GREEN    : STD_LOGIC_VECTOR(11 downto 0) := x"8F0";
	
	constant LIME          : std_logic_vector(11 downto 0) := x"0F0";
	constant SPRING_GREEN  : std_logic_vector(11 downto 0) := x"0FA";
	constant BISQUE        : std_logic_vector(11 downto 0) := x"FEC";
	constant LIGHT_GRAY    : std_logic_vector(11 downto 0) := x"D3D";
	constant GHOST_WHITE   : std_logic_vector(11 downto 0) := x"F8F";
	constant AQUA_MARINE   : std_logic_vector(11 downto 0) := x"7FF";

	constant CUSTOM_COLOR  : std_logic_vector(11 downto 0) := x"61F";
	constant CUSTOM_COLOR2 : std_logic_vector(11 downto 0) := x"128";
	

    type color_array is array (0 to 5) of STD_LOGIC_VECTOR(11 downto 0);
    constant rainbow_colors : color_array := (
        LIME, SPRING_GREEN, BISQUE,
        LIGHT_GRAY, GHOST_WHITE, AQUA_MARINE
    );

    -- Ekran / yazı parametreleri
    constant SCREEN_WIDTH  : integer := 640;
    constant SCREEN_HEIGHT : integer := 480;
    constant CHAR_WIDTH    : integer := 40;
    constant CHAR_SPACING  : integer := 10;
    constant TEXT_HEIGHT   : integer := 80;
    constant TOTAL_WIDTH   : integer := (5 * CHAR_WIDTH) + (4 * CHAR_SPACING);
    constant X_START       : integer := (SCREEN_WIDTH - TOTAL_WIDTH) / 2;
    constant Y_START       : integer := (SCREEN_HEIGHT - TEXT_HEIGHT) / 2;

    constant x_c : integer := X_START;
    constant x_i : integer := x_c + CHAR_WIDTH + CHAR_SPACING;
    constant x_h : integer := x_i + CHAR_WIDTH + CHAR_SPACING;
    constant x_a : integer := x_h + CHAR_WIDTH + CHAR_SPACING;
    constant x_t : integer := x_a + CHAR_WIDTH + CHAR_SPACING;

    -- Pipeline sinyalleri
    signal x_int, y_int      : integer range 0 to 1023;
    signal slow_cnt          : integer range 0 to 8_000_000 := 0;
    constant MAX_CNT         : integer := 8_000_000;
    signal offset            : integer range 0 to 63 := 0;
    signal band_index_reg    : integer range 0 to 63 := 0;
    signal shifted_index_reg : integer range 0 to 5  := 0;
    signal rgb_reg           : STD_LOGIC_VECTOR(11 downto 0);
	
	signal move_x_with_button : integer range -128 to 127 := 0;
	signal move_y_with_button : integer range -128 to 127 := 0;
	signal move_value 		  : integer := 5;
	
	signal led_state      : STD_LOGIC := '0';

begin

    -- Koordinat dönüşümü
    x_int <= to_integer(unsigned(x));
    y_int <= to_integer(unsigned(y));

    -- 1) slow_cnt ve offset tamamen bağımsız sayaç
    process(clk)
    begin
        if rising_edge(clk) then
            if slow_cnt = MAX_CNT then
                slow_cnt <= 0;
                if offset = 63 then
                    offset <= 0;
                else
                    offset <= offset + 1;
                end if;
            else
                slow_cnt <= slow_cnt + 1;
            end if;
        end if;
    end process;

    -- 2) Pipeline: band ve shift index hesapla
    process(clk)
    begin
        if rising_edge(clk) then
            if video_on = '1' then
                band_index_reg    <= x_int / 10;
                shifted_index_reg <= (band_index_reg + offset) mod 6;
            else
                -- Ekran kapalıyken de register’lar eski değerini korur
                band_index_reg    <= band_index_reg;
                shifted_index_reg <= shifted_index_reg;
            end if;
        end if;
    end process;

    -- 3) Asıl rgb ataması (tamamen synchronous)
    process(clk)
    begin
        if rising_edge(clk) then
	
			if up = '1' then
				move_x_with_button <= move_x_with_button;  -- No change in X
				move_y_with_button <= move_y_with_button - move_value;  -- Move up (decrease Y)
				led_state <= not led_state;
			elsif down = '1' then
				move_x_with_button <= move_x_with_button;  -- No change in X
				move_y_with_button <= move_y_with_button + move_value;  -- Move down (increase Y)
				led_state <= not led_state;
			elsif rght = '1' then
				move_x_with_button <= move_x_with_button + move_value;  -- Move right
				move_y_with_button <= move_y_with_button;
				led_state <= not led_state;
			elsif lft = '1' then
				move_x_with_button <= move_x_with_button - move_value;  -- Move left
				move_y_with_button <= move_y_with_button;
				led_state <= not led_state;
			end if;
					
            if video_on = '0' then
                rgb_reg <= BLACK;
            -- "cihat" yazısı koşulları
            elsif
                ((x_int  >= x_c+ move_x_with_button and x_int  < x_c+4+ move_x_with_button and y_int >= Y_START + move_y_with_button and y_int < Y_START+80 + move_y_with_button) or
                 (x_int >= x_c + move_x_with_button and x_int < x_c+40+ move_x_with_button and y_int >= Y_START + move_y_with_button and y_int < Y_START+4 + move_y_with_button) or
                 (x_int >= x_c + move_x_with_button and x_int < x_c+40+ move_x_with_button and y_int >= Y_START+76 + move_y_with_button and y_int < Y_START+80 + move_y_with_button)) or

                ((x_int >= x_i+18+ move_x_with_button and x_int < x_i+22+ move_x_with_button and y_int >= Y_START+20+ move_y_with_button and y_int < Y_START+80+ move_y_with_button) or
                 (x_int >= x_i+18+ move_x_with_button and x_int < x_i+22+ move_x_with_button and y_int >= Y_START+ move_y_with_button and y_int < Y_START+4+ move_y_with_button)) or

                ((x_int >= x_h+ move_x_with_button and x_int < x_h+4+ move_x_with_button and y_int >= Y_START+ move_y_with_button and y_int < Y_START+80+ move_y_with_button) or
                 (x_int >= x_h+36+ move_x_with_button and x_int < x_h+40+ move_x_with_button and y_int >= Y_START+40+ move_y_with_button and y_int < Y_START+80+ move_y_with_button) or
                 (x_int >= x_h+ move_x_with_button and x_int < x_h+40+ move_x_with_button and y_int >= Y_START+40+ move_y_with_button and y_int < Y_START+44+ move_y_with_button)) or

                ((x_int >= x_a+ move_x_with_button and x_int < x_a+4+ move_x_with_button and y_int >= Y_START+20+ move_y_with_button and y_int < Y_START+80+ move_y_with_button) or
                 (x_int >= x_a+36+ move_x_with_button and x_int < x_a+40+ move_x_with_button and y_int >= Y_START+20+ move_y_with_button and y_int < Y_START+80+ move_y_with_button) or
                 (x_int >= x_a+ move_x_with_button and x_int < x_a+40+ move_x_with_button and y_int >= Y_START+20+ move_y_with_button and y_int < Y_START+24+ move_y_with_button) or
                 (x_int >= x_a+ move_x_with_button and x_int < x_a+40+ move_x_with_button and y_int >= Y_START+48+ move_y_with_button and y_int < Y_START+52+ move_y_with_button)) or

                ((x_int >= x_t+18+ move_x_with_button and x_int < x_t+22+ move_x_with_button and y_int >= Y_START+ move_y_with_button and y_int < Y_START+80+ move_y_with_button) or
                 (x_int >= x_t+ move_x_with_button and x_int < x_t+40+ move_x_with_button and y_int >= Y_START+ move_y_with_button and y_int < Y_START+4+ move_y_with_button))
            then
				if renk_type = "000" then
					rgb_reg <= RED;
				elsif renk_type = "001" then
					rgb_reg <= BLACK;
				elsif renk_type = "010" then
					rgb_reg <= LIME;
				elsif renk_type = "011" then
					rgb_reg <= AQUA_MARINE;
				elsif renk_type = "100" then
					rgb_reg <= CUSTOM_COLOR;
				elsif renk_type = "110" then
					rgb_reg <= CUSTOM_COLOR2;
				elsif renk_type = "111" then
					rgb_reg <= GHOST_WHITE;
				end if;
            else
                rgb_reg <= rainbow_colors(shifted_index_reg);
            end if;
        end if;
    end process;

    rgb <= rgb_reg;
	led <= led_state;
end Behavioral;
