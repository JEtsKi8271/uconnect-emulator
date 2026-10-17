package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class AnnouncementMasterEvent extends Event
   {
      
      public static const AVAILABLE:String = "available";
      
      public static const DAB_ANNOUNCEMENT_SWITCH:String = "dabAnnouncementSwitchEvt";
      
      public static const TUNER_ANNOUNCEMENT_SWITCH:String = "tunerAnnouncementSwitchEvt";
      
      public static const DAB_ANNOUNCEMENT_CATEGORIES:String = "dabAnnouncementCategoriesEvt";
      
      public static const ADVISORY_MESSAGE:String = "advisoryMessageEvt";
      
      public var mData:* = null;
      
      public function AnnouncementMasterEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

