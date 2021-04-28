library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;

entity alu_bsrc_pcbranch_testbench is
end;


-- 
architecture alu_bsrc_pcbranch_testbench of alu_bsrc_pcbranch_testbench is 
    component alu is
        port(a: in STD_LOGIC_VECTOR(31 downto 0);
            b: in STD_LOGIC_VECTOR(31 downto 0);
            alucontrol: in STD_LOGIC_VECTOR(4 downto 0);  
            branch:  out STD_LOGIC;
            aluresult: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component bsrc is 
        port(instr_type: in std_logic_vector(1 downto 0);
            regB: in std_logic_vector(31 downto 0);
            immB: in std_logic_vector(31 downto 0);
            toB: out std_logic_vector(31 downto 0)
        );
    end component;

    component pcbranch is     -- define signals going in and out of the adder
        port(constant_start: in STD_LOGIC_VECTOR(31 downto 0);
            clk: in STD_LOGIC;
            branch_input: in STD_LOGIC;
            oldPC: in STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
            offset: in STD_LOGIC_VECTOR(18 downto 0);
            result: out STD_LOGIC_VECTOR(31 downto 0) := (others => '0'));
    end component;
    
    --Signals defined for simulation bsrc 
    signal sim_regA: std_logic_vector(31 downto 0);
    signal sim_regB: std_logic_vector(31 downto 0);
    signal sim_immB: std_logic_vector(31 downto 0);
    signal bsrc_result: std_logic_vector(31 downto 0);
    --signals for the alu
    signal instruct_type: std_logic_vector(1 downto 0);
    signal sim_alucontrol: std_logic_vector(4 downto 0);
    signal sim_alu_result: std_logic_vector(31 downto 0);
   
    --signals for the pcbranch
    signal branch_alu_to_pcbranch: std_logic;
    signal sim_old_PC: std_logic_vector(31 downto 0);
    signal sim_offset: std_logic_vector(18 downto 0);
    signal pcbranch_result:std_logic_vector(31 downto 0);
    signal sim_const_start: std_logic_vector(31 downto 0);
    signal sim_clk: std_logic := '0';
    
begin
    --from mips sim_testbench
    clkproc: process begin
        sim_clk <= '1'; --clock simulation
        wait for 10 ns; 
        sim_clk <= '0';
        wait for 10 ns;
      end process;
    
    
    testbenchProc: process begin
        --testing add, aluresults should = immB and pc just increments by 1
        sim_alucontrol <= "00001"; --testing add, 4.2(a)+ 2.4(b) = 6.6 (immB which is NOt sent to alu)
        instruct_type <= "01";
        sim_regA <= std_logic_vector(to_float(4.2)); 
        sim_regB <= std_logic_vector(to_float(2.4));
        sim_immB <= std_logic_vector(to_float(6.6));
        --ALU recieves sim_alucontrol, sim_regA, and bsrc_result
        --ALU should create outputs accordingly, assert alu_result == 0
        --Set signals for pcbranch
        sim_const_start <= "00000000000000000000000000000000"; --start is 0
        sim_old_pc <= "00000000000000000000000000001100"; --Const value of 12, we staring at 12 in memory
        sim_offset <= "0000000000000000000";

        wait for 20 ns;
        --PC branch should equal 0, because the register A and immB are equal, so it should branch, 
        -- and the branch offset should add 3 to the const_start of 0
        --testing jump if equal
        sim_alucontrol <= "01010"; --breanch if a = imm, it should
        instruct_type <= "10";
        sim_regA <= std_logic_vector(to_float(4.2)); 
        sim_regB <= std_logic_vector(to_float(2.4)); --this is not used ina  jump operation
        sim_immB <= std_logic_vector(to_float(4.2));
        --ALU recieves sim_alucontrol, sim_regA, and bsrc_result
        --Set signals for pcbranch the bramnch flag should be 1
        sim_offset <= "0000000000000000011"; --this should be used to calc the jump distance,from 0
        wait for 20 ns;
    end process;
    
    bsrc_map : bsrc port map( --teh same names on btoh sides in mips examples, chaned to that
        instr_type => instruct_type,
        regB => sim_regB,
        immB => sim_immB,
        toB => bsrc_result
    );
       
    alu_map : alu port map( 
            a => sim_regA,
            b => bsrc_result,
            alucontrol => sim_alucontrol,  
            branch =>  branch_alu_to_pcbranch,
            aluresult => sim_alu_result
    );   
    
    pcbranch_map : pcbranch port map(
            constant_start => sim_const_start,
            clk => sim_clk,
            branch_input => branch_alu_to_pcbranch,
            oldPC => sim_old_PC,
            offset => sim_offset,
            result => pcbranch_result
    );

end alu_bsrc_pcbranch_testbench;
