package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_TripDestroy extends RC_Task
   {
      
      public function RC_Task_TripDestroy(routeHandle:int)
      {
         super(RC_Task.TRIP_DESTROY,Object(routeHandle));
      }
      
      override public function processTask() : void
      {
         NavigationPackage.peripheral.navigation.navigation.rgDestroyRoutesForRouteHandles(String(int(payLoad)));
      }
   }
}

