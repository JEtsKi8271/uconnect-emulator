package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IDABTunerFollowMaster extends IModule
   {
      
      function requestSetFollowingSwitch(param1:Boolean) : void;
      
      function requestGetFollowingSwitch() : void;
      
      function get followingSwitch() : Boolean;
      
      function get followingStateMaster() : int;
      
      function get followingStateSlave() : int;
   }
}

