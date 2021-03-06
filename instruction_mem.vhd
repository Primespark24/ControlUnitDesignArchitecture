------------------------------------------------------------------------------
-- Instruction Memory
------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
--this code reads the .dat file and sends it out as a 64-bit instr
entity instruction_mem is -- instruction memory
  port(PC_value: in  STD_LOGIC_VECTOR(5 downto 0);
       instruc: out STD_LOGIC_VECTOR(63 downto 0)); --the signal out containing the instruction
  end;

architecture behave of instruction_mem is
  type ramtype is array (63 downto 0) of STD_LOGIC_VECTOR(63 downto 0);


  -- function to initialize the instruction memory from a data file
  impure function InitRamFromFile ( RamFileName : in string ) return RamType is
    variable ch: character;
    variable index : integer;
    variable result: signed(63 downto 0);
    variable tmpResult: signed(127 downto 0);
    file mem_file: TEXT is in RamFileName;
    variable L: line;
    variable RAM : ramtype;
  begin
    -- initialize memory from a file
    for i in 0 to 63 loop -- set all contents low
      RAM(i) := std_logic_vector(to_unsigned(0, 64));
    end loop;
    index := 0;
    while not endfile(mem_file) loop
      -- read the next line from the file
      readline(mem_file, L);
      result := to_signed(0, 64);
      for i in 1 to 16 loop
        -- read character from the line just read
        read(L, ch);
        --  convert character to a binary value from a hex value
        if '0' <= ch and ch <= '9' then
          tmpResult := result*16 + character'pos(ch) - character'pos('0') ;
          result := tmpResult(63 downto 0);
        elsif 'a' <= ch and ch <= 'f' then
          tmpResult := result*16 + character'pos(ch) - character'pos('a')+10 ;
          result := tmpResult(63 downto 0);
        else report "Format error on line " & integer'image(index)
          severity error;
        end if;
      end loop;

      -- set the width bit binary value in ram
      RAM(index) := std_logic_vector(result);
      index := index + 1;
    end loop;
    -- return the array of instructions loaded in RAM
    return RAM;
  end function;

  -- use the impure function to read RAM from a file and store in the FPGA's ram memory
  signal mem: ramtype := InitRamFromFile("memfile.dat");

begin

------------------------------------------------------------------------------------------------------------
-- Process to read memory from register file based on program counter
  process (PC_value) is
  begin
    instruc <= mem(to_integer(unsigned(PC_value)));
  end process;
end behave;
