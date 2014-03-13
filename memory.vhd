----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:14:56 03/10/2014 
-- Design Name: 
-- Module Name:    memory - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity memory is
  port (enable_m_in : in  std_logic;
        r_w_in      : in  std_logic;
        address_in  : in  std_logic_vector (5 downto 0);
        memory_out  : out std_logic_vector (7 downto 0);
        memory_in   : in  std_logic_vector (7 downto 0);
        clock       : in  std_logic;
        reset       : in  std_logic;
        ce          : in  std_logic);
end memory;

architecture Behavioral of memory is

  type mem is array (0 to 63) of std_logic_vector(7 downto 0);  --  64 blocks of 8 bits
  signal my_memory : mem;





  
begin  -- Behavioral



  process (clock, reset) is
  begin  --Process
    if reset = '1' then
      memory_out <= "00000000";


      -- Test
      --my_memory(0) <= x"08";
      --my_memory(1) <= x"47";
      --my_memory(2) <= x"86";
      --my_memory(3) <= x"C4";
      --my_memory(4) <= x"C4";
      --my_memory(5) <= x"00";
      --my_memory(6) <= x"00";
      --my_memory(7) <= x"7E";
      --my_memory(8) <= x"FE";

      -- PGCD
      my_memory(0)  <= x"11";
      my_memory(1)  <= x"15";
      my_memory(2)  <= x"52";
      my_memory(3)  <= x"54";
      my_memory(4)  <= x"C9";
      my_memory(5)  <= x"94";
      my_memory(6)  <= x"51";
      my_memory(7)  <= x"CD";
      my_memory(8)  <= x"C0";
      my_memory(9)  <= x"13";
      my_memory(10) <= x"52";
      my_memory(11) <= x"95";
      my_memory(12) <= x"C0";
      my_memory(13) <= x"CD";
      my_memory(14) <= x"00";
      my_memory(15) <= x"00";
      my_memory(16) <= x"00";
      my_memory(17) <= x"FF";
      my_memory(18) <= x"01";
      my_memory(19) <= x"00";
      my_memory(20) <= x"28";
      my_memory(21) <= x"18";

    elsif clock'event and clock = '0' then  --Front descendant
      if ce = '1' then
        if enable_m_in = '1' then
          if r_w_in = '1' then              --ecriture
            my_memory(TO_INTEGER(unsigned(address_in))) <= memory_in;
          else                              --lecture
            memory_out <= my_memory(TO_INTEGER(unsigned(address_in)));
          end if;
        end if;
      end if;
    end if;
  end process;
end Behavioral;
