package core.events
{
   import flash.events.Event;
   
   public class MessageEvent extends Event
   {
      
      public static const MESSAGE:String = "string";
      
      public var message:Object;
      
      public function MessageEvent(type:String, message:Object, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.message = message;
      }
      
      override public function clone() : Event
      {
         return new MessageEvent(type,this.message,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return formatToString("MessageEvent","message","type","bubbles","cancelable");
      }
   }
}

