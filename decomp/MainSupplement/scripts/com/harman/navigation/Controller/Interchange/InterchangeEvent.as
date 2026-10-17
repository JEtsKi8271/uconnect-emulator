package com.harman.navigation.Controller.Interchange
{
   import flash.events.Event;
   
   public class InterchangeEvent extends Event
   {
      
      public static const IC_SCREEN_UPDATE:String = "IC_Screen_Update";
      
      public function InterchangeEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

