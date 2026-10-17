package com.harman.navigation.Controller.LiveServices.helper
{
   import com.harman.navigation.Controller.LI.LocationInputEvent;
   import com.harman.navigation.Controller.LiveServices.LiveServicesEvent;
   import com.harman.navigation.Controller.LiveServices.WeatherResultList;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.LocationInputPath;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.framework.global.Framework;
   
   public class Weather extends Helper
   {
      
      private var mSearchArea:int = 0;
      
      private var mSearchLoc:LocationDescription = null;
      
      private var mSearchPending:Boolean = false;
      
      private var mSearchFailed:Boolean = false;
      
      private var mWeatherResultList:WeatherResultList = new WeatherResultList();
      
      public function Weather()
      {
         super();
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_WEATHER_UPDATE,this.onWeatherUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.TTLS_WEATHER_UPDATE_FAIL,this.onWeatherUpdateFail,false,0,true);
      }
      
      public function setWeatherSearchArea(area:int, loc:LocationDescription) : void
      {
         this.mSearchArea = area;
         this.mSearchLoc = loc;
         this.mSearchPending = true;
         var tmp:String = this.mSearchLoc.getSecondaryLocation().getType("<GEO>");
         if(tmp != "")
         {
            this.mSearchFailed = false;
            NavigationApi.api.lsRequestWeatherData(tmp);
         }
         else
         {
            tmp = this.mSearchLoc.getPrimaryLocation().getType("<GEO>");
            if(tmp != "")
            {
               this.mSearchFailed = false;
               NavigationApi.api.lsRequestWeatherData(tmp);
            }
            else
            {
               Framework.Trace("Weather.setWeatherSearchArea() No GeoCoordinate found !");
               this.mSearchPending = false;
               this.mSearchFailed = true;
            }
         }
         sendEvent(LiveServicesEvent.LS_WEATHER_UPDATE);
      }
      
      public function get weatherSearchLocation() : LocationDescription
      {
         return this.mSearchLoc;
      }
      
      public function get isWeatherPending() : Boolean
      {
         return this.mSearchPending;
      }
      
      public function get hasRequestFailed() : Boolean
      {
         return this.mSearchFailed;
      }
      
      public function get weatherResults() : WeatherResultList
      {
         return this.mWeatherResultList;
      }
      
      private function onWeatherUpdate(e:NavigationEvent) : void
      {
         this.mSearchPending = false;
         this.mSearchFailed = false;
         this.mWeatherResultList = new WeatherResultList();
         this.mWeatherResultList.importData(e.data as Array);
         sendEvent(LiveServicesEvent.LS_WEATHER_UPDATE);
         if(NavigationPackage.peripheral.navigation.navLocationInput.liIsBusy)
         {
            NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_SET_BUSY,this.onLiCtrlBusy,false,0,true);
         }
         else
         {
            this.fetchWeatherLocationDetails();
         }
      }
      
      private function onWeatherUpdateFail(e:NavigationEvent) : void
      {
         this.mSearchPending = false;
         this.mSearchFailed = true;
         sendEvent(LiveServicesEvent.LS_WEATHER_UPDATE);
      }
      
      private function onLiCtrlBusy(e:LocationInputEvent) : void
      {
         if(!NavigationPackage.peripheral.navigation.navLocationInput.liIsBusy)
         {
            NavigationPackage.peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_SET_BUSY,this.onLiCtrlBusy);
            this.fetchWeatherLocationDetails();
         }
      }
      
      private function fetchWeatherLocationDetails() : void
      {
         var locStr:String = null;
         if(this.mWeatherResultList.list.length > 0)
         {
            if(this.mWeatherResultList.list[0].hasOwnProperty("location"))
            {
               if(Boolean(this.mWeatherResultList.list[0].location.hasOwnProperty("latitude")) && Boolean(this.mWeatherResultList.list[0].location.hasOwnProperty("longitude")))
               {
                  locStr = "<GEO>" + this.mWeatherResultList.list[0].location.longitude + " " + this.mWeatherResultList.list[0].location.latitude + "<*>";
                  NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_INVALID_GEO_COODRINATE,this.onGetDetailsFailed,false,0,true);
                  NavigationPackage.peripheral.navigation.navLocationInput.addEventListener(LocationInputEvent.LI_VALID_GEO_COODRINATE,this.onGetDetailsSuccess,false,0,true);
                  NavigationPackage.peripheral.navigation.navLocationInput.liSetInputPath(LocationInputPath.FETCH_GEO_COORDINATE_DETAILS);
                  NavigationPackage.peripheral.navigation.navLocationInput.liSetGeoCoordinate(locStr,"");
               }
               else
               {
                  Framework.Trace("WeatherResultList.fetchWeatherLocation() Missing \'latitude\' \'longitude\'");
               }
            }
            else
            {
               Framework.Trace("WeatherResultList.fetchWeatherLocation() Missing \'location\'");
            }
         }
         else
         {
            Framework.Trace("WeatherResultList.fetchWeatherLocation() Missing data in mWeatherResultList.list \'" + this.mWeatherResultList.list.length);
         }
      }
      
      private function onGetDetailsSuccess(e:LocationInputEvent) : void
      {
         this.mWeatherResultList.setLocationDetails(NavigationPackage.peripheral.navigation.navLocationInput.liFetchedGeoCoordinateDetails);
         this.removeGetLocDetailsListeners();
         sendEvent(LiveServicesEvent.LS_WEATHER_UPDATE);
      }
      
      private function onGetDetailsFailed(e:LocationInputEvent) : void
      {
         Framework.Trace("WeatherResultList.onGetDetailsFailed() No LocationDetails for WeatherStation available.");
         this.mWeatherResultList.setLocationDetails(this.mSearchLoc);
         this.removeGetLocDetailsListeners();
         sendEvent(LiveServicesEvent.LS_WEATHER_UPDATE);
      }
      
      private function removeGetLocDetailsListeners() : void
      {
         NavigationPackage.peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_INVALID_GEO_COODRINATE,this.onGetDetailsFailed);
         NavigationPackage.peripheral.navigation.navLocationInput.removeEventListener(LocationInputEvent.LI_VALID_GEO_COODRINATE,this.onGetDetailsSuccess);
      }
   }
}

