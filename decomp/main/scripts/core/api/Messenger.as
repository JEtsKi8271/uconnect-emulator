package core.api
{
   import core.events.MessageEvent;
   import flash.events.EventDispatcher;
   
   public class Messenger extends EventDispatcher implements IMessenger
   {
      
      private static var thisInstance:Messenger;
      
      public function Messenger()
      {
         super();
      }
      
      public static function create() : IMessenger
      {
         if(thisInstance == null)
         {
            return thisInstance = new Messenger();
         }
         return thisInstance;
      }
      
      public static function get instance() : Messenger
      {
         return thisInstance;
      }
      
      public function send(message:Object) : void
      {
         dispatchEvent(new MessageEvent(MessageEvent.MESSAGE,message,false,false));
      }
      
      public function onSend(callback:Function) : void
      {
         this.addEventListener(MessageEvent.MESSAGE,callback);
      }
      
      public function removeOnSend(callback:Function) : void
      {
         this.removeEventListener(MessageEvent.MESSAGE,callback);
      }
   }
}

