package com.harman.navigation.Controller.MAP.enums
{
   import com.nfuzion.framework.global.Framework;
   
   public class MapViewPort
   {
      
      public static var HALF_MAP:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"210,50",
         "MVR":"430,230",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"265,122",
         "MVR":"535,265",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public static var FULL_MAP:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"1,1",
         "MVR":"640,333",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"1,1",
         "MVR":"800,420",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public static var FULL_SCROLLING:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"1,1",
         "MVR":"643,360",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"1,1",
         "MVR":"800,420",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public static var FULL_SHOW_TURN:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"1,1",
         "MVR":"640,340",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"1,1",
         "MVR":"800,425",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public static var MEDIA_MAP:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"1,1",
         "MVR":"640,333",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"1,1",
         "MVR":"800,416",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public static var WEATHER_MAP:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"1,1",
         "MVR":"640,370",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"1,1",
         "MVR":"800,370",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public static var FULL_TMC_EVENT:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"1,1",
         "MVR":"640,373",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"1,1",
         "MVR":"800,466",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public static var GARAGE:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"0,0",
         "MVR":"0,0",
         "MP":"1,41",
         "MR":"200,200"
      } : {
         "MVP":"0,0",
         "MVR":"0,0",
         "MP":"1,51",
         "MR":"250,250"
      };
      
      public static var OVERVIEW_MAP:Object = Framework.resolution == Framework.RES_640_480 ? {
         "MVP":"50,50",
         "MVR":"550,255",
         "MP":"1,41",
         "MR":"640,333"
      } : {
         "MVP":"1,1",
         "MVR":"800,420",
         "MP":"1,51",
         "MR":"800,416"
      };
      
      public function MapViewPort()
      {
         super();
      }
   }
}

