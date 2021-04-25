library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

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

component datapath 
port(clk: in STD_LOGIC);
end component;

begin
end PirateProcessorTop;