package com.harman.navigation.Controller.MAP.enums
{
   import com.nfuzion.framework.global.Framework;
   
   public class CpmPosition
   {
      
      public static const FULL_NORTH_UP_IN_ROUTE:String = Framework.resolution == Framework.RES_800_600 ? "400,213" : "320,170";
      
      public static const FULL_NORTH_UP_NO_ROUTE:String = Framework.resolution == Framework.RES_800_600 ? "400,188" : "320,150";
      
      public static const FULL_HEADING_UP:String = Framework.resolution == Framework.RES_800_600 ? "400,306" : "320,245";
      
      public static const FULL_HIGHWAY_NORTH_UP_IN_ROUTE:String = Framework.resolution == Framework.RES_800_600 ? "281,213" : "225,170";
      
      public static const FULL_HIGHWAY_NORTH_UP_NO_ROUTE:String = Framework.resolution == Framework.RES_800_600 ? "281,188" : "225,150";
      
      public static const FULL_HIGHWAY_HEADING_UP:String = Framework.resolution == Framework.RES_800_600 ? "281,306" : "225,245";
      
      public static const HALF_NORTH_UP:String = Framework.resolution == Framework.RES_800_600 ? "531,244" : "425,195";
      
      public static const HALF_HEADING_UP:String = Framework.resolution == Framework.RES_800_600 ? "531,325" : "425,260";
      
      public static const MEDIA_NORTH_UP:String = Framework.resolution == Framework.RES_800_600 ? "463,213" : "370,170";
      
      public static const MEDIA_HEADING_UP:String = Framework.resolution == Framework.RES_800_600 ? "463,310" : "370,248";
      
      public function CpmPosition()
      {
         super();
      }
      
      public function getCpmPositionForConfiguration(config:int) : String
      {
         return "";
      }
   }
}

