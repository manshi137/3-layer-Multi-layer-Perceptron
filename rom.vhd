library ieee;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use IEEE.std_logic_1164.all;
use std.textio.all;

entity ROM_MEM is
    generic (
      ADDR_WIDTH        : integer := 16;
      DATA_WIDTH        : integer := 8;
      IMAGE_SIZE        : integer := 784;
      IMAGE_FILE_NAME   : string :="imgdata_digit5.mif"
    );
    port(
        addrin: in std_logic_vector(15 downto 0);-- 8 bit vector 1
            dout: out std_logic_vector(7 downto 0)-- 8 bit vector 2
    );
    end ROM_MEM;
  architecture Behavioral of ROM_MEM is
    TYPE mem_type IS ARRAY(0 TO IMAGE_SIZE-1) OF
std_logic_vector((DATA_WIDTH-1) DOWNTO 0);
    impure function init_mem(mif_file_name : in string) return mem_type is
        file mif_file : text open read_mode is mif_file_name;
        variable mif_line : line;
        variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
        variable temp_mem : mem_type;
    begin
        for i in mem_type'range loop
            readline(mif_file, mif_line);
            read(mif_line, temp_bv);
            temp_mem(i) := to_stdlogicvector(temp_bv);
        end loop;
        return temp_mem;
    end function;
    signal rom_block: mem_type := init_mem(IMAGE_FILE_NAME);
begin
process(addrin) is
    begin
        dout<= rom_block(conv_integer(addrin));
    end process;
end Behavioral;


