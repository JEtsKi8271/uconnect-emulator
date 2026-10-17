package com.harman.navigation.Controller.RouteCalculation
{
   import flash.events.Event;
   
   public class RouteCalculationEvent extends Event
   {
      
      public static const NEW_ROUTE_CALCULATION_STATE:String = "NEW_ROUTE_CalculationState";
      
      public static const NEW_ROUTE_ELEMENT_INFO_UPDATE:String = "NEW_ROUTE_ElementInfoUpate";
      
      public static const NEW_ROUTE_OPTIONS_UPDATE:String = "NEW_ROUTE_OptionsUpdate";
      
      public static const NEW_ROUTE_CALCULATION_FAILED:String = "NEW_ROUTE_CalculationFailed";
      
      public static const NEW_ROUTE_TURNLIST:String = "NEW_ROUTE_Turnlist";
      
      public static const ACTIVE_ROUTE_GUIDANCE_STATE:String = "ACTIVE_ROUTE_GuidanceState";
      
      public static const ACTIVE_ROUTE_CALCULATION_STATE:String = "ACTIVE_ROUTE_CalculationState";
      
      public static const ACTIVE_ROUTE_DESCRIPTION_CHANGE:String = "ACTIVE_ROUTE_Description_Change";
      
      public static const ACTIVE_ROUTE_DESTINATION_REACHED:String = "ACTIVE_ROUTE_Destination_Reached";
      
      public static const ACTIVE_ROUTE_GUIDANCE_INFO:String = "ACTIVE_ROUTE_Guidance_Info";
      
      public static const ACTIVE_ROUTE_GUIDANCE_INFO_ERROR:String = "ACTIVE_ROUTE_Guidance_info_error";
      
      public static const TASK_COMPLETION:String = "Task_Completion";
      
      public static const CHANGE_TRIP_RESPONSE:String = "CHANGE_Trip_Response";
      
      private var mReqId:int = -1;
      
      private var mData:Object = new Object();
      
      public function RouteCalculationEvent(type:String, data:Object = null, reqId:int = -1, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
         this.mReqId = reqId;
      }
      
      public function get reqId() : int
      {
         return this.mReqId;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
      
      public function set data(data:Object) : void
      {
         this.mData = data;
      }
   }
}

