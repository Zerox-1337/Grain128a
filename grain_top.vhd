----------------------------------------------------------------------------------
-- Company: Lund University
-- Create Date: 04/04/2017 12:36:38 PM
-- Design Name: Stream Cipher and Attack
-- Module Name: grain top module - Structural
-- Project Name: Cryptography 
-- Description: 

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------------

  entity grainTop is
    Port ( 
        oGraintopY       : out STD_LOGIC_VECTOR (31 downto 0);
        iGraintopIv      : in STD_LOGIC_VECTOR (95 downto 0);
        iGraintopKey     : in STD_LOGIC_VECTOR (127 downto 0);
        iGraintopAttack  : in STD_LOGIC; -- Used to enter attack mode (init)
        iGraintopStart   : in STD_LOGIC;
        iGraintopReset   : in STD_LOGIC;
        iGraintopClk     : in STD_LOGIC;
        iGraintopNewkey  : in STD_LOGIC -- Resetting IV/KEY
        );
  end grainTop;

----------------------------------------------------------------------------------

architecture structural of grainTop is

----------------------------------------------------------------------------------
  component grain is
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
  end component;

  component fFunc is
    Port ( 
        iFfuncLfsr   : in STD_LOGIC_vector(5 downto 0);
        iFfuncYbit   : in STD_LOGIC; -- Only used intial phase 
        iFfuncAttack : in STD_LOGIC;
        oFfuncF      : out STD_LOGIC
        );
  end component;
  
  component gFunc is
    Port ( 
        iGfuncNfsr   : in STD_LOGIC_vector(28 downto 0);
        iGfuncLfsr   : in STD_LOGIC;
        iGfuncYbit   : in STD_LOGIC; -- Only used intial phase 
        iGfuncAttack : in STD_LOGIC;
        oGfuncG      : out STD_LOGIC
        );
  end component;

  component yFunc is
    Port ( 
        iYfuncNfsr   : in STD_LOGIC_vector(8 downto 0);
        iYfuncLfsr   : in STD_LOGIC_vector(7 downto 0);
        oYfuncYbit   : out STD_LOGIC
        );
  end component;

----------------------------------------------------------------------------------

-- Call it lfsrNewval or something. 
signal graintopLfsrFeedback : STD_LOGIC_vector(127 downto 0); -- Output that goes out from LFSR with all registers values
signal graintopLfsrNewval   : STD_LOGIC_vector(31 downto 0); -- Input to LFSR coming from F's output

signal graintopNfsrFeedback : STD_LOGIC_vector(127 downto 0); 
signal graintopNfsrNewval   : STD_LOGIC_vector(31 downto 0); -- Input to NFSR coming from G's output

signal graintopYFeedback    : STD_LOGIC_vector(31 downto 0); -- Input to F and G containing Y, Used during INIT & ATTACK stage.

signal LOW                 : STD_LOGIC; -- Useful for testing. (Can be removed when project finished)

----------------------------------------------------------------------------------

begin
LOW <= '0';

  grainInst: grain
    Port map ( 
        oGrainLfsrFeedback => graintopLfsrFeedback,
        iGrainLfsrNewval   => graintopLfsrNewval,  
        oGrainNfsrFeedback => graintopNfsrFeedback,
        iGrainNfsrNewval   => graintopNfsrNewval,  
        iGrainIv            => iGraintopIv,           
        iGrainKey           => iGraintopKey,          
        iGrainStart         => iGraintopStart,        
        iGrainReset         => iGraintopReset,        
        iGrainClk           => iGraintopClk,          
        iGrainNewkey        => iGraintopNewkey       
        );                                          

  ffuncResult: for k in 0 to 31 generate -- N = 1 not parallized, N = 32 paralized 32 times
  --ffuncInstFirstbit : if k = 0 generate -- generate for first bit
  ffuncInst : fFunc 
    port map ( 
        iFfuncLfsr(0)  => graintopLfsrFeedback(k),  -- IV or current reg values goes here. 
        iFfuncLfsr(1)  => graintopLfsrFeedback(15 + k), -- Comes from grain. (Grain is controlled by controller)
        iFfuncLfsr(2)  => graintopLfsrFeedback(26 + k), 
        iFfuncLfsr(3)  => graintopLfsrFeedback(58 + k),
        iFfuncLfsr(4)  => graintopLfsrFeedback(89 + k),
        iFfuncLfsr(5)  => graintopLfsrFeedback(96 + k),
        iFfuncYbit     => graintopYFeedback(k), -- Set by the process enter initial state of grain. 
        iFfuncAttack   => iGraintopAttack, -- Set by the process enter initial state of grain.  
        oFfuncF        => graintopLfsrNewval(k) -- Used to Update LFSR
        );
  end generate ffuncResult;

  gfuncResult: for k in 0 to 31 generate
  gfuncInst : gFunc 
    port map ( 
        iGfuncNfsr(0)  => graintopNfsrFeedback(k),  -- Key or current reg values goes here
        iGfuncNfsr(1)  => graintopNfsrFeedback(5 + k),-- Comes from grain. (Grain is controlled by controller)
        iGfuncNfsr(2)  => graintopNfsrFeedback(40 + k),
        iGfuncNfsr(3)  => graintopNfsrFeedback(70 + k),
        iGfuncNfsr(4)  => graintopNfsrFeedback(96 + k),
        iGfuncNfsr(5)  => graintopNfsrFeedback(12 + k),
        iGfuncNfsr(6)  => graintopNfsrFeedback(28 + k),
        iGfuncNfsr(7)  => graintopNfsrFeedback(29 + k),
        iGfuncNfsr(8)  => graintopNfsrFeedback(93 + k),
        iGfuncNfsr(9)  => graintopNfsrFeedback(31 + k),
        iGfuncNfsr(10) => graintopNfsrFeedback(35 + k),
        iGfuncNfsr(11) => graintopNfsrFeedback(37 + k),
        iGfuncNfsr(12) => graintopNfsrFeedback(69 + k),
        iGfuncNfsr(13) => graintopNfsrFeedback(48 + k),
        iGfuncNfsr(14) => graintopNfsrFeedback(56 + k),
        iGfuncNfsr(15) => graintopNfsrFeedback(78 + k),
        iGfuncNfsr(16) => graintopNfsrFeedback(79 + k),
        iGfuncNfsr(17) => graintopNfsrFeedback(83 + k),
        iGfuncNfsr(18) => graintopNfsrFeedback(85 + k),
        iGfuncNfsr(19) => graintopNfsrFeedback(14 + k),
        iGfuncNfsr(20) => graintopNfsrFeedback(18 + k),
        iGfuncNfsr(21) => graintopNfsrFeedback(26 + k),
        iGfuncNfsr(22) => graintopNfsrFeedback(71 + k),
        iGfuncNfsr(23) => graintopNfsrFeedback(72 + k),
        iGfuncNfsr(24) => graintopNfsrFeedback(74 + k),
        iGfuncNfsr(25) => graintopNfsrFeedback(1 + k),
        iGfuncNfsr(26) => graintopNfsrFeedback(3 + k),
        iGfuncNfsr(27) => graintopNfsrFeedback(4 + k),
        iGfuncNfsr(28) => graintopNfsrFeedback(8 + k),
        iGfuncLfsr     => graintopLfsrFeedback(96 + k), 
        iGfuncYbit     => graintopYFeedback(k), -- Set by the process enter initial state of grain. 
        iGfuncAttack   => iGraintopAttack, -- Set by the process enter initial state of grain.  
        oGfuncG        => graintopNfsrNewval(k) -- Used to Update LFSR
        );
  end generate gfuncResult;
  
  yfuncResult: for k in 0 to 31 generate
  yfuncInst : yFunc 
    port map ( 
        iYfuncNfsr(0)  => graintopNfsrFeedback(84 + k),  -- IV/Key or current reg values goes here
        iYfuncNfsr(1)  => graintopNfsrFeedback(1 + k),                                        
        iYfuncNfsr(2)  => graintopNfsrFeedback(94 + k),                                        
        iYfuncNfsr(3)  => graintopNfsrFeedback(81 + k),                                        
        iYfuncNfsr(4)  => graintopNfsrFeedback(60 + k),                                        
        iYfuncNfsr(5)  => graintopNfsrFeedback(51 + k),                                        
        iYfuncNfsr(6)  => graintopNfsrFeedback(32 + k),                                        
        iYfuncNfsr(7)  => graintopNfsrFeedback(23 + k),                                        
        iYfuncNfsr(8)  => graintopNfsrFeedback(7 + k),
        iYfuncLfsr(0)  => graintopLfsrFeedback(88 + k),    
        iYfuncLfsr(1)  => graintopLfsrFeedback(83 + k),    
        iYfuncLfsr(2)  => graintopLfsrFeedback(76 + k),    
        iYfuncLfsr(3)  => graintopLfsrFeedback(54 + k),    
        iYfuncLfsr(4)  => graintopLfsrFeedback(36 + k),    
        iYfuncLfsr(5)  => graintopLfsrFeedback(17 + k),    
        iYfuncLfsr(6)  => graintopLfsrFeedback(2 + k),    
        iYfuncLfsr(7)  => graintopLfsrFeedback(3 + k),    
        oYfuncYbit     => graintopYFeedback(k)
        );
  end generate yfuncResult;  
  
  oGraintopY <= graintopYFeedback; -- Outputs the Y values to the controller
  -- In the attack Y will be used for MDM
  -- When not attack, the controller sends it out to the CPU. 
----------------------------------------------------------------------------------

end structural;
