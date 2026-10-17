package core.events
{
   import flash.events.Event;
   
   public class FrameworkEvent extends Event
   {
      
      public static const IDLE:String = "idle";
      
      public static const READY:String = "ready";
      
      public static const KEYPAD_CHANGED:String = "keypad_changed";
      
      public static const KEYBOARD_CHANGED:String = "keyboard_changed";
      
      public function FrameworkEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new FrameworkEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("FrameworkEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

