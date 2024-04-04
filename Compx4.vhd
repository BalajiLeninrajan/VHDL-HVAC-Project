library ieee;
use ieee.std_logic_1164.all;

-- 4-bit comparator
-- takes 2 4-bit inputs and compares magnitudes
entity Compx4 is port (
    IN_A, IN_B                      : in    std_logic_vector(3 downto 0);   -- inputs to compare
    OUT_AGTB, OUT_AEQB, OUT_ALTB    : out   std_logic                       -- magnitude outputs 
                                                                            -- (greater than, equal to, less than)
);
end entity;

architecture cmp of Compx4 is
    -- 1-bit comparator
    -- takes 2 bits and compares magnitudes
    component Compx1 is port (
        IN_A, IN_B          : in    std_logic;
        AGTB, AEQB, ALTB    : out   std_logic
    );
    end component;

    -- sigals to store output from 1-bit comparators
    signal AGTB : std_logic_vector(3 downto 0);
    signal AEQB : std_logic_vector(3 downto 0);
    signal ALTB : std_logic_vector(3 downto 0);

begin
    
    -- running each individual pair of input bits through 1-bit comparator
    INST1: Compx1 port map(
        IN_A(0), IN_B(0), AGTB(0), AEQB(0), ALTB(0)
    );
    INST2: Compx1 port map(
        IN_A(1), IN_B(1), AGTB(1), AEQB(1), ALTB(1)
    );
    INST3: Compx1 port map(
        IN_A(2), IN_B(2), AGTB(2), AEQB(2), ALTB(2)
    );
    INST4: Compx1 port map(
        IN_A(3), IN_B(3), AGTB(3), AEQB(3), ALTB(3)
    );

    -- true if all bits are equal
    OUT_AEQB <= AEQB(3) and AEQB(2) and AEQB(1) and AEQB(0);

    -- true if exists greater than bit and all bits preceeding are equal
    OUT_AGTB <= AGTB(3) or 
                (AEQB(3) and AGTB(2)) or
                (AEQB(3) and AEQB(2) and AGTB(1)) or
                (AEQB(3) and AEQB(2) and AEQB(1) and AGTB(0));

    -- true if exists less than bit and all bits preceeding are equal
    OUT_ALTB <= ALTB(3) or 
                (AEQB(3) and ALTB(2)) or
                (AEQB(3) and AEQB(2) and ALTB(1)) or
                (AEQB(3) and AEQB(2) and AEQB(1) and ALTB(0));

end architecture;