-- instruction_memory.vhdl: Simple Instruction Memory (ROM)
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory is
    port (
        addr        : in  STD_LOGIC_VECTOR(31 downto 0);  -- byte address
        instruction : out STD_LOGIC_VECTOR(31 downto 0)   -- fetched instruction
    );
end instruction_memory;

architecture Behavioral of instruction_memory is
    -- Define ROM depth: 16 words
    type rom_t is array (0 to 15) of STD_LOGIC_VECTOR(31 downto 0);
    signal ROM : rom_t := (
        0  => X"20080005",  -- addi $t0, $zero, 5
        1  => X"20090003",  -- addi $t1, $zero, 3
        2  => X"01095020",  -- add  $t2, $t0, $t1
        3  => X"01285822",  -- sub  $t3, $t1, $t0
        4  => X"8D0C0000",  -- lw   $t4, 0($t0)
        5  => X"AD0B0004",  -- sw   $t3, 4($t0)
        6  => X"1109FFFC",  -- beq  $t0, $t1, back (offset = -4)
        7  => X"08000002",  -- j    to word address 2
        others => (others => '0')
    );
begin
    -- Combinational read: word-aligned index
    process(addr)
        variable idx : integer;
    begin
        idx := to_integer(unsigned(addr(31 downto 2)));
        if idx >= 0 and idx <= 15 then
            instruction <= ROM(idx);
        else
            instruction <= (others => '0');
        end if;
    end process;
end Behavioral;