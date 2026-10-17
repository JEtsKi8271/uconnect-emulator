package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IDisplayManager extends IModule
   {
      
      function get RearCameraStatus() : Boolean;
      
      function getLayerVisibility(param1:String) : Boolean;
      
      function requestDisplay(param1:String, param2:Boolean) : void;
   }
}

