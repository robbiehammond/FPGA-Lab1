LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
PORT(
    x, y, inc: IN STD_LOGIC;
    f: IN STD_LOGIC_VECTOR(2 downto 0);
    S, cout: OUT STD_LOGIC 
);
END alu;

ARCHITECTURE alu_arch of alu IS
    COMPONENT subtractor_full
        PORT(a, b, Ein: IN STD_LOGIC; D, Eout: OUT STD_LOGIC);
    END COMPONENT;

    COMPONENT adder_full
        PORT(x, y, z: IN STD_LOGIC; Sum, Carry: OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL addsum, addcout, diffsum, diffcout: STD_LOGIC;

BEGIN
    adder: adder_full PORT MAP (x, y, inc, addsum, addcout);
    subtractor: subtractor_full PORT MAP (x, y, inc, diffsum, diffcout);

     WITH f SELECT
        S <=
            '0' WHEN "000",
            x WHEN "001",
            y WHEN "010",
            inc WHEN "011",
            (x OR y) WHEN "100",
            (x AND y) WHEN "101",
            addsum WHEN "110",
            diffsum WHEN "111",
            'Z' WHEN OTHERS;

    WITH f SELECT
        cout <=
            '0' WHEN "000",
            '1' WHEN "001",
            '1' WHEN "010",
            x WHEN "011",
            x WHEN "100",
            x WHEN "101",
            addcout WHEN "110",
            diffcout WHEN "111",
            'Z' WHEN OTHERS;

END alu_arch;

CONFIGURATION alu_cfg OF alu IS
        FOR alu_arch
        END FOR;
END CONFIGURATION;