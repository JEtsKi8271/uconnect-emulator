package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.DataServicesSubscriptionStatus;
   import com.nfuzion.moduleLinkAPI.SatelliteRadioEvent;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import events.WidgetEvent;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class TravelLinkMainScreen extends GenericScreen
   {
      
      public function TravelLinkMainScreen()
      {
         mView = new C_TravelLinkMainScreenView();
         super();
         mView.btnBack_button.enabled = true;
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(mView.btnBack_button,WidgetEvent.CLICK,this.onBackBtnClick);
         attachListener(mView.btnClose_button,WidgetEvent.CLICK,close);
         attachListener(mView.btnFuel_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(mView.btnMovies_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(mView.btnSports_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(mView.btnWeather_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(mView.btnFavs_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(mView.btnSirius_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(mView.btnWeatherMap_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(mView.btnTraffic_button,WidgetEvent.CLICK,this.gotoScreen);
         attachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS,this.onSubscriptionEvent);
         attachListener(Peripheral.satelliteRadio,SatelliteRadioEvent.ADVISORY_MESSAGE,this.onSubscriptionEvent);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.btnWeather_button.value_label,T.STRB_WEATHER);
         t(mView.btnFavs_button.value_label,T.STRB_MY_FAVORITES);
         t(mView.btnSports_button.value_label,T.STRB_SPORTS);
         t(mView.btnMovies_button.value_label,T.STRB_MOVIE_LISTINGS);
         t(mView.btnFuel_button.value_label,T.STRB_FUEL_PRICES);
         t(mView.btnSirius_button.value_label,T.STRB_SUBSCRIPTION);
         t(mView.titleBar.labelValue,T.STRB_TRAVEL_LINK);
         t(mView.btnWeatherMap_button.value_label,T.STRB_WEATHER_MAP_1);
      }
      
      override protected function initView() : void
      {
         super.initView();
         Peripheral.satelliteRadio.requestSubscribed();
         mView.btnFuel_button.branch = "mainbackground/menu/travellinkfuelscreen";
         mView.btnMovies_button.branch = "mainbackground/menu/travellinkmoviesscreen";
         mView.btnSports_button.branch = "mainbackground/menu/travellinksportsscreen";
         mView.btnWeather_button.branch = "mainbackground/menu/travellinkweatherscreen";
         mView.btnFavs_button.branch = "mainbackground/menu/travelLinkFavoritesScreen";
         mView.btnSirius_button.branch = Screens.SAT_SUBSCRIPTION;
         mView.btnWeatherMap_button.branch = "mainbackground/menu/travellinkgraphicalweather";
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         if(0 == Peripheral.satelliteRadio.totalInterest(SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS))
         {
            Peripheral.satelliteRadio.addInterest(SatelliteRadioEvent.DATA_SERVICE_SUBSCRIPTION_STATUS);
         }
         this.onSpeedLockout(null);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.btnFuel_button,mView.btnMovies_button,mView.btnSports_button,mView.btnWeather_button,mView.btnFavs_button,mView.btnSirius_button,mView.btnWeatherMap_button,mView.btnTraffic_button]));
      }
      
      private function gotoScreen(evt:WidgetEvent) : void
      {
         var args:Object = null;
         var subscribed:int = int(DataServicesSubscriptionStatus.subscribedUnknown);
         var subjectToSpeedLockout:Boolean = false;
         switch(evt.target.name)
         {
            case "btnFuel_button":
               subscribed = int(Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_FUEL));
               break;
            case "btnMovies_button":
               subscribed = int(Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_MOVIES));
               subjectToSpeedLockout = true;
               break;
            case "btnSports_button":
               subscribed = int(Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_SPORTS));
               subjectToSpeedLockout = true;
               break;
            case "btnWeather_button":
               subscribed = int(Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_WEATHER));
               break;
            case "btnFavs_button":
               subscribed = int(Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_TRAVELLINK));
               break;
            case "btnSirius_button":
               subscribed = int(DataServicesSubscriptionStatus.subscribedYes);
               args = new Object();
               args.fromTravelLink = true;
               break;
            case "btnWeatherMap_button":
               subscribed = int(Peripheral.satelliteRadio.subscriptionStatus(Peripheral.satelliteRadio.SUBSCRIPTION_GRAPHICAL_WEATHER));
               break;
            case "btnTraffic_button":
               if(!Peripheral.navigation.navDomainControl.goToTmcScreenFromOutSideOfNavDomain())
               {
                  Framework.Trace("Navigation/TMC list not available!");
               }
               return;
         }
         this.gotoTLScreen(subscribed,subjectToSpeedLockout,evt.target.branch,args);
      }
      
      private function gotoTLScreen(subscribed:int, subjectToSpeedLockOut:Boolean, screen:String, args:Object = null) : void
      {
         switch(subscribed)
         {
            case DataServicesSubscriptionStatus.subscribedYes:
               if(subjectToSpeedLockOut && Boolean(Peripheral.vehicleStatus.speedLockOut))
               {
                  Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
               }
               else
               {
                  Framework.structure.setExit();
                  Framework.structure.goto(screen,args);
               }
               break;
            case DataServicesSubscriptionStatus.subscribedNo:
               Framework.popupManager.show(DynamicPopupNames.SIRIUS_TRAVEL_LINK_GENERIC,"popupstlgeneralinformation",{
                  "type":PopupType.PRIMARY,
                  "timeout":5000
               });
               break;
            case DataServicesSubscriptionStatus.subscribedUnknown:
            default:
               if(Peripheral.satelliteRadio.advisoryMessage == "CHECK ANTENNA")
               {
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.SATELLITE_AUDIO_ANTENNA_OPEN_OR_SHORT_CIRCUIT_CONDITION);
               }
               else if(Peripheral.satelliteRadio.advisoryMessage == "NO SIGNAL")
               {
                  Framework.popupManager.show(DynamicPopupNames.ERROR_ALERT,"errorpopupscreen",{
                     "type":PopupType.PRIMARY,
                     "title":T.STRB_ERROR_TITLE_SIRIUS,
                     "body":T.STRB_SAT_ACQUIRING_SIGNAL,
                     "closeButton":false,
                     "timeout":false
                  });
               }
               else if(Peripheral.satelliteRadio.advisoryMessage == "SUBSCRIPTION UPDATING")
               {
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.SUBSCRIPTION_UPDATE);
               }
               else
               {
                  Ancillary.definedDynamicPopups.show(DynamicPopupNames.DOWNLOADING_MESSAGE);
               }
         }
      }
      
      private function onSpeedLockout(e:VehicleStatusEvent) : void
      {
         var btnEnable:Boolean = Boolean(Peripheral.vehicleStatus.speedLockOut);
         mView.btnSports_button.setEnabled(!btnEnable);
         mView.btnMovies_button.setEnabled(!btnEnable);
      }
      
      private function onSubscriptionEvent(event:SatelliteRadioEvent) : void
      {
         Framework.popupManager.close();
      }
      
      private function onBackBtnClick(e:Event) : void
      {
         back();
      }
   }
}

