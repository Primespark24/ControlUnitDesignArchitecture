library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;

-- Will add more input/ouput signals as needed
entity PirateProcessorTop is
port(
     clk : in STD_LOGIC
    );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture PirateProcessorTop of PirateProcessorTop is

component datapath 
port(clk: in STD_LOGIC);
end component;

component alu
port(a: in std_logic_vector(31 downto 0);
     b: in std_logic_vector(31 downto 0);
     alucontrol: in std_logic_vector(4 downto 0);
     aluresult: out std_logic_vector(31 downto 0));
end component;

component regfile
  port(clk: in  STD_LOGIC;
       instruction: in  STD_LOGIC_Vector(63 downto 0);
       DM_result: in  STD_LOGIC_Vector(31 downto 0);
       OutA, OutB: out STD_LOGIC_VECTOR(31 downto 0));
end component;

component data_memory
  port(clk:  in STD_LOGIC;
       ReadBit: in STD_LOGIC;
       WriteBit: in STD_LOGIC;
       writeData: in STD_LOGIC_Vector(31 downto 0);
       readAddress: in STD_LOGIC_Vector(31 downto 0);
       writeAddress: in STD_LOGIC_Vector(31 downto 0);
       result: out STD_LOGIC_VECTOR(31 downto 0));
end component;

component instruction_mem
port(PC_value: in  STD_LOGIC_VECTOR(5 downto 0);
     instruc: out STD_LOGIC_VECTOR(63 downto 0)); --the signal out containing the instruction
end component;

component bsrc 
port(instr_type: in std_logic_vector(1 downto 0);
     regB: in std_logic_vector(31 downto 0);
     immB: in std_logic_vector(31 downto 0);
     toB: out std_logic_vector(31 downto 0));
end component;

component pcbranch
port(constant_start: in STD_LOGIC_VECTOR(31 downto 0);
     clk: in STD_LOGIC;
     oldPC: in STD_LOGIC_VECTOR(31 downto 0);
     instr_type: in STD_LOGIC_VECTOR(1 downto 0);
     four: in STD_LOGIC_VECTOR(31 downto 0);
     offset: in STD_LOGIC_VECTOR(18 downto 0);
     Result: out STD_LOGIC_VECTOR(31 downto 0)); 
end component;

component control_unit
port(instr: in std_logic_vector(63 downto 0);
     readBit, writeBit: out std_logic;
     instr_type: out std_logic_vector(1 downto 0);
     alucontrol: out std_logic_vector(4 downto 0));
end component;

begin
end PirateProcessorTop;

--signal const_zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
--signal four: STD_LOGIC_VECTOR(31 downto 0);
--signal PC: STD_LOGIC_VECTOR(31 downto 0);
--signal PC_jump_amount: STD_LOGIC_VECTOR(18 downto 0);
--signal RF_a: STD_LOGIC_VECTOR(31 downto 0);
--signal RF_b: STD_LOGIC_VECTOR(31 downto 0);
--signal instr: STD_LOGIC_VECTOR(63 downto 0);
--signal ALU_result: STD_LOGIC_VECTOR(31 downto 0);
--signal DM_output: STD_LOGIC_VECTOR(31 downto 0);
--signal RB, WB: STD_LOGIC;
--begin
--four <= const_zero(31 downto 4) & X"4"; -- signal to add 4 to CP in PC_Plus4
--PC <= "00000000000000000000000000000000";
--DPU : datapath port map(clk => clk);
--IM : instruction_mem port map(PC_value => PC(5 downto 0), instruc => instr);
--CU : control_unit port map(instr => instr, readBit => RB, writeBit => RB, instr_type => instr(63 downto 62), alucontrol => instr(61 downto 57));
--pcBranchComp : pcbranch port map(constant_start => const_zero, clk => clk, oldPC => PC, instr_type => instr(63 downto 62), four => four, offset => PC_jump_amount, Result => PC); 
--ALUComp : alu port map(a => RF_a, b => RF_b, alucontrol => instr(61 downto 57), aluresult => ALU_result);
--RFComp : regfile port map(clk => clk, instruction => instr, DM_result => DM_output, OutA => RF_a, OutB => RF_b);
--DMComp : data_memory port map(clk => clk, writeData => RF_b, ReadBit => '0', WriteBit => '0', readAddress => ALU_result, writeAddress => ALU_result, result => DM_output);
--BSRCComp : bsrc port map(instr_type => instr(63 downto 62), regB => RF_b, immB => instr(31 downto 0), toB => RF_b);
