----------------------------------------------------------------------------------------------------
-- @brief Sync
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

entity Sync is
   generic (
      TPD_G    : time    := 1 ns;
      STAGES_G : natural := 2
   );
   port (
      clk_i : in  sl;
      rst_i : in  sl;
      sig_i : in  sl;
      sig_o : out sl
   );
end Sync;

architecture rtl of Sync is

begin

   GEN_ASYNC : if (STAGES_G = 0) generate
      -- Output not synchronized!
      sig_o <= sig_i after TPD_G;
   end generate GEN_ASYNC;

   GEN_SYNC_ONE : if (STAGES_G = 1) generate
      signal dff : sl;
   begin
      p_Sync : process(clk_i)
      begin
         if (rising_edge(clk_i)) then
            if (rst_i = '1') then
               -- Sync reset
               dff <= '0' after TPD_G;
            else
               dff <= sig_i after TPD_G;
            end if;
         end if;
      end process p_Sync;
      -- Synchronized output
      sig_o <= dff;
   end generate GEN_SYNC_ONE;

   GEN_SYNC : if (STAGES_G > 1) generate
      signal dff                 : slv(STAGES_G - 1 downto 0);
      attribute ASYNC_REG        : string;
      attribute ASYNC_REG of dff : signal is "TRUE";

   begin

      p_Sync : process(clk_i)
      begin
         if (rising_edge(clk_i)) then
            if (rst_i = '1') then
               dff <= (others => '0') after TPD_G;
            else
               dff <= dff(STAGES_G - 2 downto 0) & sig_i after TPD_G;
            end if;
         end if;
      end process p_Sync;

      sig_o <= dff(dff'left);

   end generate GEN_SYNC;

end architecture rtl;
