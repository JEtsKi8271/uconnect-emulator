package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_TripChange extends RC_Task
   {
      
      public function RC_Task_TripChange(routeHandle:int, alternativeInterchange:String)
      {
         var obj:Object = new Object();
         obj["RTH"] = routeHandle;
         obj["AIC"] = alternativeInterchange;
         super(RC_Task.TRIP_CHANGE,obj);
      }
      
      override public function processTask() : void
      {
         var tmp:Array = new Array();
         tmp.push(super.payLoad["AIC"]);
         NavigationPackage.peripheral.navigation.navigation.rgChangeTrip(int(super.payLoad["RTH"]),tmp);
      }
   }
}

