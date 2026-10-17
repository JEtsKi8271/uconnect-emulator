package com.harman.navigation.Controller.RouteCalculation.enums.tasks
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   
   public class RC_Task_PersistRoute extends RC_Task
   {
      
      public function RC_Task_PersistRoute(data:Object)
      {
         super(RC_Task.PERSIST_ROUTE,Object(data));
      }
      
      override public function processTask() : void
      {
         var obj:Object = super.payLoad;
         if(obj.isPrototypeOf(Route))
         {
            routeCalculationMgr.guidanceRestarter.persistRoute(Route(obj));
         }
         else
         {
            routeCalculationMgr.guidanceRestarter.persistRoute(Route(obj));
         }
         routeCalculationMgr.taskHandler.reportTaskCompletion(RC_Task.PERSIST_ROUTE);
      }
   }
}

