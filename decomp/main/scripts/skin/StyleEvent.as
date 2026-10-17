package skin
{
   import flash.events.Event;
   
   public class StyleEvent extends Event
   {
      
      public static const THEME_CHANGE:String = "theme change";
      
      public function StyleEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      override public function clone() : Event
      {
         return new StyleEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("StyleEvent","type","bubbles","cancelable","eventPhase");
      }
   }
}

