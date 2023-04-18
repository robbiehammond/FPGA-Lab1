LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY subtractor_full IS
        PORT (
                a, b, Ein: IN STD_LOGIC;
                D, Eout: OUT STD_LOGIC
        );
END subtractor_full;

ARCHITECTURE subtractor_full_arch OF subtractor_full IS
BEGIN
    Eout <= (Ein AND(NOT (a XOR b))) OR ((NOT a) AND b);
    D <= (a XOR b) XOR Ein;   
END subtractor_full_arch;

CONFIGURATION subtractor_full_cfg OF subtractor_full IS
        FOR subtractor_full_arch
        END FOR;
END CONFIGURATION;