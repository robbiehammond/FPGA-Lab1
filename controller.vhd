library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY controller IS 
    PORT(
        s1 : IN STD_LOGIC; -- When sensor high, car wants to enter. 
        s2 : IN STD_LOGIC;  -- When sensor high, car wants to leave.
        clk : IN STD_LOGIC;

        override : IN STD_LOGIC; 
        start : IN STD_LOGIC; -- when high, things happen normally.
        stop : IN STD_LOGIC; -- when high, lot_closed is high.

        lot_closed_signal : OUT STD_LOGIC;  -- is parking lot even open
        lot_open_signal : OUT STD_LOGIC;
        lot_full_signal : OUT STD_LOGIC;

        gate_up : OUT STD_LOGIC;
        gate_down : OUT STD_LOGIC;

        count : OUT STD_LOGIC_VECTOR(4 downto 0)


    );
END ENTITY;

ARCHITECTURE controller_arch of controller IS 
constant NUM_BITS : INTEGER := 5;
    COMPONENT alu_n
        GENERIC(n: INTEGER := NUM_BITS);
        PORT(
            xn, yn:  IN std_logic_vector(5 - 1 downto 0);
            fn: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Sn: OUT STD_LOGIC_VECTOR(5 - 1 downto 0)
        );
    END COMPONENT;


    COMPONENT reg_5
        PORT(
            d_in : IN STD_LOGIC_VECTOR(4 downto 0);
            d_out : OUT STD_LOGIC_VECTOR(4 downto 0);
            clk : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            clear : IN STD_LOGIC
        );
    END COMPONENT;


    TYPE machineState is (Lot_Empty, Cars_In_Lot, Lot_Full, Lot_Closed);
    SIGNAL State: machineState;

    SIGNAL prev_number_cars: STD_LOGIC_VECTOR(4 downto 0) := "00000"; -- reg output, one alu input

    SIGNAL number_cars : STD_LOGIC_VECTOR(4 downto 0) := "00000"; -- reg output, one alu input
    SIGNAL car_change : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    SIGNAL alu_function : STD_LOGIC_VECTOR(2 downto 0) := "110"; -- default to add
    SIGNAL alu_out : STD_LOGIC_VECTOR(4 downto 0) := "00000";

    SIGNAL regEnable : STD_LOGIC := '0';
    SIGNAL regClear : STD_LOGIC := '0';

BEGIN
    alu5 : alu_n PORT MAP(prev_number_cars, car_change, alu_function, alu_out);
    reg : reg_5 PORT MAP(alu_out, number_cars, clk, regEnable, regClear);
    PROCESS (clk)
        BEGIN
            if s1 = '1' then
                if State = Lot_Empty then
                    State <= Cars_In_Lot;
                elsif State = Cars_In_Lot then
                    if number_cars = "10011" then
                        State <= Lot_Full;
                    end if;
                elsif State = Lot_Full then 
                    null;
                elsif State = Lot_Closed then
                    null;
                end if;

            end if;

            case State is
                when Lot_Empty =>
                when Cars_In_Lot =>
                when Lot_Full =>
                when Lot_Closed =>
                when others => 
            end case;
    END PROCESS;
END controller_arch;

