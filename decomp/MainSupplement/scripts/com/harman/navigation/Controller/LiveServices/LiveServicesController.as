package com.harman.navigation.Controller.LiveServices
{
   import com.harman.navigation.Controller.LiveServices.helper.Consent;
   import com.harman.navigation.Controller.LiveServices.helper.Helper;
   import com.harman.navigation.Controller.LiveServices.helper.LocalSearch;
   import com.harman.navigation.Controller.LiveServices.helper.SpeedCamera;
   import com.harman.navigation.Controller.LiveServices.helper.Status;
   import com.harman.navigation.Controller.LiveServices.helper.Weather;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceEvent;
   import com.harman.navigation.Controller.Persistence.PersistenceKeys;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   import flash.events.EventDispatcher;
   
   public class LiveServicesController extends EventDispatcher implements ILiveServices
   {
      
      private var mAddressWork:LocationDescription = new LocationDescription();
      
      private var mHelperConsent:Consent = new Consent();
      
      private var mHelperLocalSearch:LocalSearch = new LocalSearch();
      
      private var mHelperSpeedCamera:SpeedCamera = null;
      
      private var mHelperStatus:Status = null;
      
      private var mHelperWeather:Weather = new Weather();
      
      public function LiveServicesController()
      {
         super();
         Helper.setController(this);
         this.mHelperSpeedCamera = new SpeedCamera();
         this.init();
      }
      
      public function get consentState() : int
      {
         return this.mHelperConsent.consentState;
      }
      
      public function setConsentState(state:int) : void
      {
         this.mHelperConsent.setConsentState(state);
      }
      
      public function get consentConfirmExpiration() : Date
      {
         return this.mHelperConsent.consentConfirmExpiration;
      }
      
      public function get liveServicesEnabled() : Boolean
      {
         return this.mHelperStatus.liveServicesEnabled;
      }
      
      public function enableLiveServices(enable:Boolean) : void
      {
         this.mHelperStatus.enableLiveServices(enable);
      }
      
      public function requestLiveServicesEnabled() : void
      {
         this.sendEvent(LiveServicesEvent.LS_LIVE_SERVICES_ENABLED);
      }
      
      public function get ttlsGeneralServiceAvailable() : Boolean
      {
         return this.mHelperStatus.ttlsGeneralServiceAvailable();
      }
      
      public function get ttlsSserviceIsSupportedBySystem() : Boolean
      {
         return this.mHelperStatus.ttlsSserviceIsSupportedBySystem;
      }
      
      public function get ttlsUConnectACNAvailable() : Boolean
      {
         return this.mHelperStatus.ttlsUConnectACNAvailable();
      }
      
      public function ttlsServiceAvailable(serviceType:String) : Boolean
      {
         return this.mHelperStatus.ttlsServiceAvailable(serviceType);
      }
      
      public function ttlsServiceFunctional(ttlsService:int) : Boolean
      {
         return this.mHelperStatus.ttlsServiceFunctional(ttlsService);
      }
      
      public function ttlsRequestServiceStatusUpdate() : void
      {
         this.sendEvent(LiveServicesEvent.LS_SERVICE_STATUS_UPDATE);
      }
      
      public function get homeAddress() : LocationDescription
      {
         if(NavigationPackage.peripheral.navigation.navHomeAddress.homeAddressSet)
         {
            return NavigationPackage.peripheral.navigation.navHomeAddress.homeAddress;
         }
         return new LocationDescription();
      }
      
      public function get workAddress() : LocationDescription
      {
         return this.mAddressWork;
      }
      
      public function set homeAddress(loc:LocationDescription) : void
      {
         NavigationPackage.peripheral.navigation.navHomeAddress.clearHomeAddress();
         NavigationPackage.peripheral.navigation.navHomeAddress.setHomeAddress(loc);
      }
      
      public function set workAddress(loc:LocationDescription) : void
      {
         this.mAddressWork = loc;
         this.toPersistence();
      }
      
      public function get homeAddressIsValid() : Boolean
      {
         return NavigationPackage.peripheral.navigation.navHomeAddress.homeAddressSet;
      }
      
      public function get workAddressIsValid() : Boolean
      {
         return LocationDetails(this.mAddressWork.getSecondaryLocation()).getType("<GEO>").length > 0 ? true : false;
      }
      
      public function clearPendingDeliveryData() : void
      {
         this.mHelperSpeedCamera.clearPastCameraReportData();
      }
      
      public function get alertSettings() : Object
      {
         return this.mHelperSpeedCamera.alertSettings;
      }
      
      public function requestSpeedCameraSettings() : void
      {
         this.sendEvent(LiveServicesEvent.LS_SPEED_CAMERA_ALERT_SETTINGS);
      }
      
      public function set alertSettings(settings:Object) : void
      {
         this.mHelperSpeedCamera.alertSettings = settings;
         this.toPersistence();
      }
      
      public function reportSpeedCameraType(type:int) : void
      {
         this.mHelperSpeedCamera.reportSpeedCameraType(type);
      }
      
      public function speedCameraTypeRequiresSpeedLimit() : Boolean
      {
         return this.mHelperSpeedCamera.speedCameraTypeRequiresSpeedLimit();
      }
      
      public function reportSpeedCameraSpeed(speed:int) : void
      {
         this.mHelperSpeedCamera.reportSpeedCameraSpeed(speed);
      }
      
      public function reportSpeedCameraLocation(geo:String) : void
      {
         this.mHelperSpeedCamera.reportSpeedCameraLocation(geo);
      }
      
      public function requestReportSpeedCamera() : void
      {
         this.mHelperSpeedCamera.requestReportSpeedCamera();
      }
      
      public function get speedCameraType() : int
      {
         return this.mHelperSpeedCamera.speedCameraType;
      }
      
      public function get speedCameraSpeed() : int
      {
         return this.mHelperSpeedCamera.speedCameraSpeed;
      }
      
      public function setLocalSearchSearchArea(area:int, geo:String) : void
      {
         this.mHelperLocalSearch.setLocalSearchSearchArea(area,geo);
      }
      
      public function setLocalSearchMainTripAssemblerMode(mode:int) : void
      {
         this.mHelperLocalSearch.setLocalSearchMainTripAssemblerMode(mode);
      }
      
      public function get localSearchMainTripAssemblerMode() : int
      {
         return this.mHelperLocalSearch.localSearchMainTripAssemblerMode;
      }
      
      public function localSearchPrepareNewSearch() : void
      {
         return this.mHelperLocalSearch.prepareNewSearch();
      }
      
      public function requestLocalSearch(searchString:String) : void
      {
         if(!this.checkThrowErrorPopup())
         {
            this.mHelperLocalSearch.requestLocalSearch(searchString);
            this.sendEvent(LiveServicesEvent.TTLS_REQUEST_SENT);
         }
         else
         {
            this.sendEvent(LiveServicesEvent.TTLS_REQUEST_BLOCKED);
         }
      }
      
      public function get localSearchString() : String
      {
         return this.mHelperLocalSearch.localSearchString;
      }
      
      public function get isLocalSearchPending() : Boolean
      {
         return this.mHelperLocalSearch.isSearchPending;
      }
      
      public function get hasLocalSearchFailed() : Boolean
      {
         return this.mHelperLocalSearch.isSearchFailed;
      }
      
      public function get localSearchResults() : LocalSearchResultList
      {
         return this.mHelperLocalSearch.searchResults;
      }
      
      public function localSearchGetLocationDescriptionForTomTomID(id:int) : LocationDescription
      {
         return this.mHelperLocalSearch.getLocationDescriptionForTomTomID(id);
      }
      
      public function requestLocalSearchCancelSearch() : void
      {
         this.mHelperLocalSearch.requestLocalSearchCancelSearch();
      }
      
      public function set localSearchSortOrder(order:int) : void
      {
         this.mHelperLocalSearch.localSearchSortOrder = order;
      }
      
      public function setWeatherSearchArea(area:int, loc:LocationDescription) : void
      {
         if(!this.checkThrowErrorPopup())
         {
            this.mHelperWeather.setWeatherSearchArea(area,loc);
            this.sendEvent(LiveServicesEvent.TTLS_REQUEST_SENT);
         }
         else
         {
            this.sendEvent(LiveServicesEvent.TTLS_REQUEST_BLOCKED);
         }
      }
      
      public function get weatherSearchLocation() : LocationDescription
      {
         return this.mHelperWeather.weatherSearchLocation;
      }
      
      public function get isWeatherPending() : Boolean
      {
         return this.mHelperWeather.isWeatherPending;
      }
      
      public function get weatherResults() : WeatherResultList
      {
         return this.mHelperWeather.weatherResults;
      }
      
      public function get hasWeatherFailed() : Boolean
      {
         return this.mHelperWeather.hasRequestFailed;
      }
      
      public function sendEvent(eventType:String) : void
      {
         dispatchEvent(new LiveServicesEvent(eventType));
      }
      
      private function init() : void
      {
         NavigationApi.api.addEventListener(NavigationEvent.NAV_LANGUAGE_CHANGED,this.onLanguageChange,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.NAV_FACTORY_RESET,this.onFactoryReset,false,0,true);
         PersistenceApi.api.addEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence,false,0,true);
         PersistenceApi.api.loadData(PersistenceKeys.LIVE_SERVICES);
         this.mHelperStatus = new Status();
      }
      
      private function onLanguageChange(e:NavigationEvent) : void
      {
         if(!NavigationApi.api.langIsLanguageChangeInProgress)
         {
            Framework.Trace("LiveServicesController.onLanguageChange()");
            this.mHelperConsent.checkLanguageChange();
         }
      }
      
      private function onPersistence(e:PersistenceEvent) : void
      {
         var res:Object = null;
         var locDet:LocationDetails = null;
         var consentDataFound:Boolean = false;
         var index:int = 0;
         var i:String = null;
         if(PersistenceApi.api.dataLoaded == PersistenceKeys.LIVE_SERVICES)
         {
            res = PersistenceApi.api.getDataLoaded(PersistenceKeys.LIVE_SERVICES,true);
            locDet = new LocationDetails();
            consentDataFound = false;
            if(res != null)
            {
               index = 0;
               for(i in res)
               {
                  switch(i)
                  {
                     case "consent":
                        this.mHelperConsent.setConsentDataString(String(res[i]));
                        consentDataFound = true;
                        break;
                     case "workp":
                        locDet = new LocationDetails();
                        locDet.addEisString(String(res[i]));
                        this.mAddressWork.setPrimaryLocation(locDet);
                        break;
                     case "works":
                        locDet = new LocationDetails();
                        locDet.addEisString(String(res[i]));
                        this.mAddressWork.setSecondaryLocation(locDet);
                        break;
                     case "authStat":
                        this.mHelperStatus.persistedAuthorizationStatus = int(res[i]);
                        break;
                     case "spcam":
                        this.mHelperSpeedCamera.persistencyData = String(res[i]);
                        break;
                     case "repspcam":
                        this.mHelperSpeedCamera.persistencyReportData = String(res[i]);
                        break;
                     case "onoff":
                        this.mHelperStatus.enableLiveServices(String(res[i]) == "true" ? true : false);
                  }
               }
            }
            if(!consentDataFound)
            {
               this.mHelperConsent.setConsentDataString("");
            }
            PersistenceApi.api.removeEventListener(PersistenceEvent.PERS_DATA_LOADED,this.onPersistence);
         }
      }
      
      public function toPersistence() : void
      {
         var pers:Object = new Object();
         pers["consent"] = this.mHelperConsent.getConsentDataString();
         pers["workp"] = this.mAddressWork.getPrimaryLocation().toEIS();
         pers["works"] = this.mAddressWork.getSecondaryLocation().toEIS();
         pers["spcam"] = this.mHelperSpeedCamera.persistencyData;
         pers["repspcam"] = this.mHelperSpeedCamera.persistencyReportData;
         pers["onoff"] = this.mHelperStatus.liveServicesEnabled;
         if(NavigationApi.api.lsAuthenticationStatus != null && NavigationApi.api.lsAuthenticationStatus["authenticationStatus"] != null)
         {
            pers["authStat"] = NavigationApi.api.lsAuthenticationStatus["authenticationStatus"];
         }
         else
         {
            pers["authStat"] = this.mHelperStatus.persistedAuthorizationStatus ? AuthenticationTypes.UC_AUTH_AUTHORIZED : AuthenticationTypes.UC_AUTH_UNAUTHORIZED;
         }
         PersistenceApi.api.saveData(PersistenceKeys.LIVE_SERVICES,pers);
      }
      
      private function onFactoryReset(e:NavigationEvent) : void
      {
         this.mHelperConsent.setConsentState(ConsentStates.CONSENT_STATE_UNDEFINED);
         this.mAddressWork = new LocationDescription();
         this.toPersistence();
      }
      
      public function getAuthenticationStatusToString(status:int) : String
      {
         return AuthenticationTypes.authenticationStatusToString(status);
      }
      
      public function getDummyNavWeatherDetailsContainer() : NavWeatherDetailsContainer
      {
         return new NavWeatherDetailsContainer(null);
      }
      
      private function checkThrowErrorPopup() : Boolean
      {
         if(!this.mHelperStatus.ttlsUConnectACNAvailable())
         {
            return true;
         }
         return false;
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return true;
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
   }
}

