library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity full_adder is
  Port ( 
      a_i : in std_logic;
      b_i : in std_logic;
      carry_i : in std_logic;
      sum_o : out std_logic;
      carry_o : out std_logic
  );
end full_adder;

architecture Behavioral of full_adder is

component half_adder is
  Port ( 
    a_i : in std_logic;
    b_i : in std_logic;
    sum_o : out std_logic;
    carry_o : out std_logic
  );
end component half_adder;

signal first_sum	: std_logic := '0';
signal first_carry	: std_logic := '0';
signal second_carry	: std_logic := '0';

begin

firstHalfAdder : half_adder
port map(
    a_i => a_i,
    b_i => b_i,
    sum_o => first_sum,
    carry_o => first_carry
);

secondHalfAdder : half_adder
port map(
    a_i => first_sum,
    b_i => carry_i,
    sum_o => sum_o,
    carry_o => second_carry
);

carry_o <= first_carry or second_carry;

end Behavioral;



























