library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity ROM_MEM2 is
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
    end ROM_MEM2;
  architecture Behavioral of ROM_MEM2 is
    TYPE weight_type IS ARRAY(0 TO WEIGHT_SIZE-1) OF
std_logic_vector((DATA_WIDTH-1) DOWNTO 0);
        impure function init_weight(mif_file_name : in string) return
weight_type is
            file mif_file : text open read_mode is mif_file_name;
            variable mif_line : line;
            variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
            variable temp_mem : weight_type;
        begin
            for i in weight_type'range loop
                readline(mif_file, mif_line);
                read(mif_line, temp_bv);
                temp_mem(i) := to_stdlogicvector(temp_bv);
            end loop;
            return temp_mem;
        end function;

    signal weight_block: weight_type := init_weight(WEIGHT_FILE_NAME);
    --   ...
begin
process(addrin) is
    begin
            dout<= weight_block(conv_integer(addrin));
    end process;
end Behavioral;


