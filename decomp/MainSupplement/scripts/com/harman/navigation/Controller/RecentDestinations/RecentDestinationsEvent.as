package com.harman.navigation.Controller.RecentDestinations
{
   import flash.events.Event;
   
   public class RecentDestinationsEvent extends Event
   {
      
      public static const RD_BUSY:String = "RD_Busy";
      
      public static const RD_DESTINATIONS_CHANGED:String = "RD_DestinationsChanged";
      
      public function RecentDestinationsEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

