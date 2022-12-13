-- Code your design here
library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity mac is 
    port(
        din1: in std_logic_vector(7 downto 0);-- 8 bit vector 1
        din2: in std_logic_vector(15 downto 0);-- 16 bit vector 2
        cntrl: in std_logic_vector(1 downto 0);-- control enable for ac
        clk: in std_logic;
        dout: out std_logic_vector(15 downto 0) -- 8 bit vector product
    );
end mac;

architecture arch of mac is
    signal temp: std_logic_vector(15 downto 0):=(others=>'0');
	begin
    
        process(cntrl, clk, din1, din2) is
        variable prod : std_logic_vector(23 downto 0);
        begin
            if( rising_edge(clk) and cntrl(1)='1') then
                prod := std_logic_vector(signed(din1)*signed(din2));	
                if(cntrl(0)='0') then
                    temp<= std_logic_vector(signed(temp)+signed(prod(15 downto 0)));
                else 
                   temp <= prod(23)&prod(14 downto 0);
                end if;
            end if;
        end process;
        dout <= temp(15 downto 0);
    
end arch;
     




      
