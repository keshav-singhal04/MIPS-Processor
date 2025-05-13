-- processor.vhdl: Top-level 5-stage Pipelined MIPS-like CPU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processor is
  Port (
    clk : in  STD_LOGIC;
    rst : in  STD_LOGIC
  );
end entity processor;

architecture Structural of processor is
  -- IF stage signals
  signal PC, PC_plus4, PC_next         : STD_LOGIC_VECTOR(31 downto 0);
  signal instr_IF                      : STD_LOGIC_VECTOR(31 downto 0);

  -- IF/ID pipeline
  signal if_id_pc4, if_id_instr        : STD_LOGIC_VECTOR(31 downto 0);
  signal if_id_stall, if_id_flush      : STD_LOGIC := '0';

  -- ID stage signals
  signal id_opcode                     : STD_LOGIC_VECTOR(5 downto 0);
  signal id_rs, id_rt, id_rd           : STD_LOGIC_VECTOR(4 downto 0);
  signal id_rd1, id_rd2                : STD_LOGIC_VECTOR(31 downto 0);
  signal id_imm                        : STD_LOGIC_VECTOR(31 downto 0);
  signal ctrl_RegDst, ctrl_ALUSrc,
         ctrl_MemtoReg, ctrl_RegWrite,
         ctrl_MemRead, ctrl_MemWrite    : STD_LOGIC;
  signal ctrl_BranchEq, ctrl_BranchNE,
         ctrl_Jump                      : STD_LOGIC;
  signal ctrl_ALUOp                    : STD_LOGIC_VECTOR(1 downto 0);

  -- ID/EX pipeline
  signal ex_pc4, ex_rd1, ex_rd2, ex_imm : STD_LOGIC_VECTOR(31 downto 0);
  signal ex_rs, ex_rt, ex_rd           : STD_LOGIC_VECTOR(4 downto 0);
  signal ex_RegDst, ex_ALUSrc,
         ex_MemtoReg, ex_RegWrite      : STD_LOGIC;
  signal ex_MemRead, ex_MemWrite,
         ex_BranchEq, ex_BranchNE,
         ex_Jump                       : STD_LOGIC;
  signal ex_ALUOp                     : STD_LOGIC_VECTOR(1 downto 0);

    -- EX stage signals
  signal ex_alu_in2                      : STD_LOGIC_VECTOR(31 downto 0);
  signal ex_dst_reg                    : STD_LOGIC_VECTOR(4 downto 0);
  signal ex_ALU_result                 : STD_LOGIC_VECTOR(31 downto 0);
  signal ex_Zero                       : STD_LOGIC;
  signal ex_ALUCtl                     : STD_LOGIC_VECTOR(3 downto 0);
  signal ex_funct                      : STD_LOGIC_VECTOR(5 downto 0);

  -- EX/MEM pipeline
  signal mem_pc4, mem_ALU, mem_wdata    : STD_LOGIC_VECTOR(31 downto 0);
  signal mem_zero                       : STD_LOGIC;
  signal mem_rt, mem_rd                 : STD_LOGIC_VECTOR(4 downto 0);
  signal mem_RegDst, mem_MemtoReg,
         mem_RegWrite, mem_MemRead,
         mem_MemWrite, mem_BranchEq,
         mem_BranchNE, mem_Jump         : STD_LOGIC;

  -- MEM stage signals
  signal rd_mem                         : STD_LOGIC_VECTOR(31 downto 0);

  -- MEM/WB pipeline
  signal wb_ALU_result, wb_mem_data     : STD_LOGIC_VECTOR(31 downto 0);
  signal wb_write_reg                   : STD_LOGIC_VECTOR(4 downto 0);
  signal wb_MemtoReg, wb_RegWrite       : STD_LOGIC;

  -- WB stage
  signal wb_write_data                  : STD_LOGIC_VECTOR(31 downto 0);

  -- Hazard control (not implemented)
  signal PCWrite, IDWrite               : STD_LOGIC := '1';
begin

  -- ################ IF Stage ################
  PC_reg: entity work.pc
    port map(clk => clk, rst => rst, pc_in => PC_next, pc_out => PC);

  PC_plus4 <= std_logic_vector(unsigned(PC) + 4);

  IMem: entity work.instruction_memory
    port map(addr => PC, instruction => instr_IF);

    IFID: entity work.if_id
    port map(
      clk            => clk,
      rst            => rst,
      stall          => '0',     -- no stalling for IF stage
      flush          => '0',     -- no branch flush here
      if_pc_plus4    => PC_plus4,
      if_instruction => instr_IF,
      id_pc_plus4    => if_id_pc4,
      id_instruction => if_id_instr
    );

  -- ################ ID Stage ################
  id_opcode <= if_id_instr(31 downto 26);
  id_rs     <= if_id_instr(25 downto 21);
  id_rt     <= if_id_instr(20 downto 16);
  id_rd     <= if_id_instr(15 downto 11);

  CU: entity work.control_unit
    port map(
      opcode   => id_opcode,
      RegDst   => ctrl_RegDst,
      ALUSrc   => ctrl_ALUSrc,
      MemtoReg => ctrl_MemtoReg,
      RegWrite => ctrl_RegWrite,
      MemRead  => ctrl_MemRead,
      MemWrite => ctrl_MemWrite,
      BranchEq => ctrl_BranchEq,
      BranchNE => ctrl_BranchNE,
      Jump     => ctrl_Jump,
      ALUOp    => ctrl_ALUOp
    );

  RF: entity work.register_file
    port map(
      clk        => clk,
      rst        => rst,
      we         => wb_RegWrite,
      read_reg1  => id_rs,
      read_reg2  => id_rt,
      write_reg  => wb_write_reg,
      write_data => wb_write_data,
      read_data1 => id_rd1,
      read_data2 => id_rd2
    );

  ImmGen: entity work.immediate_generator
    port map(
      instr  => if_id_instr,
      imm_out => id_imm
    );

  IDEX: entity work.id_ex
    port map(
      clk             => clk,
      rst             => rst,
      stall           => '0',
      flush           => '0',
      id_pc_plus4_in  => if_id_pc4,
      id_read_data1_in=> id_rd1,
      id_read_data2_in=> id_rd2,
      id_imm_in       => id_imm,
      id_rs_in        => id_rs,
      id_rt_in        => id_rt,
      id_rd_in        => id_rd,
      id_funct_in     => if_id_instr(5 downto 0),
      id_RegDst_in    => ctrl_RegDst,
      id_ALUSrc_in    => ctrl_ALUSrc,
      id_MemtoReg_in  => ctrl_MemtoReg,
      id_RegWrite_in  => ctrl_RegWrite,
      id_MemRead_in   => ctrl_MemRead,
      id_MemWrite_in  => ctrl_MemWrite,
      id_BranchEq_in  => ctrl_BranchEq,
      id_BranchNE_in  => ctrl_BranchNE,
      id_Jump_in      => ctrl_Jump,
      id_ALUOp_in     => ctrl_ALUOp,
      ex_pc_plus4     => ex_pc4,
      ex_read_data1   => ex_rd1,
      ex_read_data2   => ex_rd2,
      ex_imm          => ex_imm,
      ex_rs           => ex_rs,
      ex_rt           => ex_rt,
      ex_rd           => ex_rd,
      ex_funct        => ex_funct,
      ex_RegDst       => ex_RegDst,
      ex_ALUSrc       => ex_ALUSrc,
      ex_MemtoReg     => ex_MemtoReg,
      ex_RegWrite     => ex_RegWrite,
      ex_MemRead      => ex_MemRead,
      ex_MemWrite     => ex_MemWrite,
      ex_BranchEq     => ex_BranchEq,
      ex_BranchNE     => ex_BranchNE,
      ex_Jump         => ex_Jump,
      ex_ALUOp        => ex_ALUOp
    );

  -- ################ EX Stage ################
  ex_dst_reg <= ex_rt when ex_RegDst = '0' else ex_rd;

    ex_alu_in2 <= ex_imm when ex_ALUSrc = '1' else ex_rd2;

    ALU: entity work.alu
    port map(
      A      => ex_rd1,
      B      => ex_alu_in2,
      ALUCtl => ex_ALUCtl,
      Result => ex_ALU_result,
      Zero   => ex_Zero
    );

  ALUCtrl: entity work.alu_control
    port map(
      ALUOp => ex_ALUOp,
      funct => ex_funct,
      ALUCtl=> ex_ALUCtl
    );

  EXMEM: entity work.ex_mem
    port map(
      clk               => clk,
      rst               => rst,
      stall             => '0',
      flush             => '0',
      ex_pc_plus4_in    => ex_pc4,
      ex_alu_result_in  => ex_ALU_result,
      ex_write_data_in  => ex_rd2,
      ex_zero_in        => ex_Zero,
      ex_rt_in          => ex_rt,
      ex_rd_in          => ex_dst_reg,
      ex_RegDst_in      => ex_RegDst,
      ex_MemtoReg_in    => ex_MemtoReg,
      ex_RegWrite_in    => ex_RegWrite,
      ex_MemRead_in     => ex_MemRead,
      ex_MemWrite_in    => ex_MemWrite,
      ex_BranchEq_in    => ex_BranchEq,
      ex_BranchNE_in    => ex_BranchNE,
      ex_Jump_in        => ex_Jump,
      mem_pc_plus4      => mem_pc4,
      mem_alu_result    => mem_ALU,
      mem_write_data    => mem_wdata,
      mem_zero          => mem_zero,
      mem_rt            => mem_rt,
      mem_rd            => mem_rd,
      mem_RegDst        => mem_RegDst,
      mem_MemtoReg      => mem_MemtoReg,
      mem_RegWrite      => mem_RegWrite,
      mem_MemRead       => mem_MemRead,
      mem_MemWrite      => mem_MemWrite,
      mem_BranchEq      => mem_BranchEq,
      mem_BranchNE      => mem_BranchNE,
      mem_Jump          => mem_Jump
    );

  -- ################ MEM Stage ################
  DMem: entity work.data_memory
    port map(
      clk       => clk,
      MemRead   => mem_MemRead,
      MemWrite  => mem_MemWrite,
      addr      => mem_ALU,
      write_data=> mem_wdata,
      read_data => rd_mem
    );

  MEM_WB: entity work.mem_wb
    port map(
      clk               => clk,
      rst               => rst,
      stall             => '0',
      flush             => '0',
      mem_alu_result_in => mem_ALU,
      mem_read_data_in  => rd_mem,
      mem_rd_in         => mem_rd,
      mem_MemtoReg_in   => mem_MemtoReg,
      mem_RegWrite_in   => mem_RegWrite,
      wb_alu_result     => wb_ALU_result,
      wb_read_data      => wb_mem_data,
      wb_write_reg      => wb_write_reg,
      wb_MemtoReg       => wb_MemtoReg,
      wb_RegWrite       => wb_RegWrite
    );


  -- ################ WB Stage ################
  wb_write_data <= wb_ALU_result when wb_MemtoReg = '0' else wb_mem_data;

  -- ################ PC update ################
  PC_next <= mem_pc4 when (mem_BranchEq = '1' and mem_zero = '1') or
                         (mem_BranchNE = '1' and mem_zero = '0') else
             (mem_ALU(31 downto 28) & if_id_instr(25 downto 0) & "00") when mem_Jump = '1' else
             PC_plus4;

end architecture Structural;
