library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity reg1 is 
    port(
        din: in std_logic_vector(7 downto 0);-- 8 bit vector 1
        dout: out std_logic_vector(7 downto 0);-- 8 bit vector 2
        clk: in std_logic;
        we: in std_logic
    );
end reg1;

architecture arch of reg1 is
signal reg_val : std_logic_vector(7 downto 0):=(others=>'0');
begin
    process(clk, we, din) is
    begin
        if(rising_edge(clk)) then
            if(we='1') then
                reg_val<= din;
                --dout<=reg_val;
            end if;
        end if; 
    end process; 
    dout<= reg_val;
end arch;
