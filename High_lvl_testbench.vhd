library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.numeric_std.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_real.all;
use work.fixed_float_types.all;
use work.float_pkg.all;
use work.fixed_pkg.all;

entity High_lvl_sim is
end;

architecture High_lvl_sim of High_lvl_sim is

component PirateProcessorTop is
port(clk: in STD_LOGIC);
end component;

------------------------------------
-- Signals
signal clk : STD_LOGIC;
------------------------------------

begin 

  -- Generate simulated clock with 10 ns period
  clkproc: process begin
    clk <= '0';
    wait for 10 ns; 
    clk <= '1';
    wait for 10 ns;
  end process;

  -- Wire high level component
  PirateProcessor: PirateProcessorTop 
  port map(clk => clk);

end High_lvl_sim;
