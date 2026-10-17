package com.nfuzion.moduleLinkAPI
{
   public interface ISpellerManager extends IModule
   {
      
      function initializePinYin() : void;
      
      function deinitializePinYin() : void;
      
      function getChineseWords(param1:String, param2:String, param3:int) : void;
      
      function getFeedbackWords(param1:String, param2:String, param3:int) : void;
      
      function setRecognizeRange(param1:int) : void;
      
      function recognize(param1:String) : void;
      
      function setSavedWords(param1:String) : void;
      
      function getSavedWords() : void;
      
      function get savedWords() : String;
   }
}

