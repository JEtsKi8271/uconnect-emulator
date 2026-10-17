package com.harman.navigation.Controller.LiveServices
{
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ILiveServices extends IModule
   {
      
      function get consentState() : int;
      
      function setConsentState(param1:int) : void;
      
      function get consentConfirmExpiration() : Date;
      
      function get liveServicesEnabled() : Boolean;
      
      function requestLiveServicesEnabled() : void;
      
      function enableLiveServices(param1:Boolean) : void;
      
      function get ttlsSserviceIsSupportedBySystem() : Boolean;
      
      function get ttlsUConnectACNAvailable() : Boolean;
      
      function get ttlsGeneralServiceAvailable() : Boolean;
      
      function ttlsServiceAvailable(param1:String) : Boolean;
      
      function ttlsServiceFunctional(param1:int) : Boolean;
      
      function ttlsRequestServiceStatusUpdate() : void;
      
      function get homeAddress() : LocationDescription;
      
      function set homeAddress(param1:LocationDescription) : void;
      
      function get homeAddressIsValid() : Boolean;
      
      function get workAddress() : LocationDescription;
      
      function set workAddress(param1:LocationDescription) : void;
      
      function get workAddressIsValid() : Boolean;
      
      function get alertSettings() : Object;
      
      function requestSpeedCameraSettings() : void;
      
      function set alertSettings(param1:Object) : void;
      
      function reportSpeedCameraType(param1:int) : void;
      
      function speedCameraTypeRequiresSpeedLimit() : Boolean;
      
      function reportSpeedCameraSpeed(param1:int) : void;
      
      function reportSpeedCameraLocation(param1:String) : void;
      
      function requestReportSpeedCamera() : void;
      
      function get speedCameraType() : int;
      
      function get speedCameraSpeed() : int;
      
      function setLocalSearchSearchArea(param1:int, param2:String) : void;
      
      function setLocalSearchMainTripAssemblerMode(param1:int) : void;
      
      function get localSearchMainTripAssemblerMode() : int;
      
      function localSearchPrepareNewSearch() : void;
      
      function requestLocalSearch(param1:String) : void;
      
      function get localSearchString() : String;
      
      function get isLocalSearchPending() : Boolean;
      
      function get hasLocalSearchFailed() : Boolean;
      
      function get localSearchResults() : LocalSearchResultList;
      
      function localSearchGetLocationDescriptionForTomTomID(param1:int) : LocationDescription;
      
      function requestLocalSearchCancelSearch() : void;
      
      function set localSearchSortOrder(param1:int) : void;
      
      function setWeatherSearchArea(param1:int, param2:LocationDescription) : void;
      
      function get weatherSearchLocation() : LocationDescription;
      
      function get isWeatherPending() : Boolean;
      
      function get weatherResults() : WeatherResultList;
      
      function get hasWeatherFailed() : Boolean;
   }
}

