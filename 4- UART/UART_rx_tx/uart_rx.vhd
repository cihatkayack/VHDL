library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uart_rx is
	generic(
		c_clkfreq  : integer := 100_000_000; -- 100 MHz
		c_baudrate : integer := 115_200
	);
    Port ( 
		in_clk 			: in std_logic;
		in_rst 			: in std_logic;
		in_rx 			: in std_logic;
		out_rx_data 	: out std_logic_vector(7 downto 0);
		out_rx_tamam	: out std_logic
	);
end uart_rx;

architecture Behavioral of uart_rx is

	constant c_bittimerlim  : integer := c_clkfreq / c_baudrate -1;
	
	type states is (BOSTA, BASLA, GONDER, BITIR, TAMAM);
    signal state          : states := BOSTA;

    signal bitcntr        : integer range 0 to 7 := 0;
    signal clk_cntr    : integer range 0 to c_bittimerlim*3/2 - 1 := 0;
    signal shreg		  : std_logic_vector (7 downto 0) := (others => '0');
	signal r_tx_tamam     : std_logic := '0'; 


begin
	out_rx_tamam <= r_tx_tamam;
	
	P_MAIN : process (in_clk) begin
		if (rising_edge(in_clk)) then
			case state is
				when BOSTA =>
					bitcntr <= 0;
					clk_cntr <= 0;
					r_tx_tamam <= '0';
					if (in_rx = '0') then
						state <= BASLA;
					end if;
				when BASLA =>
					if (clk_cntr = c_bittimerlim / 2 - 1) then
						clk_cntr <= 0;
						state <= GONDER;
					else
						clk_cntr <= clk_cntr + 1;
					end if;
				when GONDER =>
					if (clk_cntr = c_bittimerlim - 1) then
						if (bitcntr = 7) then
							state	<= BITIR;
							bitcntr	<= 0;
						else
							bitcntr <= bitcntr + 1;
						end if;
						shreg		<= in_rx & (shreg(7 downto 1));
						clk_cntr <= 0;
					else
						clk_cntr <= clk_cntr + 1;
					end if;
				when BITIR =>
					if (clk_cntr = c_bittimerlim-1) then
						state			<= TAMAM;
						clk_cntr		<= 0;
					else
						clk_cntr	<= clk_cntr + 1;
					end if;			
				when TAMAM =>
					r_tx_tamam <= '1';
                    state <= BOSTA;
			end case;
		end if;
	end process P_MAIN;
	out_rx_data	<= shreg;
end Behavioral;
