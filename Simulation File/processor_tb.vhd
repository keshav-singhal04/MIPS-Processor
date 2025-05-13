-- processor_tb.vhdl: Full-system testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processor_tb is
end entity processor_tb;

architecture Behavioral of processor_tb is
    signal clk : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '1';
    -- Component
    component processor is
        Port(clk : in STD_LOGIC; rst : in STD_LOGIC);
    end component;

    -- Monitor register file via a shared signal or use waveforms
begin
    uut: processor port map(clk => clk, rst => rst);

    -- Clock generation
    clk_proc: process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        -- Apply reset
        rst <= '1'; wait for 20 ns;
        rst <= '0';
        -- Run simulation for sufficient cycles to execute program
        wait for 400 ns;
        report "Simulation complete";
        wait;
    end process;
end architecture Behavioral;
