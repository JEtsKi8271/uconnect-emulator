package com.harman.moduleLinkAPI
{
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IAha extends IModule
   {
      
      function init() : void;
      
      function get TYPE_PRESETS() : uint;
      
      function get TYPE_NEARBY() : uint;
      
      function get TYPE_FEATURED() : uint;
      
      function get TYPE_ADDSTATION() : uint;
      
      function get CATEGORY_ROOT() : String;
      
      function get appState() : int;
      
      function get loadingState() : int;
      
      function set playbackState(param1:int) : void;
      
      function get playbackState() : int;
      
      function get currentStation() : AhaStation;
      
      function get currentContent() : AhaContent;
      
      function get imagePathForStation() : String;
      
      function get imagePathForContent() : String;
      
      function get imagePathForProvider() : String;
      
      function get imagePathForRating() : String;
      
      function get imagePathForLike() : String;
      
      function get imagePathForDislike() : String;
      
      function get contentList() : Array;
      
      function get presetList() : Array;
      
      function get featuredList() : Array;
      
      function get nearbyList() : Array;
      
      function get stationList() : Array;
      
      function get lastRequest() : String;
      
      function get playDuration() : int;
      
      function get playTime() : int;
      
      function set playTime(param1:int) : void;
      
      function get stationID() : int;
      
      function set stationID(param1:int) : void;
      
      function get contentID() : int;
      
      function set contentID(param1:int) : void;
      
      function like() : void;
      
      function dislike() : void;
      
      function play() : void;
      
      function pause() : void;
      
      function seekNext() : void;
      
      function seekPrev() : void;
      
      function requestStations(param1:uint) : void;
      
      function requestStationsByID(param1:String) : void;
      
      function addStation(param1:String) : void;
      
      function removeStation(param1:String) : void;
      
      function getImage(param1:String) : void;
      
      function call(param1:int) : void;
      
      function navigate(param1:int) : void;
   }
}

