package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Style;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.harman.navigation.NavigationEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.moduleLinkAPI.BluetoothDevice;
   import core.events.MessageEvent;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   public class TravelLinkGenericScreen extends GenericScreen
   {
      
      protected static const FAVORITES_BUTTON:String = "favorites_button";
      
      protected static const FAVORITES_SCREEN:String = "mainbackground/menu/travelLinkFavoritesScreen";
      
      protected static const PHONE_SCREEN:String = "mainbackground/menu/phonemainscreen";
      
      private static const conditionIconMap:Object = {
         "scatteredThunderstormsNight":"scatteredThunderstorms",
         "thunderstorms":"isolatedThunderstorms",
         "heavyRain":"rain",
         "scatteredShowersNight":"scatteredShowers",
         "showers":"rain",
         "lightRain":"rain",
         "mixedRainSnow":"winteryMix",
         "mixedRainHail":"freezingRain",
         "sleet":"mixedRainSleet",
         "icePellets":"hail",
         "snow":"moderateSnow",
         "heavySnow":"moderateSnow",
         "scatteredSnowShowers":"lightSnow",
         "snowShowers":"lightSnow",
         "lightFog":"foggy",
         "moderateFog":"foggy",
         "heavyFog":"foggy",
         "windy":"blustery",
         "partlyCloudy":"mostlySunny",
         "partlyCloudyNight":"mostlyClearNight",
         "funnelCloud":"tornado",
         "noData":"none",
         "unknownPrecipitation":"none"
      };
      
      private static const conditionMap:Object = {
         "noData":T.STRB_NO_DATA_AVAILABLE,
         "unknownPrecipitation":T.STRB_LWCOND_UNKNOWN_PRECIPITATION,
         "isolatedThunderstorms":T.STRB_LWCOND_ISOLATED_THUNDERSTORM,
         "scatteredThunderstorms":T.STRB_LWCOND_SCATTERED_THUNDERSTORMS,
         "scatteredThunderstormsNight":T.STRB_LWCOND_SCATTERED_THUNDERSTORMS,
         "severeThunderstorms":T.STRB_LWCOND_SEVERE_THUNDERSTORMS,
         "thunderstorms":T.STRB_LWCOND_THUNDERSTORMS,
         "rain":T.STRB_LWCOND_RAIN,
         "lightRain":T.STRB_LWCOND_LIGHT_RAIN,
         "heavyRain":T.STRB_LWCOND_HEAVY_RAIN,
         "scatteredShowers":T.STRB_LWCOND_SCATTERED_SHOWERS,
         "scatteredShowersNight":T.STRB_LWCOND_SCATTERED_SHOWERS,
         "showers":T.STRB_LWCOND_SHOWERS,
         "drizzle":T.STRB_LWCOND_DRIZZLE,
         "freezingDrizzle":T.STRB_LWCOND_FREEZING_DRIZZLE,
         "freezingRain":T.STRB_LWCOND_FREEZING_RAIN,
         "winteryMix":T.STRB_LWCOND_WINTRY_MIX,
         "mixedRainSnow":T.STRB_LWCOND_MIXED_RAIN_AND_SNOW,
         "mixedRainSleet":T.STRB_LWCOND_MIXED_RAIN_AND_SLEET,
         "mixedRainHail":T.STRB_LWCOND_MIXED_RAIN_AND_HAIL,
         "hail":T.STRB_LWCOND_HAIL,
         "sleet":T.STRB_LWCOND_SLEET,
         "icePellets":T.STRB_LWCOND_ICE_PELLETS,
         "flurries":T.STRB_LWCOND_FLURRIES,
         "lightSnow":T.STRB_LWCOND_LIGHT_SNOW,
         "moderateSnow":T.STRB_LWCOND_MODERATE_SNOW,
         "snow":T.STRB_LWCOND_SNOW,
         "heavySnow":T.STRB_LWCOND_HEAVY_SNOW,
         "scatteredSnowShowers":T.STRB_LWCOND_SCATTERED_SNOW_SHOWERS,
         "scatteredSnowShowersNight":T.STRB_LWCOND_SCATTERED_SNOW_SHOWERS,
         "snowShowers":T.STRB_LWCOND_SNOW_SHOWERS,
         "blowingSnow":T.STRB_LWCOND_BLOWING_SNOW,
         "blizzard":T.STRB_LWCOND_BLIZZARD,
         "sandstorm":T.STRB_LWCOND_SANDSTORM,
         "blowingDust":T.STRB_LWCOND_BLOWING_DUST,
         "dust":T.STRB_LWCOND_DUST,
         "foggy":T.STRB_LWCOND_FOGGY,
         "lightFog":T.STRB_LWCOND_LIGHT_FOG,
         "moderateFog":T.STRB_LWCOND_MODERATE_FOG,
         "heavyFog":T.STRB_LWCOND_HEAVY_FOG,
         "mist":T.STRB_LWCOND_MIST,
         "hazy":T.STRB_LWCOND_HAZY,
         "smoky":T.STRB_LWCOND_SMOKEY,
         "blustery":T.STRB_LWCOND_BLUSTERY,
         "windy":T.STRB_LWCOND_WINDY,
         "cold":T.STRB_LWCOND_COLD,
         "hot":T.STRB_LWCOND_HOT,
         "sunny":T.STRB_LWCOND_SUNNY,
         "mostlySunny":T.STRB_LWCOND_MOSTLY_SUNNY,
         "clearNight":T.STRB_LWCOND_CLEAR,
         "mostlyClearNight":T.STRB_LWCOND_CLEAR,
         "partlyCloudy":T.STRB_LWCOND_PARTLY_CLOUDY,
         "partlyCloudyNight":T.STRB_LWCOND_PARTLY_CLOUDY,
         "mostlyCloudy":T.STRB_LWCOND_MOSTLY_CLOUDY,
         "mostlyCloudyNight":T.STRB_LWCOND_MOSTLY_CLOUDY,
         "cloudy":T.STRB_LWCOND_CLOUDY,
         "tropicalStorm":T.STRB_LWCOND_TROPICAL_STORM,
         "hurricane":T.STRB_LWCOND_HURRICANE,
         "funnelCloud":T.STRB_LWCOND_FUNNEL_CLOUD,
         "tornado":T.STRB_LWCOND_TORNADO
      };
      
      private var mInitalPopupTimer:Timer = new Timer(Style.TravelLinkGenericScreen.DATA_DELAY_WARNING_THRESHOLD,Style.TravelLinkGenericScreen.DATA_DELAY_WARNING_REPEAT);
      
      private var mTimeoutPopupTimer:Timer = new Timer(Style.TravelLinkGenericScreen.DATA_DELAY_WARNING_TIMEOUT);
      
      private var mPleaseWaiting:Boolean = false;
      
      private var mPleaseWaitStopReq:Boolean = false;
      
      private var mFromTLFavScreen:Boolean = false;
      
      private var mJustAddedFavorite:Boolean = false;
      
      public function TravelLinkGenericScreen()
      {
         super();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Framework.messenger.onSend(this.onMessage);
         this.mInitalPopupTimer.addEventListener(TimerEvent.TIMER,this.onWaitingForData,false,0,true);
         this.mInitalPopupTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onWaitingForDataComplete,false,0,true);
         this.mTimeoutPopupTimer.addEventListener(TimerEvent.TIMER,this.onCloseWaitingForDataPopup,false,0,true);
         Peripheral.navigation.navigation.addEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPosition,false,int.MIN_VALUE,true);
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout,false,0,true);
      }
      
      override protected function initScreen() : void
      {
         this.JustAddedFavorite = false;
         this.isFromTLFavScreen = screenVars.fromFavoriteScreen == true;
         Framework.echo("isFromTLFavScreen = " + this.isFromTLFavScreen);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         Framework.messenger.removeOnSend(this.onMessage);
         this.mInitalPopupTimer.removeEventListener(TimerEvent.TIMER,this.onWaitingForData);
         this.mInitalPopupTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onWaitingForDataComplete);
         this.mTimeoutPopupTimer.removeEventListener(TimerEvent.TIMER,this.onCloseWaitingForDataPopup);
         Peripheral.navigation.navigation.removeEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPosition);
         Peripheral.vehicleStatus.removeEventListener(VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockout);
         this.stopWaiting();
         this.mFromTLFavScreen = false;
      }
      
      protected function get phoneAvailable() : Boolean
      {
         var phoneList:Vector.<BluetoothDevice> = Peripheral.bluetooth.getPairedDeviceListWithService("HFP");
         var hasPhone:Boolean = false;
         var phoneConnected:Boolean = false;
         for(var i:uint = 0; i < phoneList.length; i++)
         {
            if(phoneList[i].HfpAvailable == true)
            {
               hasPhone = true;
               break;
            }
         }
         if(null != Peripheral.bluetooth.currentHFPDevice)
         {
            phoneConnected = true;
         }
         return hasPhone && phoneConnected;
      }
      
      protected function dial(number:String) : void
      {
         if(this.phoneAvailable)
         {
            Peripheral.bluetoothPhone.dial(number);
            Framework.structure.goto(PHONE_SCREEN);
         }
      }
      
      protected function get isFromTLFavScreen() : Boolean
      {
         return this.mFromTLFavScreen;
      }
      
      protected function set isFromTLFavScreen(fromTLFavScreen:Boolean) : void
      {
         if(this.mFromTLFavScreen != fromTLFavScreen)
         {
            this.mFromTLFavScreen = fromTLFavScreen;
            this.onFromTLFavScreen(this.mFromTLFavScreen);
         }
      }
      
      protected function onFromTLFavScreen(fromTLFavScreen:Boolean) : void
      {
      }
      
      protected function set JustAddedFavorite(justAdded:Boolean) : void
      {
         this.mJustAddedFavorite = justAdded;
      }
      
      protected function get JustAddedFavorite() : Boolean
      {
         return this.mJustAddedFavorite;
      }
      
      private function onPosition(e:NavigationEvent) : void
      {
         var position:String = Peripheral.navigation.navigation.posPositionInformation.getType("<GEO>");
         var positionArray:Array = position.split(" ");
         var coordinates:Coordinates = new Coordinates();
         coordinates.longitude = Number(positionArray[0]);
         coordinates.latitude = Number(positionArray[1]);
         this.positionUpdate(coordinates);
      }
      
      protected function onSpeedLockout(e:VehicleStatusEvent) : void
      {
         Framework.Trace("TL: Speed Lockout Received");
      }
      
      protected function positionUpdate(coordinates:Coordinates) : void
      {
      }
      
      protected function mapCondition(condition:String) : String
      {
         if(conditionIconMap.hasOwnProperty(condition))
         {
            condition = conditionIconMap[condition];
         }
         return condition;
      }
      
      private function onWaitingForData(e:TimerEvent) : void
      {
         if(this.mPleaseWaiting == false)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.DOWNLOADING_FUEL);
            this.mPleaseWaiting = true;
         }
      }
      
      private function onWaitingForDataComplete(e:TimerEvent) : void
      {
         if(this.mPleaseWaitStopReq == true)
         {
            this.mInitalPopupTimer.reset();
            this.mTimeoutPopupTimer.reset();
            this.mPleaseWaitStopReq = false;
            this.mPleaseWaiting = false;
            Framework.popupManager.close();
         }
         else
         {
            this.mTimeoutPopupTimer.start();
         }
      }
      
      private function onCloseWaitingForDataPopup(e:TimerEvent) : void
      {
         this.mInitalPopupTimer.reset();
         this.mTimeoutPopupTimer.reset();
         this.mPleaseWaitStopReq = false;
         this.mPleaseWaiting = false;
         Framework.popupManager.close();
         this.onWaitingTimeout();
      }
      
      protected function startWaiting() : void
      {
         this.mInitalPopupTimer.start();
      }
      
      protected function stopWaiting() : void
      {
         if(this.mPleaseWaiting == false)
         {
            this.mInitalPopupTimer.reset();
            this.mTimeoutPopupTimer.reset();
            this.mPleaseWaitStopReq = false;
         }
         else if(this.mInitalPopupTimer.running)
         {
            this.mPleaseWaitStopReq = true;
         }
         else
         {
            this.mInitalPopupTimer.reset();
            this.mTimeoutPopupTimer.reset();
            this.mPleaseWaitStopReq = false;
            this.mPleaseWaiting = false;
            Framework.popupManager.close();
         }
      }
      
      protected function onWaitingTimeout() : void
      {
      }
      
      protected function addToFavoritesPopup(favData:Object) : void
      {
         Framework.popupManager.show(DynamicPopupNames.OPTIONS_FAVORITE_ADD,"addtofavoritespopup",favData);
      }
      
      protected function onConfirmedAddToFavorites() : void
      {
      }
      
      protected function onNotConfirmedAddToFavorites() : void
      {
      }
      
      protected function goTravelLink(e:MouseEvent = null) : void
      {
         Framework.structure.exit();
      }
      
      override protected function back(e:Event = null) : void
      {
         if(this.isFromTLFavScreen)
         {
            if(this.mJustAddedFavorite)
            {
               Framework.structure.returnTo(FAVORITES_SCREEN);
            }
            else
            {
               super.back(e);
            }
         }
         else if(Framework.popupManager.active == DynamicPopupNames.ALPHA_JUMP)
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
         }
         else
         {
            this.goTravelLink();
         }
      }
      
      protected function goFavorite(e:MouseEvent = null) : void
      {
         if(this.mFromTLFavScreen == false)
         {
            Framework.structure.goto(FAVORITES_SCREEN,null,false);
         }
      }
      
      protected function isBackAfterJustAddedFavorite() : Boolean
      {
         if(this.isFromTLFavScreen && this.JustAddedFavorite)
         {
            Framework.structure.returnTo(FAVORITES_SCREEN);
            return true;
         }
         return false;
      }
      
      private function onMessage(evt:MessageEvent) : void
      {
         if(evt == null)
         {
            return;
         }
         if(evt.message.type == "Travel Link")
         {
            if(evt.message.reply == "Yes")
            {
               this.onConfirmedAddToFavorites();
            }
            else
            {
               this.onNotConfirmedAddToFavorites();
            }
         }
      }
      
      protected function temperatureString(fahrenheitTemperature:Number) : String
      {
         var intTemp:int = 0;
         if(Peripheral.personalConfig.temperatureUnits == "US")
         {
            intTemp = Math.round(fahrenheitTemperature);
         }
         else
         {
            intTemp = Math.round(Format.fahrenheitToCelsius(fahrenheitTemperature));
         }
         return intTemp.toString() + "°";
      }
      
      protected function useUSDistanceUnits() : Boolean
      {
         return Peripheral.personalConfig.distanceUnits == "miles";
      }
      
      protected function useUSMilageUnits() : Boolean
      {
         return Peripheral.personalConfig.speedUnits == "mph";
      }
      
      protected function translateDayIndexToString(dayIndex:int) : String
      {
         switch(dayIndex)
         {
            case 0:
               return compose(T.STRB_SUNDAY_ABB);
            case 1:
               return compose(T.STRB_MONDAY_ABB);
            case 2:
               return compose(T.STRB_TUESDAY_ABB);
            case 3:
               return compose(T.STRB_WEDNESDAY_ABB);
            case 4:
               return compose(T.STRB_THURSDAY_ABB);
            case 5:
               return compose(T.STRB_FRIDAY_ABB);
            case 6:
               return compose(T.STRB_SATURDAY_ABB);
            default:
               return "";
         }
      }
      
      protected function mapWeatherCondition(condition:String) : String
      {
         var con:int = 0;
         if(conditionMap.hasOwnProperty(condition))
         {
            con = int(conditionMap[condition]);
            condition = compose(con);
         }
         else
         {
            condition = "";
         }
         return condition;
      }
      
      protected function setViewSelection(viewGroup:MovieClip, selectedButtonName:String, doEventDispatch:Boolean = true) : void
      {
         if(viewGroup != null)
         {
            if(this.isFromTLFavScreen == true)
            {
               viewGroup.setSelection(FAVORITES_BUTTON,false);
               viewGroup.favorites_button.setInteractive(false);
            }
            else
            {
               viewGroup.setSelection(selectedButtonName,doEventDispatch);
               viewGroup.favorites_button.setInteractive(true);
            }
         }
      }
   }
}

