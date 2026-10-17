package com.harman.navigation.Controller.RouteCalculation.enums
{
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculation;
   import com.nfuzion.framework.global.Framework;
   
   public class RC_Task
   {
      
      private static var sRouteCalculationCtrl:RouteCalculation;
      
      public static const UNDEFINED:int = 0;
      
      public static const TRIP_CREATE_NEW:int = 1;
      
      public static const TRIP_CREATE_NEW_TRAIL:int = 2;
      
      public static const TRIP_DESTROY:int = 3;
      
      public static const TRIP_PLANNED_DESTROY_ALL:int = 4;
      
      public static const GUIDANCE_START:int = 5;
      
      public static const ROUTE_ELEMENT_INFO:int = 6;
      
      public static const ROUTE_OPTIONS:int = 7;
      
      public static const TURN_LIST:int = 8;
      
      public static const GUIDANCE_STOP:int = 9;
      
      public static const BLOCK_ROUTE_SEGMENT:int = 10;
      
      public static const PERSIST_ROUTE:int = 11;
      
      public static const BLOCK_ROUTE_AHEAD:int = 12;
      
      public static const TRIP_CHANGE:int = 13;
      
      private static var mNextRequestID:uint = 0;
      
      private var mID:uint = newID;
      
      private var mTaskType:int = 0;
      
      private var mPayLoad:Object = null;
      
      public function RC_Task(taskType:int, payLoad:Object = null)
      {
         super();
         this.mTaskType = taskType;
         this.mPayLoad = payLoad;
      }
      
      private static function get newID() : uint
      {
         if(mNextRequestID > 4294967290)
         {
            mNextRequestID = 0;
         }
         return ++mNextRequestID;
      }
      
      public static function getString(id:int) : String
      {
         switch(id)
         {
            case UNDEFINED:
               return "UNDEFINED";
            case TRIP_CREATE_NEW:
               return "TripCreateNew";
            case TRIP_CREATE_NEW_TRAIL:
               return "TripCreateNewTrail";
            case TRIP_DESTROY:
               return "TripDestroy";
            case TRIP_PLANNED_DESTROY_ALL:
               return "TripPlannedDestroyAll";
            case GUIDANCE_START:
               return "GuidanceStart";
            case ROUTE_ELEMENT_INFO:
               return "RouteElementInfo";
            case ROUTE_OPTIONS:
               return "RouteOptions";
            case TURN_LIST:
               return "TurnList";
            case GUIDANCE_STOP:
               return "GuidanceStop";
            case BLOCK_ROUTE_SEGMENT:
               return "BlockRouteSegment";
            case PERSIST_ROUTE:
               return "PersistRoute";
            case BLOCK_ROUTE_AHEAD:
               return "BlockRouteAhead";
            case TRIP_CHANGE:
               return "ChangeTrip";
            default:
               return "undefined Task";
         }
      }
      
      public static function setRouteCalculationCtrl(ctrl:RouteCalculation) : void
      {
         sRouteCalculationCtrl = ctrl;
      }
      
      public function get ID() : uint
      {
         return this.mID;
      }
      
      public function get taskType() : int
      {
         return this.mTaskType;
      }
      
      public function get payLoad() : Object
      {
         return this.mPayLoad;
      }
      
      protected function get routeCalculationMgr() : RouteCalculation
      {
         return sRouteCalculationCtrl;
      }
      
      public function processTask() : void
      {
         Framework.Trace("RC_Task.processTask() ERROR - No rule to process TaskType \'" + this.mTaskType + "\'");
      }
      
      public function addToTaskHandler() : void
      {
         this.routeCalculationMgr.taskHandler.addTask(this);
      }
      
      public function get myTaskTypeString() : String
      {
         return getString(this.mTaskType);
      }
   }
}

