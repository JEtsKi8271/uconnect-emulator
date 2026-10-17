package com.harman.navigation.Controller.VoiceRecognition
{
   import flash.events.EventDispatcher;
   
   public class VoiceRecognitionImpl extends EventDispatcher
   {
      
      private static var mVoiceRecInstance:VoiceRecognitionController;
      
      public function VoiceRecognitionImpl()
      {
         super();
      }
      
      public static function create() : VoiceRecognitionController
      {
         if(mVoiceRecInstance == null)
         {
            return mVoiceRecInstance = new VoiceRecognitionController();
         }
         return mVoiceRecInstance;
      }
      
      public static function get instance() : VoiceRecognitionController
      {
         return mVoiceRecInstance;
      }
      
      public static function erase() : void
      {
         mVoiceRecInstance = null;
      }
   }
}

