package events
{
   import flash.events.Event;
   
   public class HardControlEvent extends Event
   {
      
      public static const VERTICAL_SCROLL:String = "events.hardControlEvent.verticalScroll";
      
      public static const HORIZONTAL_SCROLL:String = "events.hardControlEvent.horizontalScroll";
      
      public static const SELECT:String = "events.hardControlEvent.select";
      
      public static const SCREEN_OFF:String = "events.hardControlEvent.screenOff";
      
      public static const BACK:String = "events.hardControlEvent.back";
      
      public static const EXIT:String = "events.hardControlEvent.exit";
      
      public static const SELECT_2SEC_PRESS:String = "events.hardControlEvent.select2sPress";
      
      public static const MODE_ADVANCE:String = "events.hardControlEvent.modeAdvance";
      
      public static const BROWSE:String = "events.hardControlEvent.browse";
      
      public var data:*;
      
      public function HardControlEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.data = data;
      }
      
      override public function clone() : Event
      {
         return new HardControlEvent(type,bubbles,this.data,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("HardControlEvent","type","data","bubbles","cancelable");
      }
   }
}

