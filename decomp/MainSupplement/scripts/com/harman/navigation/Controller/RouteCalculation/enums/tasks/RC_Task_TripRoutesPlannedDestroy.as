package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_TripRoutesPlannedDestroy extends RC_Task
   {
      
      public function RC_Task_TripRoutesPlannedDestroy()
      {
         super(RC_Task.TRIP_PLANNED_DESTROY_ALL);
      }
      
      override public function processTask() : void
      {
         var arrRoutes:Array = null;
         var j:int = 0;
         var routeHandleList:String = "";
         var arrTrips:Array = super.routeCalculationMgr.tripRouteHandler.tripRoutes;
         for(var i:int = 0; i < arrTrips.length; i++)
         {
            arrRoutes = TripRoute(arrTrips[i]).routes;
            if(arrRoutes == null || Boolean(arrRoutes.length))
            {
               TripRoute(arrTrips[i]).markRoutesOnValidRouteHandleForDestruction(true);
            }
            for(j = 0; j < arrRoutes.length; j++)
            {
               if(Route(arrRoutes[j]).routeHandle == -1)
               {
                  Route(arrRoutes[j]).setDeleteRouteOnValidRouteHandleAvailable(true);
               }
               else
               {
                  if(routeHandleList.length > 0)
                  {
                     routeHandleList += ",";
                  }
                  routeHandleList += Route(arrRoutes[j]).routeHandle;
               }
            }
         }
         if(routeHandleList.length > 0)
         {
            NavigationPackage.peripheral.navigation.navigation.rgDestroyRoutesForRouteHandles(routeHandleList);
         }
         else
         {
            super.routeCalculationMgr.taskHandler.reportTaskCompletion(super.taskType);
         }
      }
   }
}

