-- alu.vhdl: Arithmetic Logic Unit
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    Port (
        A       : in  STD_LOGIC_VECTOR(31 downto 0);
        B       : in  STD_LOGIC_VECTOR(31 downto 0);
        ALUCtl  : in  STD_LOGIC_VECTOR(3 downto 0);
        Result  : out STD_LOGIC_VECTOR(31 downto 0);
        Zero    : out STD_LOGIC  -- high if Result == 0
    );
end entity alu;

architecture Behavioral of alu is
    signal signedA, signedB : signed(31 downto 0);
--    signal ALUResult : STD_LOGIC_VECTOR(31 downto 0);
begin
    signedA <= signed(A);
    signedB <= signed(B);

    process(signedA, signedB, ALUCtl)
        variable temp_result : STD_LOGIC_VECTOR(31 downto 0);
    begin
        case ALUCtl is
            when "0010" =>  -- ADD
                temp_result := std_logic_vector(signedA + signedB);
            when "0110" =>  -- SUB
                temp_result := std_logic_vector(signedA - signedB);
            when "0000" =>  -- AND
                temp_result := A and B;
            when "0001" =>  -- OR
                temp_result := A or B;
            when "0011" =>  -- XOR
                temp_result := A xor B;
            when "0111" =>  -- SLT
                if signedA < signedB then
                    temp_result := (others => '0');
                    temp_result(0) := '1';
                else
                    temp_result := (others => '0');
                end if;
            when others =>
                temp_result := (others => '0');
        end case;
    
        Result <= temp_result;
    
        if temp_result = X"00000000" then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
        
    end process;

end architecture Behavioral;
