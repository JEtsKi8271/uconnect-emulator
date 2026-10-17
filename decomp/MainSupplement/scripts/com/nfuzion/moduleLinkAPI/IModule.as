package com.nfuzion.moduleLinkAPI
{
   import flash.events.IEventDispatcher;
   
   public interface IModule extends IEventDispatcher
   {
      
      function getAll() : void;
      
      function isReady() : Boolean;
      
      function hello() : void;
      
      function addInterest(param1:String) : void;
      
      function removeInterest(param1:String) : void;
      
      function destroyInterest(param1:String) : void;
      
      function interested(param1:String) : Boolean;
      
      function totalInterest(param1:String) : uint;
   }
}

