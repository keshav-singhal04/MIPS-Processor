-- immediate_generator.vhd: Extract immediate values from instruction formats
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator is
    port (
        instr    : in  STD_LOGIC_VECTOR(31 downto 0);
        imm_out  : out STD_LOGIC_VECTOR(31 downto 0)
    );
end immediate_generator;

architecture Behavioral of immediate_generator is
begin
    process(instr)
        variable opcode : STD_LOGIC_VECTOR(5 downto 0);
        variable imm16  : STD_LOGIC_VECTOR(15 downto 0);
        variable signed_imm : SIGNED(31 downto 0);
    begin
        opcode := instr(31 downto 26);
        imm16 := instr(15 downto 0);

        case opcode is
            when "001000" |  -- addi
                 "100011" |  -- lw
                 "101011" =>  -- sw
                signed_imm := RESIZE(SIGNED(imm16), 32);
                imm_out <= STD_LOGIC_VECTOR(signed_imm);

            when "000100" =>  -- beq
                signed_imm := RESIZE(SIGNED(imm16), 32) sll 2;
                imm_out <= STD_LOGIC_VECTOR(signed_imm);

            when others =>
                imm_out <= (others => '0');
        end case;
    end process;
end Behavioral;