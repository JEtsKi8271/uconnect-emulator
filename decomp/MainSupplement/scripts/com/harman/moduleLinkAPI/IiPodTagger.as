package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IiPodTagger extends IModule
   {
      
      function tagRequest(param1:IPodTagInfo) : void;
      
      function clearAllLocalTags() : void;
      
      function getProperties(param1:Array) : void;
      
      function getAllProperties() : void;
      
      function canTagCurrent(param1:IPodTagInfo) : Boolean;
      
      function isTagged(param1:IPodTagInfo) : Boolean;
   }
}

