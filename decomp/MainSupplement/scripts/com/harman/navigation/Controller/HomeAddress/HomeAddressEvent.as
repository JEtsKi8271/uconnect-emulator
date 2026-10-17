package com.harman.navigation.Controller.HomeAddress
{
   import flash.events.Event;
   
   public class HomeAddressEvent extends Event
   {
      
      public static const HA_HOME_ADDRESS:String = "HA_Home_Address";
      
      public static const HA_HOME_ADDRESS_SET:String = "HA_Home_Address_Set";
      
      public function HomeAddressEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

