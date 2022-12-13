library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity comparator is 
    port(
        vin: in std_logic_vector(15 downto 0);
        vout: out std_logic_vector(15 downto 0)
        );
end comparator;

architecture comparator_arch of comparator is
begin
    process(vin) 
    begin
        if( vin(15)='1' ) then
            vout<=x"0000";
        else 
            vout<=vin;
        end if;
    end process;
end comparator_arch;
