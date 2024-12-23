library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
generic (
	c_clkfreq		: integer := 100_000_000;
	c_baudrate		: integer := 115_200;
	c_stopbit		: integer := 2
);
port (
	clk				: in std_logic;
	rst				: in std_logic;
	sw_i			: in std_logic_vector (7 downto 0);
	btnc_i			: in std_logic;
	tx_o			: out std_logic
);
end top;

architecture Behavioral of top is


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

signal btnc_deb			: std_logic := '0';
signal btnc_deb_next	: std_logic := '0';
signal tx_start			: std_logic := '0';
signal tx_done_tick		: std_logic := '0';

begin

	i_btnc : debounce
	generic map(
		c_clkfreq	=> c_clkfreq,
		c_debtime	=> 1000,
		c_initval	=> '0'
	)
	port map(
		clk			=> clk,
		signal_i	=> btnc_i,
		signal_o	=> btnc_deb
	);

	i_uart_tx : uart_tx
	generic map (
		c_clkfreq		=> c_clkfreq,	
		c_baudrate		=> c_baudrate,
		c_stopbit		=> c_stopbit	
	)
	port map(
		in_clk			=> clk,
		in_rst  		=> rst,
		in_tx_data		=> sw_i,
		in_tx_basla		=> tx_start,
		out_tx			=> tx_o,
		out_tx_tamam	=> tx_done_tick
	);
 
	process (clk) begin
		if (rising_edge(clk)) then

			btnc_deb_next	<= btnc_deb;
			tx_start		<= '0';
			
			if (btnc_deb = '1' and btnc_deb_next = '0') then
				tx_start	<= '1';
			end if;

		end if;
	end process;


end Behavioral;