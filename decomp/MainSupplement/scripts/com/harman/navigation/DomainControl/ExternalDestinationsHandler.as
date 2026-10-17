package com.harman.navigation.DomainControl
{
   import com.harman.moduleLinkAPI.HMIRequestEvent;
   import com.harman.navigation.Controller.LI.LocationInputEvent;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerEvent;
   import com.harman.navigation.enums.LocationInputPath;
   import com.harman.navigation.enums.TripAssemblerMode;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class ExternalDestinationsHandler
   {
      
      private static var mBackFunction:String = "";
      
      private var mListenerInterval:uint = 0;
      
      public function ExternalDestinationsHandler()
      {
         super();
         this.mListenerInterval = setInterval(this.onListerInterval,5000);
      }
      
      public static function get backFunction() : String
      {
         return mBackFunction;
      }
      
      public function setExternalDestination(dest:String, backFunction:String) : Boolean
      {
         this.setDestination(dest,backFunction);
         return true;
      }
      
      private function setDestination(dest:String, backFunction:String) : void
      {
         mBackFunction = backFunction;
         var loc:LocationDetails = new LocationDetails();
         loc.addEisString(dest);
         var customName:String = EisHelper.getValueOfType(dest,"<CUSTOM_NAME>");
         if(customName != "")
         {
            loc.setCustomName(customName);
         }
         Framework.Trace("External GEO: (" + loc.getType("<GEO>") + ")");
         if(loc.getType("<GEO>") == "")
         {
            NavigationPackage.peripheral.hmiRequest.navRouteToLocationReturnResult(false);
            return;
         }
         NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_INVALID_GEO_COODRINATE,this.onGetDetailsFailed,false,0,true);
         NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_VALID_GEO_COODRINATE,this.onGetDetailsSuccess,false,0,true);
         NavigationPackage.peripheral.navigation.navTripAssembler.setDestinationMode(TripAssemblerMode.DESTINATION_SET_EXTERNAL);
         NavigationPackage.peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.ENTER_GEO_COORDINATE);
         NavigationPackage.peripheral.navigation.navLocationInput.liSetGeoLocation(loc);
      }
      
      private function onGetDetailsFailed(e:LocationInputEvent) : void
      {
         Framework.Trace("ExternalDestinationsHandler.onGetDetailsFailed()");
         NavigationPackage.peripheral.hmiRequest.navRouteToLocationReturnResult(false);
         this.unsubscribeGetDetailsCheck();
      }
      
      private function onGetDetailsSuccess(e:LocationInputEvent) : void
      {
         Framework.Trace("ExternalDestinationsHandler.onGetDetailsSuccess()");
         NavigationPackage.peripheral.hmiRequest.navRouteToLocationReturnResult(true);
         NavigationPackage.peripheral.navigation.navTripAssembler.addEventListener(TripAssemblerEvent.TRIP_CALCULATION_PROGRESS,this.onCalculationProgress,false,0,true);
         NavigationPackage.peripheral.navigation.navTripAssembler.addEventListener(TripAssemblerEvent.TRIP_CALCULATION_FAILED,this.onCalculationFailed,false,0,true);
         NavigationPackage.peripheral.navigation.navTripAssembler.getCalculationProgress();
         this.unsubscribeGetDetailsCheck();
      }
      
      private function unsubscribeGetDetailsCheck() : void
      {
         NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_INVALID_GEO_COODRINATE,this.onGetDetailsFailed,false,0,true);
         NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_VALID_GEO_COODRINATE,this.onGetDetailsSuccess,false,0,true);
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
            Framework.Trace("ExternalDestinationHandler.onCalculationProgress()");
            this.unsubscribeCalculationProgress();
         }
      }
      
      private function onCalculationFailed(e:TripAssemblerEvent) : void
      {
         if(NavigationPackage.peripheral.navigation.navTripAssembler.calculationFailed)
         {
            this.unsubscribeCalculationProgress();
            Framework.Trace("ExternalDestinationHandler.onCalculationFailed()");
         }
      }
      
      private function onListerInterval() : void
      {
         if(NavigationPackage.peripheral.hmiRequest != null)
         {
            NavigationPackage.peripheral.hmiRequest.addEventListener(HMIRequestEvent.ROUTE_TO_LOCATION,this.onRouteToLocation,false,0,true);
            clearInterval(this.mListenerInterval);
         }
      }
      
      private function onRouteToLocation(e:HMIRequestEvent) : void
      {
         var locParms:Object = null;
         if(NavigationPackage.peripheral.navigation.navDomainControl.navIsOperable)
         {
            locParms = e.mData.routeToLocation;
            Framework.Trace("ExternalDestinationsHandler.onRouteToLocation( " + locParms.toString() + " )");
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenuStackPassive(0);
            if(!NavigationPackage.peripheral.navigation.navDomainControl.navDomainActive)
            {
               NavigationPackage.peripheral.navigation.navDomainControl.onNavDomainButton();
            }
            this.setDestination(locParms.toString(),NavGlobalSettings.EXTERNAL_DESTINATION_ON_BACK_SCREEN);
         }
         else
         {
            NavigationPackage.peripheral.hmiRequest.navRouteToLocationReturnResult(false);
         }
      }
   }
}

