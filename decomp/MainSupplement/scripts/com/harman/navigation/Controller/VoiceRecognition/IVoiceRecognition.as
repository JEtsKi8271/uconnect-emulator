package com.harman.navigation.Controller.VoiceRecognition
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVoiceRecognition extends IModule
   {
      
      function getCurrentVoiceRecEntry() : void;
      
      function get currentVoiceRecEntry() : String;
      
      function repeatNavPrompt() : void;
      
      function indicateNewDestinationEntrySessionForDefaultCountryRecovery() : void;
   }
}

