package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_BlockRouteAhead extends RC_Task
   {
      
      public function RC_Task_BlockRouteAhead(routeHandle:int, distance:int)
      {
         var obj:Object = new Object();
         obj["rth"] = routeHandle;
         obj["dist"] = distance;
         super(RC_Task.BLOCK_ROUTE_AHEAD,obj);
      }
      
      override public function processTask() : void
      {
         if(routeCalculationMgr.activeRoute == null || routeCalculationMgr.activeRoute.routeHandle != int(super.payLoad["rth"]))
         {
            routeCalculationMgr.taskHandler.reportTaskCompletion(this.taskType);
         }
         else
         {
            NavigationPackage.peripheral.navigation.navigation.rgBlockRouteAhead(int(super.payLoad["rth"]),int(super.payLoad["dist"]));
         }
      }
   }
}

