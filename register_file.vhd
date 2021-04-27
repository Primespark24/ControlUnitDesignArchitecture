library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

------------------------------------------------------------------------------------------------------------
--Regfile handles the requisiton of register values
-- Input: clk (Used to update/run processes)
-- Input: instr_type (Used to help specify register bits)
-- Input: instruction (Complete instruction signal)
-- Input: DM_result (Output signal from data memory. Used for store word instruction and R-types)
-- Outputs: OutA, OutB (Output signals sent to ALU)
entity regfile is 
  port(clk: in  STD_LOGIC;
       instruction: in  STD_LOGIC_Vector(63 downto 0);
       DM_result: in  STD_LOGIC_Vector(31 downto 0);
       OutA, OutB: out STD_LOGIC_VECTOR(31 downto 0) := (others => '0'));
end;

architecture behave of regfile is
  type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype := (others=>(others => '0'));
  signal zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');    --Constant 0 value, result if opcode is undefined 
  signal instr_type : STD_LOGIC_VECTOR(1 downto 0);
begin   
  -----------------------------------------------------
  -- Set output of register A and B depending on instruction
  -- Grabs the registers that are input depending on the instruction type, which has different formats for register inputs
  -- Read from A/B
  instr_type <= instruction(63 downto 62);
  process(clk) begin
    if rising_edge(clk) then
		if instr_type = "00" then   -- F/I-type
        -- Grabs the memory stored at 'RD'
			OutA <= mem(to_integer(unsigned(instruction(37 downto 32))));
        -- Grabs the memory stored at 'RS' 
			OutB <= mem(to_integer(unsigned(instruction(43 downto 38))));
        elsif instr_type = "01" then  --R-type
        -- Grabs the memory stored at 'RS'
			OutA <= mem(to_integer(unsigned(instruction(5 downto 0))));
        -- Grabs the memory stored at 'RD'
			OutB <= mem(to_integer(unsigned(instruction(11 downto 6))));
        elsif instr_type = "10" then  -- J-type
        -- Grabs the memory stored at input: 'RD'
			OutA <= mem(to_integer(unsigned(instruction(56 downto 51))));
			OutB <= zero;
        elsif instr_type = "11" then    -- M-type
        -- Grabs the memory stored at input: 'memory_location'
			OutA <= mem(to_integer(unsigned(instruction(11 downto 6))));
			OutB <= zero;
        else
            OutA <= zero;
            OutB <= zero;
		end if;
    end if;
  end process;
  
  -- Write register memory from data_memory result
  process(DM_result, mem, clk) begin
    if instr_type = "01" then   -- R-type
        -- Writes into the register that is located by 'RT'
        mem(to_integer(unsigned(instruction(17 downto 12)))) <= DM_result;
    elsif instr_type = "11" then  -- M-type
        -- Writes into the register that is located by 'RD'
        mem(to_integer(unsigned(instruction(11 downto 6)))) <= DM_result;
    end if;
  end process;
end;