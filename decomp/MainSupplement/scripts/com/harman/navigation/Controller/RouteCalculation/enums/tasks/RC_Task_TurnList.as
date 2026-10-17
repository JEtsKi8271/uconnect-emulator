package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.global.NavigationPackage;
   
   public class RC_Task_TurnList extends RC_Task
   {
      
      public function RC_Task_TurnList(routeHandle:int)
      {
         super(RC_Task.TURN_LIST,Object(routeHandle));
      }
      
      override public function processTask() : void
      {
         NavigationPackage.peripheral.navigation.navigation.rgRequestTurnListForRouteHandle(int(super.payLoad));
      }
   }
}

