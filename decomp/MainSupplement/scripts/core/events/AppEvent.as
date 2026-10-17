package core.events
{
   import flash.events.Event;
   
   public class AppEvent extends Event
   {
      
      public static const ICON_COMPLETE:String = "iconComplete";
      
      public static const ICON_ADDED:String = "iconAdded";
      
      public var mData:Object;
      
      public function AppEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

