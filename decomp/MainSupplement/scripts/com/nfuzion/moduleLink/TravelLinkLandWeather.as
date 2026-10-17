package com.nfuzion.moduleLink
{
   import com.harman.moduleLinkAPI.Time;
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.moduleLinkAPI.*;
   import flash.events.TimerEvent;
   
   public class TravelLinkLandWeather extends HmiGatewayModule implements ITravelLinkLandWeather
   {
      
      private static const CONDITION_MAP:Array = ["noData","unknownPrecipitation","isolatedThunderstorms","scatteredThunderstorms","scatteredThunderstormsNight","severeThunderstorms","thunderstorms","rain","lightRain","heavyRain","scatteredShowers","scatteredShowersNight","showers","drizzle","freezingDrizzle","freezingRain","winteryMix","mixedRainSnow","mixedRainSleet","mixedRainHail","hail","sleet","icePellets","flurries","lightSnow","moderateSnow","snow","heavySnow","scatteredSnowShowers","scatteredSnowShowersNight","snowShowers","blowingSnow","blizzard","sandstorm","blowingDust","dust","foggy","lightFog","moderateFog","heavyFog","mist","hazy","smoky","blustery","windy","cold","hot","sunny","mostlySunny","clearNight","mostlyClearNight","partlyCloudy","partlyCloudyNight","mostlyCloudy","mostlyCloudyNight","cloudy","tropicalStorm","hurricane","funnelCloud","tornado"];
      
      private static const STATE_MAP:Array = [{
         "id":1,
         "name":"Alabama",
         "code":"AL"
      },{
         "id":2,
         "name":"Alaska",
         "code":"AK"
      },{
         "id":3,
         "name":"Arizona",
         "code":"AZ"
      },{
         "id":4,
         "name":"Arkansas",
         "code":"AR"
      },{
         "id":5,
         "name":"California",
         "code":"CA"
      },{
         "id":6,
         "name":"Colorado",
         "code":"CO"
      },{
         "id":7,
         "name":"Connecticut",
         "code":"CT"
      },{
         "id":8,
         "name":"Delaware",
         "code":"DE"
      },{
         "id":9,
         "name":"Florida",
         "code":"FL"
      },{
         "id":10,
         "name":"Georgia",
         "code":"GA"
      },{
         "id":11,
         "name":"Hawaii",
         "code":"HI"
      },{
         "id":12,
         "name":"Idaho",
         "code":"ID"
      },{
         "id":13,
         "name":"Illinois",
         "code":"IL"
      },{
         "id":14,
         "name":"Indiana",
         "code":"IN"
      },{
         "id":15,
         "name":"Iowa",
         "code":"IA"
      },{
         "id":16,
         "name":"Kansas",
         "code":"KS"
      },{
         "id":17,
         "name":"Kentucky",
         "code":"KY"
      },{
         "id":18,
         "name":"Louisiana",
         "code":"LA"
      },{
         "id":19,
         "name":"Maine",
         "code":"ME"
      },{
         "id":20,
         "name":"Maryland",
         "code":"MD"
      },{
         "id":21,
         "name":"Massachusetts",
         "code":"MA"
      },{
         "id":22,
         "name":"Michigan",
         "code":"MI"
      },{
         "id":23,
         "name":"Minnesota",
         "code":"MN"
      },{
         "id":24,
         "name":"Mississippi",
         "code":"MS"
      },{
         "id":25,
         "name":"Missouri",
         "code":"MO"
      },{
         "id":26,
         "name":"Montana",
         "code":"MT"
      },{
         "id":27,
         "name":"Nebraska",
         "code":"NE"
      },{
         "id":28,
         "name":"Nevada",
         "code":"NV"
      },{
         "id":29,
         "name":"New Hampshire",
         "code":"NH"
      },{
         "id":30,
         "name":"New Jersey",
         "code":"NJ"
      },{
         "id":31,
         "name":"New Mexico",
         "code":"NM"
      },{
         "id":32,
         "name":"New York",
         "code":"NY"
      },{
         "id":33,
         "name":"North Carolina",
         "code":"NC"
      },{
         "id":34,
         "name":"North Dakota",
         "code":"ND"
      },{
         "id":35,
         "name":"Ohio",
         "code":"OH"
      },{
         "id":36,
         "name":"Oklahoma",
         "code":"OK"
      },{
         "id":37,
         "name":"Oregon",
         "code":"OR"
      },{
         "id":38,
         "name":"Pennsylvania",
         "code":"PA"
      },{
         "id":39,
         "name":"Rhode Island",
         "code":"RI"
      },{
         "id":40,
         "name":"South Carolina",
         "code":"SC"
      },{
         "id":41,
         "name":"South Dakota",
         "code":"SD"
      },{
         "id":42,
         "name":"Tennessee",
         "code":"TN"
      },{
         "id":43,
         "name":"Texas",
         "code":"TX"
      },{
         "id":44,
         "name":"Utah",
         "code":"UT"
      },{
         "id":45,
         "name":"Vermont",
         "code":"VT"
      },{
         "id":46,
         "name":"Virginia",
         "code":"VA"
      },{
         "id":47,
         "name":"Washington",
         "code":"WA"
      },{
         "id":48,
         "name":"West Virginia",
         "code":"WV"
      },{
         "id":49,
         "name":"Wisconsin",
         "code":"WI"
      },{
         "id":50,
         "name":"Wyoming",
         "code":"WY"
      },{
         "id":51,
         "name":"Washington, D.C.",
         "code":"DC"
      },{
         "id":52,
         "name":"Puerto Rico",
         "code":"PR"
      },{
         "id":53,
         "name":"Alberta",
         "code":"AB"
      },{
         "id":54,
         "name":"British Columbia",
         "code":"BC"
      },{
         "id":55,
         "name":"Manitoba",
         "code":"MB"
      },{
         "id":56,
         "name":"New Brunswick",
         "code":"NB"
      },{
         "id":57,
         "name":"Newfoundland/Labrador",
         "code":"NL"
      },{
         "id":58,
         "name":"Nova Scotia",
         "code":"NS"
      },{
         "id":59,
         "name":"Ontario",
         "code":"ON"
      },{
         "id":60,
         "name":"Prince Edward Island",
         "code":"PE"
      },{
         "id":61,
         "name":"Quebec",
         "code":"QC"
      },{
         "id":62,
         "name":"Saskatchewan",
         "code":"SK"
      },{
         "id":63,
         "name":"Northwest Territories",
         "code":"NT"
      },{
         "id":64,
         "name":"Nunavut",
         "code":"NU"
      },{
         "id":65,
         "name":"Yukon Territories",
         "code":"YT"
      },{
         "id":66,
         "name":"Aguascalientes",
         "code":"AGU"
      },{
         "id":67,
         "name":"Baja California",
         "code":"BCN"
      },{
         "id":68,
         "name":"Baja California Sur",
         "code":"BCS"
      },{
         "id":69,
         "name":"Campeche",
         "code":"CAM"
      },{
         "id":70,
         "name":"Chiapas",
         "code":"CHP"
      },{
         "id":71,
         "name":"Chihuahua",
         "code":"CHH"
      },{
         "id":72,
         "name":"Coahuila",
         "code":"COA"
      },{
         "id":73,
         "name":"Colima",
         "code":"COL"
      },{
         "id":74,
         "name":"Durango",
         "code":"DUR"
      },{
         "id":75,
         "name":"Guanajuato",
         "code":"GUA"
      },{
         "id":76,
         "name":"Guerrero",
         "code":"GRO"
      },{
         "id":77,
         "name":"Hidalgo",
         "code":"HID"
      },{
         "id":78,
         "name":"Jalisco",
         "code":"JAL"
      },{
         "id":79,
         "name":"Mexico State",
         "code":"MEX"
      },{
         "id":80,
         "name":"Michoacán",
         "code":"MIC"
      },{
         "id":81,
         "name":"Morelos",
         "code":"MOR"
      },{
         "id":82,
         "name":"Nayarit",
         "code":"NAY"
      },{
         "id":83,
         "name":"Nuevo León",
         "code":"NLE"
      },{
         "id":84,
         "name":"Oaxaca",
         "code":"OAX"
      },{
         "id":85,
         "name":"Puebla",
         "code":"PUE"
      },{
         "id":86,
         "name":"Querétaro",
         "code":"QUE"
      },{
         "id":87,
         "name":"Quintana Roo",
         "code":"ROO"
      },{
         "id":88,
         "name":"San Luis Potosí",
         "code":"SLP"
      },{
         "id":89,
         "name":"Sinaloa",
         "code":"SIN"
      },{
         "id":90,
         "name":"Sonora",
         "code":"SON"
      },{
         "id":91,
         "name":"Tabasco",
         "code":"TAB"
      },{
         "id":92,
         "name":"Tamaulipas",
         "code":"TAM"
      },{
         "id":93,
         "name":"Tlaxcala",
         "code":"TLA"
      },{
         "id":94,
         "name":"Veracruz",
         "code":"VER"
      },{
         "id":95,
         "name":"Yucatán",
         "code":"YUC"
      },{
         "id":96,
         "name":"Zacatecas",
         "code":"ZAC"
      }];
      
      private static const PROPERTY_NAME_FAVORITE:String = "favorite";
      
      private static const REQUEST_GETFORECAST:String = "getForecast";
      
      private static const REQUEST_GETPROPERTIES:String = "getProperties";
      
      private static const REQUEST_SETFORECASTTYPE:String = "setForecastType";
      
      private static const NEAREST_STATION:int = -1;
      
      private static const sMainForecast:String = "main";
      
      private static const sCurrentForecast:String = "current";
      
      private static const sExtendedForecast:String = "extended";
      
      private static const sFiveDayForecast:String = "fiveDay";
      
      private static const sSkiInfo:String = "ski";
      
      private var mStationSelectionMode:String;
      
      private var mStation:WeatherLocation;
      
      private var mCondition:WeatherCondition = new WeatherCondition();
      
      private var mSkiSelectionMode:String;
      
      private var mSkiResort:WeatherLocation;
      
      private var mSkiCondition:WeatherCondition = new WeatherCondition();
      
      private var mCoordinates:Coordinates = new Coordinates();
      
      private var mFavoriteStationId:int = -1;
      
      private var mStationStates:Vector.<String>;
      
      private var mStationState:String;
      
      private var mStations:Vector.<WeatherLocation> = new Vector.<WeatherLocation>();
      
      private var mSkiStates:Vector.<String>;
      
      private var mSkiState:String;
      
      private var mSkiResorts:Vector.<WeatherLocation> = new Vector.<WeatherLocation>();
      
      private var mDayOfWeekIndex:int = 0;
      
      private var mLastViewedStation:int = -1;
      
      public function TravelLinkLandWeather()
      {
         super(ConnectionEvent.TRAVELLINK_LANDWEATHER);
         this.initSelectionMode(WeatherSelectionMode.CLOSEST);
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case TravelLinkLandWeatherEvent.STATION:
               addInterest(TravelLinkLandWeatherEvent.CONDITION);
               break;
            case TravelLinkLandWeatherEvent.CONDITION:
               sendSubscribe("weather");
               break;
            case TravelLinkLandWeatherEvent.SKI:
               addInterest(TravelLinkLandWeatherEvent.SKI_CONDITION);
               break;
            case TravelLinkLandWeatherEvent.SKI_CONDITION:
               sendSubscribe("skiCondition");
               this.getCondition();
               break;
            case TravelLinkLandWeatherEvent.STATION_STATES:
               addInterest(TravelLinkLandWeatherEvent.STATION_STATE_COUNT);
               break;
            case TravelLinkLandWeatherEvent.STATION_STATES_ALPHA_JUMP_LIST:
               addInterest(TravelLinkLandWeatherEvent.STATION_STATE_COUNT);
               break;
            case TravelLinkLandWeatherEvent.STATION_STATE_COUNT:
               sendSubscribe("stateList");
               this.getStationStateCount();
               break;
            case TravelLinkLandWeatherEvent.STATIONS:
               addInterest(TravelLinkLandWeatherEvent.STATION_COUNT);
               break;
            case TravelLinkLandWeatherEvent.STATIONS_ALPHA_JUMP_LIST:
               addInterest(TravelLinkLandWeatherEvent.STATION_COUNT);
               break;
            case TravelLinkLandWeatherEvent.STATION_COUNT:
               sendSubscribe("locationList");
               this.getStationCount();
               break;
            case TravelLinkLandWeatherEvent.FAVORITE:
               sendSubscribe("favorite");
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case TravelLinkLandWeatherEvent.STATION:
               removeInterest(TravelLinkLandWeatherEvent.CONDITION);
               break;
            case TravelLinkLandWeatherEvent.CONDITION:
               sendUnsubscribe("weather");
               break;
            case TravelLinkLandWeatherEvent.SKI:
               removeInterest(TravelLinkLandWeatherEvent.SKI_CONDITION);
               break;
            case TravelLinkLandWeatherEvent.SKI_CONDITION:
               sendUnsubscribe("skiCondition");
               break;
            case TravelLinkLandWeatherEvent.STATION_STATES:
               removeInterest(TravelLinkLandWeatherEvent.STATION_STATE_COUNT);
               break;
            case TravelLinkLandWeatherEvent.STATION_STATE_COUNT:
               sendUnsubscribe("stateList");
               break;
            case TravelLinkLandWeatherEvent.STATIONS:
               removeInterest(TravelLinkLandWeatherEvent.STATION_COUNT);
               break;
            case TravelLinkLandWeatherEvent.STATION_COUNT:
               sendUnsubscribe("locationList");
               break;
            case TravelLinkLandWeatherEvent.FAVORITE:
               sendUnsubscribe("favorite");
         }
      }
      
      public function getCoordinates() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.COORDINATES));
      }
      
      public function setCoordinates(coordinates:Coordinates) : void
      {
         var firstReport:Boolean = false;
         if(coordinates.latitude == 0 && coordinates.longitude == 0)
         {
            return;
         }
         if(this.mCoordinates.latitude == 0 && this.mCoordinates.longitude == 0)
         {
            firstReport = true;
         }
         this.mCoordinates = new Coordinates(coordinates);
         if(firstReport)
         {
         }
         this.getCoordinates();
      }
      
      public function get coordinates() : Coordinates
      {
         return new Coordinates(this.mCoordinates);
      }
      
      public function setStationSelectionMode(mode:String, id:int = -1) : void
      {
         switch(mode)
         {
            case WeatherSelectionMode.CLOSEST:
               sendCommand({"setForecastType":{"type":"current"}});
               this.initSelectionMode(mode);
               break;
            case WeatherSelectionMode.FAVORITE:
               sendCommand({"setForecastType":{"type":"favorite"}});
               this.initSelectionMode(mode);
               break;
            case WeatherSelectionMode.SPECIFIC:
               sendCommand({"setForecastType":{
                  "type":"location",
                  "stationID":id
               }});
               this.initSelectionMode(mode);
         }
         this.getCondition();
         this.getStationSelectionMode();
      }
      
      private function initSelectionMode(mode:String) : void
      {
         this.mStationSelectionMode = mode;
         this.mStation = new WeatherLocation();
         this.mStation.id = -1;
         this.mCondition = new WeatherCondition();
      }
      
      public function getStationSelectionMode() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_SELECTION_MODE));
      }
      
      public function get stationSelectionMode() : String
      {
         return this.mStationSelectionMode;
      }
      
      public function getStation() : void
      {
         if(this.mStation == null || this.mStation.id == -1)
         {
            sendCommand({"getForecast":null});
         }
         else
         {
            dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION));
         }
      }
      
      public function get station() : WeatherLocation
      {
         return this.mStation;
      }
      
      public function getFavoriteStation() : void
      {
         sendCommand({"getProperties":{"props":[PROPERTY_NAME_FAVORITE]}});
      }
      
      public function setFavoriteStation(stationId:int) : void
      {
         var oldFavorite:int = this.mFavoriteStationId;
         sendCommand({"setFavorite":{"stationID":stationId}});
         this.mFavoriteStationId = stationId;
         this.mStation.favorite = this.mStation.id == this.mFavoriteStationId;
         if(stationId < 1)
         {
            if(oldFavorite == this.mStation.id && this.mStationSelectionMode != WeatherSelectionMode.CLOSEST)
            {
               this.setStationSelectionMode(WeatherSelectionMode.SPECIFIC,this.mStation.id);
            }
         }
         else
         {
            this.setStationSelectionMode(WeatherSelectionMode.FAVORITE,stationId);
         }
         this.getFavoriteStation();
      }
      
      public function get favoriteStation() : int
      {
         return this.mFavoriteStationId;
      }
      
      public function getCondition() : void
      {
         if(this.mCondition != null && this.mCondition.currentDataStatus >= DataStatus.COMPLETE && this.mCondition.currentDetailsDataStatus >= DataStatus.COMPLETE && this.mCondition.twelveHourDataStatus >= DataStatus.COMPLETE && this.mCondition.fiveDayDataStatus >= DataStatus.COMPLETE)
         {
            dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.CONDITION));
         }
         else
         {
            sendCommand({"getForecast":null});
         }
      }
      
      public function forceRefresh() : void
      {
         sendCommand({"getForecast":null});
         sendCommand({"getSkiConditions":null});
      }
      
      public function get condition() : WeatherCondition
      {
         return this.mCondition;
      }
      
      public function setSkiSelectionMode(mode:String, id:int = -1) : void
      {
         switch(mode)
         {
            case WeatherSelectionMode.CLOSEST:
               sendCommand({"setSkiConditionsType":{"type":"current"}});
               this.mSkiSelectionMode = mode;
               this.mSkiResort = new WeatherLocation();
               this.mSkiCondition = new WeatherCondition();
               break;
            case WeatherSelectionMode.FAVORITE:
               sendCommand({"setSkiConditionsType":{"type":"favorite"}});
               this.mSkiSelectionMode = mode;
               this.mSkiResort = new WeatherLocation();
               this.mSkiCondition = new WeatherCondition();
               break;
            case WeatherSelectionMode.SPECIFIC:
               sendCommand({"setSkiConditionsType":{
                  "type":"location",
                  "stationID":id
               }});
               this.mSkiSelectionMode = mode;
               this.mSkiResort = new WeatherLocation();
               this.mSkiCondition = new WeatherCondition();
         }
         this.getSkiSelectionMode();
      }
      
      public function getSkiSelectionMode() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_SELECTION_MODE));
      }
      
      public function get skiSelectionMode() : String
      {
         return this.mSkiSelectionMode;
      }
      
      public function getSki() : void
      {
         if(this.mSkiResort != null)
         {
            dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI));
         }
         else
         {
            sendCommand({"getSkiConditions":null});
         }
      }
      
      public function get ski() : WeatherLocation
      {
         return this.mSkiResort;
      }
      
      public function getSkiCondition() : void
      {
         if(this.mSkiCondition != null && this.mSkiCondition.currentDataStatus >= DataStatus.COMPLETE && this.mSkiCondition.currentDetailsDataStatus >= DataStatus.COMPLETE)
         {
            dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_CONDITION));
         }
         else
         {
            sendCommand({"getSkiConditions":null});
         }
      }
      
      public function get skiCondition() : WeatherCondition
      {
         return this.mSkiCondition;
      }
      
      public function getStationStateCount() : void
      {
         if(this.mStationStates != null)
         {
            dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_STATE_COUNT));
         }
         else
         {
            sendCommand({"getStateList":{"skiRequest":false}});
         }
      }
      
      public function get stationStateCount() : int
      {
         if(this.mStationStates != null)
         {
            return this.mStationStates.length;
         }
         return 0;
      }
      
      public function getStationStates(start:int, end:int) : void
      {
         var list:Vector.<String> = new Vector.<String>();
         for(var i:int = start; i <= end; i++)
         {
            list.push(this.mStationStates[i]);
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_STATES,{
            "offset":start,
            "list":list
         }));
      }
      
      public function getStationStatesAlphaJumpList() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_STATES_ALPHA_JUMP_LIST));
      }
      
      public function get stationStatesAlphaJumpList() : Vector.<AlphaJumpIndex>
      {
         var state:String = null;
         var alphaJumpIndex:AlphaJumpIndex = null;
         var list:Vector.<AlphaJumpIndex> = new Vector.<AlphaJumpIndex>();
         var currentLetter:String = null;
         for(var i:int = 0; i < this.mStationStates.length; i++)
         {
            state = this.mStationStates[i];
            if(state.charAt(0) != currentLetter)
            {
               currentLetter = state.charAt(0);
               alphaJumpIndex = new AlphaJumpIndex();
               alphaJumpIndex.character = currentLetter;
               alphaJumpIndex.index = i;
               list.push(alphaJumpIndex);
            }
         }
         return list;
      }
      
      public function setStationState(state:String) : void
      {
         var id:int = this.getStateId(state);
         if(id >= 0)
         {
            this.mStations = null;
            this.mStationState = state;
            sendCommand({"getAreasInState":{
               "stateID":id,
               "skiRequest":false
            }});
         }
      }
      
      public function getStationState() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_STATE));
      }
      
      public function get stationState() : String
      {
         return this.mStationState;
      }
      
      public function getStationCount() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_COUNT));
      }
      
      public function get stationCount() : int
      {
         if(this.mStations != null)
         {
            return this.mStations.length;
         }
         return 0;
      }
      
      public function getStations(start:int, end:int) : void
      {
         var list:Vector.<WeatherLocation> = new Vector.<WeatherLocation>();
         for(var i:int = start; i <= end; i++)
         {
            list.push(this.mStations[i]);
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATIONS,{
            "offset":start,
            "list":list
         }));
      }
      
      public function getStationsAlphaJumpList() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATIONS_ALPHA_JUMP_LIST));
      }
      
      public function get stationsAlphaJumpList() : Vector.<AlphaJumpIndex>
      {
         var i:int = 0;
         var name:String = null;
         var alphaJumpIndex:AlphaJumpIndex = null;
         var list:Vector.<AlphaJumpIndex> = new Vector.<AlphaJumpIndex>();
         var currentLetter:String = null;
         if(this.mStations != null)
         {
            for(i = 0; i < this.mStations.length; i++)
            {
               name = this.mStations[i].name;
               if(name.charAt(0) != currentLetter)
               {
                  currentLetter = name.charAt(0);
                  alphaJumpIndex = new AlphaJumpIndex();
                  alphaJumpIndex.character = currentLetter;
                  alphaJumpIndex.index = i;
                  list.push(alphaJumpIndex);
               }
            }
         }
         return list;
      }
      
      public function getSkiStateCount() : void
      {
         if(this.mSkiStates != null)
         {
            dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_STATE_COUNT));
         }
         else
         {
            sendCommand({"getStateList":{"skiRequest":true}});
         }
      }
      
      public function get skiStateCount() : int
      {
         if(this.mSkiStates != null)
         {
            return this.mSkiStates.length;
         }
         return 0;
      }
      
      public function getSkiStates(start:int, end:int) : void
      {
         var list:Vector.<String> = new Vector.<String>();
         for(var i:int = start; i <= end; i++)
         {
            list.push(this.mSkiStates[i]);
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_STATES,{
            "offset":start,
            "list":list
         }));
      }
      
      public function getSkiStatesAlphaJumpList() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_STATES_ALPHA_JUMP_LIST));
      }
      
      public function get skiStatesAlphaJumpList() : Vector.<AlphaJumpIndex>
      {
         var state:String = null;
         var alphaJumpIndex:AlphaJumpIndex = null;
         var list:Vector.<AlphaJumpIndex> = new Vector.<AlphaJumpIndex>();
         var currentLetter:String = null;
         for(var i:int = 0; i < this.mSkiStates.length; i++)
         {
            state = this.mSkiStates[i];
            if(state.charAt(0) != currentLetter)
            {
               currentLetter = state.charAt(0);
               alphaJumpIndex = new AlphaJumpIndex();
               alphaJumpIndex.character = currentLetter;
               alphaJumpIndex.index = i;
               list.push(alphaJumpIndex);
            }
         }
         return list;
      }
      
      public function setSkiState(state:String) : void
      {
         var id:int = this.getStateId(state);
         if(id >= 0)
         {
            this.mSkiResorts = null;
            this.mSkiState = state;
            sendCommand({"getAreasInState":{
               "stateID":id,
               "skiRequest":true
            }});
         }
      }
      
      public function getSkiState() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_STATE));
      }
      
      public function get skiState() : String
      {
         return this.mSkiState;
      }
      
      public function getSkiResortCount() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_RESORT_COUNT));
      }
      
      public function get skiResortCount() : int
      {
         if(this.mSkiResorts != null)
         {
            return this.mSkiResorts.length;
         }
         return 0;
      }
      
      public function getSkiResorts(start:int, end:int) : void
      {
         var list:Vector.<WeatherLocation> = new Vector.<WeatherLocation>();
         for(var i:int = start; i <= end; i++)
         {
            list.push(this.mSkiResorts[i]);
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_RESORTS,{
            "offset":start,
            "list":list
         }));
      }
      
      public function getSkiResortsAlphaJumpList() : void
      {
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_RESORTS_ALPHA_JUMP_LIST));
      }
      
      public function get skiResortsAlphaJumpList() : Vector.<AlphaJumpIndex>
      {
         var name:String = null;
         var alphaJumpIndex:AlphaJumpIndex = null;
         var list:Vector.<AlphaJumpIndex> = new Vector.<AlphaJumpIndex>();
         var currentLetter:String = null;
         for(var i:int = 0; i < this.mSkiResorts.length; i++)
         {
            name = this.mSkiResorts[i].name;
            if(name.charAt(0) != currentLetter)
            {
               currentLetter = name.charAt(0);
               alphaJumpIndex = new AlphaJumpIndex();
               alphaJumpIndex.character = currentLetter;
               alphaJumpIndex.index = i;
               list.push(alphaJumpIndex);
            }
         }
         return list;
      }
      
      public function setStationAsLastViewedStation(stationId:int) : void
      {
         this.mLastViewedStation = stationId;
      }
      
      public function setNearestAsLastViewedStation() : void
      {
         this.mLastViewedStation = NEAREST_STATION;
      }
      
      public function get lastViewedStation() : int
      {
         return this.mLastViewedStation;
      }
      
      public function get lastViewedStationIsNearest() : Boolean
      {
         return this.mLastViewedStation == NEAREST_STATION;
      }
      
      public function get CURRENT_FORECAST() : String
      {
         return sCurrentForecast;
      }
      
      public function get MAIN_FORECAST() : String
      {
         return sMainForecast;
      }
      
      public function get EXTENDED_FORECAST() : String
      {
         return sExtendedForecast;
      }
      
      public function get FIVEDAY_FORECAST() : String
      {
         return sFiveDayForecast;
      }
      
      public function get SKI_INFO() : String
      {
         return sSkiInfo;
      }
      
      private function reportPosition(e:TimerEvent = null) : void
      {
      }
      
      override protected function messageHandler(e:ConnectionEvent) : void
      {
         var message:Object = e.data;
         if(message.hasOwnProperty(REQUEST_GETFORECAST))
         {
            if(this.handleCmdResponse(REQUEST_GETFORECAST,message.getForecast))
            {
               return;
            }
         }
         else if(message.hasOwnProperty(REQUEST_GETPROPERTIES))
         {
            if(this.handleCmdResponse(REQUEST_GETPROPERTIES,message.getProperties))
            {
               return;
            }
         }
         else if(message.hasOwnProperty(REQUEST_SETFORECASTTYPE))
         {
            if(this.handleCmdResponse(REQUEST_SETFORECASTTYPE,message.setForecastType))
            {
               return;
            }
         }
         else if(message.hasOwnProperty("weather"))
         {
            this.processCondition(message.weather);
         }
         else if(message.hasOwnProperty("skiCondition"))
         {
            this.processSkiCondition(message.skiCondition);
         }
         else if(message.hasOwnProperty("stateList"))
         {
            if(!message.stateList.skiArea)
            {
               this.processStationStateList(message.stateList.list);
            }
            else
            {
               this.processSkiStateList(message.stateList.list);
            }
         }
         else if(message.hasOwnProperty("locationList"))
         {
            if(!message.locationList.skiArea)
            {
               if(message.locationList.hasOwnProperty("list"))
               {
                  this.processStationList = message.locationList.list.sortOn("name");
               }
            }
            else if(message.locationList.hasOwnProperty("list"))
            {
               this.processSkiResortList = message.locationList.list.sortOn("name");
            }
         }
         else if(message.hasOwnProperty(PROPERTY_NAME_FAVORITE))
         {
            this.mFavoriteStationId = message.favorite.locationID;
            if(this.mStation != null)
            {
               this.mStation.favorite = this.mStation.id == this.mFavoriteStationId;
            }
            dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.FAVORITE));
         }
      }
      
      private function handleCmdResponse(cmd:String, obj:Object) : Boolean
      {
         var rv:Boolean = false;
         if(obj != null && obj.hasOwnProperty("CmdResponse"))
         {
            rv = true;
         }
         return rv;
      }
      
      private function set processStationList(list:Array) : void
      {
         var stationObject:Object = null;
         var station:WeatherLocation = null;
         this.mStations = new Vector.<WeatherLocation>();
         for each(stationObject in list)
         {
            station = new WeatherLocation();
            station.id = stationObject.locationID;
            station.name = stationObject.name;
            this.mStations.push(station);
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_COUNT));
      }
      
      private function set processSkiResortList(list:Array) : void
      {
         var skiResortObject:Object = null;
         var skiResort:WeatherLocation = null;
         this.mSkiResorts = new Vector.<WeatherLocation>();
         for each(skiResortObject in list)
         {
            skiResort = new WeatherLocation();
            skiResort.id = skiResortObject.locationID;
            skiResort.name = skiResortObject.name;
            this.mSkiResorts.push(skiResort);
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_RESORT_COUNT));
      }
      
      private function processStationStateList(list:Array) : void
      {
         var state:Object = null;
         this.mStationStates = new Vector.<String>();
         for each(state in list)
         {
            if(state.count > 0 && state.stateID <= 50)
            {
               this.mStationStates.push(this.getStateById(state.stateID));
            }
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION_STATE_COUNT));
      }
      
      private function processSkiStateList(list:Array) : void
      {
         var state:Object = null;
         this.mSkiStates = new Vector.<String>();
         for each(state in list)
         {
            if(state.count > 0 && state.stateID <= 50)
            {
               this.mSkiStates.push(this.getStateById(state.stateID));
            }
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_STATE_COUNT));
      }
      
      private function getStateById(id:int) : String
      {
         var state:Object = null;
         for each(state in STATE_MAP)
         {
            if(state.id == id)
            {
               return state.name;
            }
         }
         return null;
      }
      
      private function getStateId(name:String) : int
      {
         var state:Object = null;
         for each(state in STATE_MAP)
         {
            if(state.name == name)
            {
               return state.id;
            }
         }
         return 0;
      }
      
      private function processSkiCondition(conditions:Object) : void
      {
         this.mSkiResort = this.parseLocation(conditions.location);
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI));
         this.mSkiCondition = new WeatherCondition();
         if(conditions.hasOwnProperty("updateTime"))
         {
            this.mSkiCondition.updateTime = conditions.updateTime;
         }
         if(conditions.hasOwnProperty("conditionCode"))
         {
            this.mSkiCondition.currentCondition = this.parseCondition(conditions.conditionCode);
         }
         if(conditions.hasOwnProperty("condition"))
         {
            this.mSkiCondition.currentDescription = conditions.condition;
         }
         this.mSkiCondition.currentDetails = this.parseDetails(conditions.forecastDetails);
         with(this.mSkiCondition)
         {
            if(Boolean(updateTime) && Boolean(currentCondition) && Boolean(currentDescription))
            {
               currentDataStatus = DataStatus.COMPLETE;
            }
            else if(Boolean(updateTime) || Boolean(currentCondition) || Boolean(currentDescription))
            {
               currentDataStatus = DataStatus.PARTIAL;
            }
            if(currentDetails.length > 0)
            {
               currentDetailsDataStatus = DataStatus.COMPLETE;
            }
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.SKI_CONDITION));
      }
      
      private function processCondition(conditions:Object) : void
      {
         var current:Object = null;
         var intraday:Object = null;
         var forecastHour:WeatherForecastHour = null;
         var fiveDay:Object = null;
         var forecastDay:WeatherForecastDay = null;
         var day:Object = null;
         this.mStation = this.parseLocation(conditions.location);
         if(this.mStation.favorite == true)
         {
            this.mFavoriteStationId = this.mStation.id;
         }
         else if(this.mStation.id == this.mFavoriteStationId)
         {
            this.mFavoriteStationId = -1;
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.STATION));
         this.mCondition = new WeatherCondition();
         if(conditions.hasOwnProperty("updateTime"))
         {
            this.mCondition.updateTime = conditions.updateTime;
         }
         if(conditions.hasOwnProperty("curCondition"))
         {
            current = conditions.curCondition;
            if(current.hasOwnProperty("conditionCode"))
            {
               this.mCondition.currentCondition = this.parseCondition(current.conditionCode);
            }
            if(current.hasOwnProperty("condition"))
            {
               this.mCondition.currentDescription = current.condition;
            }
            this.mCondition.currentDetails = this.parseDetails(current.forecastDetails);
            if(current.hasOwnProperty("temperature"))
            {
               this.mCondition.currentTemperature = int(current.temperature);
            }
            if(current.hasOwnProperty("hiTemp"))
            {
               this.mCondition.highTemperature = int(current.hiTemp);
            }
            if(current.hasOwnProperty("loTemp"))
            {
               this.mCondition.lowTemperature = int(current.loTemp);
            }
            with(this.mCondition)
            {
               
               if(Boolean(currentCondition && currentDescription && currentTemperature != int.MIN_VALUE) && Boolean(highTemperature != int.MIN_VALUE) && lowTemperature != int.MIN_VALUE)
               {
                  currentDataStatus = DataStatus.COMPLETE;
               }
               else if(Boolean(currentCondition || currentDescription || currentTemperature != int.MIN_VALUE) || Boolean(highTemperature != int.MIN_VALUE) || lowTemperature != int.MIN_VALUE)
               {
                  currentDataStatus = DataStatus.PARTIAL;
               }
               if(currentDetails.length > 0)
               {
                  currentDetailsDataStatus = DataStatus.COMPLETE;
               }
            }
         }
         if(conditions.hasOwnProperty("intraday"))
         {
            this.mCondition.twelveHourForecast = new Vector.<WeatherForecastHour>();
            intraday = conditions.intraday;
            if(intraday.hasOwnProperty("threeHour"))
            {
               forecastHour = new WeatherForecastHour();
               forecastHour.hour = 3;
               forecastHour.condition = this.parseCondition(intraday.threeHour.conditionCode);
               forecastHour.description = intraday.threeHour.condition;
               if(intraday.threeHour.hasOwnProperty("precipChance"))
               {
                  forecastHour.preciptiationChance = intraday.threeHour.precipChance;
               }
               if(intraday.threeHour.hasOwnProperty("temperature"))
               {
                  forecastHour.temperature = intraday.threeHour.temperature;
               }
               this.mCondition.twelveHourForecast.push(forecastHour);
            }
            if(intraday.hasOwnProperty("sixHour"))
            {
               forecastHour = new WeatherForecastHour();
               forecastHour.hour = 6;
               forecastHour.condition = this.parseCondition(intraday.sixHour.conditionCode);
               forecastHour.description = intraday.sixHour.condition;
               if(intraday.sixHour.hasOwnProperty("precipChance"))
               {
                  forecastHour.preciptiationChance = intraday.sixHour.precipChance;
               }
               if(intraday.sixHour.hasOwnProperty("temperature"))
               {
                  forecastHour.temperature = intraday.sixHour.temperature;
               }
               this.mCondition.twelveHourForecast.push(forecastHour);
            }
            with(this.mCondition)
            {
               
               if(twelveHourForecast.length >= 2)
               {
                  twelveHourDataStatus = DataStatus.COMPLETE;
               }
               else if(twelveHourForecast.length > 0)
               {
                  twelveHourDataStatus = DataStatus.PARTIAL;
               }
            }
         }
         if(conditions.hasOwnProperty("fiveDay"))
         {
            this.mCondition.fiveDayForecast = new Vector.<WeatherForecastDay>();
            fiveDay = conditions.fiveDay;
            for each(day in fiveDay)
            {
               forecastDay = new WeatherForecastDay();
               forecastDay.condition = this.parseCondition(day.conditionCode);
               forecastDay.description = day.condition;
               forecastDay.day = day.dayOfWeek;
               forecastDay.dayIndex = this.dayToDayIndex(day.dayOfWeek);
               if(day.hasOwnProperty("hiTemp"))
               {
                  forecastDay.highTemperature = day.hiTemp;
               }
               if(day.hasOwnProperty("loTemp"))
               {
                  forecastDay.lowTemperature = day.loTemp;
               }
               if(day.hasOwnProperty("precipChance"))
               {
                  forecastDay.preciptiationChance = day.precipChance;
               }
               this.mCondition.fiveDayForecast.push(forecastDay);
            }
            with(this.mCondition)
            {
               
               if(fiveDayForecast.length >= 5)
               {
                  fiveDayDataStatus = DataStatus.COMPLETE;
               }
               else if(fiveDayForecast.length > 0)
               {
                  fiveDayDataStatus = DataStatus.PARTIAL;
               }
            }
            this.orderFiveDayForecast();
         }
         dispatchEvent(new TravelLinkLandWeatherEvent(TravelLinkLandWeatherEvent.CONDITION));
      }
      
      private function parseDetails(message:Object) : Vector.<WeatherDetail>
      {
         var detailObject:Object = null;
         var detail:WeatherDetail = null;
         var details:Vector.<WeatherDetail> = new Vector.<WeatherDetail>();
         for each(detailObject in message)
         {
            detail = new WeatherDetail();
            detail.description = detailObject.description;
            detail.value = detailObject.value;
            details.push(detail);
         }
         return details;
      }
      
      private function parseCondition(code:int) : String
      {
         var condition:String = "none";
         if(code >= 0 && code < CONDITION_MAP.length)
         {
            condition = CONDITION_MAP[code];
         }
         return condition;
      }
      
      private function parseLocation(message:Object) : WeatherLocation
      {
         var location:WeatherLocation = new WeatherLocation();
         if(message)
         {
            location.favorite = message.isFavorite == "true";
            location.id = int(message.locationID);
            location.name = message.name;
         }
         else
         {
            location.favorite = false;
            location.id = -1;
            location.name = "";
         }
         return location;
      }
      
      private function orderFiveDayForecast() : void
      {
         var today:Date = null;
         var time:Time = Clock.getInstance()._time;
         today = new Date(time.year,time.month - 1,time.day,time.hour,time.minute,0);
         this.mDayOfWeekIndex = today.getDay();
         trace(" >> time.year: " + time.year + " time.month: " + (time.month - 1) + " time.day: " + time.day + "time.hour: " + time.hour + "time.min: " + time.minute);
         trace("mDayOfWeekIndex: " + this.mDayOfWeekIndex);
         this.mCondition.fiveDayForecast.sort(this.compareFiveDayForecast);
      }
      
      private function compareFiveDayForecast(x:WeatherForecastDay, y:WeatherForecastDay) : int
      {
         var xPosition:int = (x.dayIndex + 7 - this.mDayOfWeekIndex) % 7;
         var yPosition:int = (y.dayIndex + 7 - this.mDayOfWeekIndex) % 7;
         return xPosition - yPosition;
      }
      
      private function dayToDayIndex(name:String) : int
      {
         var index:int = -1;
         name = name.toLowerCase();
         switch(name.charAt(0))
         {
            case "s":
               switch(name.charAt(1))
               {
                  case "u":
                     index = 0;
                     break;
                  case "a":
                     index = 6;
               }
               break;
            case "m":
               index = 1;
               break;
            case "t":
               switch(name.charAt(1))
               {
                  case "u":
                     index = 2;
                     break;
                  case "h":
                     index = 4;
               }
               break;
            case "w":
               index = 3;
               break;
            case "f":
               index = 5;
         }
         return index;
      }
   }
}

