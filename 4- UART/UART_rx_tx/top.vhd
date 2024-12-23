library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
  generic (
	c_clkfreq		: integer := 100_000_000;
	c_baudrate		: integer := 115_200;
	c_stopbit 		: integer := 2
  );
  
  Port ( 
	clk  			: in std_logic;
	rst  			: in std_logic;
	rx_i 			: in std_logic;
	tx_o			: out std_logic;
	leds_o 			: out std_logic_vector(15 downto 0)
  );
end top;

architecture Behavioral of top is

	component uart_rx is
		generic(
			c_clkfreq    : integer := 100_000_000; -- 100 MHz
			c_baudrate   : integer := 115_200
		);
		Port ( 
			in_clk 			: in std_logic;
			in_rst 			: in std_logic;
			in_rx 			: in std_logic;
			out_rx_data 	: out std_logic_vector(7 downto 0);
			out_rx_tamam	: out std_logic
		);
	end component;

	component uart_tx is
		Generic (
			c_clkfreq  : integer := 100_000_000; -- 100 MHz
			c_baudrate : integer := 115200;
			c_stopbit  : integer := 2
		);
		Port (
			in_clk         : in std_logic;
			in_rst         : in std_logic;
			in_tx_basla    : in std_logic;
			in_tx_data     : in std_logic_vector(7 downto 0);
			out_tx         : out std_logic;
			out_tx_tamam   : out std_logic
		);
	end component;

  type t_Data_Cntrl is (BOSTA, DATA_AL, DATA_GONDER);
  signal r_Data_Cntrl : t_Data_Cntrl := BOSTA;
  signal r_tx_basla   : std_logic := '0';
  signal r_tx_tamam   : std_logic := '0';
  signal r_rx_tamam   : std_logic := '0';
  signal r_tx_data    : std_logic_vector(7 downto 0) := (others => '0');
  signal r_rx_data    : std_logic_vector(7 downto 0) := (others => '0');
  signal led          : std_logic_vector(15 downto 0) := (others => '0');

begin

  process(clk, rst)
  begin
    if rst = '1' then
      r_Data_Cntrl <= BOSTA;
      r_tx_basla <= '0';
      r_tx_data <= (others => '0');

    elsif rising_edge(clk) then
      r_tx_basla <= '0'; -- Varsayılan: Gönderme tetiklemesini düşük tut

      case r_Data_Cntrl is
        when BOSTA =>
          r_Data_Cntrl <= DATA_AL; -- Yeni veri bekleme durumuna geç

        when DATA_AL =>
          if r_rx_tamam = '1' then
            r_tx_data <= r_rx_data;   -- Alınan veriyi tx modülüne ata
            led(15 downto 8) <= led(7 downto 0); -- Kaydırma işlemi
            led(7 downto 0) <= r_rx_data;
            r_tx_basla <= '1';        -- Veri gönderimini tetikleyici
            r_Data_Cntrl <= DATA_GONDER;
          end if;

        when DATA_GONDER =>
          if r_tx_tamam = '1' then
            r_Data_Cntrl <= BOSTA;    -- Gönderim tamamlandığında başa dön
          end if;

        when others => NULL;
      end case;
    end if;
  end process;

  i_uart_rx : uart_rx 
  generic map(
    c_clkfreq  => c_clkfreq,
    c_baudrate => c_baudrate
  )
  port map(
    in_clk      => clk,
    in_rst      => rst,
    in_rx       => rx_i,
    out_rx_data => r_rx_data,
    out_rx_tamam=> r_rx_tamam
  );

  o_uart_tx : uart_tx
  generic map(
    c_clkfreq  => c_clkfreq,
    c_baudrate => c_baudrate,
    c_stopbit  => c_stopbit
  )
  port map(
    in_clk      => clk,
    in_rst      => rst,
    in_tx_basla => r_tx_basla,
    in_tx_data  => r_tx_data,
    out_tx      => tx_o,
    out_tx_tamam=> r_tx_tamam
  );

  leds_o <= led;

end Behavioral;
