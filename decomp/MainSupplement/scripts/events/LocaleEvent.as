package events
{
   import flash.events.Event;
   
   public class LocaleEvent extends Event
   {
      
      public static const CHANGE:String = "change";
      
      public function LocaleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

