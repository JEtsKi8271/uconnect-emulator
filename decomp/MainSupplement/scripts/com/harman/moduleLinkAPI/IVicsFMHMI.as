package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IVicsFMHMI extends IModule
   {
      
      function get MenuDataState() : Object;
      
      function get MenuButton() : Object;
      
      function get InterButton() : Object;
      
      function get IsMenuDataUpdated() : Boolean;
      
      function get IsSubmenuDisplayed() : Boolean;
      
      function get CurrentType() : uint;
      
      function get PrgNum() : uint;
      
      function requestDrawMenuTopPageText() : void;
      
      function requestDrawMenuTopPageDiag() : void;
      
      function requestDrawMenuPrevPage() : void;
      
      function requestDrawMenuNextPage() : void;
      
      function requestDrawMenuProgram(param1:int) : void;
      
      function requestDrawMenuBack() : void;
      
      function requestFinishMenu() : void;
      
      function requestDrawInterTopPage() : void;
      
      function requestDrawInterPrevPage() : void;
      
      function requestDrawInterNextPage() : void;
      
      function requestFinishInterrupt() : void;
      
      function setCurrentType(param1:uint) : void;
      
      function setPrgNum(param1:uint) : void;
      
      function requestMenuData() : void;
      
      function requestMenuButton() : void;
      
      function requestInterButton() : void;
      
      function requestIsMenuDataUpdated() : void;
      
      function requestIsSubmenuDisplayed() : void;
   }
}

