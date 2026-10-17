package com.harman.navigation.Controller.GeoCoordinate
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IGeoCoordinate extends IModule
   {
      
      function setCoordinateEntryType(param1:int) : void;
      
      function getCoordinateEntryType() : void;
      
      function get coordinateEntryType() : int;
      
      function getCurrentEntry() : void;
      
      function get currentEntry() : String;
      
      function setFormat(param1:int) : void;
      
      function getFormat() : void;
      
      function get format() : int;
      
      function setCursorPosition(param1:int) : void;
      
      function getCursorPosition() : void;
      
      function get cursorPosition() : int;
      
      function get maxCursorPosition() : int;
      
      function getAvailableCharacters() : void;
      
      function get availableCharacters() : String;
      
      function enterCharacter(param1:String) : void;
      
      function getIsValid() : void;
      
      function get isValid() : Boolean;
      
      function getDetails() : void;
      
      function factoryReset() : void;
   }
}

