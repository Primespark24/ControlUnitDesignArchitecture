library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;

entity regfile_testbench is
end;
------------------------------------------------------------------------------------------------------------
-- 
architecture regfile_testbench of regfile_testbench is 
    component regfile is
        port(clk: in  STD_LOGIC;
        instruction: in  STD_LOGIC_Vector(63 downto 0);
        DM_result: in  STD_LOGIC_Vector(31 downto 0);
        OutA, OutB: out STD_LOGIC_VECTOR(31 downto 0));
    end component;
    
    --Signals defined for simulation 
    signal sim_clk: std_logic := 0;
    signal sim_DM: std_logic_vector(31 downto 0);
    signal sim_instruction: std_logic_vector(63 downto 0);
    signal sim_outA, sim_outB: std_logic_vector(31 downto 0);
begin 
    testproc: process begin
        clk <= not clk after half_period when finished /= '1' else '0';
        wait for 10ns;
        -- Store values in the register by using DM_result, which will test that we can properly write into the regfile
        DM_result <= "111111111111111100000000000000000000";
        -- Create an M-Type instruction: sw to store the value of a register(memoryloc) into RD 

        -- Check that the register located at RD is modified

        -- Create an I-type instruction where I know what the register inputs are
        -- Check that the register outputs are as desired

        -- Create an R-Type instruction 
        -- Check that the register outputs are as desired

    end process;

sim_regfile: regfile port map();
end regfile_testbench;
