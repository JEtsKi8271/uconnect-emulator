package com.harman.navigation.Controller.VoiceRecognition
{
   import flash.events.Event;
   
   public class VoiceRecognitionNavEvent extends Event
   {
      
      public static const VR_CURRENT_ENTRY:String = "VR_CurrentEntry";
      
      public function VoiceRecognitionNavEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

