library IEEE;
use IEEE.STD_LOGIC_1164.all;

ENTITY reg_5 IS PORT(
    d_in   : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    d_out   : OUT STD_LOGIC_VECTOR(4 DOWNTO 0); -- output
    clk : IN STD_LOGIC; -- clock.
    enable  : IN STD_LOGIC; -- load/enable.
    clear : IN STD_LOGIC -- async. clear.
);
END reg_5;

ARCHITECTURE reg5_desc OF reg_5 IS

BEGIN
    process(clk, clear)
    begin
        if enable = '1' then
            d_out <= d_in;
        end if;
        if clear = '1' then
            d_out <= "00000";
        end if;
    end process;
END reg5_desc;