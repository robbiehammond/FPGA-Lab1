LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Design assumptions made
    -- Only one thing can happen per clock cycle (ex: you can't insert money and reset at the same time).
    -- Each 'event' (inserting money, ordering a drink, etc) lasts at least 2 clock cycles.
    -- A maximum of $2.56 can be inserted at once.
    -- Signals for when the drink is deposited and the amount of change hold their value until an operation makes them be overriden (for example, change will stay the same until a new amount of change is deposited.)

ENTITY test_bench IS
END test_bench;

ARCHITECTURE behavior of test_bench IS

COMPONENT controller
    PORT(
        s1 : IN STD_LOGIC; -- When sensor high, car wants to enter. 
        s2 : IN STD_LOGIC;  -- When sensor high, car wants to leave.
        clk : IN STD_LOGIC;

        override : IN STD_LOGIC; 
        stop : IN STD_LOGIC;

        lot_closed_signal : OUT STD_LOGIC;  -- is parking lot even open
        lot_open_signal: OUT STD_LOGIC;
        lot_full_signal: OUT STD_LOGIC;

        gate_up : OUT STD_LOGIC;
        gate_down : OUT STD_LOGIC;

        count : OUT STD_LOGIC_VECTOR(4 downto 0)

    );
END COMPONENT;


SIGNAL s1 : STD_LOGIC := '0';
SIGNAL s2 :STD_LOGIC := '0';  -- 1 when car leaves, 0 other times
SIGNAL clk : STD_LOGIC := '0';
SIGNAL override : STD_LOGIC;

SIGNAL stop :STD_LOGIC;
SIGNAL lot_closed : STD_LOGIC;
SIGNAL lot_open : STD_LOGIC;
SIGNAL lot_full: STD_LOGIC;

SIGNAL gate_up : STD_LOGIC;
SIGNAL gate_down : STD_LOGIC;


SIGNAL count : STD_LOGIC_VECTOR(4 downto 0);


BEGIN 

    uut: controller PORT MAP (
        s1, s2, clk, override, stop, lot_closed, lot_open, lot_full, gate_up, gate_down, count
    );

CLOCK:
clk <=  '1' after 10 ns when clk = '0' else
        '0' after 10 ns when clk = '1';

PROCESS
    BEGIN
        stop <= '1' after 10 ns, '0' after 20 ns;
        s1 <= '1' after 30 ns, '0' after 100 ns, '1' after 150 ns, '0' after 200 ns, '1' after 550 ns, '0' after 700 ns;
        s2 <= '1' after 300 ns, '0' after 400 ns;
        override <= '1' after 500 ns, '0' after 600 ns;
    wait;
    END PROCESS;
END behavior;


