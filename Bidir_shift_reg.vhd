library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 8-bit bidirectional shift register
entity Bidir_shift_reg is port (
    CLK             : in    std_logic := '0';
    RESET           : in    std_logic := '0';
    CLK_EN          : in    std_logic := '0';
    LEFT0_RIGHT1    : in    std_logic := '0';
    REG_BITS        : out   std_logic_vector(7 downto 0)
);
end entity;

architecture one of Bidir_shift_reg is

    signal sreg : std_logic_vector(7 downto 0);

begin

    setBits: process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RESET = '1') then
                sreg <= "00000000";
            elsif (CLK_EN = '1') then
                if (LEFT0_RIGHT1 = '1') then
                    sreg(7 downto 0) <= '1' & sreg(7 downto 1);
                else
                    sreg(7 downto 0) <= sreg(6 downto 0) & '0';
                end if;
            end if;
        end if;
        REG_BITS <= sreg;
    end process;

end architecture;