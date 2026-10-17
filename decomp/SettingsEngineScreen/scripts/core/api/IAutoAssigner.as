package core.api
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public interface IAutoAssigner
   {
      
      function addDecoratorClass(param1:Class) : Boolean;
      
      function assignChildren(param1:DisplayObjectContainer) : void;
      
      function getFunctionDescriptors(param1:DisplayObject) : Array;
      
      function getFunctionDescriptor(param1:DisplayObject, param2:String) : Object;
   }
}

