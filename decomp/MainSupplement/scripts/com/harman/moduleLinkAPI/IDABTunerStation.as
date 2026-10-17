package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IDABTunerStation extends IModule
   {
      
      function requestStartTune(param1:int, param2:int, param3:int, param4:int) : void;
      
      function requestControlSeek(param1:int, param2:int) : void;
      
      function requestForceUpdate(param1:int) : void;
      
      function requestSortStationlist(param1:String, param2:String = "ascending") : Vector.<DABTunerStationInstance>;
      
      function get handle() : String;
      
      function get feedback() : int;
      
      function get currentStation() : DABTunerStationInstance;
      
      function get stationList() : Vector.<DABTunerStationInstance>;
      
      function get startTuneStatus() : DABRequestStatus;
      
      function get controlSeekStatus() : DABRequestStatus;
      
      function get forceUpdateStatus() : DABRequestStatus;
      
      function get stationListSortType() : String;
      
      function get Presets() : Array;
      
      function storePreset(param1:int) : void;
      
      function recallPreset(param1:int) : void;
      
      function clearPreset(param1:int) : void;
      
      function clearAllPresets() : void;
      
      function seekPreset(param1:int) : void;
      
      function requestPresetList() : void;
      
      function get ensembleList() : Vector.<DABTunerStationInstance>;
      
      function get genreList() : Vector.<String>;
   }
}

