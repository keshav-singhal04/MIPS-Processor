-- control_unit.vhdl: Main Control Unit for MIPS Subset
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        opcode    : in  STD_LOGIC_VECTOR(5 downto 0);
        RegDst    : out STD_LOGIC;
        ALUSrc    : out STD_LOGIC;
        MemtoReg  : out STD_LOGIC;
        RegWrite  : out STD_LOGIC;
        MemRead   : out STD_LOGIC;
        MemWrite  : out STD_LOGIC;
        BranchEq  : out STD_LOGIC;
        BranchNE  : out STD_LOGIC;
        Jump      : out STD_LOGIC;
        ALUOp     : out STD_LOGIC_VECTOR(1 downto 0)
    );
end entity control_unit;

architecture Behavioral of control_unit is
begin
    process(opcode)
    begin
        -- Default values
        RegDst   <= '0';
        ALUSrc   <= '0';
        MemtoReg <= '0';
        RegWrite <= '0';
        MemRead  <= '0';
        MemWrite <= '0';
        BranchEq <= '0';
        BranchNE <= '0';
        Jump     <= '0';
        ALUOp    <= "00";

        case opcode is
            -- R-type
            when "000000" =>  -- add, sub, and, or, xor, slt
                RegDst   <= '1';
                ALUSrc   <= '0';
                MemtoReg <= '0';
                RegWrite <= '1';
                ALUOp    <= "10";

            -- addi, slti, andi, ori, xori
            when "001000" | "001010" | "001100" | "001101" | "001110" =>
                RegDst   <= '0';
                ALUSrc   <= '1';
                MemtoReg <= '0';
                RegWrite <= '1';
                -- differentiate addi/slti vs logical imm if needed in ALU Control
                ALUOp    <= "11";

            -- lw
            when "100011" =>
                RegDst   <= '0';
                ALUSrc   <= '1';
                MemtoReg <= '1';
                RegWrite <= '1';
                MemRead  <= '1';
                ALUOp    <= "00";

            -- sw
            when "101011" =>
                ALUSrc   <= '1';
                MemWrite <= '1';
                ALUOp    <= "00";

            -- beq
            when "000100" =>
                BranchEq <= '1';
                ALUOp    <= "01";

            -- bne
            when "000101" =>
                BranchNE <= '1';
                ALUOp    <= "01";

            -- jump
            when "000010" =>
                Jump     <= '1';

            when others =>
                null;
        end case;
    end process;
end architecture Behavioral;
