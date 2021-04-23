---------------------------------------------------------------
-- Arithmetic/Logic unit with add/sub, AND, OR, set less than
---------------------------------------------------------------
library IEEE; 
 -- these libraries give us basic float Arithmetic
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;

------------------------------------------------------------------------------------------------------------
--Alu does mathematical operations
-- Inputs: A, B (32 bit signals that are the two numbers being added/subtracted/multiplied/etc)
-- Input: alucontrol - (3 bit singal that tells alu what operation is being performed)
-- Output: aluresult (Result of the operation between A, B)
entity alu is     -- define signals going in and out of the alu
  port(a: in STD_LOGIC_VECTOR(31 downto 0);
       b: in STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in STD_LOGIC_VECTOR(4 downto 0);  
       aluresult: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of alu is
    signal zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');    --Constant 0 value, result if opcode is undefined 
    signal float_a, float_b : UNRESOLVED_float(8 downto -23);          --Converted signals of a and b to floats
begin
    float_a <= to_float(a);   --Convert signals to floats
    float_b <= to_float(b);

  -- determine alu operation from alucontrol bits 0 and 1
  with alucontrol(2 downto 0) select aluresult <=
    STD_LOGIC_VECTOR(float_a + float_b)     when "000",   --addfi
    STD_LOGIC_VECTOR(float_a + float_b)     when "001",   --add
    STD_LOGIC_VECTOR(float_a - float_b)     when "010",   --sub
    STD_LOGIC_VECTOR(float_a * float_b)     when "011",   --mul
    STD_LOGIC_VECTOR(float_a / float_b)     when "100",   --div
    STD_LOGIC_VECTOR(float_a mod float_b)   when "101",   --mod
    --these may never be used but wanted to have 8 ops
    a and b                 when "110",   --and
    a or b                  when "111",   --or
    zero                    when others;
end;
