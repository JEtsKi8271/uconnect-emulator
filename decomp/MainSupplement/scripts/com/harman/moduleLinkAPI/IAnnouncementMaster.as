package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IAnnouncementMaster extends IModule
   {
      
      function get dabAnnouncementSwitch() : Boolean;
      
      function get tunerAnnouncementSwitch() : Boolean;
      
      function get dabAnnCategoryStates() : Object;
      
      function get advisoryMessage() : uint;
      
      function getCategoryState(param1:uint) : Boolean;
      
      function setDabCategory(param1:uint, param2:Boolean) : void;
      
      function setAllDabCategories(param1:Boolean) : void;
      
      function setTunerAnnouncementSwitch(param1:Boolean) : void;
      
      function setDabAnnouncementSwitch(param1:Boolean) : void;
      
      function requestAbortAnnouncement() : void;
   }
}

