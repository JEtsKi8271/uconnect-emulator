package core.api
{
   import flash.events.IEventDispatcher;
   
   public interface IStructure extends IEventDispatcher
   {
      
      function set currentBranch(param1:String) : void;
      
      function get currentBranch() : String;
      
      function get currentExtension() : int;
      
      function get variables() : Object;
      
      function set variables(param1:Object) : void;
      
      function historyIndexOf(param1:String) : int;
      
      function goto(param1:String, param2:Object = null, param3:Boolean = true) : void;
      
      function getAddress(param1:String) : String;
      
      function getStackIndex(param1:String) : int;
      
      function removeFromStack(param1:String) : void;
      
      function returnTo(param1:String) : void;
      
      function findAndReplace(param1:String, param2:String, param3:Object = null, param4:Boolean = false) : void;
      
      function returnExitBranch() : String;
      
      function updateHistory(param1:Object) : void;
      
      function back() : void;
      
      function gotolastScreen() : void;
      
      function exit() : void;
      
      function setExit() : void;
      
      function captureExit() : void;
      
      function taskComplete(param1:String) : void;
   }
}

