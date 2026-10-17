package com.harman.navigation.global
{
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestinationsApi;
   import com.harman.navigation.Controller.FavoriteDestinations.FavoriteDestinationsImpl;
   import com.harman.navigation.Controller.FavoriteDestinations.IFavoriteDestinations;
   import com.harman.navigation.Controller.GeoCoordinate.GeoCoordinateApi;
   import com.harman.navigation.Controller.GeoCoordinate.GeoCoordinateImpl;
   import com.harman.navigation.Controller.GeoCoordinate.IGeoCoordinate;
   import com.harman.navigation.Controller.HomeAddress.HomeAddressApi;
   import com.harman.navigation.Controller.HomeAddress.HomeAddressImpl;
   import com.harman.navigation.Controller.HomeAddress.IHomeAddress;
   import com.harman.navigation.Controller.Interchange.IInterchange;
   import com.harman.navigation.Controller.Interchange.InterchangeApi;
   import com.harman.navigation.Controller.Interchange.InterchangeImpl;
   import com.harman.navigation.Controller.LI.ILocationInput;
   import com.harman.navigation.Controller.LI.LocationInputApi;
   import com.harman.navigation.Controller.LI.LocationInputImpl;
   import com.harman.navigation.Controller.LiveServices.ILiveServices;
   import com.harman.navigation.Controller.LiveServices.LiveServicesApi;
   import com.harman.navigation.Controller.LiveServices.LiveServicesImpl;
   import com.harman.navigation.Controller.MAP.IMapControl;
   import com.harman.navigation.Controller.MAP.MapControllerApi;
   import com.harman.navigation.Controller.MAP.MapControllerImpl;
   import com.harman.navigation.Controller.NDR.INDRControl;
   import com.harman.navigation.Controller.NDR.NDRControlApi;
   import com.harman.navigation.Controller.NDR.NDRControlImpl;
   import com.harman.navigation.Controller.POI.IPoiInput;
   import com.harman.navigation.Controller.POI.PoiInputApi;
   import com.harman.navigation.Controller.POI.PoiInputImpl;
   import com.harman.navigation.Controller.Persistence.IPersistence;
   import com.harman.navigation.Controller.Persistence.PersistenceApi;
   import com.harman.navigation.Controller.Persistence.PersistenceImpl;
   import com.harman.navigation.Controller.ProductActivation.IProductActivation;
   import com.harman.navigation.Controller.ProductActivation.ProductActivationApi;
   import com.harman.navigation.Controller.ProductActivation.ProductActivationImpl;
   import com.harman.navigation.Controller.RecentDestinations.IRecentDestinations;
   import com.harman.navigation.Controller.RecentDestinations.RecentDestinationsApi;
   import com.harman.navigation.Controller.RecentDestinations.RecentDestinationsImpl;
   import com.harman.navigation.Controller.RouteCalculation.IRouteCalculation;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationApi;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationImpl;
   import com.harman.navigation.Controller.TripAssembler.ITripAssembler;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerApi;
   import com.harman.navigation.Controller.TripAssembler.TripAssemblerImpl;
   import com.harman.navigation.Controller.Trips.ITrips;
   import com.harman.navigation.Controller.Trips.TripsApi;
   import com.harman.navigation.Controller.Trips.TripsImpl;
   import com.harman.navigation.Controller.VoiceRecognition.IVoiceRecognition;
   import com.harman.navigation.Controller.VoiceRecognition.VoiceRecognitionApi;
   import com.harman.navigation.Controller.VoiceRecognition.VoiceRecognitionImpl;
   import com.harman.navigation.DomainControl.INavDomain;
   import com.harman.navigation.DomainControl.NavDomainControlApi;
   import com.harman.navigation.DomainControl.NavDomainControlImpl;
   import com.harman.navigation.INavigation;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.StartupState;
   import com.harman.navigation.global.vServices.VServiceContainer;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   
   use namespace NavigationNamespace;
   
   public class NavigationPackage extends Module
   {
      
      public static var peripheral:*;
      
      public static var ancillary:*;
      
      public static var dynamicPopupNames:*;
      
      public static var translations:*;
      
      private var mVServiceContainer:VServiceContainer = new VServiceContainer();
      
      private var mReEnterNavDomainAfterReinitialize:Boolean = false;
      
      public function NavigationPackage()
      {
         super();
         this.init();
      }
      
      public function reinitialize() : void
      {
         Framework.Trace("~~~~~~~~~ NavigationPackage.reinitialize() ~~~~~~~~~");
         if(NavigationPackage.peripheral.navigation.navDomainControl.navDomainActive)
         {
            this.mReEnterNavDomainAfterReinitialize = true;
            Framework.structure.goto("mainbackground/menu/navpopupgenericscreen",null,false);
         }
         this.mVServiceContainer = new VServiceContainer();
         NavigationImpl.erase();
         PersistenceImpl.erase();
         TripAssemblerImpl.erase();
         MapControllerImpl.erase();
         LocationInputImpl.erase();
         VoiceRecognitionImpl.erase();
         TripsImpl.erase();
         NavDomainControlImpl.erase();
         RouteCalculationImpl.erase();
         InterchangeImpl.erase();
         LiveServicesImpl.erase();
         PoiInputImpl.erase();
         RecentDestinationsImpl.erase();
         HomeAddressImpl.erase();
         FavoriteDestinationsImpl.erase();
         GeoCoordinateImpl.erase();
         this.init();
      }
      
      private function init() : void
      {
         NDRControlApi.impl = NDRControlImpl.create();
         NavigationApi.impl = NavigationImpl.create();
         NavDomainControlApi.impl = NavDomainControlImpl.create();
         if(this.mReEnterNavDomainAfterReinitialize)
         {
            this.mReEnterNavDomainAfterReinitialize = false;
            NavigationPackage.peripheral.navigation.navDomainControl.onNavDomainButton();
         }
         NavigationApi.api.addEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onStartupState,false,0,true);
         this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
      }
      
      override public function isReady() : Boolean
      {
         return true;
      }
      
      public function get navigation() : INavigation
      {
         return NavigationApi.api;
      }
      
      public function get navDomainControl() : INavDomain
      {
         return NavDomainControlApi.api;
      }
      
      public function get navTripAssembler() : ITripAssembler
      {
         return TripAssemblerApi.api;
      }
      
      public function get navLocationInput() : ILocationInput
      {
         return LocationInputApi.api;
      }
      
      public function get navPoiInput() : IPoiInput
      {
         return PoiInputApi.api;
      }
      
      public function get navMapControl() : IMapControl
      {
         return MapControllerApi.api;
      }
      
      public function get navRecentDestinations() : IRecentDestinations
      {
         return RecentDestinationsApi.api;
      }
      
      public function get navRouteCalculation() : IRouteCalculation
      {
         return RouteCalculationApi.api;
      }
      
      public function get navPersistence() : IPersistence
      {
         return PersistenceApi.api;
      }
      
      public function get navNDR() : INDRControl
      {
         return NDRControlApi.api;
      }
      
      public function get navTrips() : ITrips
      {
         return TripsApi.api;
      }
      
      public function get navHomeAddress() : IHomeAddress
      {
         return HomeAddressApi.api;
      }
      
      public function get navGeoCoordinate() : IGeoCoordinate
      {
         return GeoCoordinateApi.api;
      }
      
      public function get navVoiceRecognition() : IVoiceRecognition
      {
         return VoiceRecognitionApi.api;
      }
      
      public function get navFavoriteDestinations() : IFavoriteDestinations
      {
         return FavoriteDestinationsApi.api;
      }
      
      public function get navProductActivation() : IProductActivation
      {
         return ProductActivationApi.api;
      }
      
      public function get navInterchange() : IInterchange
      {
         return InterchangeApi.api;
      }
      
      public function get navLiveServices() : ILiveServices
      {
         return LiveServicesApi.api;
      }
      
      public function get navVServices() : VServiceContainer
      {
         return this.mVServiceContainer;
      }
      
      private function onStartupState(e:NavigationEvent) : void
      {
         if(NavigationApi.api.navStartupState == StartupState.LOCKED)
         {
            ProductActivationApi.impl = ProductActivationImpl.create();
         }
         if(NavigationApi.api.navStartupState >= StartupState.PARTIALLY_READY)
         {
            NavigationApi.api.removeEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onStartupState);
            PersistenceApi.impl = PersistenceImpl.create();
            RouteCalculationApi.impl = RouteCalculationImpl.create();
            TripAssemblerApi.impl = TripAssemblerImpl.create();
            LocationInputApi.impl = LocationInputImpl.create();
            MapControllerApi.impl = MapControllerImpl.create();
            PoiInputApi.impl = PoiInputImpl.create();
            RecentDestinationsApi.impl = RecentDestinationsImpl.create();
            TripsApi.impl = TripsImpl.create();
            HomeAddressApi.impl = HomeAddressImpl.create();
            GeoCoordinateApi.impl = GeoCoordinateImpl.create();
            VoiceRecognitionApi.impl = VoiceRecognitionImpl.create();
            FavoriteDestinationsApi.impl = FavoriteDestinationsImpl.create();
            InterchangeApi.impl = InterchangeImpl.create();
            LiveServicesApi.impl = LiveServicesImpl.create();
         }
      }
   }
}

