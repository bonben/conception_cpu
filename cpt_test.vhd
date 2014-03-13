--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:21:36 03/12/2014
-- Design Name:   
-- Module Name:   /home/leonardon/Ecole/Conception_processeur_elementaire/processeur/cpt_test.vhd
-- Project Name:  processeur
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cpt
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;

entity cpt_test is
end cpt_test;

architecture behavior of cpt_test is

  -- Component Declaration for the Unit Under Test (UUT)
  
  component cpt
    port(
      clock       : in  std_logic;
      reset       : in  std_logic;
      load_cpt    : in  std_logic;
      incr_cpt    : in  std_logic;
      init_cpt    : in  std_logic;
      bus_cpt_in  : in  std_logic_vector(5 downto 0);
      bus_cpt_out : out std_logic_vector(5 downto 0)
      );
  end component;


  --Inputs
  signal clock      : std_logic                    := '0';
  signal reset      : std_logic                    := '0';
  signal load_cpt   : std_logic                    := '0';
  signal incr_cpt   : std_logic                    := '0';
  signal init_cpt   : std_logic                    := '0';
  signal bus_cpt_in : std_logic_vector(5 downto 0) := (others => '0');

  --Outputs
  signal bus_cpt_out : std_logic_vector(5 downto 0);

  -- Clock period definitions
  constant clock_period : time := 10 ns;
  
begin

  -- Instantiate the Unit Under Test (UUT)
  uut : cpt port map (
    clock       => clock,
    reset       => reset,
    load_cpt    => load_cpt,
    incr_cpt    => incr_cpt,
    init_cpt    => init_cpt,
    bus_cpt_in  => bus_cpt_in,
    bus_cpt_out => bus_cpt_out
    );

  -- Clock process definitions
  clock_process : process
  begin
    clock <= '0';
    wait for clock_period/2;
    clock <= '1';
    wait for clock_period/2;
  end process;


  -- Stimulus process
  stim_proc : process
  begin
	 ce <='1';	
    reset      <= '1';
    bus_cpt_in <= "101010";

    wait for 100 ns;
    reset    <= '0';
    load_cpt <= '0';
    incr_cpt <= '0';
    init_cpt <= '1';

    wait for clock_period*10;
    load_cpt <= '1';
    incr_cpt <= '0';
    init_cpt <= '0';

    wait for clock_period*10;
    load_cpt <= '0';
    incr_cpt <= '1';
    init_cpt <= '0';


    wait;
  end process;

end;
