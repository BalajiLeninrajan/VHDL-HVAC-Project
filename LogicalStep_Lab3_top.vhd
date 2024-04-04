library ieee;
use ieee.std_logic_1164.all;

entity LogicalStep_Lab3_top is port (
    clkin_50		: in    std_logic;
    pb_n			: in	std_logic_vector(3 downto 0);
    sw   			: in    std_logic_vector(7 downto 0);

    ----------------------------------------------------
    -- HVAC_temp       : out   std_logic_vector(3 downto 0);   -- used for simulations only. Comment out for FPGA download compiles.
    ----------------------------------------------------

    leds			: out   std_logic_vector(7 downto 0);
    seg7_data 	    : out   std_logic_vector(6 downto 0);   -- 7-bit outputs to a 7-segment
    seg7_char1      : out   std_logic;				    	-- seg7 digit1 selector
    seg7_char2      : out	std_logic				    	-- seg7 digit2 selector
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

    component SevenSegment port (
        hex         : in    std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
        sevenseg    : out   std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
    ); 
    end component SevenSegment;

    component segment7_mux port (
        clk     : in    std_logic := '0';
        DIN2 	: in    std_logic_vector(6 downto 0);	
        DIN1 	: in    std_logic_vector(6 downto 0);
        DOUT	: out   std_logic_vector(6 downto 0);
        DIG2	: out	std_logic;
        DIG1	: out	std_logic
    );
    end component segment7_mux;

    component Tester port (
        MC_TESTMODE				: in    std_logic;
        I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
    	input1					: in    std_logic_vector(3 downto 0);
        input2					: in    std_logic_vector(3 downto 0);
        TEST_PASS  				: out	std_logic
    ); 
    end component;

    component HVAC port (
    	HVAC_SIM			: in    boolean;
    	clk					: in    std_logic; 
        run		   			: in    std_logic;
        increase, decrease  : in    std_logic;
        temp				: out   std_logic_vector (3 downto 0)
    );
    end component;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------

    -- 4-bit comparator
    -- takes 2 4-bit inputs and compares magnitudes
    component Compx4 is port (
        IN_A, IN_B                      : in    std_logic_vector(3 downto 0);
        OUT_AGTB, OUT_AEQB, OUT_ALTB    : out   std_logic
    );
    end component;

    -- converts buttons from active low to active high
    component Pb_inverters is port (
        pb_n    : in    std_logic_vector(3 downto 0);
        pb      : out   std_logic_vector(3 downto 0)
    );
    end component;

    -- 2 - 1 MUX
    -- selects between 2 hex inputs
    component Two_to_one_mux is port (
        hex_num1, hex_num0  : in    std_logic_vector(3 downto 0);
        mux_select          : in    std_logic;
        hex_out             : out   std_logic_vector(3 downto 0)
    );
    end component;

    component Energy_Monitor is port (
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
    end component;

------------------------------------------------------------------
-- Create any additional internal signals to be used
------------------------------------------------------------------
    constant HVAC_SIM : boolean := FALSE;   -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                            -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

    -- global clock
    signal clk_in					    : std_logic;
    signal desired_temp, vacation_temp  : std_logic_vector(3 downto 0);
    signal hexA_7seg, hexB_7seg         : std_logic_vector(6 downto 0);

    -- buttons
    signal pb                           : std_logic_vector(3 downto 0);

    signal mux_temp, current_temp       : std_logic_vector(3 downto 0);
    signal temp_cmp                      : std_logic_vector(2 downto 0);
    signal increase, decrease, run      : std_logic;
------------------------------------------------------------------- 
begin -- Here the circuit begins

    clk_in <= clkin_50;	--hook up the clock input

    -- HVAC_temp <= current_temp;

    -- temp inputs hook-up to internal busses.
    desired_temp <= sw(3 downto 0);
    vacation_temp <= sw(7 downto 4);

    -- Initialize 7 segment displays
    Inst1: sevensegment port map (mux_temp, hexA_7seg);
    Inst2: sevensegment port map (current_temp, hexB_7seg);
    Inst3: segment7_mux port map (
        clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1
    );

    -- invert buttons
    Inst4: Pb_inverters port map (pb_n, pb);

    Inst5: Two_to_one_mux port map (
        vacation_temp, desired_temp, pb(3), mux_temp
    );

    Inst6: Compx4 port map (
        mux_temp, current_temp, temp_cmp(1), temp_cmp(0), temp_cmp(2)
    );

    Inst7: HVAC port map (
        HVAC_SIM, clk_in, run, increase, decrease, current_temp
    );

    Inst8: Tester port map (
        pb(2), temp_cmp(0), temp_cmp(1), temp_cmp(2), 
        desired_temp, current_temp, leds(6)
    );

    Inst9: Energy_Monitor port map (
        temp_cmp(1), temp_cmp(0), temp_cmp(2), pb(3), pb(2), pb(1), pb(0),
        leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7),
        run, increase, decrease
    );

end architecture;