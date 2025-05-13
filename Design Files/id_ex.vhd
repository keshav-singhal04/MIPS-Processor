-- id_ex.vhdl: ID/EX Pipeline Register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity id_ex is
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        stall           : in  STD_LOGIC;
        flush           : in  STD_LOGIC;
        -- from ID stage
        id_pc_plus4_in  : in  STD_LOGIC_VECTOR(31 downto 0);
        id_read_data1_in: in  STD_LOGIC_VECTOR(31 downto 0);
        id_read_data2_in: in  STD_LOGIC_VECTOR(31 downto 0);
        id_imm_in       : in  STD_LOGIC_VECTOR(31 downto 0);
        id_rs_in        : in  STD_LOGIC_VECTOR(4 downto 0);
        id_rt_in        : in  STD_LOGIC_VECTOR(4 downto 0);
        id_rd_in        : in  STD_LOGIC_VECTOR(4 downto 0);
        id_funct_in     : in  STD_LOGIC_VECTOR(5 downto 0);
        -- control signals
        id_RegDst_in    : in  STD_LOGIC;
        id_ALUSrc_in    : in  STD_LOGIC;
        id_MemtoReg_in  : in  STD_LOGIC;
        id_RegWrite_in  : in  STD_LOGIC;
        id_MemRead_in   : in  STD_LOGIC;
        id_MemWrite_in  : in  STD_LOGIC;
        id_BranchEq_in  : in  STD_LOGIC;
        id_BranchNE_in  : in  STD_LOGIC;
        id_Jump_in      : in  STD_LOGIC;
        id_ALUOp_in     : in  STD_LOGIC_VECTOR(1 downto 0);
        -- to EX stage
        ex_pc_plus4     : out STD_LOGIC_VECTOR(31 downto 0);
        ex_read_data1   : out STD_LOGIC_VECTOR(31 downto 0);
        ex_read_data2   : out STD_LOGIC_VECTOR(31 downto 0);
        ex_imm          : out STD_LOGIC_VECTOR(31 downto 0);
        ex_rs           : out STD_LOGIC_VECTOR(4 downto 0);
        ex_rt           : out STD_LOGIC_VECTOR(4 downto 0);
        ex_rd           : out STD_LOGIC_VECTOR(4 downto 0);
        ex_funct        : out STD_LOGIC_VECTOR(5 downto 0);
        ex_RegDst       : out STD_LOGIC;
        ex_ALUSrc       : out STD_LOGIC;
        ex_MemtoReg     : out STD_LOGIC;
        ex_RegWrite     : out STD_LOGIC;
        ex_MemRead      : out STD_LOGIC;
        ex_MemWrite     : out STD_LOGIC;
        ex_BranchEq     : out STD_LOGIC;
        ex_BranchNE     : out STD_LOGIC;
        ex_Jump         : out STD_LOGIC;
        ex_ALUOp        : out STD_LOGIC_VECTOR(1 downto 0)
    );
end entity id_ex;

architecture Behavioral of id_ex is
    signal pc_reg, d1_reg, d2_reg, imm_reg : STD_LOGIC_VECTOR(31 downto 0);
    signal rs_reg, rt_reg, rd_reg         : STD_LOGIC_VECTOR(4 downto 0);
    signal fn_reg                         : STD_LOGIC_VECTOR(5 downto 0);
    signal RegDst_reg, ALUSrc_reg,
           MemtoReg_reg, RegWrite_reg     : STD_LOGIC;
    signal MemRead_reg, MemWrite_reg,
           BranchEq_reg, BranchNE_reg,
           Jump_reg                      : STD_LOGIC;
    signal ALUOp_reg                      : STD_LOGIC_VECTOR(1 downto 0);
begin
    ex_pc_plus4   <= pc_reg;
    ex_read_data1 <= d1_reg;
    ex_read_data2 <= d2_reg;
    ex_imm        <= imm_reg;
    ex_rs         <= rs_reg;
    ex_rt         <= rt_reg;
    ex_rd         <= rd_reg;
    ex_funct      <= fn_reg;
    ex_RegDst     <= RegDst_reg;
    ex_ALUSrc     <= ALUSrc_reg;
    ex_MemtoReg   <= MemtoReg_reg;
    ex_RegWrite   <= RegWrite_reg;
    ex_MemRead    <= MemRead_reg;
    ex_MemWrite   <= MemWrite_reg;
    ex_BranchEq   <= BranchEq_reg;
    ex_BranchNE   <= BranchNE_reg;
    ex_Jump       <= Jump_reg;
    ex_ALUOp      <= ALUOp_reg;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' or flush = '1' then
                pc_reg        <= (others => '0');
                d1_reg        <= (others => '0');
                d2_reg        <= (others => '0');
                imm_reg       <= (others => '0');
                rs_reg        <= (others => '0');
                rt_reg        <= (others => '0');
                rd_reg        <= (others => '0');
                fn_reg        <= (others => '0');
                RegDst_reg    <= '0';
                ALUSrc_reg    <= '0';
                MemtoReg_reg  <= '0';
                RegWrite_reg  <= '0';
                MemRead_reg   <= '0';
                MemWrite_reg  <= '0';
                BranchEq_reg  <= '0';
                BranchNE_reg  <= '0';
                Jump_reg      <= '0';
                ALUOp_reg     <= (others => '0');
            elsif stall = '0' then
                pc_reg        <= id_pc_plus4_in;
                d1_reg        <= id_read_data1_in;
                d2_reg        <= id_read_data2_in;
                imm_reg       <= id_imm_in;
                rs_reg        <= id_rs_in;
                rt_reg        <= id_rt_in;
                rd_reg        <= id_rd_in;
                fn_reg        <= id_funct_in;
                RegDst_reg    <= id_RegDst_in;
                ALUSrc_reg    <= id_ALUSrc_in;
                MemtoReg_reg  <= id_MemtoReg_in;
                RegWrite_reg  <= id_RegWrite_in;
                MemRead_reg   <= id_MemRead_in;
                MemWrite_reg  <= id_MemWrite_in;
                BranchEq_reg  <= id_BranchEq_in;
                BranchNE_reg  <= id_BranchNE_in;
                Jump_reg      <= id_Jump_in;
                ALUOp_reg     <= id_ALUOp_in;
            end if;
        end if;
    end process;
end architecture Behavioral;