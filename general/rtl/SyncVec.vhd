----------------------------------------------------------------------------------------------------
-- @brief Sync Vector
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date January 2023
-- 
-- @version v0.1
--
-- @file Sync.vhd
--
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.StdRtlPkg.all;

entity SyncVec is
   generic (
      TPD_G    : time    := 1 ns;
      WIDTH_G  : natural := 4;
      STAGES_G : natural := 2
   );
   port (
      clk_i : in  sl;
      rst_i : in  sl;
      sig_i : in  slv(WIDTH_G - 1 downto 0);
      sig_o : out slv(WIDTH_G - 1 downto 0)
   );
end SyncVec;

architecture rtl of SyncVec is

begin

   GEN_SYNC_VEC : for I in 0 to WIDTH_G - 1 generate
      ux_Sync : entity work.Sync
         generic map (
            TPD_G    => TPD_G,
            STAGES_G => STAGES_G
         )
         port map (
            clk_i => clk_i,
            rst_i => rst_i,
            sig_i => sig_i(I),
            sig_o => sig_o(I)
         );
   end generate GEN_SYNC_VEC;

end architecture rtl;
