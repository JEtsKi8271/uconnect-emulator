package mx.core
{
   import flash.utils.Dictionary;
   
   public interface IFlexModuleFactory
   {
      
      function get preloadedRSLs() : Dictionary;
      
      function allowDomain(... rest) : void;
      
      function allowInsecureDomain(... rest) : void;
      
      function callInContext(param1:Function, param2:Object, param3:Array, param4:Boolean = true) : *;
      
      function create(... rest) : Object;
      
      function getImplementation(param1:String) : Object;
      
      function info() : Object;
      
      function registerImplementation(param1:String, param2:Object) : void;
   }
}

