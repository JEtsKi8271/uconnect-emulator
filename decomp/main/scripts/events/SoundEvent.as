package events
{
   import flash.events.Event;
   
   public class SoundEvent extends Event
   {
      
      public static const CLICK:String = "events.SoundEvent.click";
      
      public static const REJECT:String = "events.SoundEvent.reject";
      
      public static const TOGGLE:String = "events.SoundEvent.toggle";
      
      public static const SET:String = "events.SoundEvent.set";
      
      public function SoundEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
   }
}

