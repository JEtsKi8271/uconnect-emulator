package events
{
   import flash.events.Event;
   
   public class StartupEvent extends Event
   {
      
      public static const UNLOCK:String = "event.StartupEvent.unlock";
      
      public static const ACCEPT:String = "event.StartupEvent.accept";
      
      public static const READY:String = "event.StartupEvent.ready";
      
      public function StartupEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

