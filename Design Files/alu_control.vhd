-- alu_control.vhdl: ALU Control for MIPS-like instructions
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_control is
    Port (
        ALUOp      : in  STD_LOGIC_VECTOR(1 downto 0);
        funct      : in  STD_LOGIC_VECTOR(5 downto 0);
        ALUCtl     : out STD_LOGIC_VECTOR(3 downto 0)  -- control to ALU
    );
end entity alu_control;

architecture Behavioral of alu_control is
begin
    process(ALUOp, funct)
    begin
        case ALUOp is
            when "00" =>  -- lw, sw (add)
                ALUCtl <= "0010";  -- ADD
            when "01" =>  -- beq, bne (subtract)
                ALUCtl <= "0110";  -- SUB
            when "11" =>  -- immediate logical or set instructions
                -- differentiate by funct? funct is "imm type" in opcode
                ALUCtl <= "0010";  -- default to ADD; further decoding in ALU if needed
            when "10" =>  -- R-type
                case funct is
                    when "100000" => ALUCtl <= "0010"; -- ADD
                    when "100010" => ALUCtl <= "0110"; -- SUB
                    when "100100" => ALUCtl <= "0000"; -- AND
                    when "100101" => ALUCtl <= "0001"; -- OR
                    when "100110" => ALUCtl <= "0011"; -- XOR
                    when "101010" => ALUCtl <= "0111"; -- SLT
                    when others   => ALUCtl <= "0000"; -- default AND
                end case;
            when others =>
                ALUCtl <= "0000";
        end case;
    end process;
end architecture Behavioral;