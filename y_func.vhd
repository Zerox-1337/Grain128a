----------------------------------------------------------------------------------
-- Company: 
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: yFunc - Behavioral
-- Project Name: Cryptography 
-- Description: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
entity yFunc is
  Port ( 
    iYfuncNfsr : in STD_LOGIC_vector(8 downto 0);
    iYfuncLfsr : in STD_LOGIC_vector(7 downto 0);
    oYfuncYbit : out STD_LOGIC
    );
end yFunc;
----------------------------------------------------------------------------------
architecture Behavioral of yFunc is
----------------------------------------------------------------------------------
begin
    process(iYfuncNfsr, iYfuncLfsr)
        begin
            oYfuncYbit <= (iYfuncNfsr(0) and iYfuncLfsr(0)) xor (iYfuncLfsr(1) and iYfuncLfsr(2)) xor 
                (iYfuncNfsr(1) and iYfuncLfsr(3)) xor (iYfuncLfsr(4) and iYfuncLfsr(5)) xor 
                (iYfuncNfsr(0) and iYfuncNfsr(1) and iYfuncLfsr(6)) xor -- This is the h function (to the left and up)
                iYfuncLfsr(7) xor iYfuncNfsr(2) xor iYfuncNfsr(3) xor iYfuncNfsr(4) xor iYfuncNfsr(5) xor 
                iYfuncNfsr(6) xor iYfuncNfsr(7) xor iYfuncNfsr(8) -- This is the y function in papper.
               
                
                
                
                ;
    end process;
----------------------------------------------------------------------------------
end Behavioral;

-- bit index k = 31 in N (parallell) = 32 is bit index k = 0 in N = 1. 

-- N = 32. k 0 to 31

-- Constants are calculated = 127 - 31 - num 

--      iYfuncNfsr(0)  => graintopNfsrFeedback(84 + k),  -- IV/Key or current reg values goes here
--      iYfuncNfsr(1)  => graintopNfsrFeedback(1 + k),                                        
--      iYfuncNfsr(2)  => graintopNfsrFeedback(94 + k),                                        
--      iYfuncNfsr(3)  => graintopNfsrFeedback(81 + k),                                        
--      iYfuncNfsr(4)  => graintopNfsrFeedback(60 + k),                                        
--      iYfuncNfsr(5)  => graintopNfsrFeedback(51 + k),                                        
--      iYfuncNfsr(6)  => graintopNfsrFeedback(32 + k),                                        
--      iYfuncNfsr(7)  => graintopNfsrFeedback(23 + k),                                        
--      iYfuncNfsr(8)  => graintopNfsrFeedback(7 + k),
--      iYfuncLfsr(0)  => graintopLfsrFeedback(88 + k),    
--      iYfuncLfsr(1)  => graintopLfsrFeedback(83 + k),    
--      iYfuncLfsr(2)  => graintopLfsrFeedback(76 + k),    
--      iYfuncLfsr(3)  => graintopLfsrFeedback(54 + k),    
--      iYfuncLfsr(4)  => graintopLfsrFeedback(36 + k),    
--      iYfuncLfsr(5)  => graintopLfsrFeedback(17 + k),    
--      iYfuncLfsr(6)  => graintopLfsrFeedback(2 + k),    
--      iYfuncLfsr(7)  => graintopLfsrFeedback(3 + k), 
