package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_StartGuidance extends RC_Task
   {
      
      public function RC_Task_StartGuidance(routeHandle:int)
      {
         super(RC_Task.GUIDANCE_START,Object(routeHandle));
      }
      
      override public function processTask() : void
      {
         NavigationPackage.peripheral.navigation.navigation.rgStartGuidanceForRouteHandle(int(super.payLoad));
      }
   }
}

