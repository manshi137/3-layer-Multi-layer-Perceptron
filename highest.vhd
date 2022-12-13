library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity highest is 
    port(
        vin: in std_logic_vector(7 downto 0);
        iin : in std_logic_vector(3 downto 0);
        iout: out std_logic_vector(3 downto 0)
        );
end highest;

architecture highest_arch of highest is

signal maxval : integer := 0;
signal maxindex : std_logic_vector(3 downto 0) := (others => '0');
begin
    process(vin, iin) 
    begin
        if( conv_integer(vin) > maxval) then
            maxindex <= iin; maxval <= conv_integer(vin);
        end if;
    end process;
    iout <= maxindex;
end highest_arch;
