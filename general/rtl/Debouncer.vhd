----------------------------------------------------------------------------------------------------
-- @brief Debouncer
--
-- @author Rene Brglez (rene.brglez@gmail.com)
--
-- @date January 2023
-- 
-- @version v0.1
--
-- @file Debouncer.vhd
--
----------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.StdRtlPkg.all;

entity Debouncer is
   generic (
      TPD_G         : time    := 1 ns;
      DEBOUNCE_CC_G : natural := 10_000
   );
   port (
      clk_i : in  sl;
      rst_i : in  sl;
      sig_i : in  sl;
      sig_o : out sl
   );
end entity Debouncer;

architecture rtl of Debouncer is

   type RegType is record
      cnt    : natural;
      sig    : sl;
      debSig : sl;
   end record RegType;

   constant REG_INIT_C : RegType := (
         cnt    => 0,
         sig    => '0',
         debSig => '0'
      );

   -- Output of registers
   signal r : RegType;

   -- Combinatorial input to registers
   signal rin : RegType;

begin

   p_Comb : process (all) is
      variable v : RegType;
   begin
      v := r;

      v.sig := sig_i;

      if (r.sig = sig_i) then
         -- input signal is "stable"
         if (r.cnt = DEBOUNCE_CC_G - 1) then
            -- input signal was "stable" for  at least 
            -- DEBOUNCE_CC_G clock cycles
            v.debSig := r.sig;
         else
            v.cnt := r.cnt + 1;
         end if;

      elsif(r.sig /= sig_i) then
         -- input signal is "unstable"
         v.cnt := 0;
      end if;

      -- Synchronous Reset
      if (rst_i = '1') then
         v := REG_INIT_C;
      end if;

      rin <= v; -- drive register inputs

      -- drive outputs
      sig_o <= r.debSig;

   end process p_Comb;

   p_Seq : process (clk_i) is
   begin
      if (rising_edge(clk_i)) then
         r <= rin after TPD_G;
      end if;
   end process p_Seq;

end architecture rtl;
