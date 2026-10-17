package com.harman.navigation.Controller.VoiceRecognition
{
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.harman.navigation.Controller.LI.LocationInputEvent;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerEvent;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.enums.LocationInputPath;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceHmiUtils;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.VoiceRecognitionEvent;
   import flash.events.EventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class VoiceRecognitionController extends EventDispatcher implements IVoiceRecognition
   {
      
      private static const AE_UNDEFINED:int = 0;
      
      private static const AE_LOCATION_INPUT:int = 1;
      
      private static const AE_POI_INPUT:int = 2;
      
      private static const AE_FAVORITE_INPUT:int = 3;
      
      private var mCurrentEntryLI:String = "";
      
      private var mCurrentEntryPOI:String = "";
      
      private var mCurrentEntryFAV:vrFavoriteEntry = new vrFavoriteEntry();
      
      private var mCurrentActiveEntry:int = 1;
      
      private var mNewSession:Boolean = true;
      
      private var mPreviousGuidanceState:Boolean = false;
      
      private var mListenerInterval:uint = 0;
      
      private var mAcceptDelayInterval:uint = 0;
      
      public function VoiceRecognitionController()
      {
         super();
         this.mListenerInterval = setInterval(this.onListenerInterval,5000);
      }
      
      public function getCurrentVoiceRecEntry() : void
      {
         this.sendEvent(VoiceRecognitionNavEvent.VR_CURRENT_ENTRY);
      }
      
      public function get currentVoiceRecEntry() : String
      {
         switch(this.mCurrentActiveEntry)
         {
            case AE_POI_INPUT:
               return this.mCurrentEntryPOI;
            case AE_FAVORITE_INPUT:
               return this.mCurrentEntryFAV.data;
            case AE_LOCATION_INPUT:
            case AE_UNDEFINED:
         }
         return this.mCurrentEntryLI;
      }
      
      public function repeatNavPrompt() : void
      {
         NavigationPackage.peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveMsg,false,0,true);
      }
      
      private function onVRDialogActiveMsg(e:VoiceRecognitionEvent) : void
      {
         var message:Object = e;
         var mVRActive:Boolean = Boolean(message.mData.vrDialogActive.state);
         Framework.Trace("onVrDialogActive: " + mVRActive);
         if(mVRActive == false)
         {
            NavigationPackage.peripheral.voiceRecognition.removeEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogActiveMsg);
            NavigationPackage.peripheral.navigation.navigation.navAdaRepeat();
         }
      }
      
      private function onGetProperties(e:HMIRequestEvent) : void
      {
         if(e.mData.getLDProperties.hasOwnProperty("type"))
         {
            switch(e.mData.getLDProperties.type)
            {
               case "LI_CurrentLD":
                  Framework.Trace("Nav.VRC: getLI_CurrentLD");
                  NavigationPackage.peripheral.hmiRequest.navSendGetPropertiesResponse(VServiceHmiUtils.performDoubleQuoteCheck(this.mCurrentEntryLI),"LI_CurrentLD",true);
                  break;
               case "POI_CurrentLD":
                  Framework.Trace("Nav.VRC: getPOI_CurrentLD");
                  NavigationPackage.peripheral.hmiRequest.navSendGetPropertiesResponse(VServiceHmiUtils.performDoubleQuoteCheck(this.mCurrentEntryPOI),"POI_CurrentLD",true);
                  break;
               case "LI_FavoriteLD":
                  Framework.Trace("Nav.VRC: getLI_FavoriteLD");
                  NavigationPackage.peripheral.hmiRequest.navSendGetPropertiesResponse(VServiceHmiUtils.performDoubleQuoteCheck(this.mCurrentEntryFAV.data),"LI_FavoriteLD",true);
                  break;
               default:
                  Framework.Trace("VoiceRecognitionController.onGetProperties() unknown type: " + e.mData.getLDProperties.type);
            }
         }
         else
         {
            Framework.Trace("VoiceRecognitionController.onGetProperties() no type: ");
         }
      }
      
      private function onSetProperties(e:HMIRequestEvent) : void
      {
         var formattedName:String = null;
         if(e.mData.setLDProperties != null && Boolean(e.mData.setLDProperties.hasOwnProperty("type")))
         {
            switch(e.mData.setLDProperties.type)
            {
               case "LI_CurrentLD":
                  this.mCurrentActiveEntry = AE_LOCATION_INPUT;
                  this.mCurrentEntryLI = String(e.mData.setLDProperties.LD);
                  Framework.Trace("Nav.VRC: setLI_CurrentLD: \'" + this.mCurrentEntryLI + "\'");
                  NavigationPackage.peripheral.hmiRequest.navSendSetPropertiesResponse("LI_CurrentLD",true);
                  break;
               case "POI_CurrentLD":
                  this.mCurrentActiveEntry = AE_POI_INPUT;
                  this.mCurrentEntryPOI = String(e.mData.setLDProperties.LD);
                  Framework.Trace("Nav.VRC: setPOI_CurrentLD: \'" + this.mCurrentEntryPOI + "\'");
                  NavigationPackage.peripheral.hmiRequest.navSendSetPropertiesResponse("POI_CurrentLD",true);
                  break;
               case "LI_FavoriteLD":
                  this.mCurrentActiveEntry = AE_FAVORITE_INPUT;
                  formattedName = "";
                  if(e.mData.setLDProperties.hasOwnProperty("formattedName"))
                  {
                     formattedName = e.mData.setLDProperties.formattedName as String;
                  }
                  this.mCurrentEntryFAV.setup(formattedName,e.mData.setLDProperties.LD as String);
                  Framework.Trace("Nav.VRC: setLI_FavoriteLD: \'" + this.mCurrentEntryFAV.data + "\'");
                  NavigationPackage.peripheral.hmiRequest.navSendSetPropertiesResponse("LI_FavoriteLD",true);
                  break;
               default:
                  this.mCurrentActiveEntry = AE_LOCATION_INPUT;
                  Framework.Trace("HMIRequest.setLDProperties() unknown type: " + e.mData.setLDProperties.type);
                  NavigationPackage.peripheral.hmiRequest.navSendSetPropertiesResponse(String(e.mData.setLDProperties.type),false);
            }
            this.sendEvent(VoiceRecognitionNavEvent.VR_CURRENT_ENTRY);
         }
         else
         {
            Framework.Trace("HMIRequest.setLDProperties() no type: ");
            NavigationPackage.peripheral.hmiRequest.navSendSetPropertiesResponse("no type",false);
         }
      }
      
      private function onAcceptProperties(e:HMIRequestEvent) : void
      {
         var locDesc:LocationDescription = null;
         Framework.Trace("onAcceptProperties " + this.mCurrentActiveEntry);
         var locDet:LocationDetails = new LocationDetails();
         locDet.addEisString(NavigationPackage.peripheral.navigation.navVoiceRecognition.currentVoiceRecEntry);
         this.indicateEndDestinationEntrySession();
         this.checkDefaultCountryStateChange();
         if(this.mCurrentActiveEntry == AE_LOCATION_INPUT)
         {
            NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_INVALID_GEO_COODRINATE,this.onGetDetailsFailed,false,0,true);
            NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_VALID_GEO_COODRINATE,this.onGetDetailsSuccess,false,0,true);
            NavigationPackage.peripheral.navigation.navTripAssembler.setSecondaryMode(TripAssemblerMode.UNDEFINED);
            NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_VOICE_RECKONED);
            NavigationPackage.peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_VR_DESTINATION);
            NavigationPackage.peripheral.navigation.navLocationInput.liSetGeoLocation(locDet);
         }
         else
         {
            locDesc = new LocationDescription();
            locDesc.setPrimaryLocation(locDet);
            locDesc.setSecondaryLocation(locDet);
            if(this.mCurrentActiveEntry == AE_FAVORITE_INPUT && this.mCurrentEntryFAV.name != "")
            {
               locDesc.setName(this.mCurrentEntryFAV.name);
            }
            NavigationPackage.peripheral.navigation.navTripAssembler.setSecondaryMode(TripAssemblerMode.UNDEFINED);
            NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_VOICE_RECKONED);
            NavigationPackage.peripheral.navigation.navTripAssembler.addLocationDescription(locDesc);
            this.registerOnCalculationProgress();
         }
      }
      
      private function onStopGuidance(e:HMIRequestEvent) : void
      {
         Framework.Trace("VoiceRecognitionController.onStopGuidance()");
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState == true)
         {
            NavigationPackage.peripheral.navigation.navRouteCalculation.stopGuidance();
            NavigationPackage.peripheral.hmiRequest.navStopGuidanceReturnResult("success");
         }
         else
         {
            NavigationPackage.peripheral.hmiRequest.navStopGuidanceReturnResult("invalid");
         }
      }
      
      private function onGetGuidanceState(e:HMIRequestEvent) : void
      {
         Framework.Trace("VoiceRecognitionController.onGetGuidanceState()");
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState == true)
         {
            NavigationPackage.peripheral.hmiRequest.navSendRouteGuidanceStatusResponse("active");
         }
         else
         {
            NavigationPackage.peripheral.hmiRequest.navSendRouteGuidanceStatusResponse("inactive");
         }
      }
      
      private function onGuidanceState(e:RouteCalculationEvent) : void
      {
         if(this.mPreviousGuidanceState != NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
         {
            this.mPreviousGuidanceState = NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState;
            if(this.mPreviousGuidanceState == true)
            {
               NavigationPackage.peripheral.hmiRequest.navSignalRouteGuidanceStatus("active");
            }
            else
            {
               NavigationPackage.peripheral.hmiRequest.navSignalRouteGuidanceStatus("inactive");
            }
         }
      }
      
      private function onDefaultCountryChange(e:LocationInputEvent) : void
      {
         this.mCurrentEntryLI = NavigationPackage.peripheral.navigation.navLocationInput.liDefaultCountry + NavigationPackage.peripheral.navigation.navLocationInput.liDefaultState;
         Framework.Trace("VoiceRecognitionController.onDefaultCountryChange() " + this.mCurrentEntryLI);
         NavigationPackage.peripheral.hmiRequest.navSignalCountryChanged();
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new VoiceRecognitionNavEvent(eventType));
      }
      
      private function onGetDetailsFailed(e:LocationInputEvent) : void
      {
         Framework.Trace("VoiceRecognitionController.onGetDetailsFailed()");
         this.mAcceptDelayInterval = setInterval(this.acceptDetailsDelayDeclineIntervall,NavGlobalSettings.VR_ACCEPT_PROP_LD_RESPONSE_TIME);
         this.unsubscribeGetDetailsCheck();
      }
      
      private function onGetDetailsSuccess(e:LocationInputEvent) : void
      {
         Framework.Trace("VoiceRecognitionController.onGetDetailsSuccess()");
         this.registerOnCalculationProgress();
      }
      
      private function registerOnCalculationProgress() : void
      {
         NavigationPackage.peripheral.navigation.navTripAssembler.addEventListener(TripAssemblerEvent.TRIP_CALCULATION_PROGRESS,this.onCalculationProgress,false,0,true);
         NavigationPackage.peripheral.navigation.navTripAssembler.addEventListener(TripAssemblerEvent.TRIP_CALCULATION_FAILED,this.onCalculationFailed,false,0,true);
         NavigationPackage.peripheral.navigation.navTripAssembler.getCalculationProgress();
         this.unsubscribeGetDetailsCheck();
      }
      
      private function unsubscribeGetDetailsCheck() : void
      {
         NavigationPackage.peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_INVALID_GEO_COODRINATE,this.onGetDetailsFailed);
         NavigationPackage.peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_VALID_GEO_COODRINATE,this.onGetDetailsSuccess);
      }
      
      private function unsubscribeCalculationProgress() : void
      {
         NavigationPackage.peripheral.navigation.navTripAssembler.removeEventListener(TripAssemblerEvent.TRIP_CALCULATION_PROGRESS,this.onCalculationProgress);
         NavigationPackage.peripheral.navigation.navTripAssembler.removeEventListener(TripAssemblerEvent.TRIP_CALCULATION_FAILED,this.onCalculationFailed);
      }
      
      private function onCalculationProgress(e:TripAssemblerEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navTripAssembler.calculationProgress >= 100)
         {
            this.unsubscribeCalculationProgress();
            this.acceptDetailsAccept();
         }
      }
      
      private function onCalculationFailed(e:TripAssemblerEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navTripAssembler.calculationFailed == true)
         {
            this.unsubscribeCalculationProgress();
            this.acceptDetailsDelayDeclineIntervall();
         }
      }
      
      private function onListenerInterval() : void
      {
         if(NavigationPackage.peripheral.hmiRequest != null)
         {
            clearInterval(this.mListenerInterval);
            NavigationPackage.peripheral.hmiRequest.addEventListener(HMIRequestEvent.GET_PROP_LD,this.onGetProperties,false,0,true);
            NavigationPackage.peripheral.hmiRequest.addEventListener(HMIRequestEvent.SET_PROP_LD,this.onSetProperties,false,0,true);
            NavigationPackage.peripheral.hmiRequest.addEventListener(HMIRequestEvent.ACCEPT_PROP_LD,this.onAcceptProperties,false,0,true);
            NavigationPackage.peripheral.hmiRequest.addEventListener(HMIRequestEvent.STOP_GUIDANCE,this.onStopGuidance,false,0,true);
            NavigationPackage.peripheral.hmiRequest.addEventListener(HMIRequestEvent.GET_GUIDANCE_STATE,this.onGetGuidanceState,false,0,true);
            NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onGuidanceState,false,0,true);
            NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_DEFAULT_COUNTRY_CHANGE,this.onDefaultCountryChange,false,0,true);
            NavigationPackage.peripheral.navigation.navRouteCalculation.getActiveRouteGuidanceState();
            NavigationPackage.peripheral.navigation.navLocationInput.liGetDefaultCountry();
            if(NavigationPackage.peripheral.navigation.navLocationInput.liInputPath != LocationInputPath.UNDEFINED)
            {
               this.mCurrentEntryLI = NavigationPackage.peripheral.navigation.navLocationInput.liGetCurrentInputProgress();
            }
            else
            {
               this.mCurrentEntryLI = NavigationPackage.peripheral.navigation.navLocationInput.liDefaultCountry + NavigationPackage.peripheral.navigation.navLocationInput.liDefaultState;
            }
         }
      }
      
      private function acceptDetailsAccept() : void
      {
         NavigationPackage.peripheral.hmiRequest.navSendAcceptPropertiesResponse(true);
      }
      
      private function acceptDetailsDelayDeclineIntervall() : void
      {
         NavigationPackage.peripheral.hmiRequest.navSendAcceptPropertiesResponse(false);
         clearInterval(this.mAcceptDelayInterval);
      }
      
      private function checkDefaultCountryStateChange() : void
      {
         Framework.Trace("Nav.checkDefaultCountryStateChange() \'" + this.mCurrentEntryLI + "\'->\'" + NavigationPackage.peripheral.navigation.navLocationInput.liDefaultCountry + "\'");
         if(EisHelper.getValueOfType(this.mCurrentEntryLI,"<CTR_NNG>") != "" && EisHelper.getValueOfType(this.mCurrentEntryLI,"<CTR_NNG>") != EisHelper.getValueOfType(NavigationPackage.peripheral.navigation.navLocationInput.liDefaultCountry,"<CTR_NNG>"))
         {
            Framework.Trace(" -Change DefaultCountry");
            NavigationPackage.peripheral.navigation.navLocationInput.setDefaultCountry("<CTR>" + EisHelper.getValueOfType(this.mCurrentEntryLI,"<CTR>") + "<*>" + "<CTR_NNG>" + EisHelper.getValueOfType(this.mCurrentEntryLI,"<CTR_NNG>") + "<*>");
            if(EisHelper.getValueOfType(this.mCurrentEntryLI,"<STA_NNG>") == "" || this.mCurrentEntryLI.indexOf("<STA_NNG>") < 0)
            {
               Framework.Trace(" -Clearing State");
               NavigationPackage.peripheral.navigation.navLocationInput.setDefaultState("");
            }
         }
         if(EisHelper.getValueOfType(this.mCurrentEntryLI,"<STA_NNG>") != "" && EisHelper.getValueOfType(this.mCurrentEntryLI,"<STA_NNG>") != EisHelper.getValueOfType(NavigationPackage.peripheral.navigation.navLocationInput.liDefaultState,"<STA_NNG>"))
         {
            NavigationPackage.peripheral.navigation.navLocationInput.setDefaultState("<STA>" + EisHelper.getValueOfType(this.mCurrentEntryLI,"<STA>") + "<*>" + "<STA_NNG>" + EisHelper.getValueOfType(this.mCurrentEntryLI,"<STA_NNG>") + "<*>");
         }
      }
      
      private function shutDown() : void
      {
         NavigationPackage.peripheral.hmiRequest.removeEventListener(HMIRequestEvent.GET_PROP_LD,this.onGetProperties);
         NavigationPackage.peripheral.hmiRequest.removeEventListener(HMIRequestEvent.SET_PROP_LD,this.onSetProperties);
         NavigationPackage.peripheral.hmiRequest.removeEventListener(HMIRequestEvent.ACCEPT_PROP_LD,this.onAcceptProperties);
         NavigationPackage.peripheral.hmiRequest.removeEventListener(HMIRequestEvent.STOP_GUIDANCE,this.onStopGuidance);
         NavigationPackage.peripheral.hmiRequest.removeEventListener(HMIRequestEvent.GET_GUIDANCE_STATE,this.onGetGuidanceState);
         NavigationPackage.peripheral.navigation.navRouteCalculation.removeEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE,this.onGuidanceState);
         NavigationPackage.peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_DEFAULT_COUNTRY_CHANGE,this.onDefaultCountryChange);
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
      
      public function indicateNewDestinationEntrySessionForDefaultCountryRecovery() : void
      {
         NavigationPackage.peripheral.voiceRecognition.addEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogAbortMsg,false,0,true);
      }
      
      private function indicateEndDestinationEntrySession() : void
      {
         NavigationPackage.peripheral.voiceRecognition.removeEventListener(VoiceRecognitionEvent.VR_DIALOG_ACTIVE_MESSAGE,this.onVRDialogAbortMsg);
      }
      
      private function onVRDialogAbortMsg(e:VoiceRecognitionEvent) : void
      {
         var message:Object = e;
         var mVRActive:Boolean = Boolean(message.mData.vrDialogActive.state);
         Framework.Trace("onVRDialogAbortMsg: " + mVRActive);
         if(mVRActive == false)
         {
            this.checkCountryStateChangeOnSessionAbort();
            this.indicateEndDestinationEntrySession();
         }
      }
      
      private function checkCountryStateChangeOnSessionAbort() : void
      {
         if(EisHelper.getValueOfType(this.mCurrentEntryLI,"<CTR_NNG>") != EisHelper.getValueOfType(NavigationPackage.peripheral.navigation.navLocationInput.liDefaultCountry,"<CTR_NNG>") || EisHelper.getValueOfType(this.mCurrentEntryLI,"<STA_NNG>") != EisHelper.getValueOfType(NavigationPackage.peripheral.navigation.navLocationInput.liDefaultState,"<STA_NNG>"))
         {
            this.switchVrDefaultsBackToHmiDefaults();
         }
      }
      
      private function switchVrDefaultsBackToHmiDefaults() : void
      {
         this.mCurrentEntryLI = NavigationPackage.peripheral.navigation.navLocationInput.liDefaultCountry + NavigationPackage.peripheral.navigation.navLocationInput.liDefaultState;
         NavigationPackage.peripheral.hmiRequest.navSignalCountryChanged();
      }
   }
}

class vrFavoriteEntry
{
   
   public var data:String;
   
   public var name:String;
   
   public function vrFavoriteEntry(entryName:String = "", entryData:String = "")
   {
      super();
      this.setup(entryName,entryData);
   }
   
   public function setup(entryName:String = "", entryData:String = "") : void
   {
      this.name = entryName;
      this.data = entryData;
   }
}
