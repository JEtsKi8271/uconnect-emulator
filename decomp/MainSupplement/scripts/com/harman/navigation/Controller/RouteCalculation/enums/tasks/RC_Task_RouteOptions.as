package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_RouteOptions extends RC_Task
   {
      
      public function RC_Task_RouteOptions(routeHandle:int)
      {
         super(RC_Task.ROUTE_OPTIONS,Object(routeHandle));
      }
      
      override public function processTask() : void
      {
         NavigationPackage.peripheral.navigation.navigation.rgRequestRouteOptionsForRouteHandle(int(super.payLoad));
      }
   }
}

