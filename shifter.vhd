library IEEE;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity shifter is 
    port (
--        clk: in std_logic;
        enable: in std_logic;
        valin: in std_logic_vector(15 downto 0);
        valout: out std_logic_vector(15 downto 0)
    );
end shifter;
architecture shifter_arch of shifter is 
begin
    process(enable, valin) is
    begin
        --if(rising_edge(clk)) then
            if(enable='1') then
                if (valin(15) = '0') then
                    valout<= "00000" & valin(15 downto 5);
                else 
                    valout <= "11111" & valin(15 downto 5);
                end if;
--            else 
--                valout <= valin;
            end if;
        --end if;
    end process;
end shifter_arch;
