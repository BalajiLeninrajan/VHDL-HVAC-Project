-- Author: Group 12, Balaji Leninrajan, Kayla Chang
library ieee;
use ieee.std_logic_1164.all;

-- converts buttons from active low to active high
entity Pb_inverters is port (
    pb_n    : in    std_logic_vector(3 downto 0); -- original buttons
    pb      : out   std_logic_vector(3 downto 0)  -- new inverted buttons
);
END entity;

architecture gates of Pb_inverters is
begin

    pb <= not(pb_n); -- converting active-low to active-high

end architecture;