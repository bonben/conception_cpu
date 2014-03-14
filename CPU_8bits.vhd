----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:40:00 02/15/2011 
-- Design Name: 
-- Module Name:    CPU_8bits - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_8bits is
  port (reset        : in    std_logic;
        clk100M      : in    std_logic;
        valid_saisie : in    std_logic;
        AN1          : out   std_logic;
        AN2          : out   std_logic;
        AN3          : out   std_logic;
        AN4          : out   std_logic;
        Sevenseg     : out   std_logic_vector (7 downto 0);
        LED          : out   std_logic_vector (7 downto 0);
        pdb          : inout std_logic_vector(7 downto 0);
        astb         : in    std_logic;
        dstb         : in    std_logic;
        pwr          : in    std_logic;
        pwait        : out   std_logic;
        ldg          : out   std_logic
        );
end CPU_8bits;

architecture Behavioral of CPU_8bits is

  component IP_clk
    port
      (
        CLK_IN1  : in  std_logic;
        CLK_OUT1 : out std_logic
        );
  end component;

  component cpu
    port(
      clock   : in  std_logic;
      reset   : in  std_logic;
      ce      : in  std_logic;
      bus_out : out std_logic_vector(7 downto 0);
      bus_in  : out std_logic_vector(7 downto 0);
      address : out std_logic_vector(5 downto 0)
      );
  end component;

  --component Control_Unit
  --  port (Clk            : in  std_logic;
  --        Ce             : in  std_logic;
  --        Reset          : in  std_logic;
  --        Carry          : in  std_logic;
  --        Data_In        : in  std_logic_vector (7 downto 0);
  --        Adr            : out std_logic_vector (5 downto 0);
  --        Clear_Carry    : out std_logic;
  --        Enable_Mem     : out std_logic;
  --        Load_Reg1      : out std_logic;
  --        Load_Reg_Accu  : out std_logic;
  --        Load_Reg_Carry : out std_logic;
  --        Sel_UAL        : out std_logic;
  --        W_Mem          : out std_logic);
  --end component;

  --component Processing_unit
  --  port (Data_in    : in  std_logic_vector (7 downto 0);
  --        clk        : in  std_logic;
  --        Ce         : in  std_logic;
  --        reset      : in  std_logic;
  --        load_reg1  : in  std_logic;
  --        load_accu  : in  std_logic;
  --        load_carry : in  std_logic;
  --        init_carry : in  std_logic;
  --        Sel_UAL    : in  std_logic_vector (2 downto 0);
  --        Data_out   : out std_logic_vector (7 downto 0);
  --        Carry      : out std_logic);
  --end component;

  --component RAM_SP_64_8
  --  port (ADD      : in  std_logic_vector (5 downto 0);
  --        DATA_IN  : in  std_logic_vector (7 downto 0);
  --        R_W      : in  std_logic;
  --        ENABLE   : in  std_logic;
  --        clk      : in  std_logic;
  --        Ce       : in  std_logic;
  --        DATA_OUT : out std_logic_vector (7 downto 0)
  --        );
  --end component;

  component acces_carte
    port (clk       : in  std_logic;
          reset     : in  std_logic;
          AdrLSB    : in  std_logic_vector(3 downto 0);
          AdrMSB    : in  std_logic_vector(1 downto 0);
          DataLSB   : in  std_logic_vector(3 downto 0);
          DataMSB   : in  std_logic_vector(3 downto 0);
          DataInMem : in  std_logic_vector(7 downto 0);
          ce1s      : out std_logic;
          ce25M     : out std_logic;
          AN1       : out std_logic;
          AN2       : out std_logic;
          AN3       : out std_logic;
          AN4       : out std_logic;
          Sseg      : out std_logic_vector(7 downto 0);
          LED       : out std_logic_vector(7 downto 0);
          LEDg      : out std_logic);
  end component;

  component interface_PC is
    port (
      mclk         : in    std_logic;
      reset        : in    std_logic;
      valid_saisie : in    std_logic;
      pdb          : inout std_logic_vector(7 downto 0);
      astb         : in    std_logic;
      dstb         : in    std_logic;
      pwr          : in    std_logic;
      pwait        : out   std_logic;
      rgOp1        : out   std_logic_vector(7 downto 0);
      rgOp2        : out   std_logic_vector(7 downto 0);
      rgSwt        : in    std_logic_vector(7 downto 0);
      Adr          : in    std_logic_vector(5 downto 0);
      R_W          : in    std_logic;
      ldg          : out   std_logic
      );
  end component;

  signal Data_Mem_Unit  : std_logic_vector (7 downto 0);
  signal Data_Unit_Mem  : std_logic_vector (7 downto 0);
  signal val_PC_in1     : std_logic_vector (7 downto 0);
  signal val_PC_in2     : std_logic_vector (7 downto 0);
  signal Adr            : std_logic_vector (5 downto 0);
  signal Carry          : std_logic;
  signal Clear_Carry    : std_logic;
  signal Enable_Mem     : std_logic;
  signal Load_Reg1      : std_logic;
  signal Load_Reg_Accu  : std_logic;
  signal Load_Reg_Carry : std_logic;
  signal Sel_UAL_UT     : std_logic_vector (2 downto 0);
  signal Sel_UAL_UC     : std_logic;
  signal W_Mem          : std_logic;
  signal clk25M         : std_logic;
  signal ce1s           : std_logic;
  signal ce25M          : std_logic;
  signal LEDg           : std_logic;

begin

  Sel_UAL_UT(2 downto 0) <= "00"&Sel_UAL_UC;

-- Attention pour la simulation mettre  ce de UT et UC à ce25M sinon ce1s

  Clock_manager : IP_clk
    port map
    (
      CLK_IN1  => clk100M,
      CLK_OUT1 => clk25M);

  instance_cpu : cpu
    port map (clk25M,
              Reset,
              ce1s,
              Data_Mem_Unit,
              Data_Unit_Mem,
              Adr);


  --UC : Control_Unit port map (clk25M,
  --                            ce1s,
  --                            Reset,
  --                            Carry,
  --                            Data_Mem_Unit,
  --                            Adr,
  --                            Clear_Carry,
  --                            Enable_Mem,
  --                            Load_Reg1,
  --                            Load_Reg_Accu,
  --                            Load_Reg_Carry,
  --                            Sel_UAL_UC,
  --                            W_Mem);

  --UT : Processing_unit port map (Data_Mem_Unit,
  --                               clk25M,
  --                               ce1s,
  --                               Reset,
  --                               Load_Reg1,
  --                               Load_Reg_Accu,
  --                               Load_Reg_Carry,
  --                               Clear_Carry,
  --                               Sel_UAL_UT,
  --                               Data_Unit_Mem,
  --                               Carry);

  --UM : RAM_SP_64_8 port map (Adr,
  --                           Data_Unit_Mem,
  --                           W_Mem,
  --                           Enable_Mem,
  --                           clk25M,
  --                           ce25M,
  --                           Data_Mem_Unit);

  Peripheriques : acces_carte port map (clk25M,
                                        Reset,
                                        Adr(3 downto 0),
                                        Adr(5 downto 4),
                                        Data_Unit_Mem(3 downto 0),
                                        Data_Unit_Mem(7 downto 4),
                                        Data_Mem_Unit,
                                        ce1s,
                                        ce25M,
                                        AN1,
                                        AN2,
                                        AN3,
                                        AN4,
                                        Sevenseg,
                                        LED,
                                        LEDg);                

  Peripherique_PC : interface_PC port map (clk25M,
                                           Reset,
                                           valid_saisie,
                                           pdb,
                                           astb,
                                           dstb,
                                           pwr,
                                           pwait,
                                           val_PC_in1,
                                           val_PC_in2,
                                           Data_Unit_Mem,
                                           Adr,
                                           W_Mem,
                                           ldg);                                                                                                                                                                                 

end Behavioral;

