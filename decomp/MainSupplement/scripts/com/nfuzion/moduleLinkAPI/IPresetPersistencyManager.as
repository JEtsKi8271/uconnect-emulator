package com.nfuzion.moduleLinkAPI
{
   public interface IPresetPersistencyManager extends IModule
   {
      
      function get AllPresets() : Vector.<Preset>;
      
      function getFilteredPresets(param1:String, param2:int = 0, param3:int = 0) : Vector.<Preset>;
      
      function init(param1:String) : void;
      
      function save(param1:Vector.<Preset>) : Boolean;
   }
}

