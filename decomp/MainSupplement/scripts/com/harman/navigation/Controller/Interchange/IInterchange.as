package com.harman.navigation.Controller.Interchange
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IInterchange extends IModule
   {
      
      function get interchangePresent() : Boolean;
      
      function initializeNewSession() : void;
      
      function getInterchangeScreen() : void;
      
      function get interchangeScreen() : InterchangeListScreen;
      
      function selectListItem(param1:int) : void;
      
      function onBack() : Boolean;
   }
}

