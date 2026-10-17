package com.harman.moduleLinkAPI
{
   import flash.events.Event;
   
   public class RemoteStartEvent extends Event
   {
      
      public static const REMOTE_START_ACTIVE:String = "remoteStartActive";
      
      public var mData:* = null;
      
      public function RemoteStartEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
      
      override public function toString() : String
      {
         return formatToString("RemoteStartEvent","type","mData","bubbles","cancelable");
      }
      
      override public function clone() : Event
      {
         return new RemoteStartEvent(type,this.mData,bubbles,cancelable);
      }
   }
}

