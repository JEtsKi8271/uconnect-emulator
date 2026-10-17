package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.VehicleStatusEvent;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.geographic.Distance;
   import com.nfuzion.moduleLinkAPI.AlphaJumpIndex;
   import com.nfuzion.moduleLinkAPI.DataStatus;
   import com.nfuzion.moduleLinkAPI.PersonalConfigEvent;
   import com.nfuzion.moduleLinkAPI.TravelLinkLandWeatherEvent;
   import com.nfuzion.moduleLinkAPI.WeatherCondition;
   import com.nfuzion.moduleLinkAPI.WeatherDetail;
   import com.nfuzion.moduleLinkAPI.WeatherForecastDay;
   import com.nfuzion.moduleLinkAPI.WeatherForecastHour;
   import com.nfuzion.moduleLinkAPI.WeatherLocation;
   import com.nfuzion.moduleLinkAPI.WeatherSelectionMode;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.MessageEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class TravelLinkWeatherScreen extends TravelLinkGenericScreen
   {
      
      private static const DEFAULT_INVALID:uint = 0;
      
      private static const WEATHER_MAIN:uint = 1;
      
      private static const WEATHER_HOURLY:uint = 2;
      
      private static const WEATHER_FIVE_DAY:uint = 3;
      
      private static const WEATHER_CHANGE_LOCATION:uint = 4;
      
      private static const SKI_INFO_MAIN:uint = 5;
      
      private static const SKI_INFO_CHANGE_LOCATION:uint = 6;
      
      private static const WEATHER_FORECAST_BTN:String = "weatherForecast_button";
      
      private static const SKI_INFO_BTN:String = "skiInfo_button";
      
      private var mSkiDetailsList:Vector.<WeatherDetail> = new Vector.<WeatherDetail>();
      
      private var mCurrentDetailsList:Vector.<WeatherDetail> = new Vector.<WeatherDetail>();
      
      private var mCurrentView:uint = 0;
      
      private var mHistory:Vector.<uint> = new Vector.<uint>();
      
      private var mBack:Boolean = false;
      
      private var mLastStateListPosition:uint = 0;
      
      private var mLastStateListCursor:uint = 0;
      
      private var mLastStationListPosition:uint = 0;
      
      private var mLastStationListCursor:uint = 0;
      
      private var mLastSkiStatesPosition:uint = 0;
      
      private var mLastSkiStatesCursor:uint = 0;
      
      private var mLastSkiStatesStationPosition:uint = 0;
      
      private var mLastSkiStatesStationCursor:uint = 0;
      
      private var mWeatherButtonInfo:String = "current_button";
      
      private var mSelectedStationID:int = -1;
      
      public function TravelLinkWeatherScreen()
      {
         mView = new C_TravelLinkWeatherScreenView();
         cache = true;
         super();
      }
      
      public function get currentView() : uint
      {
         return this.mCurrentView;
      }
      
      public function set currentView(view:uint) : void
      {
         if(this.mCurrentView != view)
         {
            this.mBack = false;
            this.mCurrentView = view;
         }
      }
      
      override public function cleanup() : void
      {
         this.mCurrentView = DEFAULT_INVALID;
         this.mHistory = null;
         this.mSkiDetailsList = null;
         super.cleanup();
      }
      
      override protected function initView() : void
      {
         super.initView();
         pushBreadcrumb(new Breadcrumb(T.STRB_TRAVEL_LINK_BREADCRUMB,Breadcrumb.FUNCTION,goTravelLink));
         pushBreadcrumb(new Breadcrumb(T.STRB_WEATHER_BREADCRUMB,Breadcrumb.FUNCTION,mView.viewButtons_group.setSelection,WEATHER_FORECAST_BTN));
         pushBreadcrumb(new Breadcrumb(""));
         mView.list_scroller.setReportingPeriod(0);
         mView.list_scroller.setPopupUpdater(this.updateScrollerPopup);
         mView.views_group.setExclusiveChildren(true);
         mView.views_group.weather_group.weatherViews_group.setExclusiveChildren(true);
         mView.headers_group.setExclusiveChildren(true);
         mView.viewButtons_group.setRadioButtons(true);
         mView.viewButtons_group.setRequireSelection(true);
         mView.headers_group.skiButtons_group.setRadioButtons(true);
         mView.headers_group.skiButtons_group.setRequireSelection(true);
         mView.headers_group.weatherButtons_group.setRadioButtons(true);
         mView.headers_group.weatherButtons_group.setRequireSelection(true);
         mView.headers_group.weatherButtons_group.setEventsRequireChange(false);
         mView.viewButtons_group.setEventsRequireChange(false);
         mView.headers_group.skiButtons_group.setEventsRequireChange(false);
         mView.views_group.weather_group.weatherViews_group.hourly_chain.setItemUpdater(this.hourlyItemUpdater);
         mView.views_group.weather_group.weatherViews_group.daily_chain.setItemUpdater(this.dailyItemUpdater);
         mView.views_group.location_group.location_list.setSelectionChanger(this.changeSelection);
         mView.views_group.weather_group.weatherViews_group.currentDetails_list.setDataRequester(this.requestCurrentDetails);
         mView.views_group.weather_group.weatherViews_group.currentDetails_list.setRowUpdater(this.detailsItemUpdater);
         mView.views_group.weather_group.favorite_icon.visible = false;
         t(mView.views_group.weather_group.location_label,"");
         with(mView.views_group.weather_group.weatherViews_group)
         {
            currentOverview_group.favorite_button.setEnabled(false);
            currentOverview_group.favorite_button.setInteractive(false);
            currentOverview_group.condition_icon.gotoAndStop("none");
            t(currentOverview_group.temperature_label,"");
            t(currentOverview_group.condition_label,"");
            t(currentOverview_group.highLow_label,"");
            hourly_chain.setLinks(null);
            daily_chain.setLinks(null);
         }
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         mView.views_group.weather_group.favorite_icon.visible = false;
         var station:WeatherLocation = Peripheral.travelLink.landWeather.station;
         if(Peripheral.travelLink.landWeather.lastViewedStationIsNearest)
         {
            Peripheral.travelLink.landWeather.setStationSelectionMode(WeatherSelectionMode.CLOSEST);
         }
         else
         {
            Peripheral.travelLink.landWeather.setStationSelectionMode(WeatherSelectionMode.SPECIFIC,Peripheral.travelLink.landWeather.lastViewedStation);
         }
         if(Peripheral.travelLink.landWeather.skiSelectionMode == WeatherSelectionMode.SPECIFIC && Peripheral.travelLink.landWeather.ski != null)
         {
            Peripheral.travelLink.landWeather.setSkiSelectionMode(WeatherSelectionMode.SPECIFIC,Peripheral.travelLink.landWeather.ski.id);
         }
         else
         {
            Peripheral.travelLink.landWeather.setSkiSelectionMode(WeatherSelectionMode.CLOSEST);
         }
         switch(screenVars.favoriteData)
         {
            case "currentFavorite":
               Peripheral.travelLink.landWeather.setStationSelectionMode(WeatherSelectionMode.FAVORITE);
               this.selectViewButton(FAVORITES_BUTTON);
               this.setView(FAVORITES_BUTTON);
               this.mSelectedStationID = station.id;
               mView.headers_group.weatherButtons_group.setSelection("current_button");
               this.currentView = WEATHER_MAIN;
               break;
            case "fiveDayFavorite":
               Peripheral.travelLink.landWeather.setStationSelectionMode(WeatherSelectionMode.FAVORITE);
               this.selectViewButton(FAVORITES_BUTTON);
               this.setView(FAVORITES_BUTTON);
               this.mSelectedStationID = station.id;
               mView.headers_group.weatherButtons_group.setSelection("daily_button");
               this.currentView = WEATHER_FIVE_DAY;
               break;
            case "current":
               this.selectViewButton(WEATHER_FORECAST_BTN);
               this.setView(WEATHER_FORECAST_BTN);
               mView.headers_group.weatherButtons_group.setSelection("current_button");
               this.currentView = WEATHER_MAIN;
               break;
            case "fiveDay":
               this.setView(WEATHER_FORECAST_BTN);
               mView.headers_group.weatherButtons_group.setSelection("daily_button");
               this.currentView = WEATHER_FIVE_DAY;
               break;
            case "extended":
               this.setView(WEATHER_FORECAST_BTN);
               mView.headers_group.weatherButtons_group.setSelection("hourly_button");
               this.currentView = WEATHER_HOURLY;
               break;
            case "ski":
               this.setView(SKI_INFO_BTN);
               mView.viewButtons_group.setSelection(SKI_INFO_BTN);
               this.currentView = SKI_INFO_MAIN;
               break;
            default:
               this.setView(WEATHER_FORECAST_BTN);
               mView.headers_group.weatherButtons_group.setSelection("current_button");
               this.currentView = WEATHER_MAIN;
               screenVars.favoriteData = "current";
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[mView.viewButtons_group.weatherForecast_button,mView.viewButtons_group.skiInfo_button,mView.favorites_button,mView.refresh_button]));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.headers_group.skiButtons_group.currentConditions_button,mView.headers_group.skiButtons_group.changeLocation_button,mView.headers_group.weatherButtons_group.current_button,mView.headers_group.weatherButtons_group.hourly_button,mView.headers_group.weatherButtons_group.daily_button,mView.headers_group.weatherButtons_group.changeLocation_button,mView.views_group.location_group.jump_button]));
      }
      
      private function selectViewButton(buttonName:String, triggerEvent:Boolean = false) : void
      {
         if(buttonName == FAVORITES_BUTTON)
         {
            mView.viewButtons_group.setSelection("none",false);
            this.showFavoritesButtonSelected(true);
            mView.viewButtons_group.skiInfo_button.setInteractive(true);
            mView.viewButtons_group.weatherForecast_button.setInteractive(true);
         }
         else
         {
            isFromTLFavScreen = false;
            this.showFavoritesButtonSelected(false);
            mView.viewButtons_group.setSelection(buttonName,triggerEvent);
            JustAddedFavorite = false;
            switch(buttonName)
            {
               case "skiInfo_button":
                  mView.viewButtons_group.skiInfo_button.setInteractive(false);
                  mView.viewButtons_group.weatherForecast_button.setInteractive(true);
                  screenVars.favoriteData = "ski";
                  break;
               case "weatherForecast_button":
                  mView.viewButtons_group.skiInfo_button.setInteractive(true);
                  mView.viewButtons_group.weatherForecast_button.setInteractive(false);
                  screenVars.favoriteData = "current";
            }
         }
      }
      
      private function showFavoritesButtonSelected(selected:Boolean) : void
      {
         mView.favorites_button.setSelected(selected);
         mView.favorites_button.setInteractive(!selected);
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(Framework.messenger,MessageEvent.MESSAGE,this.onMessage);
         attachListener(mView.refresh_button,WidgetEvent.CLICK,this.onRefresh);
         attachListener(mView.back_button,MouseEvent.CLICK,this.goBack);
         attachListener(mView.travelLink_button,MouseEvent.CLICK,goTravelLink);
         attachListener(mView.favorites_button,MouseEvent.CLICK,goFavorite);
         attachListener(mView.views_group.weather_group.weatherViews_group.currentOverview_group.favorite_button,MouseEvent.CLICK,this.setFavorite);
         attachListener(mView.viewButtons_group,WidgetEvent.SELECT,this.onSelectView);
         attachListener(mView.headers_group.weatherButtons_group,WidgetEvent.SELECT,this.onSelectWeatherView);
         attachListener(mView.headers_group.skiButtons_group,WidgetEvent.SELECT,this.onSelectSkiView);
         attachListener(mView.views_group.weather_group.weatherViews_group.currentOverview_group.details_button,MouseEvent.CLICK,this.onSelectDetails);
         attachListener(mView.views_group.changeLocationMethods_group.nearest_button,MouseEvent.CLICK,this.trackNearestStation);
         attachListener(mView.views_group.changeLocationMethods_group.fromList_button,MouseEvent.CLICK,this.beginLocationSelection);
         attachListener(mView.views_group.location_group.location_list,WidgetEvent.SELECT,this.onLocationSelect);
         attachListener(mView.views_group.location_group.jump_button,MouseEvent.CLICK,this.onAlphaJumpClick);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATION,this.onStation);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI,this.onSki);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATION_STATE_COUNT,this.onCount);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATION_STATES,this.onStationStates);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATION_COUNT,this.onCount);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATIONS,this.onStations);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_STATE_COUNT,this.onCount);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_STATES,this.onSkiStates);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_RESORT_COUNT,this.onCount);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_RESORTS,this.onSkiResorts);
         attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.FAVORITE,this.onFavorite);
         Peripheral.personalConfig.addEventListener(PersonalConfigEvent.TEMPERATURE_UNITS,this.onTemperatureUnits,false,0,true);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.views_group.changeLocationMethods_group.nearest_button.value_label,T.STRB_NEAREST_LOCATION_2);
         t(mView.views_group.changeLocationMethods_group.fromList_button.value_label,T.STRB_SELECT_FROM_STATE_LIST);
         t(mView.views_group.location_group.value_label,T.STRB_SELECT_A_STATE);
         t(mView.views_group.location_group.jump_button.value_label,T.STRB_ALPHAJUMP_TRAVELLINK);
         t(mView.views_group.message_group.message_label,T.STRB_FUNCTION_NOT_AVAILABLE,TRUNCATE_NONE);
         t(mView.viewButtons_group.weatherForecast_button.value_label,T.STRB_WEATHER_FORECAST);
         t(mView.viewButtons_group.skiInfo_button.value_label,T.STRB_SKI_INFO);
         t(mView.refresh_button.value_label,T.STRB_REFRESH_DATA);
         t(mView.favorites_button.value_label,T.STRB_FAVOURITES);
         t(mView.headers_group.skiButtons_group.changeLocation_button.value_label,T.STRB_CHANGE_LOCATION);
         t(mView.headers_group.skiButtons_group.currentConditions_button.value_label,T.STRB_CURRENT_CONDITIONS);
         t(mView.headers_group.weatherButtons_group.hourly_button.value_label,T.STRB_HR);
         t(mView.headers_group.weatherButtons_group.daily_button.value_label,T.STRB_DAY);
         t(mView.headers_group.weatherButtons_group.current_button.value_label,T.STRB_CURRENT);
         t(mView.headers_group.weatherButtons_group.changeLocation_button.value_label,T.STRB_CHANGE_LOCATION_WEATHERBUTTON);
         t(mView.views_group.weather_group.weatherViews_group.currentOverview_group.details_button.value_label,T.STRB_DETAILS);
         t(mView.views_group.weather_group.weatherViews_group.currentOverview_group.favorite_button.value_label,T.STRB_ADD);
         t(mView.itemsInList_label,"");
      }
      
      private function onRefresh(e:WidgetEvent) : void
      {
         Peripheral.travelLink.landWeather.forceRefresh();
      }
      
      private function setView(viewButtonName:String) : void
      {
         mView.list_scroller.hide();
         t(mView.itemsInList_label,"");
         this.selectViewButton(viewButtonName);
         this.endLocationSelection();
         switch(viewButtonName)
         {
            case FAVORITES_BUTTON:
            case WEATHER_FORECAST_BTN:
               mView.views_group.weather_group.show();
               mView.headers_group.weatherButtons_group.show();
               mView.views_group.skiInfo_group.hide();
               if(screenVars.favoriteData == null)
               {
                  mView.headers_group.weatherButtons_group.setSelection("current_button");
               }
               if(this.mCurrentView == SKI_INFO_MAIN)
               {
                  mView.headers_group.weatherButtons_group.setSelection(this.mWeatherButtonInfo);
               }
               Peripheral.travelLink.landWeather.getCondition();
               popBreadcrumb();
               pushBreadcrumb(new Breadcrumb(T.STRB_FORECAST_BREADCRUMB,Breadcrumb.FUNCTION,mView.viewButtons_group.setSelection,WEATHER_FORECAST_BTN));
               break;
            case SKI_INFO_BTN:
               mView.views_group.skiInfo_group.show();
               mView.headers_group.weatherButtons_group.hide();
               mView.headers_group.skiButtons_group.show();
               mView.headers_group.skiButtons_group.setSelection("currentConditions_button");
               Peripheral.travelLink.landWeather.getSkiCondition();
               this.currentView = SKI_INFO_MAIN;
               mView.views_group.message_group.visible = Peripheral.vehicleStatus.speedLockOut;
               popBreadcrumb();
               pushBreadcrumb(new Breadcrumb(T.STRB_SKI_INFO_BREADCRUMB,Breadcrumb.FUNCTION,mView.viewButtons_group.setSelection,SKI_INFO_BTN));
         }
      }
      
      private function setWeatherView(weatherButtonName:String) : void
      {
         detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_CONDITION,this.onSkiCondition);
         detachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.onHardControlVerticalScroll);
         this.endLocationSelection();
         this.setDetailView(false);
         t(mView.itemsInList_label,"");
         this.mWeatherButtonInfo = weatherButtonName;
         switch(weatherButtonName)
         {
            case "current_button":
               attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.CONDITION,this.onCondition);
               mView.views_group.weather_group.show();
               mView.views_group.weather_group.weatherViews_group.currentOverview_group.show();
               this.currentView = WEATHER_MAIN;
               screenVars.favoriteData = "current";
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.views_group.weather_group.weatherViews_group.currentOverview_group.details_button,mView.views_group.weather_group.weatherViews_group.currentOverview_group.favorite_button]));
               Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
               break;
            case "hourly_button":
               attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.CONDITION,this.onCondition);
               mView.views_group.weather_group.show();
               mView.views_group.weather_group.weatherViews_group.hourly_chain.show();
               this.currentView = WEATHER_HOURLY;
               screenVars.favoriteData = "extended";
               Framework.focusManager.setFocus(FocusPriority.REGULAR);
               break;
            case "daily_button":
               attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.CONDITION,this.onCondition);
               mView.views_group.weather_group.show();
               mView.views_group.weather_group.weatherViews_group.daily_chain.show();
               this.currentView = WEATHER_FIVE_DAY;
               screenVars.favoriteData = "fiveDay";
               Framework.focusManager.setFocus(FocusPriority.REGULAR);
               break;
            case "changeLocation_button":
               detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.CONDITION,this.onCondition);
               t(mView.views_group.changeLocationMethods_group.nearest_button.value_label,T.STRB_NEAREST_LOCATION_2);
               t(mView.views_group.changeLocationMethods_group.select_label,T.STRB_SELECT_LOCATION);
               mView.views_group.changeLocationMethods_group.show();
               this.currentView = WEATHER_CHANGE_LOCATION;
               screenVars.favoriteData = null;
               isFromTLFavScreen = false;
               Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.views_group.changeLocationMethods_group.nearest_button,mView.views_group.changeLocationMethods_group.fromList_button]));
         }
      }
      
      private function setSkiView(skiButtonName:String) : void
      {
         detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.CONDITION,this.onCondition);
         this.endLocationSelection();
         switch(skiButtonName)
         {
            case "currentConditions_button":
               attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_CONDITION,this.onSkiCondition);
               attachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.onHardControlVerticalScroll);
               mView.views_group.skiInfo_group.show();
               mView.list_scroller.show();
               mView.views_group.skiInfo_group.skiDetails_list.attachScroller(mView.list_scroller);
               mView.views_group.skiInfo_group.skiDetails_list.setRowUpdater(this.updateSkiDetailRow);
               mView.views_group.skiInfo_group.skiDetails_list.setDataRequester(this.requestSkiDetails);
               this.updateSkiDetailsList();
               this.currentView = SKI_INFO_MAIN;
               mView.views_group.message_group.visible = Peripheral.vehicleStatus.speedLockOut;
               screenVars.favoriteData = "ski";
               Framework.focusManager.setFocus(FocusPriority.REGULAR);
               break;
            case "changeLocation_button":
               detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_CONDITION,this.onSkiCondition);
               detachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,this.onHardControlVerticalScroll);
               t(mView.views_group.changeLocationMethods_group.nearest_button.value_label,T.STRB_NEAREST_SKI_AREA);
               t(mView.views_group.changeLocationMethods_group.select_label,T.STRB_SELECT_SKI_AREA);
               mView.views_group.changeLocationMethods_group.show();
               mView.list_scroller.hide();
               this.currentView = SKI_INFO_CHANGE_LOCATION;
               mView.views_group.message_group.visible = Peripheral.vehicleStatus.speedLockOut;
               screenVars.favoriteData = null;
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.views_group.changeLocationMethods_group.nearest_button,mView.views_group.changeLocationMethods_group.fromList_button]));
               Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
         }
         t(mView.itemsInList_label,"");
      }
      
      private function detailsItemUpdater(row:MovieClip, rowIndex:int, detail:WeatherDetail, detailIndex:int) : void
      {
         var val:Number = NaN;
         var distanceVal:Distance = null;
         var displayDistance:String = null;
         if(detail)
         {
            t(row.label_translate,this.translateDescription(detail.description));
            if(detail.description == "Precipitation Amount")
            {
               if(useUSDistanceUnits())
               {
                  displayDistance = detail.value + "\"";
               }
               else
               {
                  val = parseFloat(detail.value) * 2.54;
                  displayDistance = compose([val.toFixed(1)," ",T.STRB_CENTIMETER_ABB]);
               }
               t(row.value_label,displayDistance);
               return;
            }
            if(detail.description == "Winds")
            {
               if(useUSMilageUnits())
               {
                  displayDistance = compose([detail.value," ",T.STRB_MPH_ABB]);
               }
               else
               {
                  val = parseInt(detail.value);
                  distanceVal = new Distance();
                  distanceVal.miles = val;
                  val = Math.round(distanceVal.kilometers);
                  displayDistance = compose([val.toString()," ",T.STRB_KMH_ABB]);
               }
               t(row.value_label,displayDistance);
               return;
            }
            if(detail.description == "Cloud Cover")
            {
               t(row.value_label,this.translateCloudCoverValue(detail.value));
               return;
            }
            t(row.value_label,detail.value);
         }
         else
         {
            t(row.label_translate,"");
            t(row.value_label,"");
         }
      }
      
      private function requestCurrentDetails(start:uint, end:uint) : void
      {
         var list:Vector.<WeatherDetail> = new Vector.<WeatherDetail>();
         for(var i:int = int(start); i <= end; i++)
         {
            list.push(this.mCurrentDetailsList[i]);
         }
         mView.views_group.weather_group.weatherViews_group.currentDetails_list.setData({
            "offset":start,
            "list":list
         });
      }
      
      private function hourlyItemUpdater(item:MovieClip, hour:WeatherForecastHour) : void
      {
         t(item.title_label,[T.STRB_FORECAST_HOUR_HEADER,hour.hour.toString()]);
         if(hour.temperature != int.MIN_VALUE)
         {
            t(item.temperature_label,temperatureString(hour.temperature));
         }
         else
         {
            t(item.temperature_label,T.STRB_NA);
         }
         if(hour.preciptiationChance != int.MIN_VALUE)
         {
            t(item.pop_label,[T.STRB_HOUR_CHANCE_PRECIP,hour.preciptiationChance.toString()]);
         }
         else
         {
            t(item.pop_label,T.STRB_NA);
         }
         item.condition_icon.gotoAndStop(mapCondition(hour.condition || "none"));
      }
      
      private function dailyItemUpdater(item:MovieClip, day:WeatherForecastDay) : void
      {
         t(item.title_label,translateDayIndexToString(day.dayIndex));
         if(day.highTemperature != int.MIN_VALUE && day.lowTemperature != int.MIN_VALUE)
         {
            t(item.highLow_label,temperatureString(day.highTemperature) + " / " + temperatureString(day.lowTemperature));
         }
         else
         {
            t(item.highLow_label,T.STRB_NA);
         }
         if(day.preciptiationChance != int.MIN_VALUE)
         {
            t(item.pop_label,[T.STRB_DAY_CHANCE_PRECIP,day.preciptiationChance.toString()]);
         }
         else
         {
            t(item.pop_label,T.STRB_NA);
         }
         item.condition_icon.gotoAndStop(mapCondition(day.condition || "none"));
      }
      
      private function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         (row.getChildAt(0) as MovieClip).setSelected(selected);
      }
      
      private function updateSkiDetailsList() : void
      {
         var length:int = 0;
         if(mView.views_group.skiInfo_group.visible)
         {
            length = int(this.mSkiDetailsList.length);
            if(length < 0)
            {
               length = 0;
            }
            mView.views_group.skiInfo_group.skiDetails_list.setLength(length);
            t(mView.itemsInList_label,Format.itemsInList(length));
            mView.views_group.skiInfo_group.skiDetails_list.requestData();
         }
      }
      
      private function updateSkiDetailRow(row:MovieClip, rowIndex:int, detail:WeatherDetail, detailIndex:int) : void
      {
         var tmpAtBase:int = 0;
         var baseDepthAvg:int = 0;
         row.visible = detail != null;
         if(detail)
         {
            t(row.label_translate,this.translateSkiDescription(detail.description));
            if(detail.description == "Temp at base")
            {
               tmpAtBase = parseInt(detail.value);
               t(row.value_label,temperatureString(tmpAtBase));
            }
            else if(detail.description == "Base Depth, avg")
            {
               if(useUSDistanceUnits())
               {
                  t(row.value_label,detail.value + "\"");
               }
               else
               {
                  baseDepthAvg = parseInt(detail.value);
                  t(row.value_label,this.inchesToCentimeters(baseDepthAvg));
               }
            }
            else if(detail.description == "Base Depth avg Value")
            {
               if(useUSDistanceUnits())
               {
                  t(row.value_label,this.formatSnowRange(detail.value));
               }
               else
               {
                  t(row.value_label,this.convertSnowRange(detail.value));
               }
            }
            else if(detail.description == "New snow")
            {
               if(useUSDistanceUnits())
               {
                  t(row.value_label,this.formatSnowRange(detail.value));
               }
               else
               {
                  t(row.value_label,this.convertSnowRange(detail.value));
               }
            }
            else if(detail.description == "Operational status")
            {
               if(detail.value == "Open")
               {
                  t(row.value_label,T.STRB_OPERATIONAL_STATUS_OPEN);
               }
               else if(detail.value == "Closed")
               {
                  t(row.value_label,T.STRB_OPERATIONAL_STATUS_CLOSED);
               }
               else
               {
                  t(row.value_label,"");
               }
            }
            else if(detail.description == "Wind Conditions")
            {
               t(row.value_label,this.translateSkiWindConditions(detail.value));
            }
            else if(detail.description == "Snow Conditions")
            {
               t(row.value_label,this.translateSkiSnowConditions(detail.value));
            }
            else if(detail.description == "Snow Making" || detail.description == "Snow Grooming" || detail.description == "Night Skiing" || detail.description == "Snowboarding")
            {
               if(detail.value == "YES")
               {
                  t(row.value_label,T.STRB_YES);
               }
               else if(detail.value == "NO")
               {
                  t(row.value_label,T.STRB_NO);
               }
               else
               {
                  t(row.value_label,"");
               }
            }
            else
            {
               t(row.value_label,detail.value);
            }
         }
      }
      
      private function formatSnowRange(rangeString:String) : String
      {
         var snowArray:Array = rangeString.split("/");
         var lowValue:int = parseInt(snowArray[0]);
         var highValue:int = parseInt(snowArray[1]);
         return lowValue.toString() + "\"/" + highValue.toString() + "\"";
      }
      
      private function convertSnowRange(rangeString:String) : String
      {
         var snowArray:Array = rangeString.split("/");
         var lowValue:int = parseInt(snowArray[0]);
         var highValue:int = parseInt(snowArray[1]);
         return this.inchesToCentimeters(lowValue) + "/" + this.inchesToCentimeters(highValue);
      }
      
      private function inchesToCentimeters(inchVal:int) : String
      {
         var cmVal:int = Math.round(2.54 * inchVal);
         return compose([cmVal.toString()," cm"]);
      }
      
      private function requestSkiDetails(start:uint, end:uint) : void
      {
         var list:Vector.<WeatherDetail> = new Vector.<WeatherDetail>();
         for(var i:int = int(start); i <= end; i++)
         {
            list.push(this.mSkiDetailsList[i]);
         }
         mView.views_group.skiInfo_group.skiDetails_list.setData({
            "offset":start,
            "list":list
         });
      }
      
      private function clearSkiInfo() : void
      {
         mView.views_group.weather_group.favorite_icon.visible = false;
         var skiInfo:MovieClip = mView.views_group.skiInfo_group;
         t(skiInfo.location_label,"");
         t(skiInfo.conditions_label,"");
         skiInfo.conditions_icon.gotoAndStop(mapCondition("none"));
         this.mSkiDetailsList = new Vector.<WeatherDetail>();
         this.updateSkiDetailsList();
      }
      
      private function clearWeatherInfo() : void
      {
         mView.views_group.weather_group.weatherViews_group.currentOverview_group.hide();
         t(mView.views_group.weather_group.location_label,"");
         mView.views_group.weather_group.favorite_icon.visible = false;
         mView.headers_group.weatherButtons_group.hourly_button.setEnabled(false);
         mView.headers_group.weatherButtons_group.hourly_button.setInteractive(false);
         mView.headers_group.weatherButtons_group.daily_button.setEnabled(false);
         mView.headers_group.weatherButtons_group.daily_button.setInteractive(false);
      }
      
      private function updateStateRow(row:MovieClip, rowIndex:int, state:String, stateIndex:int) : void
      {
         row.visible = state != null;
         t(row.location_button.name_label,state || "");
         row.location_button.displayMore_icon.visible = true;
      }
      
      private function updateLocationRow(row:MovieClip, rowIndex:int, location:WeatherLocation, locationIndex:int) : void
      {
         row.visible = location != null;
         if(location != null)
         {
            t(row.location_button.name_label,location.name);
            row.location_button.displayMore_icon.visible = false;
         }
      }
      
      private function updateScrollerPopup(popup:MovieClip) : void
      {
         var indexes:Vector.<AlphaJumpIndex> = this.getIndexes();
         for(var i:* = 0; i < indexes.length; i++)
         {
            if(indexes[i].index > mView.views_group.location_group.location_list.getPosition())
            {
               break;
            }
         }
         i--;
         if(i < 0)
         {
            i = 0;
         }
         t(popup.value_label,indexes[i].character);
      }
      
      private function getIndexes() : Vector.<AlphaJumpIndex>
      {
         var dataRequester:Function = mView.views_group.location_group.location_list.getDataRequester();
         if(dataRequester == Peripheral.travelLink.landWeather.getStationStates)
         {
            return Peripheral.travelLink.landWeather.stationStatesAlphaJumpList;
         }
         if(dataRequester == Peripheral.travelLink.landWeather.getStations)
         {
            return Peripheral.travelLink.landWeather.stationsAlphaJumpList;
         }
         if(dataRequester == Peripheral.travelLink.landWeather.getSkiStates)
         {
            return Peripheral.travelLink.landWeather.skiStatesAlphaJumpList;
         }
         if(dataRequester == Peripheral.travelLink.landWeather.getSkiResorts)
         {
            return Peripheral.travelLink.landWeather.skiResortsAlphaJumpList;
         }
         return null;
      }
      
      private function enableAddFavoriteButton(enableButton:Boolean) : void
      {
         if(Peripheral.travelLink.landWeather.station.id == -1)
         {
            enableButton = false;
         }
         mView.views_group.weather_group.weatherViews_group.currentOverview_group.favorite_button.setEnabled(enableButton);
         mView.views_group.weather_group.weatherViews_group.currentOverview_group.favorite_button.setInteractive(enableButton);
      }
      
      override protected function onFromTLFavScreen(fromTLFavScreen:Boolean) : void
      {
         if(fromTLFavScreen)
         {
            this.selectViewButton(FAVORITES_BUTTON);
         }
      }
      
      protected function setFavorite(e:MouseEvent) : void
      {
         var favAction:String = Peripheral.travelLink.landWeather.favoriteStation != -1 ? Peripheral.travelLink.replaceFavorite : Peripheral.travelLink.addFavorite;
         var favObj:Object = {
            "line1":Peripheral.travelLink.landWeather.station.name,
            "action":favAction,
            "service":Peripheral.travelLink.TLLandWeather
         };
         addToFavoritesPopup(favObj);
      }
      
      override protected function onConfirmedAddToFavorites() : void
      {
         Peripheral.travelLink.landWeather.setFavoriteStation(Peripheral.travelLink.landWeather.station.id);
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         JustAddedFavorite = true;
      }
      
      private function onStationStates(e:TravelLinkLandWeatherEvent) : void
      {
         if(mView.views_group.location_group.location_list.getDataRequester() == Peripheral.travelLink.landWeather.getStationStates)
         {
            mView.views_group.location_group.location_list.setData(e.data);
         }
      }
      
      private function onStations(e:TravelLinkLandWeatherEvent) : void
      {
         if(mView.views_group.location_group.location_list.getDataRequester() == Peripheral.travelLink.landWeather.getStations)
         {
            mView.views_group.location_group.location_list.setData(e.data);
         }
      }
      
      private function onSkiStates(e:TravelLinkLandWeatherEvent) : void
      {
         if(mView.views_group.location_group.location_list.getDataRequester() == Peripheral.travelLink.landWeather.getSkiStates)
         {
            mView.views_group.location_group.location_list.setData(e.data);
         }
      }
      
      private function onSkiResorts(e:TravelLinkLandWeatherEvent) : void
      {
         if(mView.views_group.location_group.location_list.getDataRequester() == Peripheral.travelLink.landWeather.getSkiResorts)
         {
            mView.views_group.location_group.location_list.setData(e.data);
         }
      }
      
      private function onFavorite(e:TravelLinkLandWeatherEvent) : void
      {
         if(Peripheral.travelLink.landWeather.station.id == Peripheral.travelLink.landWeather.favoriteStation)
         {
            mView.views_group.weather_group.favorite_icon.visible = true;
            this.enableAddFavoriteButton(false);
         }
         else
         {
            mView.views_group.weather_group.favorite_icon.visible = false;
            this.enableAddFavoriteButton(true);
         }
      }
      
      private function onAlphaJumpClick(e:MouseEvent) : void
      {
         var dataRequester:Function = mView.views_group.location_group.location_list.getDataRequester();
         if(dataRequester == Peripheral.travelLink.landWeather.getStationStates)
         {
            attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATION_STATES_ALPHA_JUMP_LIST,this.onAlphaJumpList);
            Peripheral.travelLink.landWeather.getStationStatesAlphaJumpList();
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getStations)
         {
            attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATIONS_ALPHA_JUMP_LIST,this.onAlphaJumpList);
            Peripheral.travelLink.landWeather.getStationsAlphaJumpList();
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getSkiStates)
         {
            attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_STATES_ALPHA_JUMP_LIST,this.onAlphaJumpList);
            Peripheral.travelLink.landWeather.getSkiStatesAlphaJumpList();
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getSkiResorts)
         {
            attachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_RESORTS_ALPHA_JUMP_LIST,this.onAlphaJumpList);
            Peripheral.travelLink.landWeather.getSkiResortsAlphaJumpList();
         }
      }
      
      private function onAlphaJumpList(e:TravelLinkLandWeatherEvent) : void
      {
         var index:AlphaJumpIndex = null;
         var indexes:Vector.<AlphaJumpIndex> = this.getIndexes();
         var characters:Vector.<String> = new Vector.<String>();
         if(indexes != null)
         {
            for each(index in indexes)
            {
               characters.push(index.character);
            }
            Framework.popupManager.show(DynamicPopupNames.ALPHA_JUMP,Screens.POPUP_ALPHAJUMP,{
               "type":PopupType.SPELLER,
               "availableCharacters":characters
            });
         }
         detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATION_STATES_ALPHA_JUMP_LIST,this.onAlphaJumpList);
         detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.STATIONS_ALPHA_JUMP_LIST,this.onAlphaJumpList);
         detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_STATES_ALPHA_JUMP_LIST,this.onAlphaJumpList);
         detachListener(Peripheral.travelLink.landWeather,TravelLinkLandWeatherEvent.SKI_RESORTS_ALPHA_JUMP_LIST,this.onAlphaJumpList);
      }
      
      private function onLocationSelect(e:WidgetEvent) : void
      {
         var state:String = null;
         var station:WeatherLocation = null;
         var skiResort:WeatherLocation = null;
         var dataRequester:Function = mView.views_group.location_group.location_list.getDataRequester();
         t(mView.itemsInList_label,"");
         if(dataRequester == Peripheral.travelLink.landWeather.getStationStates)
         {
            this.mLastStateListPosition = mView.views_group.location_group.location_list.getPosition();
            this.mLastStateListCursor = mView.views_group.location_group.location_list.getCursor();
            this.mLastStationListPosition = 0;
            this.mLastStationListCursor = 0;
            this.mLastSkiStatesPosition = 0;
            this.mLastSkiStatesCursor = 0;
            this.mLastSkiStatesStationPosition = 0;
            this.mLastSkiStatesStationCursor = 0;
            state = e.data.data;
            Peripheral.travelLink.landWeather.setStationState(state);
            mView.views_group.location_group.location_list.setLength(0);
            t(mView.views_group.location_group.value_label,T.STRB_SELECT_A_WEATHER_STATION);
            mView.views_group.location_group.location_list.setDataRequester(Peripheral.travelLink.landWeather.getStations);
            mView.views_group.location_group.location_list.setRowUpdater(this.updateLocationRow);
            Peripheral.travelLink.landWeather.getStationCount();
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getStations)
         {
            this.mLastStateListPosition = 0;
            this.mLastStateListCursor = 0;
            this.mLastStationListPosition = mView.views_group.location_group.location_list.getPosition();
            this.mLastStationListCursor = mView.views_group.location_group.location_list.getCursor();
            this.mLastSkiStatesPosition = 0;
            this.mLastSkiStatesCursor = 0;
            this.mLastSkiStatesStationPosition = 0;
            this.mLastSkiStatesStationCursor = 0;
            station = e.data.data;
            Peripheral.travelLink.landWeather.setStationAsLastViewedStation(station.id);
            Peripheral.travelLink.landWeather.setStationSelectionMode(WeatherSelectionMode.SPECIFIC,station.id);
            this.selectViewButton(WEATHER_FORECAST_BTN,true);
            mView.headers_group.weatherButtons_group.setSelection("current_button");
            this.setWeatherView("current_button");
            this.mSelectedStationID = station.id;
            this.clearWeatherInfo();
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getSkiStates)
         {
            this.mLastStateListPosition = 0;
            this.mLastStateListCursor = 0;
            this.mLastStationListPosition = 0;
            this.mLastStationListCursor = 0;
            this.mLastSkiStatesPosition = mView.views_group.location_group.location_list.getPosition();
            this.mLastSkiStatesCursor = mView.views_group.location_group.location_list.getCursor();
            this.mLastSkiStatesStationPosition = 0;
            this.mLastSkiStatesStationCursor = 0;
            state = e.data.data;
            Peripheral.travelLink.landWeather.setSkiState(state);
            mView.views_group.location_group.location_list.setLength(0);
            t(mView.itemsInList_label,"");
            t(mView.views_group.location_group.value_label,T.STRB_SELECT_A_SKI_AREA);
            mView.views_group.location_group.location_list.setDataRequester(Peripheral.travelLink.landWeather.getSkiResorts);
            mView.views_group.location_group.location_list.setRowUpdater(this.updateLocationRow);
            Peripheral.travelLink.landWeather.getSkiResortCount();
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getSkiResorts)
         {
            this.mLastStateListPosition = 0;
            this.mLastStateListCursor = 0;
            this.mLastStationListPosition = 0;
            this.mLastStationListCursor = 0;
            this.mLastSkiStatesPosition = 0;
            this.mLastSkiStatesCursor = 0;
            this.mLastSkiStatesStationPosition = mView.views_group.location_group.location_list.getPosition();
            this.mLastSkiStatesStationCursor = mView.views_group.location_group.location_list.getCursor();
            skiResort = e.data.data;
            Peripheral.travelLink.landWeather.setSkiSelectionMode(WeatherSelectionMode.SPECIFIC,skiResort.id);
            this.selectViewButton(SKI_INFO_BTN,true);
         }
      }
      
      private function onCount(e:TravelLinkLandWeatherEvent) : void
      {
         var count:int = 0;
         var position:uint = 0;
         var cursor:uint = 0;
         var dataRequester:Function = mView.views_group.location_group.location_list.getDataRequester();
         if(dataRequester == Peripheral.travelLink.landWeather.getStationStates)
         {
            position = this.mLastStateListPosition;
            cursor = this.mLastStateListCursor;
            count = int(Peripheral.travelLink.landWeather.stationStateCount);
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getStations)
         {
            position = this.mLastStationListPosition;
            cursor = this.mLastStationListCursor;
            count = int(Peripheral.travelLink.landWeather.stationCount);
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getSkiStates)
         {
            position = this.mLastSkiStatesPosition;
            cursor = this.mLastSkiStatesCursor;
            count = int(Peripheral.travelLink.landWeather.skiStateCount);
         }
         else if(dataRequester == Peripheral.travelLink.landWeather.getSkiResorts)
         {
            position = this.mLastSkiStatesStationPosition;
            cursor = this.mLastSkiStatesStationCursor;
            count = int(Peripheral.travelLink.landWeather.skiResortCount);
         }
         if(count > 0)
         {
            mView.views_group.location_group.location_list.setLength(count);
            t(mView.itemsInList_label,Format.itemsInList(count));
            mView.views_group.location_group.location_list.setPosition(position);
            mView.views_group.location_group.location_list.setCursor(cursor);
            mView.views_group.location_group.location_list.update();
         }
      }
      
      private function beginLocationSelection(e:MouseEvent = null) : void
      {
         if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "524")
         {
            mView.headers_group.weatherButtons_group.hide();
            mView.headers_group.skiButtons_group.hide();
         }
         t(mView.views_group.location_group.value_label,T.STRB_SELECT_A_STATE);
         mView.views_group.location_group.show();
         mView.list_scroller.show();
         mView.views_group.location_group.location_list.attachScroller(mView.list_scroller);
         mView.views_group.location_group.location_list.setRowUpdater(this.updateStateRow);
         mView.views_group.location_group.location_list.setLength(0);
         t(mView.itemsInList_label,"");
         swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.views_group.location_group.location_list.scrollEventHandler);
         swapListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.views_group.location_group.location_list.selectEventHandler);
         switch(mView.viewButtons_group.getSelection())
         {
            case WEATHER_FORECAST_BTN:
               mView.views_group.location_group.location_list.setDataRequester(Peripheral.travelLink.landWeather.getStationStates);
               Peripheral.travelLink.landWeather.getStationStateCount();
               break;
            case SKI_INFO_BTN:
               mView.views_group.location_group.location_list.setDataRequester(Peripheral.travelLink.landWeather.getSkiStates);
               Peripheral.travelLink.landWeather.getSkiStateCount();
               break;
            default:
               if(mView.favorites_button.getSelected())
               {
                  mView.views_group.location_group.location_list.setDataRequester(Peripheral.travelLink.landWeather.getStationStates);
                  Peripheral.travelLink.landWeather.getStationStateCount();
               }
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.location_group.location_list.onFocusCallBack));
         Framework.focusManager.refresh();
      }
      
      private function endLocationSelection() : void
      {
         mView.views_group.location_group.hide();
         mView.list_scroller.hide();
         mView.views_group.location_group.location_list.detachScroller();
         detachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.views_group.location_group.location_list.scrollEventHandler);
         detachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.views_group.location_group.location_list.selectEventHandler);
      }
      
      private function trackNearestStation(e:MouseEvent) : void
      {
         var weatherGrp:MovieClip = mView.views_group.weather_group;
         switch(mView.viewButtons_group.getSelection())
         {
            case WEATHER_FORECAST_BTN:
               Peripheral.travelLink.landWeather.setNearestAsLastViewedStation();
               Peripheral.travelLink.landWeather.setStationSelectionMode(WeatherSelectionMode.CLOSEST);
               this.selectViewButton(WEATHER_FORECAST_BTN);
               mView.headers_group.weatherButtons_group.setSelection("current_button");
               this.setWeatherView("current_button");
               this.clearWeatherInfo();
               break;
            case SKI_INFO_BTN:
               Peripheral.travelLink.landWeather.setSkiSelectionMode(WeatherSelectionMode.CLOSEST);
               mView.headers_group.skiButtons_group.setSelection("currentConditions_button");
               weatherGrp.weatherViews_group.currentOverview_group.hide();
               t(weatherGrp.location_label,"");
               this.clearSkiInfo();
               break;
            default:
               if(mView.favorites_button.getSelected())
               {
                  Peripheral.travelLink.landWeather.setNearestAsLastViewedStation();
                  Peripheral.travelLink.landWeather.setStationSelectionMode(WeatherSelectionMode.CLOSEST);
                  this.selectViewButton(WEATHER_FORECAST_BTN);
                  mView.headers_group.weatherButtons_group.setSelection("current_button");
                  this.setWeatherView("current_button");
                  this.clearWeatherInfo();
               }
         }
      }
      
      private function onStation(e:TravelLinkLandWeatherEvent) : void
      {
         var station:WeatherLocation = Peripheral.travelLink.landWeather.station;
         mView.views_group.weather_group.favorite_icon.visible = station.favorite;
         this.enableAddFavoriteButton(!station.favorite);
         if(WeatherSelectionMode.CLOSEST == Peripheral.travelLink.landWeather.stationSelectionMode)
         {
            this.mSelectedStationID = station.id;
         }
      }
      
      private function onCondition(e:TravelLinkLandWeatherEvent) : void
      {
         var condition:WeatherCondition = null;
         var overview:MovieClip = null;
         var station:WeatherLocation = Peripheral.travelLink.landWeather.station;
         if(WeatherSelectionMode.CLOSEST == Peripheral.travelLink.landWeather.stationSelectionMode || this.mSelectedStationID == -1 || this.mSelectedStationID == station.id)
         {
            t(mView.views_group.weather_group.location_label,station.name);
            condition = Peripheral.travelLink.landWeather.condition;
            if(condition)
            {
               mView.headers_group.weatherButtons_group.current_button.setEnabled(condition.currentDataStatus > DataStatus.EMPTY);
               mView.headers_group.weatherButtons_group.current_button.setInteractive(condition.currentDataStatus > DataStatus.EMPTY);
               mView.headers_group.weatherButtons_group.hourly_button.setEnabled(condition.twelveHourDataStatus > DataStatus.EMPTY);
               mView.headers_group.weatherButtons_group.hourly_button.setInteractive(condition.twelveHourDataStatus > DataStatus.EMPTY);
               mView.headers_group.weatherButtons_group.daily_button.setEnabled(condition.fiveDayDataStatus > DataStatus.EMPTY);
               mView.headers_group.weatherButtons_group.daily_button.setInteractive(condition.fiveDayDataStatus > DataStatus.EMPTY);
               mView.views_group.weather_group.weatherViews_group.currentOverview_group.details_button.setEnabled(condition.currentDetailsDataStatus > DataStatus.EMPTY);
               mView.views_group.weather_group.weatherViews_group.currentOverview_group.details_button.setInteractive(condition.currentDetailsDataStatus > DataStatus.EMPTY);
               if(condition.updateTime != null)
               {
                  t(mView.views_group.weather_group.timestamp_label,condition.updateTime || "");
               }
               overview = mView.views_group.weather_group.weatherViews_group.currentOverview_group;
               if(this.currentView == WEATHER_MAIN)
               {
                  overview.show();
               }
               overview.condition_icon.gotoAndStop(mapCondition(condition.currentCondition || "none"));
               if(condition.currentTemperature != int.MIN_VALUE)
               {
                  t(overview.temperature_label,temperatureString(condition.currentTemperature));
               }
               else
               {
                  t(overview.temperature_label,T.STRB_NA);
               }
               t(overview.condition_label,mapWeatherCondition(condition.currentCondition) || T.STRB_NA);
               if(condition.highTemperature != int.MIN_VALUE && condition.lowTemperature != int.MIN_VALUE)
               {
                  t(overview.highLow_label,temperatureString(condition.highTemperature) + " / " + temperatureString(condition.lowTemperature));
               }
               else
               {
                  t(overview.highLow_label,T.STRB_NA);
               }
               this.mCurrentDetailsList = condition.currentDetails;
               mView.views_group.weather_group.weatherViews_group.currentDetails_list.setLength(this.mCurrentDetailsList.length);
               mView.views_group.weather_group.weatherViews_group.hourly_chain.setLinks(condition.twelveHourForecast);
               mView.views_group.weather_group.weatherViews_group.daily_chain.setLinks(condition.fiveDayForecast);
            }
         }
      }
      
      private function onSki(e:TravelLinkLandWeatherEvent) : void
      {
         var skiResort:WeatherLocation = Peripheral.travelLink.landWeather.ski;
         switch(mView.viewButtons_group.getSelection())
         {
            case SKI_INFO_BTN:
               mView.views_group.weather_group.favorite_icon.visible = skiResort.favorite;
               break;
            case WEATHER_FORECAST_BTN:
         }
         var locationText:String = skiResort.name;
         if(locationText.length == 0)
         {
            t(mView.views_group.skiInfo_group.location_label,T.STRB_MISC_TRAVELLINK_NO_DATA_AVAILABLE);
            this.mSkiDetailsList = new Vector.<WeatherDetail>();
            mView.views_group.skiInfo_group.skiDetails_list.setLength(0);
         }
         else
         {
            t(mView.views_group.skiInfo_group.location_label,locationText);
         }
      }
      
      private function onSkiCondition(e:TravelLinkLandWeatherEvent) : void
      {
         var condition:WeatherCondition = Peripheral.travelLink.landWeather.skiCondition;
         var skiInfo:MovieClip = mView.views_group.skiInfo_group;
         if(condition.currentDetailsDataStatus > DataStatus.EMPTY)
         {
            t(skiInfo.timestamp_label,condition.updateTime || "");
            t(skiInfo.conditions_label,mapWeatherCondition(condition.currentCondition) || T.STRB_NA);
            skiInfo.conditions_icon.gotoAndStop(mapCondition(condition.currentCondition || "none"));
            this.mSkiDetailsList = condition.currentDetails;
            this.updateSkiDetailsList();
         }
         else
         {
            t(skiInfo.timestamp_label,"");
            t(skiInfo.conditions_label,"");
            skiInfo.conditions_icon.gotoAndStop(mapCondition("none"));
            this.mSkiDetailsList = new Vector.<WeatherDetail>();
            this.updateSkiDetailsList();
         }
      }
      
      private function onSelectView(e:WidgetEvent) : void
      {
         var buttonName:String = e.data.targetName;
         this.setView(buttonName);
      }
      
      private function onSelectWeatherView(e:WidgetEvent) : void
      {
         var buttonName:String = e.data.targetName;
         this.setWeatherView(buttonName);
      }
      
      private function onSelectSkiView(e:WidgetEvent) : void
      {
         var buttonName:String = e.data.targetName;
         this.setSkiView(buttonName);
      }
      
      private function onSelectDetails(e:MouseEvent) : void
      {
         mView.views_group.weather_group.weatherViews_group.currentDetails_list.requestData();
         this.setDetailView(true);
      }
      
      private function onMessage(e:MessageEvent) : void
      {
         var offset:int = 0;
         var indexes:Vector.<AlphaJumpIndex> = null;
         var index:AlphaJumpIndex = null;
         if(e.message.type == "alpha number")
         {
            offset = -1;
            indexes = this.getIndexes();
            for each(index in indexes)
            {
               if(index.character == e.message.value)
               {
                  offset = int(index.index);
                  break;
               }
            }
            if(offset >= 0)
            {
               mView.views_group.location_group.location_list.setPosition(offset);
               mView.views_group.location_group.location_list.setCursor(offset);
            }
         }
         else if(e.message.type == "screen transition")
         {
            switch(e.message.value)
            {
               case Peripheral.travelLink.landWeather.CURRENT_FORECAST:
               case Peripheral.travelLink.landWeather.MAIN_FORECAST:
                  mView.headers_group.weatherButtons_group.setSelection("current_button");
                  this.setView(WEATHER_FORECAST_BTN);
                  this.setWeatherView("current_button");
                  break;
               case Peripheral.travelLink.landWeather.EXTENDED_FORECAST:
                  mView.headers_group.weatherButtons_group.setSelection("hourly_button");
                  this.setView(WEATHER_FORECAST_BTN);
                  this.setWeatherView("hourly_button");
                  break;
               case Peripheral.travelLink.landWeather.FIVEDAY_FORECAST:
                  mView.headers_group.weatherButtons_group.setSelection("daily_button");
                  this.setView(WEATHER_FORECAST_BTN);
                  this.setWeatherView("daily_button");
                  break;
               case Peripheral.travelLink.landWeather.SKI_INFO:
                  this.setView(SKI_INFO_BTN);
            }
         }
      }
      
      public function onHardControlVerticalScroll(e:HardControlEvent) : void
      {
         e.stopImmediatePropagation();
         var newPosition:int = int(mView.views_group.skiInfo_group.skiDetails_list.getPosition());
         newPosition += e.data;
         mView.views_group.skiInfo_group.skiDetails_list.setPosition(newPosition);
      }
      
      override protected function onSpeedLockout(e:VehicleStatusEvent) : void
      {
         super.onSpeedLockout(e);
         if(mView.viewButtons_group.getSelection() == SKI_INFO_BTN)
         {
            mView.views_group.message_group.visible = Peripheral.vehicleStatus.speedLockOut;
         }
      }
      
      private function goBack(e:MouseEvent) : void
      {
         var previousView:uint = 0;
         if(!isBackAfterJustAddedFavorite())
         {
            if(this.mHistory.length > 0)
            {
               previousView = this.mHistory.pop();
               this.mBack = true;
               switch(previousView)
               {
                  case WEATHER_MAIN:
                     this.resetViewButtonSelection(WEATHER_FORECAST_BTN);
                     mView.headers_group.weatherButtons_group.show();
                     mView.headers_group.weatherButtons_group.setSelection("current_button");
                     break;
                  case WEATHER_HOURLY:
                     this.resetViewButtonSelection(WEATHER_FORECAST_BTN);
                     mView.headers_group.weatherButtons_group.show();
                     mView.headers_group.weatherButtons_group.setSelection("hourly_button");
                     break;
                  case WEATHER_FIVE_DAY:
                     this.resetViewButtonSelection(WEATHER_FORECAST_BTN);
                     mView.headers_group.weatherButtons_group.show();
                     mView.headers_group.weatherButtons_group.setSelection("daily_button");
                     break;
                  case WEATHER_CHANGE_LOCATION:
                     this.resetViewButtonSelection(WEATHER_FORECAST_BTN);
                     mView.headers_group.weatherButtons_group.show();
                     mView.headers_group.weatherButtons_group.setSelection("changeLocation_button");
                     break;
                  case SKI_INFO_MAIN:
                     this.resetViewButtonSelection(SKI_INFO_BTN);
                     mView.headers_group.skiButtons_group.setSelection("currentConditions_button");
                     break;
                  case SKI_INFO_CHANGE_LOCATION:
                     this.resetViewButtonSelection(SKI_INFO_BTN);
                     mView.headers_group.skiButtons_group.show();
                     mView.headers_group.skiButtons_group.setSelection("changeLocation_button");
               }
            }
            else
            {
               back();
            }
         }
      }
      
      private function resetViewButtonSelection(selection:String) : void
      {
         if(mView.favorites_button.getSelected())
         {
            selection = FAVORITES_BUTTON;
         }
         this.selectViewButton(selection);
      }
      
      private function translateSkiDescription(description:String) : String
      {
         switch(description)
         {
            case "Temp at base":
               return compose(T.STRB_TEMP_AT_BASE);
            case "Base Depth, avg":
               return compose(T.STRB_BASE_DEPTH_AVG);
            case "Base Depth avg Value":
               return compose(T.STRB_BASE_DEPTH_AVG_VALUE);
            case "New snow":
               return compose(T.STRB_NEW_SNOW);
            case "Operational status":
               return compose(T.STRB_OPERATIONAL_STATUS);
            case "Lifts Open":
               return compose(T.STRB_LIFTS_OPEN);
            case "Trails Open":
               return compose(T.STRB_TRAILS_OPEN);
            case "Wind Conditions":
               return compose(T.STRB_WIND_CONDITIONS);
            case "Snow Conditions":
               return compose(T.STRB_SNOW_CONDITIONS);
            case "Snow Making":
               return compose(T.STRB_SNOW_MAKING);
            case "Snow Grooming":
               return compose(T.STRB_SNOW_GROOMING);
            case "Night Skiing":
               return compose(T.STRB_NIGHT_SKIING);
            case "Snowboarding":
               return compose(T.STRB_SNOWBOARDING);
            case null:
         }
         return "";
      }
      
      private function translateDescription(description:String) : String
      {
         switch(description)
         {
            case "Probability of Precipitation":
               return compose(T.STRB_PROBABILITY_OF_PRECIPITATION);
            case "Precipitation Amount":
               return compose(T.STRB_PRECIPITATION_AMOUNT);
            case "Winds":
               return compose(T.STRB_WINDS);
            case "UV Index":
               return compose(T.STRB_UV_INDEX);
            case "Humidity":
               return compose(T.STRB_HUMIDITY);
            case "Cloud Cover":
               return compose(T.STRB_CLOUD_COVER);
            case null:
         }
         return "";
      }
      
      private function translateCloudCoverValue(cloudCoverValue:String) : String
      {
         switch(cloudCoverValue)
         {
            case "Clear":
               return compose(T.STRB_CLOUD_COVER_CLEAR);
            case "Few":
               return compose(T.STRB_CLOUD_COVER_FEW);
            case "Scattered":
               return compose(T.STRB_CLOUD_COVER_SCATTERED);
            case "Broken":
               return compose(T.STRB_CLOUD_COVER_BROKEN);
            case "Overcast":
               return compose(T.STRB_CLOUD_COVER_OVERCAST);
            case "Unknown":
               return compose(T.STRB_CLOUD_COVER_UNKNOWN);
            case null:
         }
         return "";
      }
      
      private function translateSkiSnowConditions(skiSnowCondition:String) : String
      {
         switch(skiSnowCondition)
         {
            case "Powder":
               return compose(T.STRB_SNOW_CONDITION_POWDER);
            case "Hard Packed":
               return compose(T.STRB_SNOW_CONDITION_HARD_PACKED);
            case "Wet Packed":
               return compose(T.STRB_SNOW_CONDITION_WET_PACKED);
            case "Loose Granular":
               return compose(T.STRB_SNOW_CONDITION_LOOSE_GRANULAR);
            case "Wet Granular":
               return compose(T.STRB_SNOW_CONDITION_WET_GRANULAR);
            case "Frozen Granular":
               return compose(T.STRB_SNOW_CONDITION_FROZEN_GRANULAR);
            case "Icy":
               return compose(T.STRB_SNOW_CONDITION_ICY);
            case "Mixed":
               return compose(T.STRB_SNOW_CONDITION_MIXED);
            case "Unknown":
               return compose(T.STRB_SNOW_CONDITION_UNKNOWN);
            case null:
         }
         return "";
      }
      
      private function translateSkiWindConditions(skiWindCondition:String) : String
      {
         switch(skiWindCondition)
         {
            case "Calm":
               return compose(T.STRB_WIND_CONDITION_CALM);
            case "Mild":
               return compose(T.STRB_WIND_CONDITION_MILD);
            case "Moderate":
               return compose(T.STRB_WIND_CONDITION_MODERATE);
            case "Strong":
               return compose(T.STRB_WIND_CONDITION_STRONG);
            case "Gusty":
               return compose(T.STRB_WIND_CONDITION_GUSTY);
            case "Very Strong":
               return compose(T.STRB_WIND_CONDITION_VERY_STRONG);
            case "Not Recommended":
               return compose(T.STRB_WIND_CONDITION_NOT_RECOMM);
            case "Unknown":
               return compose(T.STRB_WIND_CONDITION_UNKNOWN);
            case null:
         }
         return "";
      }
      
      private function setDetailView(show:Boolean) : void
      {
         if(show)
         {
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "524")
            {
               mView.views_group.weather_group.favorite_icon.visible = false;
               mView.views_group.weather_group.header.visible = false;
               mView.views_group.weather_group.location_label.visible = false;
               mView.views_group.weather_group.timestamp_label.visible = false;
               mView.views_group.weather_group.weatherViews_group.currentDetails_list.attachScroller(mView.list_scroller);
            }
            mView.views_group.weather_group.weatherViews_group.currentDetails_list.show();
         }
         else
         {
            if(Peripheral.versionInfo.productVariantID.VARIANT_PRODUCT == "524")
            {
               if(Peripheral.travelLink.landWeather.station.id == Peripheral.travelLink.landWeather.favoriteStation)
               {
                  mView.views_group.weather_group.favorite_icon.visible = true;
               }
               else
               {
                  mView.views_group.weather_group.favorite_icon.visible = false;
               }
               mView.views_group.weather_group.header.visible = true;
               mView.views_group.weather_group.location_label.visible = true;
               mView.views_group.weather_group.timestamp_label.visible = true;
            }
            mView.views_group.weather_group.weatherViews_group.currentDetails_list.hide();
         }
      }
      
      public function onTemperatureUnits(e:Event) : void
      {
         var overview:MovieClip = mView.views_group.weather_group.weatherViews_group.currentOverview_group;
         var condition:WeatherCondition = Peripheral.travelLink.landWeather.condition;
         if(condition.currentTemperature != int.MIN_VALUE)
         {
            t(overview.temperature_label,temperatureString(condition.currentTemperature));
         }
         else
         {
            t(overview.temperature_label,T.STRB_NA);
         }
         if(condition.highTemperature != int.MIN_VALUE && condition.lowTemperature != int.MIN_VALUE)
         {
            t(overview.highLow_label,temperatureString(condition.highTemperature) + " / " + temperatureString(condition.lowTemperature));
         }
         else
         {
            t(overview.highLow_label,T.STRB_NA);
         }
      }
   }
}

