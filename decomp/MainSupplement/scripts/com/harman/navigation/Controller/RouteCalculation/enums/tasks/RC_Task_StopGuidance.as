package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_StopGuidance extends RC_Task
   {
      
      public function RC_Task_StopGuidance()
      {
         super(RC_Task.GUIDANCE_STOP);
      }
      
      override public function processTask() : void
      {
         NavigationPackage.peripheral.navigation.navigation.rgStopGuidance();
      }
   }
}

