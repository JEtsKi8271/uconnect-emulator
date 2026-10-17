package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ILocation extends IModule
   {
      
      function getCompassHeading() : void;
      
      function get compassHeading() : int;
   }
}

