package com.harman.navigation.Controller.Trips
{
   import flash.events.Event;
   
   public class TripsEvent extends Event
   {
      
      public static const TRIPS_BUSY:String = "TRIPS_Busy";
      
      public static const TRIPS_UPDATED:String = "TRIPS_Updated";
      
      public static const TRIPS_IMPORT_EXPORT_IN_PROGRESS:String = "TRIPS_Import_Export_In_Progress";
      
      public function TripsEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

