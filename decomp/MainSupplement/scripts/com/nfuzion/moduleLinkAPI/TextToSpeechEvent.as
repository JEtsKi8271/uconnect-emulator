package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class TextToSpeechEvent extends Event
   {
      
      public static const PLAY_STATE:String = "playState";
      
      public static const AVAILABLE_STATE:String = "availableState";
      
      public static const RESULT:String = "result";
      
      public var mData:Object = null;
      
      public function TextToSpeechEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      override public function clone() : Event
      {
         return new TextToSpeechEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("TextToSpeechEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

