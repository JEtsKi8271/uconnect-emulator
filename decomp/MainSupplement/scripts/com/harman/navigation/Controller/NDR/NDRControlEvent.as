package com.harman.navigation.Controller.NDR
{
   import flash.events.Event;
   
   public class NDRControlEvent extends Event
   {
      
      public static const NDR_BUSY:String = "NDR_busy";
      
      public static const NDR_GPS_INFO:String = "NDR_Gps_Info";
      
      public static const NDR_HEADING:String = "NDR_Heading";
      
      public static const NDR_SATELLITE_INFO:String = "NDR_Satellite_Info";
      
      public static const NDR_VEHICLE_SPEED:String = "NDR_Vehicle_Speed";
      
      public static const NDR_TRIP_COMPUTER_DATA:String = "NDR_Trip_Computer_Data";
      
      public static const NAV_LOW_CALIBRATION:String = "Nav_Low_Calibration";
      
      public function NDRControlEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

