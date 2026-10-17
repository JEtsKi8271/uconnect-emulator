package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class SpellerEvent extends Event
   {
      
      public static const RETRIEVE_CHARACTER:String = "RetrieveCharacter";
      
      public static const FEEDBACK_WORD:String = "FeedbackSelectedWord";
      
      public static const SAVED_WORD:String = "SavedWord";
      
      public static const RECOGNIZE_RANGE:String = "RecognizeRange";
      
      public static const RECOGNIZE:String = "Recognize";
      
      public static const ON_RECOG_RANGE:String = "onRecogRange";
      
      public static const ON_RECOGNITION_RESULT:String = "onRecognitionResult";
      
      private var mData:Object;
      
      public function SpellerEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      public function get data() : Object
      {
         return this.mData;
      }
   }
}

