LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY adder_full IS
    PORT (
    x, y, z: IN std_logic;
    Sum, Carry: OUT std_logic
    );
END adder_full;

ARCHITECTURE adder_full_arch OF adder_full IS
BEGIN
    Sum <= ( ( x XOR y ) XOR z );
    Carry <= (( x AND y ) OR (z AND (x XOR y)));
END adder_full_arch;

CONFIGURATION adder_full_cfg OF adder_full IS
        FOR adder_full_arch
        END FOR;
END CONFIGURATION;