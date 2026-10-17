package events
{
   import flash.events.Event;
   
   public class PresetManagerEvent extends Event
   {
      
      public static const DAB_PRESET_UPDATE:String = "events.PresetManagerEvent.dabPresetUpdate";
      
      public var value:String;
      
      public function PresetManagerEvent(type:String, value:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.value = value;
      }
      
      override public function clone() : Event
      {
         return new PresetManagerEvent(type,this.value,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("PresetManagerEvent","type","value","bubbles","cancelable");
      }
   }
}

