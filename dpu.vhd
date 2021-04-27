-- heavy citation to Kent Jones's MIPS datapath
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

--High level entity that connects various components of the Micro Pirate Processor
-- Inputs: ?
-- Inputs: ?
-- Inputs: ?
-- Inputs: ?
-- Outputs: ?
entity datapath is 
    port(clk:     in std_logic);  --there will be more signals and such added when we implement the control unit
end;

------------------------------------------------------------------------------------------------------------
architecture struct of datapath is
signal const_zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal PC: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal RF_a: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal RF_b: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal instr: STD_LOGIC_VECTOR(63 downto 0) := (others=> '0');
signal ALU_result: STD_LOGIC_VECTOR(31 downto 0);
signal DM_output: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal RB, WB: STD_LOGIC;
signal instruct_type: STD_LOGIC_VECTOR(1 downto 0);
signal alu_control: STD_LOGIC_VECTOR(4 downto 0);
signal immB_input: STD_LOGIC_VECTOR(31 downto 0);
signal b_alu_input: STD_LOGIC_VECTOR(31 downto 0);
signal branch: STD_LOGIC := '0';
begin

--Set the immediate B value depending on the instruction type
process(instr(63 downto 62))
begin
    if instr(63 downto 62) = "00" then
         immB_input <= instr(31 downto 0);
    elsif instr(63 downto 62) = "10" then
         immB_input <= instr(50 downto 19);
    else 
         immB_input <= const_zero;
    end if;
end process;

---- Wiring for instruction memory
IM : entity work.instruction_mem port map(PC_value => PC(5 downto 0), instruc => instr);

---- Wiring for control unit                                           
CU : entity work.control_unit port map(clk=>clk, instr => instr, readBit => RB, writeBit => WB, instr_type => instruct_type, alucontrol => alu_control);

------ Wiring for pcbranch            
pcBranchComp : entity work.pcbranch port map(constant_start => const_zero, clk => clk, branch_input => branch, oldPC => PC, offset => instr(18 downto 0), Result => PC); 

---- Wiring for bsrc
BSRCComp : entity work.bsrc port map(instr_type => instr(63 downto 62), regB => RF_b, immB => immB_input, toB => b_alu_input);

---- Wiring for ALU
--ALUComp : entity work.alu port map(a => RF_a, b => b_alu_input, alucontrol => instr(61 downto 57), branch => branch, aluresult => ALU_result);

---- Wiring for register file 
--RFComp : entity work.regfile port map(clk => clk, instruction => instr, DM_result => DM_output, OutA => RF_a, OutB => RF_b);

---- Wiring for data_memory 
-- Add ReadBit (From control unit)
-- Add WriteBit (From control unit)
-- Read address and write address are probably wrong. May need more signals
--DMComp : entity work.data_memory port map(clk => clk, writeData => RF_b, ReadBit => '0', WriteBit => '0', readAddress => ALU_result, writeAddress => ALU_result, result => DM_output);

end;




