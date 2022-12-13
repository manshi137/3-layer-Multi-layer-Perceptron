library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

entity ram is 
    port(
        din: in std_logic_vector(7 downto 0);
        addr: in std_logic_vector(6 downto 0);-- 7 bit addr
        we: in std_logic;
        clk: in std_logic;
        dout: out  std_logic_vector(7 downto 0)
    );
end ram;

architecture arch of ram is
    type memory is array (0 to 127) of std_logic_vector(7 downto 0);
    signal ram_memory : memory:=(others => x"00");
	begin
    process(clk, we, addr, din) is 
    begin
        if(rising_edge(clk)) then
            if(we='1') then 
                ram_memory(conv_integer(addr))<= din;
            end if;
        end if;
    end process;
    dout<=ram_memory(conv_integer(addr)); 
end arch;
