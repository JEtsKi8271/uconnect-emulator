package com.nfuzion.moduleLinkAPI
{
   public class MediaPlayerDevice
   {
      
      public static const BLUETOOTH:String = "btsa";
      
      public static const OTHER:String = "other";
      
      public static const AUX:String = "aux";
      
      public static const IPOD:String = "ipod";
      
      public static const USB:String = "usb";
      
      public static const PFS:String = "PlaysForSure";
      
      public static const SDCARD:String = "sdcard";
      
      public var id:int;
      
      public var name:String;
      
      public var type:String;
      
      public var available:Boolean;
      
      public var syncState:int;
      
      public var readyToBrowse:Boolean;
      
      public var autoplayOff:int;
      
      public function MediaPlayerDevice()
      {
         super();
      }
   }
}

