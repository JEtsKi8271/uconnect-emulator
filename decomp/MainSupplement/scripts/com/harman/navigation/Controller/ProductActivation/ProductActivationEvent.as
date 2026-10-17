package com.harman.navigation.Controller.ProductActivation
{
   import flash.events.Event;
   
   public class ProductActivationEvent extends Event
   {
      
      public static const PA_REQUEST_CODE:String = "PA_RequestCode";
      
      public function ProductActivationEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

