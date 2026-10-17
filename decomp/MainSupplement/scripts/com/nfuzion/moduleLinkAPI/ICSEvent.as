package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class ICSEvent extends Event
   {
      
      public static const ENCODER:String = "encoder";
      
      public static const SELECT:String = "select";
      
      public static const SELECT_2SEC_PRESS:String = "select_2sec_press";
      
      public static const BACK:String = "back";
      
      public static const BROWSE:String = "browse";
      
      public static const EXIT:String = "exit";
      
      public static const SCREEN_OFF:String = "screenOff";
      
      public static const RADIO:String = "radio";
      
      public static const PLAYER:String = "player";
      
      public static const NAV:String = "nav";
      
      public static const PHONE:String = "phone";
      
      public static const MORE:String = "more";
      
      public static const SETTINGS:String = "settings";
      
      public static const AUDIOONOFF:String = "audioOnOff";
      
      public static const SRT:String = "srt";
      
      public static const SPORT:String = "sport";
      
      public static const DEALER_MODE:String = "dealermode";
      
      public static const ENGINEERING_MODE:String = "engineeringmode";
      
      public static const LAUNCH:String = "ICS_launch_hardbtn_status_press";
      
      public static const LEFT_TEMP_UP:String = "Left_Temp_Up";
      
      public static const LEFT_TEMP_DOWN:String = "Left_Temp_Down";
      
      public static const RIGHT_TEMP_UP:String = "Right_Temp_Up";
      
      public static const RIGHT_TEMP_DOWN:String = "Right_Temp_Down";
      
      public static const ICS_KNOB3:String = "ICS_Knob3";
      
      public var delta:int;
      
      public var data:*;
      
      public function ICSEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
   }
}

