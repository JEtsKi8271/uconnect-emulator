package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_BlockRouteSegment extends RC_Task
   {
      
      public function RC_Task_BlockRouteSegment(data:Object)
      {
         super(RC_Task.BLOCK_ROUTE_SEGMENT,Object(data));
      }
      
      override public function processTask() : void
      {
         NavigationPackage.peripheral.navigation.navigation.rgBlockRouteSegment(int(super.payLoad["routeHandle"]),int(super.payLoad["routeElement"]),int(super.payLoad["routeSegment"]));
      }
   }
}

