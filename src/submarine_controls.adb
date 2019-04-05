package body Submarine_Controls with SPARK_Mode is


   
   function isAtLeastOneAirlockLocked (innerAirlockState : AirlockState; 
                                       outerAirlockState : AirlockState) 
                                       return AirlockState is
   begin
      if innerAirlockState = True or outerAirlockState = True then      
        return True;
      end if;
      return False;              
   end isAtLeastOneAirlockLocked;
   
   procedure closeInnerAirlock is      
   begin
      innerAirlockState := True;      
   end closeInnerAirlock;
   
   procedure closeOuterAirlock is      
   begin
      outerAirlockState := True;    
   end closeOuterAirlock;
   
   
   
   
   function canOperateSubmarine (innerAirlockState : AirlockState; 
                                 outerAirlockState : AirlockState) 
                                 return AirlockState is
   begin
      if innerAirlockState = True and outerAirlockState = True then      
        return True;
      end if;
      return False;  
   end canOperateSubmarine;
   
   function isOxygenLevelSafe(Oxygen : Integer) return Boolean is
   begin
      if Oxygen > 0 then
           return True;
      end if;
      return False;
   end isOxygenLevelSafe;
   



end Submarine_Controls;
