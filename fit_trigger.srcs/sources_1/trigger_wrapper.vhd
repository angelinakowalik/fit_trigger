library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package PM12_pkg is
type trig_time is array (0 to 11)  of STD_LOGIC_VECTOR (9 downto 0);
type trig_ampl0 is array (0 to 11) of STD_LOGIC_VECTOR(12 downto 0);
end package; 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library work;
use work.PM12_pkg.all; 

entity trigger_wrapper is
  Port ( clk320 : in STD_LOGIC;   -- main 320 MHz clock;
         mt_cou : in STD_LOGIC_VECTOR (2 downto 0); -- Global state counter (0-7)
         CH_trigt : in STD_LOGIC_VECTOR (11 downto 0); -- Timing information valid for trigger (mt=2)
         CH_triga : in STD_LOGIC_VECTOR (11 downto 0); -- Amplitude information valid for trigger (mt=1)
         CH_trigb : in STD_LOGIC_VECTOR (11 downto 0); -- Amplitude information valid for trigger (mt=1)
         CH_TIME_T : in STD_LOGIC_VECTOR (12*10-1 downto 0); -- Timing information from channels (mt=2), 0 if not to be used in trigger
         CH_ampl0 : in STD_LOGIC_VECTOR (12*13-1 downto 0); -- Amplitude information from channels (mt=2), 0 if not to be used in trigger
         tcm_req : in STD_LOGIC;
         tt  : out STD_LOGIC_VECTOR (1 downto 0); -- trigger data outputs to OLOGIC 
         ta  : out STD_LOGIC_VECTOR (1 downto 0)
          );
end trigger_wrapper;

architecture Behavioral of trigger_wrapper is

component trigger
    Port ( clk320 :     in STD_LOGIC;
           mt_cou :     in STD_LOGIC_VECTOR (2 downto 0);
           CH_trigt :   in STD_LOGIC_VECTOR (11 downto 0);
           CH_triga :   in STD_LOGIC_VECTOR (11 downto 0);
           CH_trigb :   in STD_LOGIC_VECTOR (11 downto 0);
           CH_TIME_T :  in trig_time;
           CH_ampl0 :   in trig_ampl0;
           tcm_req :    in STD_LOGIC;
           tt  :        out STD_LOGIC_VECTOR (1 downto 0); 
           ta  :        out STD_LOGIC_VECTOR (1 downto 0)
            );
end component ;

signal s_CH_TIME_T: trig_time;
signal s_CH_ampl0: trig_ampl0;

begin

trigger_0: trigger port map(
   clk320     => clk320,
   mt_cou     => mt_cou,
   CH_trigt   => CH_trigt,
   CH_triga   => CH_triga,
   CH_trigb   => CH_trigb,
   CH_TIME_T  => s_CH_TIME_T,
   CH_ampl0   => s_CH_ampl0,
   tcm_req    => tcm_req,
   tt         => tt,
   ta         => ta
);

gen_arrays:
for i in 0 to 11 generate
  s_CH_TIME_T(i) <= CH_TIME_T((9+i*(9+1)) downto (i*(9+1)));
  s_CH_ampl0(i)  <= CH_ampl0((12+i*(12+1)) downto (i*(12+1)));
end generate gen_arrays;

end Behavioral;
