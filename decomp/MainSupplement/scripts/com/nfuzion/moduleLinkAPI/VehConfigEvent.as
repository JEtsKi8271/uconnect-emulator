package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class VehConfigEvent extends Event
   {
      
      public static const AVAILABLE:String = "Available";
      
      public static const VARIANT_MARKET:String = "variantMarket";
      
      public var mData:Object = null;
      
      public function VehConfigEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

