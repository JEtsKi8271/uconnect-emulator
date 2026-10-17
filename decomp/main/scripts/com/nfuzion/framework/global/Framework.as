package com.nfuzion.framework.global
{
   import core.api.IAutoAssigner;
   import core.api.IFocusManager;
   import core.api.IKeyboards;
   import core.api.IMapping;
   import core.api.IMessenger;
   import core.api.IPopupManager;
   import core.api.IStructure;
   import core.api.IThemeEngine;
   import core.api.ScreenModel;
   
   public class Framework
   {
      
      public static var themeEngine:IThemeEngine;
      
      public static const RES_800_480:String = "800x480";
      
      public static const RES_640_480:String = "640x480";
      
      public static const RES_800_600:String = "800x600";
      
      public static const RES_1024_768:String = "1024x768";
      
      public static var resolution:String = "640x480";
      
      public static var autoAssigner:IAutoAssigner = null;
      
      public static var focusManager:IFocusManager = null;
      
      public static var keyboards:IKeyboards = null;
      
      public static var mapping:IMapping = null;
      
      public static var messenger:IMessenger = null;
      
      public static var popupManager:IPopupManager = null;
      
      public static var screens:ScreenModel = null;
      
      public static var structure:IStructure = null;
      
      public static var enableTrace:Boolean = false;
      
      public static var enableCatch:Boolean = true;
      
      public static var enableInsight:Boolean = false;
      
      public function Framework()
      {
         super();
      }
      
      public static function Trace(param1:String) : void
      {
         if(enableTrace)
         {
            trace(param1);
         }
      }
      
      public static function echo(param1:String) : void
      {
         var _loc2_:Date = new Date();
         trace(_loc2_.minutes.toString() + ":" + _loc2_.seconds.toString() + ":" + _loc2_.milliseconds.toString() + "  " + param1);
      }
   }
}

