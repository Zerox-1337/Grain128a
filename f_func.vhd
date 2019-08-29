----------------------------------------------------------------------------------
-- Company: 
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: fFunc - Behavioral
-- Project Name: Cryptography 
-- Description: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fFunc is
  Port ( 
    iFfuncLfsr   : in STD_LOGIC_vector(5 downto 0);
    iFfuncYbit  : in STD_LOGIC; -- Only used intial phase 
    iFfuncAttack : in STD_LOGIC;
    oFfuncF   : out STD_LOGIC
    );
end fFunc;

architecture Behavioral of fFunc is

begin
    process(iFfuncLfsr, iFfuncYbit, iFfuncAttack)
        variable fRes : STD_LOGIC;
        begin
            fRes := iFfuncLfsr(0) xor iFfuncLfsr(1) xor iFfuncLfsr(2) xor iFfuncLfsr(3) xor iFfuncLfsr(4) xor iFfuncLfsr(5);
            if iFfuncAttack= '0' then
                oFfuncF <= fRes;
            else
                oFfuncF <= fRes  xor  iFfuncYbit;
            end if;
    end process;
end Behavioral;

-- To compare with the formulas. 

-- Feedback function: f(x) = 1 + x^32 + x^47 + x^58 + x^90 + x^121 + x^128. 
-- num = [32, 47, 58, 90, 121, 128]. 
-- Constant in formula below N (parallisation) = 1: (num - 1).
-- Constant in formula below N = 32: ((num-1) - 31). 



--        iFfuncLfsr(0)  => graintopLfsrFeedback(k),  -- IV or current reg values goes here. 
--        iFfuncLfsr(1)  => graintopLfsrFeedback(15 + k), -- Comes from grain. (Grain is controlled by controller)
--        iFfuncLfsr(2)  => graintopLfsrFeedback(26 + k), 
--        iFfuncLfsr(3)  => graintopLfsrFeedback(58 + k),
--        iFfuncLfsr(4)  => graintopLfsrFeedback(89 + k),
--        iFfuncLfsr(5)  => graintopLfsrFeedback(96 + k),
--        iFfuncYbit     => graintopYFeedback(k), -- Set by the process enter initial state of grain. 
--        iFfuncAttack   => i_graintopAttack, -- Set by the process enter initial state of grain.  
--        oFfuncF        => graintopLfsr_newval(k) 