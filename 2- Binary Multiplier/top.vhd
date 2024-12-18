library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
port (
SW		: in std_logic_vector (3 downto 0);
LED		: out std_logic_vector (3 downto 0)
);
end top;

architecture Behavioral of top is

-- COMPONENT DECLERATION
component binary_multiplier is
  Port ( 
    a_i : in std_logic_vector(1 downto 0);
    b_i : in std_logic_vector(1 downto 0);
    sum_o : out std_logic_vector(2 downto 0);
    carry_o : out std_logic
  );
end component binary_multiplier;

begin

-- COMPONENT INSTANTIATION
binaryMultiplier : binary_multiplier
port map(
a_i		=> SW(1 downto 0),
b_i		=> SW(3 downto 2),
sum_o	=> LED(2 downto 0),
carry_o	=> LED(3)
);

end Behavioral;