library IEEE;
use IEEE.STD_LOGIC_1164.all;
use STD.TEXTIO.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

------------------------------------------------------------------------------------------------------------
--Multiplexer that controls what goes into the b port of the alu 
-- Input: instr_Type (Alucontrol signal that specifies which type of instruction is being executed)
-- Input: regB (Output value from register file component - Only used for R type instructions)
-- Input: immB (Bottom 32 bits of any instruction signal, used only for F/I-Type instructions)
-- Output: toB (Value that is sent to 'B' signal of the ALU)
entity bsrc is
port(instr_type: in std_logic_vector(1 downto 0);
     regB: in std_logic_vector(31 downto 0);
     immB: in std_logic_vector(31 downto 0);
     toB: out std_logic_vector(31 downto 0));
end;

-- The outout toB will depend on the type of instruction (alucontrol bits)
-- If the instruction is a I-type instruction, output will be immB
-- Else, the output will be regB
architecture behave of bsrc is 
begin 
    with instr_type(1 downto 0) select toB <=
    immB when "00",   
    regB when others; 
end;
    
