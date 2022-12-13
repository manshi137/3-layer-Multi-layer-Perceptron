library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity seven_seg is 
    port(
        din: in std_logic_vector(3 downto 0);-- no to be displayed 
        clk: in std_logic;
        -- four_bit_anode : out std_logic_vector(3 downto 0);
        seven_bit_out: out std_logic_vector(6 downto 0)
    );
end seven_seg;

architecture arch of seven_seg is
begin
    process(clk) is
    begin
      
        if(rising_edge(clk)) then
            -- four_bit_anode<="1110";
            -- four_bit_anode<="1110";
            seven_bit_out(6)<=(not din(3) and not din(2) and not din(1) and din(0)) or (din(2) and not din(1)and not din(0));
            seven_bit_out(5)<=( din(2) and not din(1) and din(0)) or (din(2) and din(1) and not din(0));
            seven_bit_out(4)<=(not din(2) and din(1) and not din(0));
            seven_bit_out(3)<=(din(2) and din(1) and din(0)) or (not din(3) and not din(2) and not din(1) and din(0)) or (din(2) and not din(1) and not din(0));
            seven_bit_out(2)<=( din(0)) or ( din(2) and not din(1) );
            seven_bit_out(1)<=(not din(2) and din(1)) or (din(1) and din(0)) or (not din(3) and not din(2) and din(0));
            seven_bit_out(0)<=(not din(3) and not din(2) and not din(1)) or ( din(2) and din(1) and din(0));
        end if;
    
    end process; 
end arch;
