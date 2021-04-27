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

architecture struct of datapath is
------------------------------------------------------------------------------------------------------------
--Alu does mathematical operations
-- Inputs: A, B (32 bit signals that are the two numbers being added/subtracted/multiplied/etc)
-- Input: alucontrol - (3 bit singal that tells alu what operation is being performed)
-- Output: aluresult (Result of the operation between A, B)
component alu
port(a: in std_logic_vector(31 downto 0);
     b: in std_logic_vector(31 downto 0);
     alucontrol: in std_logic_vector(4 downto 0);
     aluresult: out std_logic_vector(31 downto 0));
end component;

------------------------------------------------------------------------------------------------------------
--Regfile handles the requisiton of register values
-- Input: clk (Used to update/run processes)
-- Input: instr_type (Used to help specify register bits)
-- Input: instruction (Complete instruction signal)
-- Input: DM_result (Output signal from data memory. Used for store word instruction and R-types)
-- Outputs: OutA, OutB (Output signals sent to ALU)
component regfile
  port(clk: in  STD_LOGIC;
       instruction: in  STD_LOGIC_Vector(63 downto 0);
       DM_result: in  STD_LOGIC_Vector(31 downto 0);
       OutA, OutB: out STD_LOGIC_VECTOR(31 downto 0));
end component;

------------------------------------------------------------------------------------------------------------
--Data memory holds program data
-- Input: clk (Used to update/run processes)
-- Input: ReadBit (Control bit that specifies if data should be read)
-- Input: WriteBit (Control bit that specifies if data should be written)
-- Input: ALUResult (Result from previous ALU operation)
-- Input: writeData (Data that will be put into memory)
-- Input: readAddress (32 bit signal of which memory location to read from)
-- Input: writeAddress (32 bit signal of which memory location to write to)
-- Output: result (Signal sent back to regfile for loadword instructions)
component data_memory
  port(clk:  in STD_LOGIC;
       ReadBit: in STD_LOGIC;
       WriteBit: in STD_LOGIC;
       writeData: in STD_LOGIC_Vector(31 downto 0);
       readAddress: in STD_LOGIC_Vector(31 downto 0);
       writeAddress: in STD_LOGIC_Vector(31 downto 0);
       result: out STD_LOGIC_VECTOR(31 downto 0));
end component;


------------------------------------------------------------------------------------------------------------
--Memory location for all instructions from assembly program
-- Input: PC_value (Current value of the program counter)
-- Output: instruc (Bits for current instruction)
component instruction_mem
port(PC_value: in  STD_LOGIC_VECTOR(5 downto 0);
     instruc: out STD_LOGIC_VECTOR(63 downto 0)); --the signal out containing the instruction
end component;

------------------------------------------------------------------------------------------------------------
--Multiplexer that controls what goes into the b port of the alu 
-- Input: instr_Type (Alucontrol signal that specifies which type of instruction is being executed)
-- Input: regB (Output value from register file component - Only used for R type instructions)
-- Input: immB (Bottom 32 bits of any instruction signal, used only for F/I-Type instructions)
-- Output: toB (Value that is sent to 'B' signal of the ALU)
component bsrc 
port(instr_type: in std_logic_vector(1 downto 0);
     regB: in std_logic_vector(31 downto 0);
     immB: in std_logic_vector(31 downto 0);
     toB: out std_logic_vector(31 downto 0));
end component;

------------------------------------------------------------------------------------------------------------
--Component used for J-type instructions only
-- Input: constant_start (The memory address of the first instruction)
-- Input: offset (Number added/subtracted to constant_start to jump to a new memory address, from control unit)
-- Output: result (Result of constant_start +- offset)
component pcbranch
port(constant_start: in STD_LOGIC_VECTOR(31 downto 0);
     clk: in STD_LOGIC;
     oldPC: in STD_LOGIC_VECTOR(31 downto 0);
     instr_type : IN STD_LOGIC_VECTOR(1 downto 0);
     one: in STD_LOGIC_VECTOR(31 downto 0);
     offset: in STD_LOGIC_VECTOR(18 downto 0);
     Result: out STD_LOGIC_VECTOR(31 downto 0)); 
end component;

------------------------------------------------------------------------------------------------------------
--Component used to help aide other components 
-- Input: instr (Entire 64bit instruction that helps determine control bits)
-- Output: readBit (Single bit that helps load/store sword instructions for DM)
-- Output: writeBit (Single bit that helps load/store sword instructions for DM)
-- Output: alucontrol (5 bit opcode that is given to the ALU)
-- Output: instr_type (2 bit given to various components)
component control_unit
port(instr: in std_logic_vector(63 downto 0);
     readBit, writeBit: out std_logic;
     instr_type: out std_logic_vector(1 downto 0);
     alucontrol: out std_logic_vector(4 downto 0));
end component;

------------------------------------------------------------------------------------------------------------
signal const_zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal one: STD_LOGIC_VECTOR(31 downto 0);
signal PC: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal PC_jump_amount: STD_LOGIC_VECTOR(18 downto 0);
signal RF_a: STD_LOGIC_VECTOR(31 downto 0);
signal RF_b: STD_LOGIC_VECTOR(31 downto 0);
signal instr: STD_LOGIC_VECTOR(63 downto 0) := (others=> '0');
signal ALU_result: STD_LOGIC_VECTOR(31 downto 0);
signal DM_output: STD_LOGIC_VECTOR(31 downto 0);
signal RB, WB: STD_LOGIC;
signal instruct_type: STD_LOGIC_VECTOR(1 downto 0);
signal alu_control: STD_LOGIC_VECTOR(4 downto 0);

begin
one <= const_zero(31 downto 1) & '1'; -- signal to add 1 to PC in PcBranch

---- Wiring for instruction memory
IM : instruction_mem port map(PC_value => PC(5 downto 0), instruc => instr);

---- Wiring for control unit                                               --these are OUT SIGNALS, they were overiding instr
CU : control_unit port map(instr => instr, readBit => RB, writeBit => RB, instr_type => instruct_type, alucontrol => alu_control);

---- Wiring for pcbranch            --Don't know what first memory address is
pcBranchComp : pcbranch port map(constant_start => const_zero, clk => clk, oldPC => PC, instr_type => instr(63 downto 62), 
                                 one => one, offset => PC_jump_amount, Result => PC); 

---- Wiring for ALU
--ALUComp : alu port map(a => RF_a, b => RF_b, alucontrol => instr(61 downto 57), aluresult => ALU_result);

---- Wiring for register file 
--RFComp : regfile port map(clk => clk, instruction => instr, DM_result => DM_output, OutA => RF_a, OutB => RF_b);

---- Wiring for data_memory 
-- Add ReadBit (From control unit)
-- Add WriteBit (From control unit)
-- Read address and write address are probably wrong. May need more signals
--DMComp : data_memory port map(clk => clk, writeData => RF_b, ReadBit => '0', WriteBit => '0', readAddress => ALU_result, writeAddress => ALU_result, result => DM_output);

---- Wiring for bsrc
--BSRCComp : bsrc port map(instr_type => instr(63 downto 62), regB => RF_b, immB => instr(31 downto 0), toB => RF_b);
 
end;




