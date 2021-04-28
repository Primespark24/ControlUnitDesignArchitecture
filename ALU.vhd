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
  port(
       instruction: in STD_LOGIC_Vector(63 downto 0);
       a: in STD_LOGIC_VECTOR(31 downto 0);
       b: in STD_LOGIC_VECTOR(31 downto 0);
       alucontrol: in STD_LOGIC_VECTOR(4 downto 0);  
       branch:  out STD_LOGIC;
       aluresult: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of alu is
    signal zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');    --Constant 0 value, result if opcode is undefined 
    signal float_a, float_b, float_zero : UNRESOLVED_float(8 downto -23);          --Converted signals of a and b to floats
    signal a_minus_b : STD_LOGIC_VECTOR(31 downto 0);                  --Signal for comparing a and b, will be used for branching 
begin
    float_a <= to_float(a);   --Convert signals to floats
    float_b <= to_float(b);
    float_zero <= to_float(zero);
    a_minus_b <= STD_LOGIC_VECTOR(float_a - float_b);

  -- determine alu operation from alucontrol bits 0 and 1
  with alucontrol(4 downto 0) select aluresult <=
    STD_LOGIC_VECTOR(float_a + float_b)     when "00000",   --addfi
    STD_LOGIC_VECTOR(float_a + float_b)     when "00001",   --add
    STD_LOGIC_VECTOR(float_a - float_b)     when "00010",   --sub
    STD_LOGIC_VECTOR(float_a * float_b)     when "00011",   --mul
    STD_LOGIC_VECTOR(float_a / float_b)     when "00100",   --div
    STD_LOGIC_VECTOR(float_a mod float_b)   when "00101",   --mod
    --these may never be used but wanted to have 8 ops
    a                       when "01000",   --sw
    b                       when "01001",   --lw
    zero                    when others;


  --Process to determine the branching flag
  process(a_minus_b, alucontrol, instruction)
  begin
    --BEQ: Set the branch flag 
    if alucontrol = "01010" and a_minus_b = STD_LOGIC_VECTOR(float_zero) then
      branch <= '1'; 
    --BNE
    elsif alucontrol = "01011" and a_minus_b /= STD_LOGIC_VECTOR(float_zero) then 
      branch <= '1';
    --Jump
    elsif alucontrol = "01100" then
      branch <= '1';
    --BLT: If a is less than b, then a-b will be negative
    elsif alucontrol = "01110" and a_minus_b < STD_LOGIC_VECTOR(float_zero) then
      branch <= '1';
    --BGT: If a is greater than b, then a-b will be positive
    elsif alucontrol = "01111" and a_minus_b > STD_LOGIC_VECTOR(float_zero) then
      branch <= '1';
    else
      branch <= '0';
    end if;
  end process;
end;
