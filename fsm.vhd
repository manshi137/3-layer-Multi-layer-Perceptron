library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;

-- check for data size in ram
-- remove clock and enable from rom 1 and 2

entity fsm_new is
   --generic (clockfreq: integer);
   
   port(
           basys_clk : in std_logic ;
       -- mac_cntrl : out std_logic;
       -- rom_addin : out std_logic_vector(15 downto 0);
       -- ram_addin : out std_logic_vector(6 downto 0);
       -- mac_din1 :  out std_logic_vector(7 downto 0);
       -- mac_din2 :  out std_logic_vector(15 downto 0);
       -- reg1_we :   out std_logic;
       -- reg2_we :   out std_logic;
       -- reg1_din :  out std_logic_vector(7 downto 0);
       -- reg2_din :  out std_logic_vector(7 downto 0);
--        outputclass : out std_logic_vector(3 downto 0):= (others=>'0');

       four_bit_anode: out std_logic_vector(3 downto 0):= "1110";
--       dummystate: out std_logic_vector(4 downto 0):="00001";
--toactivate the 4 anodes
       seven_bit_out: out std_logic_vector(6 downto 0):=(others=>'0')    
--toactivate the 7 cathodes
       );
end fsm_new;


architecture fsm_arch of fsm_new is

component seven_seg is
  port(
        din: in std_logic_vector(3 downto 0);-- no to be displayed 
        clk: in std_logic;
        -- four_bit_anode : out std_logic_vector(3 downto 0);
        seven_bit_out: out std_logic_vector(6 downto 0)
    );
end component;
component mac is
port(
   din1: in std_logic_vector(7 downto 0);-- 8 bit vector 1
   din2: in std_logic_vector(15 downto 0);-- 16 bit vector 2
   cntrl: in std_logic_vector(1 downto 0);-- control enable for ac
   clk: in std_logic;
   dout: out std_logic_vector(15 downto 0) -- 8 bit vector product
);
end component;

component ram is
    port(
        din: in std_logic_vector(7 downto 0);
        addr: in std_logic_vector(6 downto 0);-- 7 bit addr
        we: in std_logic;
        clk: in std_logic;
        dout: out  std_logic_vector(7 downto 0)
    );
end component;

component reg1 is
port(
       din: in std_logic_vector(7 downto 0);-- 8 bit vector 1
       dout: out std_logic_vector(7 downto 0);-- 8 bit vector 2
       clk: in std_logic;
       we: in std_logic
   );
end component;

component reg2 is
port(
       din: in std_logic_vector(7 downto 0);-- 8 bit vector 1
       dout: out std_logic_vector(7 downto 0);-- 8 bit vector 2
       clk: in std_logic;
       we: in std_logic
   );
end component;


component comparator is
port(
       vin: in std_logic_vector(15 downto 0);
       vout: out std_logic_vector(15 downto 0)
       );
end component;


component ROM_MEM is
generic (
         ADDR_WIDTH        : integer := 10;
         DATA_WIDTH        : integer := 8;
         IMAGE_SIZE        : integer := 784;
         IMAGE_FILE_NAME   : string :="imgdata_digit5.mif"
       );
port(
       addrin: in std_logic_vector(15 downto 0);-- 8 bit vector 1
           dout: out std_logic_vector(7 downto 0)
   );
end component;

component ROM_MEM2 is
generic (
         ADDR_WIDTH        : integer := 10;
         DATA_WIDTH        : integer := 8;
         WEIGHT_SIZE       : integer := 50890;
         WEIGHT_FILE_NAME   : string :="weights_bias.mif"
       );
port(
       addrin: in std_logic_vector(15 downto 0);-- 8 bit vector 1
           dout: out std_logic_vector(7 downto 0)
   );
end component;


component shifter is
port (
       enable: in std_logic;
       valin: in std_logic_vector(15 downto 0);
       valout: out std_logic_vector(15 downto 0)
   );
end component;

            
component highest is 
    port(
        vin: in std_logic_vector(7 downto 0);
        iin : in std_logic_vector(3 downto 0);
        iout: out std_logic_vector(3 downto 0)
        );
end component;

signal clk_count: integer:=0;
signal clock: std_logic:='0';
signal state: integer := 1;
--signal ip_add, w_add :    std_logic_vector(15 downto 0):= (others=>'0');
--signal w_add :     std_logic_vector(15 downto 0):= "0000010000000000";
--signal b_add :     std_logic_vector(15 downto 0):= x"CA80";
signal cell_count :    integer := 1;
signal res1_count :integer := 1;
signal res2_count :integer := 1;
signal res1_add :  std_logic_vector(6 downto 0):= (others=>'0');
signal res2_add :  std_logic_vector(6 downto 0):= "1000001";    -- 65
signal tempmax:   std_logic_vector(15 downto 0):= (others=>'0');
signal outputmax : std_logic_vector(15 downto 0):= (others=>'0');
-- signal mac_din1 : std_logic_vector(7 downto 0);
signal mac_dout, comp_din, comp_dout, shift_din,shift_dout :std_logic_vector(15 downto 0):=(others=>'0');
signal ram_we : std_logic:='0';
-- signal ram_addin : std_logic_vector(6 downto 0);
signal reg1_dout, reg2_dout, rom_dout1, rom_dout2 ,ram_din, ram_dout: std_logic_vector(7 downto 0):=(others=>'0');

signal rom_addin : std_logic_vector(15 downto 0):=x"0219";
signal ram_addin :  std_logic_vector(6 downto 0):=(others=>'0');
signal mac_din1 :   std_logic_vector(7 downto 0):=(others=>'0');
signal mac_din2 :   std_logic_vector(15 downto 0):=(others=>'0');
signal reg1_we :    std_logic:='0';
signal reg2_we :    std_logic:='0';
signal reg1_din, vin :   std_logic_vector(7 downto 0):=(others=>'0');
signal reg2_din :   std_logic_vector(7 downto 0):=(others=>'0');
signal outputclass :  std_logic_vector(3 downto 0):= (others=>'0');
signal rom_addin1, rom_addin2 : std_logic_vector(15 downto 0) := (others => '0');

signal en1, en2, we, shift_e :std_logic:= '0';
signal me , cntrl: std_logic_vector(1 downto 0):= "00";
signal address_max, iout, iin : std_logic_vector(3 downto 0) := "1111";

begin

mc : mac port map(reg1_dout, mac_din2, cntrl, clock, mac_dout);
rm : ram port map(comp_dout(7 downto 0), ram_addin, we, clock, ram_dout);
r1 : reg1 port map(reg1_din, reg1_dout, clock, en1);
r2 : reg2 port map(rom_dout2, reg2_dout, clock, en2);
cmp : comparator port map(shift_dout, comp_dout);
shft : shifter port map(shift_e, mac_dout, shift_dout);
high : highest port map(vin, iin, iout);
disp : seven_seg port map(iout, clock, seven_bit_out);
rom : ROM_MEM 
      generic map(
        ADDR_WIDTH       => 10,
        DATA_WIDTH     => 8,
        IMAGE_SIZE       => 784,
        IMAGE_FILE_NAME =>"imgdata_digit5.mif"
       )
      port map(rom_addin1, rom_dout1);
       
rom2 : ROM_MEM2 
        generic map(
          ADDR_WIDTH       => 10,
          DATA_WIDTH     => 8,
          WEIGHT_SIZE      => 50890,
          WEIGHT_FILE_NAME   =>"weights_bias.mif"
        )
        port map(rom_addin2, rom_dout2);

process(basys_clk)
  begin
    if(rising_edge(basys_clk)) then
      clk_count<= clk_count+1;
      if(clk_count = 2) then
        clock<= not clock;
        clk_count<=0;
      end if;
    end if;
end process;

process(clock)
  begin
  if(rising_edge(clock)) then
      if(state=1) then --1
        en1<= '1';
        me<= "00";
        en2<='1';
        cntrl<="00";
--        if(cell_count=1) then
--            cntrl<="11";
--          else 
--            cntrl<= "10";
--          end if;
        shift_e<='0';
        we<='0';
--        cell_count<=cell_count+1;
--        res1_count<=res1_count+1;
        
        state<= 2;
        
      elsif(state = 2) then --2
          en1<= '0';
          me<= "00";
          
--          cntrl<="00";
          en2<='0';
          if(cell_count=1) then
            cntrl<="11";
          else 
            cntrl<= "10";
          end if;
          shift_e<='0';
          we<='0';
          if(cell_count= 784) then
            state<= 3;
            res1_count <= res1_count + 1;
            cell_count <= 1;
          else 
            state<= 1;
            cell_count<=cell_count+1;
          end if;
        
      elsif(state = 3) then--3
          en1<= '1';
          me<= "10";
          en2<='1';
          cntrl<="00";
          shift_e<='0';
          we<='0';
          state<=4;
          
        
        
      elsif(state = 4) then --4
        en1<= '0';
        me<= "00";
        en2<='0';
        cntrl<="10";
        shift_e<='0';
        we<='0';
        state<= 5;
        
      elsif(state = 5) then --5
        en1<= '0';
        me<= "00";
        en2<='0';
        cntrl<="00";
        shift_e<='1';
        we<='0';
        state<=6;
        
      elsif(state = 6) then --6
          en1<= '0';
          me<= "00";
          en2<='0';
          cntrl<="00";
          shift_e<='0';
          we<='1';
          cell_count<=1;
          if(res1_count = 64) then
            state<= 20;
            
          else 
            state<= 1;
          end if;
      elsif (state = 20) then
        we <= '0';
        state <= 7;
        res1_count<=1;
        
      elsif(state=7) then --7
         en1<= '1';
          me<= "01";
          en2<='1';
          cntrl<="00";
          shift_e<='0';
          we<='0';
--          cell_count<=cell_count+1;
--          res1_count<=res1_count+1;
              
        
       state <= 8;
      
      elsif(state = 8) then --8
         en1<= '0';
           me<= "00";
           cell_count<=cell_count+1;
           en2<='0';
           if(cell_count=1) then
             cntrl<="11";
           else 
             cntrl<= "10";
           end if;
           shift_e<='0';
           we<='0';
           if(cell_count= 64) then --64
             state<= 9;
             res1_count <= res1_count + 1;
             cell_count <= 1;
           else 
             state<= 7;
           end if;
        
      elsif(state = 9) then --9
            en1<= '1';
            me<= "10";
            en2<='1';
            cntrl<="00";
            shift_e<='0';
            we<='0';
            state<=10;
                

      elsif (state = 10) then --10
          en1<= '0';
          me<= "00";
          en2<='0';
          cntrl<="10";
          shift_e<='0';
          we<='0';
            
          state<= 11;

      elsif(state = 11) then --11
          en1<= '0';
          me<= "00";
          en2<='0';
          cntrl<="00";
          shift_e<='1';
          we<='0';
          state<=12;
      
      elsif(state = 12  ) then --12
        en1<= '0';
        me<= "00";
        en2<='0';
        cntrl<="00";
        shift_e<='0';
        we<='1';
        cell_count <= 1;
        if(res1_count = 11) then
          state<= 13;
          
--          cell_count<="0000000000";
--          res1_count<="0000000";
        else 
          state <= 7;
        end if;
      elsif(state = 13) then --13
        we <= '0';
        state <= 14;
        res1_count <= 1;
      elsif (state = 14) then
        if (res1_count = 10) then
            state <= 15;
        else 
            res1_count <= res1_count + 1;
        end if; 
        -- address iterator current address is 63+res1_count 
        -- state for calculating maxima among 10 values stored in ram starting from address 64 to 73
      end if;
  end if;
end process;
-- outputclass = ans
--mac_din1<= reg1_dout;

mac_din2<= "11111111" & reg2_dout when reg2_dout(7)= '1' else 
            "00000000" & reg2_dout when reg2_dout(7)= '0';
--shift_din<=mac_dout;
--comp_din<= shift_dout;

rom_addin1<= std_logic_vector(to_signed(cell_count-1, 16)) when me = "00";
reg1_din<= rom_dout1 when me = "00" else 
            ram_dout when me = "01" else 
            "00000001" when me = "10" else
            "00000000";
ram_addin<= std_logic_vector(to_signed(cell_count-1, 7)) when me = "01" else 
            std_logic_vector(to_signed(res1_count -2, 7)) when state = 1 or state = 20 else 
            res1_count -2 + "1000000" when state = 7 or state = 13 else 
            std_logic_vector(to_unsigned(63+res1_count, 7)) when state = 14 else
            "0000000";
--ram_din<= comp_dout(7 downto 0) when we = '1';
            
--rom_addin2 <= std_logic_vector(to_signed(cell_count + (res1_count-1)*784 - 1, 16)) when state = 1; 

rom_addin2<= std_logic_vector(to_signed(cell_count + (res1_count-1)*784 - 1, 16)) when state = 2 else
             std_logic_vector(to_signed(res1_count-2+64*784, 16)) when state= 4 else
             std_logic_vector(to_signed(cell_count -1+784*64 +64  + (res1_count -1)*64, 16)) when state= 8 else
             std_logic_vector(to_signed(res1_count -2 + 64*784 + 64 + 64*10, 16))when state= 10;
             
vin <= ram_dout when state = 14 else
      x"00";
iin <= std_logic_vector(to_unsigned(res1_count-1, 4)) when state = 14 else "0000";

--if (me="00") then
--rom_addin1<= cell_count +1 when me = "00"
--reg1_din<= rom_dout1;
--elsif(me="01") then
--ram_addin<= cell_count - 1;
--reg1_din<= ram_dout;
--elsif(me="10") then
--reg1_din= "00000001";
--end if;

end fsm_arch;

