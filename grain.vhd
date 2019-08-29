----------------------------------------------------------------------------------
-- Company: Lund University
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: grain - behavioral
-- Project Name: Cryptography 
-- Description: 

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------------

  entity grain is
    Port ( 
        oGrainLfsrFeedback : out STD_LOGIC_vector(127 downto 0); 
        iGrainLfsrNewval   : in STD_LOGIC_vector(31 downto 0); -- Input coming from F's output
        oGrainNfsrFeedback : out STD_LOGIC_vector(127 downto 0);                                  
        iGrainNfsrNewval   : in STD_LOGIC_vector(31 downto 0); -- Input coming from F's output  
        iGrainIv            : in STD_LOGIC_VECTOR (95 downto 0);                    
        iGrainKey           : in STD_LOGIC_VECTOR (127 downto 0);                  
        iGrainStart         : in STD_LOGIC;                                         
        iGrainReset         : in STD_LOGIC;   
        iGrainClk           : in STD_LOGIC;                                      
        iGrainNewkey        : in STD_LOGIC
        );  
  end grain;

----------------------------------------------------------------------------------

architecture behavioral of grain is

----------------------------------------------------------------------------------



-- Call it lfsrNewval or something. 
signal grainLfsrReg        : STD_LOGIC_vector(127 downto 0);
signal grainLfsrNext       : STD_LOGIC_vector(127 downto 0);
signal grainNfsrReg        : STD_LOGIC_vector(127 downto 0);
signal grainNfsrNext       : STD_LOGIC_vector(127 downto 0);

----------------------------------------------------------------------------------

begin
----------------------------------------------------------------------------------
  seq: process(iGrainClk,iGrainReset)
    begin
        if (iGrainReset = '1') then
            grainNfsrReg <= (others=>'0');
            grainLfsrReg <= (others=>'0');
        elsif (rising_edge(iGrainClk)) then
            grainNfsrReg <= grainNfsrNext;
            grainLfsrReg <= grainLfsrNext;
        end if;
  end process;        

----------------------------------------------------------------------------------
  comb: process(iGrainIv, iGrainKey, iGrainStart, 
                iGrainReset, iGrainNewkey, grainLfsrReg, grainNfsrReg, 
                iGrainLfsrNewval, iGrainNfsrNewval)  
    begin
        if (iGrainStart = '1') then -- Circuit on
            if (iGrainNewkey = '1') then -- When we get a new key. 
                oGrainLfsrFeedback <= iGrainIv & "11111111111111111111111111111110"; -- Send IV into feedback
                oGrainNfsrFeedback <= iGrainKey; -- Send key into the feedback.
                --oGrainLfsr_outbit <= iGrainIv(95 downto 64); -- Feedback to nfsr
                
                grainLfsrNext <= iGrainIv(63 downto 0) & "11111111111111111111111111111110" & iGrainLfsrNewval; -- The 32 bits used in lfsr_outbit gets shifted out for the new values. 
                grainNfsrNext <= iGrainKey(95 downto 0) & iGrainNfsrNewval; -- Updates the register for the next value
            else -- no new keys
                oGrainLfsrFeedback <= grainLfsrReg; -- Sends out the current values
                oGrainNfsrFeedback <= grainNfsrReg; 
                --oGrainLfsr_outbit <= grainLfsrReg(127 downto 96); -- feedback nfsr
                
                grainLfsrNext  <= grainLfsrReg(95 downto 0) & iGrainLfsrNewval;
                grainNfsrNext  <= grainNfsrReg(95 downto 0) & iGrainNfsrNewval; -- Updates for next values. 
            end if;
        
        else -- Circuit off, reset
            grainLfsrNext <= (others => '0');
            grainNfsrNext <= (others => '0');
            oGrainLfsrFeedback <= (others => '0');
            oGrainNfsrFeedback <= (others => '0');
            --oGrainLfsr_outbit <= (others => '0');
        
        end if;
  
  end process;
----------------------------------------------------------------------------------

end behavioral;
