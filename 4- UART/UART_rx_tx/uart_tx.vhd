library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_tx is
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
end uart_tx;

architecture Behavioral of uart_tx is


    constant c_bittimerlim  : integer := c_clkfreq / c_baudrate + 1;
    constant c_stopbitlim   : integer := (c_clkfreq / c_baudrate) * c_stopbit + 1;

    type states is (BOSTA, BASLA, GONDER, BITIR, TAMAM);
    signal state          : states := BOSTA;

    signal bitcntr        : integer range 0 to 7 := 0;
    signal r_clk_sayac    : integer range 0 to c_stopbitlim - 1 := 0;
    signal r_data         : std_logic_vector(7 downto 0) := (others => '0');
    signal r_tx           : std_logic := '1';
    signal r_tx_tamam     : std_logic := '0';  

begin

    out_tx <= r_tx;
    out_tx_tamam <= r_tx_tamam;

    process(in_clk, in_rst)
    begin
        if (in_rst = '1') then
            state <= BOSTA;
            r_tx <= '1';
            r_clk_sayac <= 0;
            r_tx_tamam <= '0';
            r_data <= (others => '0');
            bitcntr <= 0;

        elsif(rising_edge(in_clk)) then
            case state is
                when BOSTA =>
                    r_tx <= '1';
                    r_clk_sayac <= 0;
                    bitcntr <= 0;
					r_data <= (others => '0');
                    if in_tx_basla = '1' then
                        r_data <= in_tx_data;
                        state <= BASLA;
                    end if;
                when BASLA =>
					r_tx_tamam <= '0';
                    r_tx <= '0';
                    if (r_clk_sayac = c_bittimerlim/2 - 1) then
                        r_clk_sayac <= 0;
                        state <= GONDER;
                    else 
                        r_clk_sayac <= r_clk_sayac + 1;
                    end if;
                when GONDER =>
                    r_tx <= r_data(bitcntr);
                    if (r_clk_sayac = c_bittimerlim - 1) then
                        r_clk_sayac <= 0;
                        if (bitcntr = 7) then
                            bitcntr <= 0;
                            state <= BITIR;
                        else
                            bitcntr <= bitcntr + 1;
                        end if;
                    else 
                        r_clk_sayac <= r_clk_sayac + 1;
                    end if;                     
                when BITIR =>
                    r_tx <= '1';
                    if (r_clk_sayac = c_bittimerlim - 1) then
                        r_clk_sayac <= 0;
                        state <= TAMAM;
                    else 
                        r_clk_sayac <= r_clk_sayac + 1;
                    end if;
                when TAMAM =>
                    r_tx <= '1';
                    r_tx_tamam <= '1';
                    state <= BOSTA;

                when others => NULL;
            end case;
        end if;
    end process;

end Behavioral;