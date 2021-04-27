library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;

-- Will add more input/ouput signals as needed
entity PirateProcessorTop is
port(
     clk : in STD_LOGIC
    );
end;

---------------------------------------------------------
-- Architecture Definitions
---------------------------------------------------------

architecture PirateProcessorTop of PirateProcessorTop is

begin
    DPU : entity work.datapath port map(clk => clk);
end PirateProcessorTop;