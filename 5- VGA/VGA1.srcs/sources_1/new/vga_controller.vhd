library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_controller is
    Port (
        clk_100MHz : in  std_logic;
        reset      : in  std_logic;
        video_on   : out std_logic;
        hsync      : out std_logic;
        vsync      : out std_logic;
        p_tick     : out std_logic;
        x          : out std_logic_vector(9 downto 0);
        y          : out std_logic_vector(9 downto 0)
    );
end vga_controller;

architecture Behavioral of vga_controller is

    -- VGA timing parameters
    constant HD   : integer := 640;
    constant HB   : integer := 48;  -- back porch
    constant HF   : integer := 16;  -- front porch
    constant HR   : integer := 96;  -- Sync Pulse
    constant HMAX : integer := HD + HF + HB + HR - 1;

    constant VD   : integer := 480;
    constant VF   : integer := 10;  -- front porch
    constant VB   : integer := 33;  -- back porch
    constant VR   : integer := 2;   -- Sync Pulse
    constant VMAX : integer := VD + VF + VB + VR - 1;

    -- 25MHz clock generation (divide by 4)
    signal r_25MHz : std_logic_vector(1 downto 0) := (others => '0');
    signal w_25MHz : std_logic;

    -- Counters and next states
    signal h_count_reg, h_count_next : unsigned(9 downto 0) := (others => '0');
    signal v_count_reg, v_count_next : unsigned(9 downto 0) := (others => '0');

    -- Sync signals
    signal h_sync_reg, v_sync_reg : std_logic := '0';
    signal h_sync_next, v_sync_next : std_logic;

begin

    -- 25MHz clock from 100MHz
    process(clk_100MHz, reset)
    begin
        if reset = '1' then
            r_25MHz <= (others => '0');
        elsif rising_edge(clk_100MHz) then
            r_25MHz <= std_logic_vector(unsigned(r_25MHz) + 1);
        end if;
    end process;

    w_25MHz <= '1' when r_25MHz = "00" else '0';  -- assert tick 1/4 of the time
    p_tick  <= w_25MHz;

    -- Horizontal counter logic
    process(clk_100MHz, reset)
    begin
        if reset = '1' then
            h_count_reg <= (others => '0');
        elsif rising_edge(clk_100MHz) then
            if w_25MHz = '1' then
                if h_count_reg = to_unsigned(HMAX, 10) then
                    h_count_reg <= (others => '0');
                else
                    h_count_reg <= h_count_reg + 1;
                end if;
            end if;
        end if;
    end process;

    -- Vertical counter logic
    process(clk_100MHz, reset)
    begin
        if reset = '1' then
            v_count_reg <= (others => '0');
        elsif rising_edge(clk_100MHz) then
            if w_25MHz = '1' then
                if h_count_reg = to_unsigned(HMAX, 10) then
                    if v_count_reg = to_unsigned(VMAX, 10) then
                        v_count_reg <= (others => '0');
                    else
                        v_count_reg <= v_count_reg + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- Sync generation
    h_sync_next <= '1' when h_count_reg >= to_unsigned(HD + HB, 10) and 
                             h_count_reg <= to_unsigned(HD + HB + HR - 1, 10) else '0';

    v_sync_next <= '1' when v_count_reg >= to_unsigned(VD + VB, 10) and 
                             v_count_reg <= to_unsigned(VD + VB + VR - 1, 10) else '0';

    -- Sync register assignment
    process(clk_100MHz, reset)
    begin
        if reset = '1' then
            h_sync_reg <= '0';
            v_sync_reg <= '0';
        elsif rising_edge(clk_100MHz) then
            h_sync_reg <= h_sync_next;
            v_sync_reg <= v_sync_next;
        end if;
    end process;

    -- Output logic
    video_on <= '1' when (h_count_reg < to_unsigned(HD, 10) and v_count_reg < to_unsigned(VD, 10)) else '0';
    hsync    <= h_sync_reg;
    vsync    <= v_sync_reg;
    x        <= std_logic_vector(h_count_reg);
    y        <= std_logic_vector(v_count_reg);

end Behavioral;
