library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity binary_multiplier is
  Port ( 
    a_i : in std_logic_vector(1 downto 0);
    b_i : in std_logic_vector(1 downto 0);
    sum_o : out std_logic_vector(2 downto 0);
    carry_o : out std_logic
  );
end binary_multiplier;

architecture Behavioral of binary_multiplier is

component half_adder is
  Port ( 
    a_i : in std_logic;
    b_i : in std_logic;
    sum_o : out std_logic;
    carry_o : out std_logic
  );
end component half_adder;

signal carry_first : std_logic := '0';

begin

sum_o(0) <= a_i(0) and b_i(0);

hald_adder_1: half_adder
port map(
    a_i => (a_i(0) and b_i(1)),
    b_i => (a_i(1) and b_i(0)),
    sum_o => sum_o(1),
    carry_o => carry_first
);

hald_adder_2: half_adder
port map(
    a_i => carry_first,
    b_i => (a_i(1) and b_i(1)),
    sum_o => sum_o(2),
    carry_o => carry_o
);


end Behavioral;









