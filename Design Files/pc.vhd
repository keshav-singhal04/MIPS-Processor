-- pc.vhdl: Program Counter component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc is
    Port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        pc_in  : in  STD_LOGIC_VECTOR(31 downto 0);
        pc_out : out STD_LOGIC_VECTOR(31 downto 0)
    );
end entity pc;

architecture Behavioral of pc is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pc_out <= (others => '0');
        elsif rising_edge(clk) then
            pc_out <= pc_in;
        end if;
    end process;
end architecture Behavioral;