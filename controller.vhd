library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.numeric_std.ALL;


ENTITY controller IS 
    PORT(
        s1 : IN STD_LOGIC; -- When sensor high, car wants to enter. 
        s2 : IN STD_LOGIC;  -- When sensor high, car wants to leave.
        clk : IN STD_LOGIC;

        override : IN STD_LOGIC; 
        stop : IN STD_LOGIC; -- high is closed, low is open

        lot_closed_signal : OUT STD_LOGIC;  -- is parking lot even open
        lot_open_signal : OUT STD_LOGIC;
        lot_full_signal : OUT STD_LOGIC
        --count : OUT STD_LOGIC_VECTOR(4 downto 0)


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
    SIGNAL State: machineState := Lot_Empty;

    SIGNAL number_cars_int: STD_LOGIC_VECTOR(4 downto 0) := "00000"; -- reg output, one alu input
    SIGNAL reg_out_int: STD_LOGIC_VECTOR(4 downto 0) := "00000"; -- reg output, one alu input

    SIGNAL number_cars : STD_LOGIC_VECTOR(4 downto 0) := "00000"; -- reg output, one alu input
    SIGNAL car_change : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    SIGNAL alu_function : STD_LOGIC_VECTOR(2 downto 0) := "110"; -- default to add
    SIGNAL alu_out : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    SIGNAL alu_out_int : STD_LOGIC_VECTOR(4 downto 0) := "00000";

    SIGNAL s1_int : STD_LOGIC := '0';

    SIGNAL s2_int : STD_LOGIC := '0';

    SIGNAL regEnable : STD_LOGIC := '1';
    SIGNAL regClear : STD_LOGIC := '0';

    SIGNAL s1_clock_count : INTEGER := 0;
    SIGNAL s2_clock_count : INTEGER := 0;

BEGIN
    alu5 : alu_n PORT MAP(number_cars, car_change, alu_function, alu_out_int);
    reg : reg_5 PORT MAP(alu_out, reg_out_int, clk, regEnable, regClear);
    PROCESS (clk)
        BEGIN
        if rising_edge(clk) then
            if stop = '1' then
                State <= Lot_Closed;
            elsif stop = '0' then
                State <= Lot_Empty; --kinda weird, but this is how it is on the FSM.
            end if;


            if s1 = '0' and s2 = '0' then
                regEnable <= '0';
                car_change <= "00000";
                s1_clock_count <= 0;

            elsif s1 = '1' then
                s1_clock_count <= 0;
                regEnable <= '1';
                car_change <= "00001";
                alu_function <= "110";
                
                -- As implemented, if s1 goes high at all when override is high, that car isn't counted.
                if override = '1' then 
                    regEnable <= '0';
                    car_change <= "00000";
                elsif s1_int = '0' then -- if s1 actually changed (not just reading from prev cycle)
                    s1_clock_count <= 0;
                    regEnable <= '1';
                    car_change <= "00001";
                    alu_function <= "110";

                    if State = Lot_Empty then
                        State <= Cars_In_Lot;

                    elsif State = Cars_In_Lot then
                        -- If number of cars is 19 and we add one, lot becomes full
                        if number_cars = "10011" then
                            State <= Lot_Full;
                        end if;

                    elsif State = Lot_Full then 
                        null;

                    elsif State = Lot_Closed then
                        null;

                    end if;
                else  -- if it already was 1, don't do anything special
                    s1_clock_count <= s1_clock_count + 1;
                    if s1_clock_count = 3 then -- takes about 3 clock ticks for everything to propogate.
                        s1_clock_count <= 0;
                        regEnable <= '0';
                    end if;
                end if;

            elsif s2 = '1' then
                if s2_int = '0' then -- if s2 actually changed
                    regEnable <= '1';
                    car_change <= "00001";
                    alu_function <= "111";
                    if State = Lot_Empty then
                        null;
                    elsif State = Cars_In_Lot then
                        if number_cars = "00001" then
                            State <= Lot_Empty;
                        end if;
                    elsif State = Lot_Full then
                        State <= Cars_In_Lot;
                    elsif State = Lot_Closed then
                        null;
                    end if;
                else -- if already was 1, we've already considered this change
                    s2_clock_count <= s2_clock_count + 1;
                    if s2_clock_count = 3 then
                        s2_clock_count <= 0;
                        regEnable <= '0';
                    end if;
                end if;
            
            end if;


            -- Mess with output signals based on state
            case State is
                when Lot_Empty =>
                    lot_closed_signal <= '0';
                    lot_open_signal <= '1';
                    lot_full_signal <= '0';
                when Cars_In_Lot =>
                    lot_closed_signal <= '0';
                    lot_open_signal <= '1';
                    lot_full_signal <= '0';
                when Lot_Full =>
                    lot_closed_signal <= '0';
                    lot_open_signal <= '0';
                    lot_full_signal <= '1';
                when Lot_Closed =>
                    lot_closed_signal <= '1';
                    lot_open_signal <= '0';
                    lot_full_signal <= '0';
                when others => 
            end case;
            s1_int <= s1;
            s2_int <= s2;
            alu_out <= alu_out_int;
            number_cars_int <= reg_out_int;
            number_cars <= number_cars_int;
            -- count <= reg_out_int;
        end if;
    END PROCESS;
END controller_arch;

