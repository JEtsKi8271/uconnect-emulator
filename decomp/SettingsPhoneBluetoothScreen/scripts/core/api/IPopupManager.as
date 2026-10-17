package core.api
{
   import flash.events.IEventDispatcher;
   
   public interface IPopupManager extends IEventDispatcher
   {
      
      function get currentBranch() : String;
      
      function get active() : int;
      
      function get type() : int;
      
      function get variables() : Object;
      
      function show(param1:int, param2:String, param3:Object = null) : void;
      
      function close(param1:String = "unknown", param2:Object = null) : void;
      
      function exit() : void;
      
      function dispatch(param1:String, param2:Object = null) : void;
      
      function dequeue(param1:int) : void;
      
      function check(param1:int) : Boolean;
      
      function checkForType(param1:int) : Boolean;
      
      function resetTimeout(param1:int = 0) : void;
      
      function setTimeout(param1:int) : void;
      
      function error(param1:String) : void;
      
      function taskComplete(param1:String) : void;
   }
}

