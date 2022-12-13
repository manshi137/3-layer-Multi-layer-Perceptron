library IEEE;
-- use work.myTypes.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- entity definition
entity testbench is
    -- empty
end testbench;
-- implementing the architecture of the test_bench
architecture implement_tb of testbench is
    component fsm_new is
        port(
               basys_clk : in std_logic ;
   
           four_bit_anode: out std_logic_vector(3 downto 0):=(others=>'0');                   --toactivate the 4 anodes
--           dummystate: out std_logic_vector(4 downto 0):="00001";

           seven_bit_out: out std_logic_vector(6 downto 0):=(others=>'0')     --toactivate the 7 cathodes
           );
    end component;
    
    signal clock: std_logic:='0';
    signal seven_bit_out : std_logic_vector(6 downto 0):=(others=>'0');
    signal four_bit_anode : std_logic_vector(3 downto 0):= (others=>'0');
--    signal dummystate: std_logic_vector(4 downto 0):="00001";

begin
    fsm: fsm_new port map(
    	basys_clk =>clock,
        
        four_bit_anode => four_bit_anode,
--        dummystate =>dummystate,
        seven_bit_out =>seven_bit_out
       );
       
    process
    begin
        clock <= '0';
        for i in 0 to 1220000 loop
            clock <= not clock;
            wait for 1 ps;
        end loop;    
        wait;
    end process;
end implement_tb;
