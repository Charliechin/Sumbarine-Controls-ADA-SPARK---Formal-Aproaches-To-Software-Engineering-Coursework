package Submarine_Controls with SPARK_Mode is

   innerAirlockState : Boolean; --True closed, False open
   outerAirlockState : Boolean; --True closed, False open
   airlockDoorsLocked : Boolean; --True no doors can be opened
   maximumOxygen : Integer := 10000; --maximum possible level of oxygen
   oxygenLevel : Integer; --current oxygen level
   submarineSubmerged : Boolean; --submarine status
   
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
   
   
   
   function canOperateSubmarine (innerAirlockState : in Boolean; 
                                 outerAirlockState : in Boolean) 
                                 return Boolean with
     Pre => innerAirlockState = True and outerAirlockState = True,
     Post => canOperateSubmarine'Result = True or canOperateSubmarine'Result = False;
   
   
end Submarine_Controls;
