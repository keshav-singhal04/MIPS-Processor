-- data_memory.vhdl: Data Memory for lw/sw instructions
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    Port (
        clk         : in  STD_LOGIC;
        MemRead     : in  STD_LOGIC;
        MemWrite    : in  STD_LOGIC;
        addr        : in  STD_LOGIC_VECTOR(31 downto 0);  -- byte address
        write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
        read_data   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity data_memory;

architecture Behavioral of data_memory is
    -- 16 words of 32 bits each
    type ram_t is array (0 to 15) of STD_LOGIC_VECTOR(31 downto 0);
    signal RAM : ram_t := (others => (others => '0'));
begin
    -- Write (synchronous on rising edge)
    process(clk)
        variable index : integer;
    begin
        if rising_edge(clk) then
            index := to_integer(unsigned(addr(31 downto 2)));
            if MemWrite = '1' then
                if (index >= 0) and (index <= 15) then
                    RAM(index) <= write_data;
                end if;
            end if;
        end if;
    end process;

    -- Read (combinational)
    read_data_process: process(addr, MemRead, RAM)
        variable index : integer;
    begin
        index := to_integer(unsigned(addr(31 downto 2)));
        if MemRead = '1' and (index >= 0) and (index <= 15) then
            read_data <= RAM(index);
        else
            read_data <= X"00000000";
        end if;
    end process;
end architecture Behavioral;