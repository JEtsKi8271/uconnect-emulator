package events
{
   import flash.events.Event;
   
   public class ControlsManagerEvent extends Event
   {
      
      public static const STARTUP_INFO:String = "events.ControlsManagerEvent.startUpInfo";
      
      public static const STOP_DISCLAIMER:String = "events.ControlsManagerEvent.stopDisclaimer";
      
      public static const RESUME_DISCLAIMER:String = "events.ControlsManagerEvent.resumeDisclaimer";
      
      public static const LEFT_SEAT_HEAT:String = "events.ControlsManagerEvent.leftSeatHeat";
      
      public static const RIGHT_SEAT_HEAT:String = "events.ControlsManagerEvent.rightSeatHeat";
      
      public static const LEFT_SEAT_VENT:String = "events.ControlsManagerEvent.leftSeatVent";
      
      public static const RIGHT_SEAT_VENT:String = "events.ControlsManagerEvent.rightSeatVent";
      
      public static const STEERING_WHEEL_HEAT:String = "events.ControlsManagerEvent.steeringWheelHeat";
      
      public static const DRIVE_MODE_STATUS:String = "events.ControlsManagerEvent.driveModesStatus";
      
      public static const CLOSE:String = "events.ControlsManagerEvent.close";
      
      public static const RECEIVED_COMFORT_DISABLED:String = "events.ControlsManagerEvent.receivedComfortDisabled";
      
      public var value:String;
      
      public function ControlsManagerEvent(type:String, value:String = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.value = value;
      }
      
      override public function clone() : Event
      {
         return new ControlsManagerEvent(type,this.value,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("ControlsManagerEvent","type","value","bubbles","cancelable");
      }
   }
}

