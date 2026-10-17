package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class IPodTaggerEvent extends Event
   {
      
      public static const IS_TAGGABLE:String = "isTaggable";
      
      public static const IPOD_CONNECTION:String = "iPodConnection";
      
      public static const TRANSFER_RESULT:String = "transferResult";
      
      public static const TAG_COUNT:String = "tagCount";
      
      public static const TagOK:int = 1;
      
      public static const TagError:int = 2;
      
      public static const TagTargetFull:int = 3;
      
      public static const TagLocalStorageFull:int = 4;
      
      public static const TagStoredLocal:int = 5;
      
      public static const TagStoredToTarget:int = 6;
      
      public static const TagsTransferSucceeded:int = 7;
      
      public static const TagTransferFailed:int = 8;
      
      public static const TagStoredLocalIPodIncompatible:int = 9;
      
      public static const TagLocalFullIPodIncompatible:int = 10;
      
      public static const TagErrorMultipleIPods:int = 15;
      
      public static const TagNewIPodIncompatible:int = 16;
      
      public var eventdata:Object;
      
      public function IPodTaggerEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this.eventdata = data;
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new IPodTaggerEvent(type,this.eventdata,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("IPodTaggerEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

