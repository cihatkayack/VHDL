library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
	generic (
	c_clkfreq	: integer := 100_000_000
	);
    Port (
        clk_100MHz 		: in STD_LOGIC;
        reset      		: in STD_LOGIC;
		SW		        : in std_logic_vector (2 downto 0);
		up 				: in STD_LOGIC;	
		down            : in STD_LOGIC;
		lft             : in STD_LOGIC;
		rght            : in STD_LOGIC;
        hsync      		: out STD_LOGIC;
        vsync      		: out STD_LOGIC;
        rgb        		: out STD_LOGIC_VECTOR(11 downto 0);
        led_clk_status  : out STD_LOGIC_VECTOR(1 downto 0)  -- CLK test LED’i
    );
end top;

architecture Behavioral of top is

	component debounce is
	generic (
	c_clkfreq	: integer := 100_000_000;
	c_debtime	: integer := 1000;
	c_initval	: std_logic	:= '0'
	);
	port (
	clk			: in std_logic;
	signal_i	: in std_logic;
	signal_o	: out std_logic
	);
	end component;



    -- İç sinyaller
    signal w_x, w_y       : STD_LOGIC_VECTOR(9 downto 0);
    signal w_p_tick       : STD_LOGIC;
    signal w_video_on     : STD_LOGIC;
    signal w_reset        : STD_LOGIC;
	signal w_up           : STD_LOGIC;
	signal w_down         : STD_LOGIC;
	signal w_right        : STD_LOGIC;
	signal w_left         : STD_LOGIC;
    signal rgb_next       : STD_LOGIC_VECTOR(11 downto 0);
    signal rgb_reg        : STD_LOGIC_VECTOR(11 downto 0);

    -- CLK Test için ek sinyaller
    signal clk_counter    : unsigned(26 downto 0) := (others => '0');  -- 27-bit sayaç
    signal led_state      : STD_LOGIC := '0';

begin

    -- VGA Controller Instance
    vga_controller_inst : entity work.vga_controller
        port map (
            clk_100MHz => clk_100MHz,
            reset      => w_reset,
            video_on   => w_video_on,
            p_tick     => w_p_tick,
            hsync      => hsync,
            vsync      => vsync,
            x          => w_x,
            y          => w_y
        );

    -- Pixel Generator
    pixel_gen_inst : entity work.pixel_gen
        port map (
            clk       => clk_100MHz,
            video_on  => w_video_on,
            x         => w_x,
            y         => w_y,
			renk_type => SW(2 downto 0),
			up 	      => w_up,  
			down      => w_down,
			lft       => w_right,
			rght      => w_left, 
            rgb       => rgb_next,
			led       => led_clk_status(1)
        );
		
		
	debounce_reset : debounce
		generic map(
		c_clkfreq	=> c_clkfreq,
		c_debtime	=> 1000,
		c_initval	=> '0'
		)
		port map(
		clk			=> clk_100MHz,
		signal_i	=> reset,
		signal_o	=> w_reset
		);

	debounce_up : debounce
		generic map(
		c_clkfreq	=> c_clkfreq,
		c_debtime	=> 1000,
		c_initval	=> '0'
		)
		port map(
		clk			=> clk_100MHz,
		signal_i	=> up,
		signal_o	=> w_up
		);
	
	debounce_down : debounce
		generic map(
		c_clkfreq	=> c_clkfreq,
		c_debtime	=> 1000,
		c_initval	=> '0'
		)
		port map(
		clk			=> clk_100MHz,
		signal_i	=> down,
		signal_o	=> w_down
		);

	debounce_right : debounce
		generic map(
		c_clkfreq	=> c_clkfreq,
		c_debtime	=> 1000,
		c_initval	=> '0'
		)
		port map(
		clk			=> clk_100MHz,
		signal_i	=> rght,
		signal_o	=> w_right
		);
	
	debounce_left : debounce
		generic map(
		c_clkfreq	=> c_clkfreq,
		c_debtime	=> 1000,
		c_initval	=> '0'
		)
		port map(
		clk			=> clk_100MHz,
		signal_i	=> lft,
		signal_o	=> w_left
		);

   

    -- RGB Buffer
    process(clk_100MHz)
    begin
        if rising_edge(clk_100MHz) then
            --if w_p_tick = '1' then
                rgb_reg <= rgb_next;
            --end if;
        end if;
    end process;

    rgb <= rgb_reg;

    -- CLK LED Blink Sistemi
    process(clk_100MHz)
    begin
        if rising_edge(clk_100MHz) then
            clk_counter <= clk_counter + 1;
            if clk_counter = x"7FFFFFF" then  -- 2^27 - 1 (yaklaşık 1.34 saniye)
                led_state <= not led_state;
                clk_counter <= (others => '0');
            end if;
        end if;
    end process;

    led_clk_status(0) <= led_state;

end Behavioral;
