package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IBeaconDSRCHMI extends IModule
   {
      
      function get InterruptCharacterInfo() : Boolean;
      
      function get InterruptFigureInfo() : Boolean;
      
      function get VICSVoiceGuidance() : Boolean;
      
      function get DSRSTTSAnnouncement() : Boolean;
      
      function get DSRSUplink() : Boolean;
      
      function get DisplayTime() : uint;
      
      function get MenuDataState() : BeaconDSRCID;
      
      function get ButtonDataState() : BeaconDSRCID;
      
      function get InterButtonState() : BeaconDSRCID;
      
      function get CurrentRoadType() : uint;
      
      function get CurrentDataType() : uint;
      
      function get MsgNum() : uint;
      
      function get ReceivedTime() : BeaconDSRCID;
      
      function get VicsInterruptActive() : Boolean;
      
      function get VicsInterruptPriority() : uint;
      
      function setVicsInterruptActive(param1:Boolean) : void;
      
      function requestSwitchInterruptCharacterInfo(param1:Boolean) : void;
      
      function requestSwitchInterruptFigureInfo(param1:Boolean) : void;
      
      function requestSwitchVICSVoiceGuidance(param1:Boolean) : void;
      
      function requestSwitchDSRSTTSAnnouncement(param1:Boolean) : void;
      
      function requestSwitchDSRSUplink(param1:Boolean) : void;
      
      function requestSwitchDisplayTime(param1:uint) : void;
      
      function requestStartMenu(param1:int) : void;
      
      function requestDrawMenuTopPageText() : void;
      
      function requestDrawMenuTopPageDiag() : void;
      
      function requestDrawMenuTextMsg(param1:uint) : void;
      
      function requestDrawMenuDiagMsg(param1:uint) : void;
      
      function requestDrawMenuNextPage() : void;
      
      function requestDrawMenuPrevPage() : void;
      
      function requestStartMenuTTS() : void;
      
      function requestStopMenuTTS() : void;
      
      function requestFinishMenu() : void;
      
      function requestDrawInterTopPage() : void;
      
      function requestDrawInterPrevPage() : void;
      
      function requestDrawInterNextPage() : void;
      
      function requestFinishInterupt() : void;
      
      function setCurrentRoadType(param1:uint) : void;
      
      function setCurrentDataType(param1:uint) : void;
      
      function setMsgNum(param1:uint) : void;
      
      function requestMenuData() : void;
      
      function requestMenuButton() : void;
      
      function requestInterButton() : void;
      
      function requestInterruptCharacterInfo() : void;
      
      function requestInterruptFigureInfo() : void;
      
      function requestVICSVoiceGuidance() : void;
      
      function requestDSRSTTSAnnouncement() : void;
      
      function requestDSRSUplink() : void;
      
      function requestDisplayTime() : void;
      
      function requestPubTextReceivedTime() : void;
      
      function requestPubDiagReceivedTime() : void;
      
      function requestExpTextReceivedTime() : void;
      
      function requestExpDiagReceivedTime() : void;
      
      function requestExpTextTokenClearFlag() : void;
      
      function requestExpDiagTokenClearFlag() : void;
   }
}

