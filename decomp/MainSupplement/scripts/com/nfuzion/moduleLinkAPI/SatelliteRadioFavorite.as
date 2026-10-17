package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioFavorite
   {
      
      public static const VISUAL_ONLY:String = "visual";
      
      public static const AUDIO_VISUAL:String = "audio";
      
      public static const ALERT_OFF:String = "off";
      
      public static const ARTIST:String = "artist";
      
      public static const SONG:String = "song";
      
      public static const NONE:String = "none";
      
      public var type:String;
      
      public var song:String;
      
      public var artist:String;
      
      public var id:uint;
      
      public function SatelliteRadioFavorite()
      {
         super();
      }
   }
}

