-- ex_mem.vhdl: EX/MEM Pipeline Register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ex_mem is
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        stall           : in  STD_LOGIC;
        flush           : in  STD_LOGIC;
        -- data
        ex_pc_plus4_in  : in  STD_LOGIC_VECTOR(31 downto 0);
        ex_alu_result_in: in  STD_LOGIC_VECTOR(31 downto 0);
        ex_write_data_in: in  STD_LOGIC_VECTOR(31 downto 0);
        ex_zero_in      : in  STD_LOGIC;
        ex_rt_in        : in  STD_LOGIC_VECTOR(4 downto 0);
        ex_rd_in        : in  STD_LOGIC_VECTOR(4 downto 0);
        -- control
        ex_RegDst_in    : in  STD_LOGIC;
        ex_MemtoReg_in  : in  STD_LOGIC;
        ex_RegWrite_in  : in  STD_LOGIC;
        ex_MemRead_in   : in  STD_LOGIC;
        ex_MemWrite_in  : in  STD_LOGIC;
        ex_BranchEq_in  : in  STD_LOGIC;
        ex_BranchNE_in  : in  STD_LOGIC;
        ex_Jump_in      : in  STD_LOGIC;
        -- outputs
        mem_pc_plus4    : out STD_LOGIC_VECTOR(31 downto 0);
        mem_alu_result  : out STD_LOGIC_VECTOR(31 downto 0);
        mem_write_data  : out STD_LOGIC_VECTOR(31 downto 0);
        mem_zero        : out STD_LOGIC;
        mem_rt          : out STD_LOGIC_VECTOR(4 downto 0);
        mem_rd          : out STD_LOGIC_VECTOR(4 downto 0);
        -- control
        mem_RegDst      : out STD_LOGIC;
        mem_MemtoReg    : out STD_LOGIC;
        mem_RegWrite    : out STD_LOGIC;
        mem_MemRead     : out STD_LOGIC;
        mem_MemWrite    : out STD_LOGIC;
        mem_BranchEq    : out STD_LOGIC;
        mem_BranchNE    : out STD_LOGIC;
        mem_Jump        : out STD_LOGIC
    );
end entity ex_mem;

architecture Behavioral of ex_mem is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' or flush='1' then
                mem_pc_plus4   <= (others=>'0');
                mem_alu_result <= (others=>'0');
                mem_write_data <= (others=>'0');
                mem_zero       <= '0';
                mem_rt         <= (others=>'0');
                mem_rd         <= (others=>'0');
                mem_RegDst     <= '0';
                mem_MemtoReg   <= '0';
                mem_RegWrite   <= '0';
                mem_MemRead    <= '0';
                mem_MemWrite   <= '0';
                mem_BranchEq   <= '0';
                mem_BranchNE   <= '0';
                mem_Jump       <= '0';
            elsif stall='0' then
                mem_pc_plus4   <= ex_pc_plus4_in;
                mem_alu_result <= ex_alu_result_in;
                mem_write_data <= ex_write_data_in;
                mem_zero       <= ex_zero_in;
                mem_rt         <= ex_rt_in;
                mem_rd         <= ex_rd_in;
                mem_RegDst     <= ex_RegDst_in;
                mem_MemtoReg   <= ex_MemtoReg_in;
                mem_RegWrite   <= ex_RegWrite_in;
                mem_MemRead    <= ex_MemRead_in;
                mem_MemWrite   <= ex_MemWrite_in;
                mem_BranchEq   <= ex_BranchEq_in;
                mem_BranchNE   <= ex_BranchNE_in;
                mem_Jump       <= ex_Jump_in;
            end if;
        end if;
    end process;
end architecture Behavioral;
