package com.harman.navigation.DomainControl
{
   import com.nfuzion.moduleLinkAPI.IModule;
   import flash.display.Sprite;
   
   public interface INavDomain extends IModule
   {
      
      function getNavIsOperable() : void;
      
      function get navIsOperable() : Boolean;
      
      function onNavDomainButton() : void;
      
      function exitNavDomain() : void;
      
      function toggleMenus() : void;
      
      function getNavDomainActive() : void;
      
      function get navDomainActive() : Boolean;
      
      function get mapMenuStackIsActive() : Boolean;
      
      function get mapMenuStackIsSelected() : Boolean;
      
      function switchToMenu(param1:int) : void;
      
      function onBackButtonPress() : void;
      
      function setBackFlag() : void;
      
      function onCancelButtonPress() : void;
      
      function clearMenuStack(param1:int) : void;
      
      function addMenuToStackPassive(param1:int, param2:int) : void;
      
      function addMenuToStackNoAction(param1:int, param2:int) : void;
      
      function removeTopMenuFromStackPassive() : void;
      
      function switchToMenuStackPassive(param1:int) : void;
      
      function getNavActiveMenu() : void;
      
      function get navActiveMenu() : int;
      
      function moveBackToMenu(param1:int) : void;
      
      function enableMediaMap(param1:Boolean) : void;
      
      function getMediaMapEnabled() : void;
      
      function get mediaMapEnabled() : Boolean;
      
      function setExternalDestination(param1:String, param2:String) : void;
      
      function addContactToFavoriteDestinations(param1:String, param2:String, param3:Object) : Boolean;
      
      function get addContactToFavoriteDestinationsAvailable() : Boolean;
      
      function goToTmcScreenFromOutSideOfNavDomain() : Boolean;
      
      function requestShortcut(param1:int) : void;
      
      function requestVRShortcut(param1:String) : void;
      
      function factoryReset() : void;
      
      function setSprite(param1:Sprite) : void;
   }
}

