package com.harman.navigation.Controller.Persistence
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IPersistence extends IModule
   {
      
      function saveData(param1:String, param2:Object) : void;
      
      function loadData(param1:String) : void;
      
      function get dataLoaded() : String;
      
      function getDataLoaded(param1:String, param2:Boolean) : Object;
      
      function indicateDatabaseUpdate() : void;
      
      function isBusy() : Boolean;
   }
}

