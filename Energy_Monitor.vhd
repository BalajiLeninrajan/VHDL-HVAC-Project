library ieee;
use ieee.std_logic_1164.all;

-- Energy Monitor
entity Energy_Monitor is port (
    AGTB, AEQB, ALTB            : in    std_logic;
    vacation_mode, MC_test_mode : in    std_logic;
    window_open, door_open      : in    std_logic;
    furnace                     : out   std_logic;
    at_temp                     : out   std_logic;
    AC                          : out   std_logic;
    blower                      : out   std_logic;
    window                      : out   std_logic;
    door                        : out   std_logic;
    vacation                    : out   std_logic;
    run, increase, decrease     : out   std_logic
);
end Energy_Monitor ;

architecture monitor_logic of Energy_Monitor is

begin
    vacation    <= vacation_mode;
    window      <= window_open;
    door        <= door_open;
    at_temp     <= AEQB;
    furnace     <= AGTB;
    increase    <= AGTB;
    AC          <= ALTB;
    decrease    <= ALTB;
    blower      <= not(AEQB) and not(MC_test_mode) and not(window_open) and not(door_open);
    run         <= not(AEQB) and not(MC_test_mode) and not(window_open) and not(door_open);

end architecture;