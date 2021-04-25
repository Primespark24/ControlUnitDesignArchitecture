---------------------------------------------------------------
-- Branch component for the program counter, increments PC by specific number
---------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.NUMERIC_STD.all;

------------------------------------------------------------------------------------------------------------
--Component used for J-type instructions only
-- Input: constant_start (The memory address of the first instruction)
-- Input: offset (Number added/subtracted to constant_start to jump to a new memory address, from control unit)
-- Output: result (Result of constant_start +- offset)
entity pcbranch is     -- define signals going in and out of the adder
port(constant_start: in STD_LOGIC_VECTOR(31 downto 0);
     instr_type: in STD_LOGIC_VECTOR(1 downto 0);
     four: in STD_LOGIC_VECTOR(31 downto 0);
     offset: in STD_LOGIC_VECTOR(18 downto 0);
     Result: out STD_LOGIC_VECTOR(31 downto 0)); 
end;

------------------------------------------------------------------------------------------------------------
-- Add the offset to the constant_start and wire that to the result
architecture behave of pcbranch is
signal extendedOffset: STD_LOGIC_VECTOR(31 downto 0);
signal zero : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
    extendedOffset(31 downto 19) <= "0000000000000";
    extendedOffset(18 downto 0) <= offset;
    with instr_type(1 downto 0) select Result <=
        constant_start + offset when "10", --J-type
        constant_start + four when others;
end;
