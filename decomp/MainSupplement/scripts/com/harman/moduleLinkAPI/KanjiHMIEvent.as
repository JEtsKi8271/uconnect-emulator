package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class KanjiHMIEvent extends Event
   {
      
      public static const KANJI_CONVERTED:String = "EventKanjiConverted";
      
      public static const GET_CAND_LIST:String = "EventGetCandList";
      
      public var mData:Object = null;
      
      public function KanjiHMIEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

