-- heavy citation to Kent Jones's MIPS datapath
library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity control_unit is 
    port(instr: in std_logic_vector(63 downto 0);
         readBit, writeBit out std_logic;
         instr_type out std_logic_vector(1 downto 0);
         alucontrol out std_logic_vector(3 downto 0));
end;

architecture struct of datapath is 

begin 
    instr_type <= instr(1 downto 0);
    alucontrol <= instr(6 downto 4);

    --addsomething (process?) thta determines read/write bits
