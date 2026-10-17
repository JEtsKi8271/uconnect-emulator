package com.harman.navigation.Controller.GeoCoordinate.util
{
   public interface IGeoFormat
   {
      
      function get formatID() : int;
      
      function importGeoEntry(param1:String, param2:String) : void;
      
      function get currentEntry() : String;
      
      function setCoordinateType(param1:int) : void;
      
      function get coordinateType() : int;
      
      function setCursorPosition(param1:int) : void;
      
      function get cursorPosition() : int;
      
      function get maxCursorPosition() : int;
      
      function get availableCharacters() : String;
      
      function enterCharacter(param1:String) : void;
      
      function checkIsValid() : Boolean;
      
      function getDetails() : void;
      
      function get latitudeAsDD() : String;
      
      function get longitudeAsDD() : String;
   }
}

