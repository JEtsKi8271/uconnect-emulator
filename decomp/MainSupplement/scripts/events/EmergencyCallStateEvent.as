package events
{
   import flash.events.Event;
   
   public class EmergencyCallStateEvent extends Event
   {
      
      public static const EMERGENCY_CALLSTATE:String = "events.emergencycallstateevent.emergencycallstate";
      
      public static const EMERGENCY_SWITCHTO_ECALLSCREEN:String = "events.emergencycallstateevent.switchtoecallscreen";
      
      public static const EMERGENCY_CALLSTATE_STARTING:String = "CALL_STATE_STARTING";
      
      public static const EMERGENCY_CALLSTATE_DIALING:String = "CALL_STATE_DIALING";
      
      public static const EMERGENCY_CALLSTATE_ACTIVE:String = "CALL_STATE_ACTIVE";
      
      public static const EMERGENCY_CALLSTATE_END:String = "CALL_STATE_TERMINATED";
      
      public static const EMERGENCY_CALLSTATE_RETRY:String = "CALL_STATE_RETRY";
      
      public static const EMERGENCY_CALLSTATE_ECALLBACK:String = "CALL_STATE_ECALLBACK";
      
      public static const EMERGENCY_CALLSTATE_IDLE:String = "CALL_STATE_IDLE";
      
      public static const EMERGENCY_CALLSTATE_RING:String = "CALL_STATE_RINGING";
      
      public function EmergencyCallStateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new EmergencyCallStateEvent(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("EmergencyCallStateEvent","type","bubbles","cancelable");
      }
   }
}

