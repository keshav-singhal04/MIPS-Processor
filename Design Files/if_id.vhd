-- if_id.vhdl: IF/ID Pipeline Register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity if_id is
    Port (
        clk            : in  STD_LOGIC;
        rst            : in  STD_LOGIC;  -- synchronous reset
        stall          : in  STD_LOGIC;  -- hold state
        flush          : in  STD_LOGIC;  -- clear on branch
        if_pc_plus4    : in  STD_LOGIC_VECTOR(31 downto 0);
        if_instruction : in  STD_LOGIC_VECTOR(31 downto 0);
        id_pc_plus4    : out STD_LOGIC_VECTOR(31 downto 0);
        id_instruction : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity if_id;

architecture Behavioral of if_id is
    signal pc_reg, instr_reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    id_pc_plus4    <= pc_reg;
    id_instruction <= instr_reg;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or flush = '1' then
                pc_reg    <= (others => '0');
                instr_reg <= (others => '0');
            elsif stall = '0' then
                pc_reg    <= if_pc_plus4;
                instr_reg <= if_instruction;
            end if;
        end if;
    end process;
end architecture Behavioral;