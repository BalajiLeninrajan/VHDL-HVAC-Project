library ieee;
use ieee.std_logic_1164.all;

-- 1-bit comparator
-- takes 2 bits and compares magnitudes
entity Compx1 is port (
    IN_A, IN_B          : in    std_logic;  -- inputs to compare
    AGTB, AEQB, ALTB    : out   std_logic   -- magnitude outputs (greater than, equal to, less than), active high
);
end entity;

architecture cmp of Compx1 is
begin
    AGTB <= IN_A and not(IN_B); -- greater than set to true when IN_A is true and IN_B is false (1 > 0)
    AEQB <= IN_A xnor IN_B;     -- true when both IN_A and IN_B have the same bit value (0 = 0 & 1 = 1)
    ALTB <= not(IN_A) and IN_B; -- greater than set to true when IN_A is false and IN_B is true (0 < 1)
end cmp;