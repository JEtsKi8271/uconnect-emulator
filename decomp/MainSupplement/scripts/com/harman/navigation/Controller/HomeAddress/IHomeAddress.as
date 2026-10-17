package com.harman.navigation.Controller.HomeAddress
{
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IHomeAddress extends IModule
   {
      
      function getHomeAddressSet() : void;
      
      function get homeAddressSet() : Boolean;
      
      function getHomeAddress() : void;
      
      function get homeAddress() : LocationDescription;
      
      function setHomeAddress(param1:LocationDescription) : void;
      
      function clearHomeAddress() : void;
   }
}

