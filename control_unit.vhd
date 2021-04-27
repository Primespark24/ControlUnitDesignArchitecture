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
port(clk: in std_logic;
    instr: in std_logic_vector(63 downto 0) := (others=> '0');
     readBit, writeBit: out std_logic := '0';
port(instr: in std_logic_vector(63 downto 0) := (others=> '0');
     readBit, writeBit: out std_logic;
     instr_type: out std_logic_vector(1 downto 0) := (others=> '0');
     alucontrol: out std_logic_vector(4 downto 0):= (others=> '0'));
end;

architecture behave of control_unit is
begin 
    process(instr)
    begin
            instr_type <= instr(63 downto 62);
            alucontrol <= instr(61 downto 57);

            --Set readbit
            if(instr(61 downto 57) = "01000") then
                readBit <= '1';
                writeBit <= '0';
            else
                readBit <= '0';
            end if;

                --Set writebit
            if(instr(61 downto 57) = "01001") then
                writeBit <= '1';
                readBit <= '0';
            else
                writeBit <= '0';
            end if;
     end process;
end;
