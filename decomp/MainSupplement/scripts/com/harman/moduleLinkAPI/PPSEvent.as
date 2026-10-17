package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class PPSEvent extends Event
   {
      
      public static const PPS_BUSY:String = "PPS_busy";
      
      public static const PPS_NAV_MARKET_CONFIG:String = "PPS_NavMarketConfig";
      
      public static const PPS_ECU_PART_NUM:String = "PPS_ECU_Part_Num";
      
      public function PPSEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

