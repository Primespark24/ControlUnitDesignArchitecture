library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;

entity alu_testbench is
end;
------------------------------------------------------------------------------------------------------------
-- Alu_testbench simulates ALU - It does mathematical operations
-- Inputs: A, B (32 bit signals that are the two numbers being added/subtracted/multiplied/etc)
-- Output: aluresult (Result of the operation between A, B)
architecture alu_testbench of alu_testbench is 
    component alu is
        port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
            alucontrol: in STD_LOGIC_VECTOR(4 downto 0);
            aluresult: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    --Signals defined for simulation - Same as alu component
    signal sim_a, sim_b: STD_LOGIC_VECTOR(31 downto 0);
    signal sim_alucontrol: STD_LOGIC_VECTOR(4 downto 0);
    signal sim_result: STD_LOGIC_VECTOR(31 downto 0);
begin 
    testproc: process begin
        wait for 10ns;
        sim_alucontrol <= "00000"; -- addfi instruction
        sim_a <= std_logic_vector(to_float(4.5));
        sim_b <= std_logic_vector(to_float(3.2));
        wait for 10ns;
        assert sim_result = std_logic_vector(to_float(7.7)) report "Failed 4.5 addfi 3.2";

        sim_alucontrol <= "00001"; -- add instruction, essentially same test as add: addfi and add do same computation
        sim_a <= std_logic_vector(to_float(-11));
        sim_b <= std_logic_vector(to_float(-48));
        wait for 10ns;
        assert sim_result = std_logic_vector(to_float(-59)) report "Failed -11 add -48";
        wait for 10ns; 
        
        sim_alucontrol <= "00010"; -- sub instruction
        sim_a <= std_logic_vector(to_float(-11));
        sim_b <= std_logic_vector(to_float(22));
        wait for 10ns;
        assert sim_result = std_logic_vector(to_float(-33)) report "Failed -11 sub 22";
        wait for 10ns; 
        
        sim_alucontrol <= "00011"; -- mul instruction
        sim_a <= std_logic_vector(to_float(-11.12));
        sim_b <= std_logic_vector(to_float(58.56));
        wait for 10ns;
        assert sim_result = std_logic_vector(to_float(-651.1872)) report "Failed -11.12 mul 58.56";
        wait for 10ns; 

        sim_alucontrol <= "00100"; -- div instruction
        sim_a <= std_logic_vector(to_float(9974.54));
        sim_b <= std_logic_vector(to_float(3.45));
        wait for 10ns;
        assert sim_result = std_logic_vector(to_float(2891.171014)) report "Failed 9974.54 div 3.45";
        wait for 10ns; 

        sim_alucontrol <= "00101"; -- mod instruction
        sim_a <= std_logic_vector(to_float(65));
        sim_b <= std_logic_vector(to_float(7.5));
        wait for 10ns;
        assert sim_result = std_logic_vector(to_float(5)) report "Failed 65 mul 7.5";
        wait for 10ns; 
    end process;

sim_alu: alu port map(
        a => sim_a, 
        b => sim_b, 
        alucontrol => sim_alucontrol,
        aluresult => sim_result
    );
end alu_testbench;
