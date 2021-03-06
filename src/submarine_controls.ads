package Submarine_Controls with SPARK_Mode is

   innerAirlockState : Boolean; --True closed, False open
   outerAirlockState : Boolean; --True closed, False open
   airlockDoorsLocked : Boolean; --True no doors can be opened
--maximum possible level of oxygen, 0 is depleted
   maximumOxygen : constant Integer := 10000; 
--current oxygen level, each operation consumes oxygen
   oxygenLevel : Integer; 
   submarineSubmerged : Boolean; --submarine status
   currentDepth : Integer; 
   --maximum possible depth, 0 is on surface
   maximumDepth : constant Integer := 5000; 
   reactorOverheatThreshold : constant Integer := 12000;
   
   --at least one airlock door closed at all times
   --procedures below ensure that at least one airlock door is closed at all times
   procedure closeInnerAirlock  with
     Global => (In_Out => innerAirlockState, Input => outerAirlockState),
     Pre => outerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = True;
   
   procedure openInnerAirlock  with
     Global => (In_Out => innerAirlockState, 
                Input => (outerAirlockState, airlockDoorsLocked)),
     Pre => airlockDoorsLocked = False and then 
            outerAirlockState = True and then innerAirlockState = True,
     Post => innerAirlockState = False and then outerAirlockState = True;
   
   procedure closeOuterAirlock  with
     Global => (In_Out => outerAirlockState, Input => innerAirlockState),
     Pre => innerAirlockState = True,
     Post => outerAirlockState = True and then innerAirlockState = True;

   procedure openOuterAirlock  with
     Global => (In_Out => outerAirlockState, 
                Input => (innerAirlockState, airlockDoorsLocked)),
     Pre => airlockDoorsLocked = False and then 
            outerAirlockState = True and then innerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = False;
   
   procedure lockAirlockDoors with
     Global => (Input => (innerAirlockState, outerAirlockState), 
                In_Out => airlockDoorsLocked),
     Pre => innerAirlockState = True and then outerAirlockState = True,
     Post => innerAirlockState = True and then outerAirlockState = True 
     and then airlockDoorsLocked = True;
   
   
   
   
   --oxygen is decreased 100 points while the submarine is submerged
   --it can happen only if the airlock is locked and there is still any oxygen left
   --decreasing oxygen below 500 points shows a warning
   procedure decreaseOxygen with
     Global => (Input => (airlockDoorsLocked, submarineSubmerged), In_Out => oxygenLevel),
     Pre => oxygenLevel >= 100 and then 
            airlockDoorsLocked = True and then
            submarineSubmerged = True,
     Post => oxygenLevel >= 0;
   
--     procedure displayOxygenWarning;
   
   procedure checkOxygenAndReactorStatus with 
     Global => (In_Out => (oxygenLevel, currentDepth)),
     Pre =>  oxygenLevel >= 0,
     Post =>  oxygenLevel >= 0;
    
   
   --submerge submarine
   --cannot be done if there is no oxygen left
   --diving or surfacing reduces oxygen
   procedure diveDeeper with
     Global =>(Input =>(airlockDoorsLocked, submarineSubmerged), 
               In_Out => (oxygenLevel, currentDepth )),
     Pre => currentDepth < maximumDepth and then
            oxygenLevel >= 100 and then 
            airlockDoorsLocked = True and then
            submarineSubmerged = True,
     Post => 
       currentDepth <= maximumDepth and then 
       currentDepth >= 0 and then
       oxygenLevel >= 0;

   
end Submarine_Controls;
