LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu_n IS
    GENERIC(n: INTEGER :=5);
PORT(
    xn, yn: IN STD_LOGIC_VECTOR(5-1 downto 0);
    fn: IN STD_LOGIC_VECTOR(2 downto 0);
    Sn: OUT STD_LOGIC_VECTOR(5-1 downto 0)
);
END alu_n;

ARCHITECTURE alu_n_arch of alu_n IS

    COMPONENT alu
        PORT(
            x, y, inc: IN STD_LOGIC;
            f: IN STD_LOGIC_VECTOR(2 downto 0);
            S, cout: OUT STD_LOGIC
        );
    END COMPONENT;

    SIGNAL carries: STD_LOGIC_VECTOR(5 downto 0) := "000000";

BEGIN
    carries(0) <= '0';

    RIPALU: for i in 0 to 5-1 generate
        RIPALU_i: alu PORT MAP(xn(i), yn(i), carries(i), fn, Sn(i), carries(i+1));
    END GENERATE;
END alu_n_arch;

CONFIGURATION alu_n_cfg OF alu_n IS
        FOR alu_n_arch
        END FOR;
END CONFIGURATION;