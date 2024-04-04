-- Author: Group 12, Balaji Leninrajan, Kayla Chang
library ieee;
use ieee.std_logic_1164.all;

-- selects between 2 hex inputs
entity Two_to_one_mux is port (
    hex_num1, hex_num0  : in    std_logic_vector(3 downto 0); -- hex inputs
    mux_select          : in    std_logic;                    -- selection toggle
    hex_out             : out   std_logic_vector(3 downto 0)  -- hex output
);
end entity;

architecture mux_logic of Two_to_one_mux is

begin

    with mux_select select -- selects between hex_num0 and hex_num1
    hex_out <=  hex_num0 when '0',
                hex_num1 when '1';

end architecture;