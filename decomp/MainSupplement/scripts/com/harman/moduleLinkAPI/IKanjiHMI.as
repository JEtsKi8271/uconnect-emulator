package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IKanjiHMI extends IModule
   {
      
      function sendHiraCharacter(param1:String) : void;
      
      function hiraConvert() : void;
      
      function FocusAllAndConvert() : void;
      
      function kanjiCandidateList() : void;
      
      function kanjiCandidateSelect(param1:int) : void;
      
      function hiraBackspace() : void;
      
      function hiraCancelAll() : void;
      
      function hiraDeleteAll() : void;
      
      function ModifyChar(param1:String) : void;
      
      function SetInputMax(param1:int) : void;
      
      function CursorRight() : void;
      
      function CursorLeft() : void;
      
      function get kanjiCandidateCount() : int;
      
      function get kanjiCandidateArray() : Object;
      
      function get kanjiConverting() : String;
      
      function get kanjiPreConverting() : String;
      
      function setkanjiCandidateArray(param1:Object) : void;
   }
}

