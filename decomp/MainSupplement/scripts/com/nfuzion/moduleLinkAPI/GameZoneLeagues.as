package com.nfuzion.moduleLinkAPI
{
   public class GameZoneLeagues
   {
      
      public var abbrev:String = "";
      
      public var contentDescriptor:uint = 0;
      
      public var name:String = "";
      
      public function GameZoneLeagues()
      {
         super();
      }
      
      public static function isValidLeague(league:String) : Boolean
      {
         return true;
      }
   }
}

