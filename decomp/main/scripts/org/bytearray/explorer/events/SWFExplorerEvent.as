package org.bytearray.explorer.events
{
   import flash.events.Event;
   
   public final class SWFExplorerEvent extends Event
   {
      
      public static const COMPLETE:String = "parseComplete";
      
      public var definitions:Array;
      
      public function SWFExplorerEvent(type:String, classes:Array)
      {
         super(type,false,false);
         this.definitions = classes;
      }
      
      override public function clone() : Event
      {
         return new SWFExplorerEvent(SWFExplorerEvent.COMPLETE,this.definitions);
      }
      
      override public function toString() : String
      {
         return "[LoaderExplorerEvent type=parseComplete, definitions=" + this.definitions + "]";
      }
   }
}

