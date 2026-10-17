package com.harman.navigation.Controller.VoiceRecognition
{
   import com.harman.navigation.NavigationNamespace;
   
   use namespace NavigationNamespace;
   
   public class VoiceRecognitionApi
   {
      
      NavigationNamespace static var impl:IVoiceRecognition;
      
      public function VoiceRecognitionApi()
      {
         super();
      }
      
      public static function get api() : IVoiceRecognition
      {
         return impl;
      }
   }
}

