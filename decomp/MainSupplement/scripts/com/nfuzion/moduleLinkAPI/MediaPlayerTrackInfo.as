package com.nfuzion.moduleLinkAPI
{
   public class MediaPlayerTrackInfo
   {
      
      public static const WILDCARD_UNKNOWN:String = "$unknown$";
      
      public static const WILDCARD_ALL:String = "*all*";
      
      public static const WILDCARD_ALL_ID:int = 0;
      
      public static const WILDCARD_UNKNOWN_ID:int = 1;
      
      public var album:String;
      
      public var artist:String;
      
      public var composer:String;
      
      public var filename:String;
      
      public var genre:String;
      
      public var title:String;
      
      public var year:int;
      
      public var msid:int;
      
      public function MediaPlayerTrackInfo()
      {
         super();
      }
   }
}

