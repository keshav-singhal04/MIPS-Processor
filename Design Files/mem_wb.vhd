-- mem_wb.vhd: MEM/WB pipeline register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_wb is
  Port (
    clk               : in  STD_LOGIC;
    rst               : in  STD_LOGIC;
    stall             : in  STD_LOGIC;
    flush             : in  STD_LOGIC;
    mem_alu_result_in : in  STD_LOGIC_VECTOR(31 downto 0);
    mem_read_data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
    mem_rd_in         : in  STD_LOGIC_VECTOR(4 downto 0);
    mem_MemtoReg_in   : in  STD_LOGIC;
    mem_RegWrite_in   : in  STD_LOGIC;
    wb_alu_result     : out STD_LOGIC_VECTOR(31 downto 0);
    wb_read_data      : out STD_LOGIC_VECTOR(31 downto 0);
    wb_write_reg      : out STD_LOGIC_VECTOR(4 downto 0);
    wb_MemtoReg       : out STD_LOGIC;
    wb_RegWrite       : out STD_LOGIC
  );
end entity mem_wb;

architecture Behavioral of mem_wb is
begin
  process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        wb_alu_result <= (others => '0');
        wb_read_data  <= (others => '0');
        wb_write_reg  <= (others => '0');
        wb_MemtoReg   <= '0';
        wb_RegWrite   <= '0';
      elsif flush = '1' then
        wb_alu_result <= (others => '0');
        wb_read_data  <= (others => '0');
        wb_write_reg  <= (others => '0');
        wb_MemtoReg   <= '0';
        wb_RegWrite   <= '0';
      elsif stall = '0' then
        wb_alu_result <= mem_alu_result_in;
        wb_read_data  <= mem_read_data_in;
        wb_write_reg  <= mem_rd_in;
        wb_MemtoReg   <= mem_MemtoReg_in;
        wb_RegWrite   <= mem_RegWrite_in;
      end if;
    end if;
  end process;
end architecture Behavioral;
