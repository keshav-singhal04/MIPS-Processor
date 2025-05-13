-- register_file.vhdl: 32x32 Register File for MIPS subset
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;  -- synchronous reset
        we          : in  STD_LOGIC;  -- write enable
        read_reg1   : in  STD_LOGIC_VECTOR(4 downto 0);
        read_reg2   : in  STD_LOGIC_VECTOR(4 downto 0);
        write_reg   : in  STD_LOGIC_VECTOR(4 downto 0);
        write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
        read_data1  : out STD_LOGIC_VECTOR(31 downto 0);
        read_data2  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    type reg_file_t is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
    signal regs : reg_file_t := (others => (others => '0'));
begin
    -- Asynchronous read ports
    read_data1 <= regs(to_integer(unsigned(read_reg1)));
    read_data2 <= regs(to_integer(unsigned(read_reg2)));

    -- Write port (synchronous)
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                for i in 0 to 31 loop
                    regs(i) <= (others => '0');
                end loop;
            elsif we = '1' then
                -- enforce register 0 always zero
                if to_integer(unsigned(write_reg)) /= 0 then
                    regs(to_integer(unsigned(write_reg))) <= write_data;
                end if;
            end if;
        end if;
    end process;
end Behavioral;