package core.api
{
   import flash.events.IEventDispatcher;
   
   public interface IMessenger extends IEventDispatcher
   {
      
      function send(param1:Object) : void;
      
      function onSend(param1:Function) : void;
      
      function removeOnSend(param1:Function) : void;
   }
}

