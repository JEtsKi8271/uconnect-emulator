package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IAudioMixerManager extends IModule
   {
      
      function get AMM_SOURCE_SIGNAL() : String;
      
      function get AMM_SOURCE_NONE() : String;
      
      function get TONE_NORMAL() : String;
      
      function get TONE_REJECTION() : String;
      
      function get TONE_SET() : String;
      
      function getAMMBusy() : void;
      
      function get AMMBusy() : Boolean;
      
      function requestInformationSource(param1:String, param2:Boolean) : void;
      
      function releaseInformationSource(param1:String) : void;
      
      function sendConfirmationTone(param1:String) : void;
      
      function sendInformationAlert(param1:String) : void;
      
      function adjustNavPromptVolume(param1:String) : void;
      
      function getNavPromptVolume() : void;
      
      function get navPromptVolume() : int;
      
      function get dabfmMuxSource() : Boolean;
      
      function get interruptSource() : String;
      
      function registerMuteClient(param1:String) : void;
      
      function setEntertainmentSrcMute(param1:String) : Boolean;
      
      function setEntertainmentSrcUnmute(param1:String) : Boolean;
      
      function setTouchScreenEnable(param1:Boolean) : void;
      
      function get phoneMuteStatus() : Boolean;
      
      function get phoneMicMuteStatus() : Boolean;
      
      function setAuxVolumeOffset(param1:int) : void;
      
      function getAuxVolumeOffset() : void;
      
      function get AuxVolumeOffset() : int;
      
      function sendPhoneMute(param1:Boolean) : void;
   }
}

