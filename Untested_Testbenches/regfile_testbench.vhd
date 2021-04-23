library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;

entity regfile_testbench is
end;
------------------------------------------------------------------------------------------------------------
-- Alu_testbench simulates ALU - It does mathematical operations
-- Inputs: A, B (32 bit signals that are the two numbers being added/subtracted/multiplied/etc)
-- Output: aluresult (Result of the operation between A, B)
architecture regfile_testbench of regfile_testbench is 
    component regfile is
        port(clk: in  STD_LOGIC;
        instr_type: in  STD_LOGIC_VECTOR(1 downto 0);
        instruction: in  STD_LOGIC_Vector(63 downto 0);
        DM_result: in  STD_LOGIC_Vector(31 downto 0);
        OutA, OutB: out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    
    --Signals defined for simulation 
    signal sim_clk: std_logic := 0;
begin 
    testproc: process begin
        clk <= not clk after half_period when finished /= '1' else '0';
        
    end process;

sim_regfile: regfile port map(
        a => sim_a, 
        b => sim_b, 
        alucontrol => sim_alucontrol,
        aluresult => sim_result
    );
end regfile_testbench;
