library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all;  
use IEEE.NUMERIC_STD.all;


-------------------------------------------------------------------- 
--Data memory holds program data
-- Input: clk (Used to update/run processes)
-- Input: ReadBit (Control bit that specifies if data should be read)
-- Input: WriteBit (Control bit that specifies if data should be written)
-- Input: ALUResult (Result from previous ALU operation)
-- Input: writeData (Data that will be put into memory)
-- Input: readAddress (32 bit signal of which memory location to read from)
-- Input: writeAddress (32 bit signal of which memory location to write to)
-- Output: result (Signal sent back to regfile for loadword instructions)
entity data_memory is -- data memory
  port(
       instruction: in STD_LOGIC_Vector(63 downto 0);
       clk:  in STD_LOGIC;
       ReadBit: in STD_LOGIC;
       WriteBit: in STD_LOGIC;
       writeData: in STD_LOGIC_Vector(31 downto 0);
       ALU_result: in STD_LOGIC_Vector(31 downto 0);
       result: out STD_LOGIC_VECTOR(31 downto 0) := (others=> '0'));
end;

-------------------------------------------------------------------- 
-- Data memory holds 64 32-bit numbers
architecture behave of data_memory is
  type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
  signal mem: ramtype := (others=>(others => '0'));
  signal const_zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin

  -------------------------------------------------------------------- 
  --Process for reading data
  process (ReadBit, instruction, clk) is
  begin
        if (ReadBit = '1') then 
			result <= mem(to_integer(unsigned(instruction(5 downto 0)))); 
        else
			result <= const_zero;
        end if;
  end process;

  -------------------------------------------------------------------- 
  --Process for writing data
  process (WriteBit, instruction, clk) is
  begin
        if (WriteBit = '1') then 
            mem(to_integer(unsigned(instruction(5 downto 0)))) <= ALU_result;
        else
			result <= const_zero;
        end if;
  end process;
end;