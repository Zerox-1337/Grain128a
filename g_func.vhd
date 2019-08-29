----------------------------------------------------------------------------------
-- Company: 
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: gFunc - Behavioral
-- Project Name: Cryptography 
-- Description: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------

entity gFunc is
  Port ( 
    iGfuncNfsr :in STD_LOGIC_vector(28 downto 0);
    iGfuncLfsr : in STD_LOGIC;
    iGfuncYbit : in STD_LOGIC; -- Only used intial phase 
    iGfuncAttack : in STD_LOGIC;
    oGfuncG : out STD_LOGIC
    );
end gFunc;
----------------------------------------------------------------------------------

architecture Behavioral of gFunc is
----------------------------------------------------------------------------------

begin
    process(iGfuncNfsr, iGfuncLfsr, iGfuncYbit, iGfuncAttack)
        variable gRes : STD_LOGIC;
        begin
            gRes := iGfuncNfsr(0) xor iGfuncNfsr(1) xor iGfuncNfsr(2) xor iGfuncNfsr(3) xor  
            iGfuncNfsr(4) xor (iGfuncNfsr(5) and iGfuncNfsr(6)) xor (iGfuncNfsr(7) and iGfuncNfsr(8)) xor  
            (iGfuncNfsr(9) and iGfuncNfsr(10)) xor (iGfuncNfsr(11) and iGfuncNfsr(12)) xor  
            (iGfuncNfsr(13) and iGfuncNfsr(14)) xor (iGfuncNfsr(15) and iGfuncNfsr(16)) xor  
            (iGfuncNfsr(17) and iGfuncNfsr(18)) xor (iGfuncNfsr(19) and iGfuncNfsr(20) and iGfuncNfsr(21)) xor  
            (iGfuncNfsr(22) and iGfuncNfsr(23) and iGfuncNfsr(24)) xor  
            (iGfuncNfsr(25) and iGfuncNfsr(26) and iGfuncNfsr(27) and iGfuncNfsr(28)) xor iGfuncLfsr;
            if iGfuncAttack = '0' then
                oGfuncG <= gRes;
            else
                oGfuncG <= gRes xor iGfuncYbit;
            end if;
    end process;
    
----------------------------------------------------------------------------------

end Behavioral;

 --       iGfuncNfsr(0)  => graintopNfsrFeedback(k),  -- IV/Key or current reg values goes here
--        iGfuncNfsr(1)  => graintopNfsrFeedback(5 + k),
--        iGfuncNfsr(2)  => graintopNfsrFeedback(40 + k),
--        iGfuncNfsr(3)  => graintopNfsrFeedback(70 + k),
--        iGfuncNfsr(4)  => graintopNfsrFeedback(96 + k),
--        iGfuncNfsr(5)  => graintopNfsrFeedback(12 + k),
--        iGfuncNfsr(6)  => graintopNfsrFeedback(28 + k),
--        iGfuncNfsr(7)  => graintopNfsrFeedback(29 + k),
--        iGfuncNfsr(8)  => graintopNfsrFeedback(93 + k),
--        iGfuncNfsr(9)  => graintopNfsrFeedback(31 + k),
--        iGfuncNfsr(10) => graintopNfsrFeedback(35 + k),
--        iGfuncNfsr(11) => graintopNfsrFeedback(37 + k),
--        iGfuncNfsr(12) => graintopNfsrFeedback(69 + k),
--        iGfuncNfsr(13) => graintopNfsrFeedback(48 + k),
--        iGfuncNfsr(14) => graintopNfsrFeedback(56 + k),
--        iGfuncNfsr(15) => graintopNfsrFeedback(78 + k),
--        iGfuncNfsr(16) => graintopNfsrFeedback(79 + k),
--        iGfuncNfsr(17) => graintopNfsrFeedback(83 + k),
--        iGfuncNfsr(18) => graintopNfsrFeedback(85 + k),
--        iGfuncNfsr(19) => graintopNfsrFeedback(14 + k),
--        iGfuncNfsr(20) => graintopNfsrFeedback(18 + k),
--        iGfuncNfsr(21) => graintopNfsrFeedback(26 + k),
--        iGfuncNfsr(22) => graintopNfsrFeedback(71 + k),
--        iGfuncNfsr(23) => graintopNfsrFeedback(72 + k),
--        iGfuncNfsr(24) => graintopNfsrFeedback(74 + k),
--        iGfuncNfsr(25) => graintopNfsrFeedback(1 + k),
--        iGfuncNfsr(26) => graintopNfsrFeedback(3 + k),
--        iGfuncNfsr(27) => graintopNfsrFeedback(4 + k),
--        iGfuncNfsr(28) => graintopNfsrFeedback(8 + k),
--        iGfuncLfsr     => LOW, --graintopLfsrFeedback(96 + k), -- 96 old
--        iGfuncYbit     => graintopYFeedback(k), -- Set by the process enter initial state of grain. 
--        iGfuncAttack   => iGraintopAttack, -- Set by the process enter initial state of grain.  
--        oGfuncG        => graintopNfsrNewval(k) -- Used to Update LFSR
