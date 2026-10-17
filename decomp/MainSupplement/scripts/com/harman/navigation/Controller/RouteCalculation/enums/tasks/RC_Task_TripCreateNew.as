package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_TripCreateNew extends RC_Task
   {
      
      public function RC_Task_TripCreateNew(tripRoute:TripRoute = null)
      {
         super(RC_Task.TRIP_CREATE_NEW,Object(tripRoute));
      }
      
      override public function processTask() : void
      {
         TripRoute(this.payLoad).setTripID(this.ID);
         super.routeCalculationMgr.tripRouteHandler.addTripRoute(TripRoute(this.payLoad));
         if(TripRoute(this.payLoad).trailPath != "")
         {
            NavigationPackage.peripheral.navigation.navigation.rgCreateNewTrail(TripRoute(this.payLoad).trailPath,TripRoute(this.payLoad).trailMode);
         }
         else
         {
            NavigationPackage.peripheral.navigation.navigation.rgCreateNewTrip(TripRoute(payLoad));
         }
      }
   }
}

