package com.nfuzion.moduleLink
{
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.geographic.Distance;
   import com.nfuzion.moduleLinkAPI.FuelPrice;
   import com.nfuzion.moduleLinkAPI.FuelStation;
   import com.nfuzion.moduleLinkAPI.FuelStationList;
   import com.nfuzion.moduleLinkAPI.FuelStationSortField;
   import com.nfuzion.moduleLinkAPI.ITravelLinkFuel;
   import com.nfuzion.moduleLinkAPI.TravelLinkFuelEvent;
   import com.nfuzion.moduleLinkAPI.TravelLinkStatus;
   import flash.events.TimerEvent;
   
   public class TravelLinkFuel extends HmiGatewayModule implements ITravelLinkFuel
   {
      
      private var mServiceStatus:String = "notReady";
      
      private var mDefaultFuelTypeID:int = -1;
      
      private var mFavoriteStation:FuelStation = new FuelStation();
      
      private var mFuelTypeNames:Vector.<String>;
      
      private var mFuelTypeIDs:Vector.<int>;
      
      private var mStations:Vector.<FuelStation> = null;
      
      private var mSearchRadius:Distance = new Distance();
      
      private var mStationSortField:String;
      
      private var mCoordinates:Coordinates = new Coordinates();
      
      private var mStationsSubscription:int = 0;
      
      private var mWaitingForStations:Boolean = false;
      
      public function TravelLinkFuel()
      {
         super(ConnectionEvent.TRAVELLINK_FUEL);
      }
      
      override protected function init() : void
      {
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case TravelLinkFuelEvent.SERVICE_STATUS:
               sendSubscribe("status");
               this.getServiceStatus();
               break;
            case TravelLinkFuelEvent.FUEL_TYPES:
               sendSubscribe("fuelTypes");
               this.getFuelTypes();
               break;
            case TravelLinkFuelEvent.DEFAULT_FUEL_TYPE:
               addInterest(TravelLinkFuelEvent.FUEL_TYPES);
               sendSubscribe("defaultFuelType");
               this.getDefaultFuelType();
               break;
            case TravelLinkFuelEvent.FAVORITE_STATION:
               sendSubscribe("favoriteStation");
               this.getFavoriteStation();
               break;
            case TravelLinkFuelEvent.STATIONS_COUNT:
            case TravelLinkFuelEvent.STATIONS:
               if(this.mStationsSubscription == 0)
               {
                  sendSubscribe("closestStations");
               }
               ++this.mStationsSubscription;
               break;
            case TravelLinkFuelEvent.STATION_DETAILS:
               sendSubscribe("detailedStationInfo");
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case TravelLinkFuelEvent.SERVICE_STATUS:
               sendUnsubscribe("status");
               break;
            case TravelLinkFuelEvent.FUEL_TYPES:
               sendUnsubscribe("fuelTypes");
               break;
            case TravelLinkFuelEvent.DEFAULT_FUEL_TYPE:
               removeInterest(TravelLinkFuelEvent.FUEL_TYPES);
               sendUnsubscribe("defaultFuelType");
               break;
            case TravelLinkFuelEvent.FAVORITE_STATION:
               sendUnsubscribe("favoriteStation");
               break;
            case TravelLinkFuelEvent.STATIONS_COUNT:
            case TravelLinkFuelEvent.STATIONS:
               --this.mStationsSubscription;
               if(this.mStationsSubscription == 0)
               {
                  sendUnsubscribe("closestStations");
               }
               break;
            case TravelLinkFuelEvent.STATION_DETAILS:
               sendUnsubscribe("detailedStationInfo");
         }
      }
      
      public function getServiceStatus() : void
      {
         sendCommand({"getProperties":{"props":"status"}});
      }
      
      public function get serviceStatus() : String
      {
         return this.mServiceStatus;
      }
      
      public function getFuelTypes() : void
      {
         sendCommand({"getProperties":{"props":"fuelTypes"}});
      }
      
      public function get fuelTypes() : Vector.<String>
      {
         return this.mFuelTypeNames;
      }
      
      public function getDefaultFuelType() : void
      {
         sendCommand({"getProperties":{"props":"defaultFuelType"}});
      }
      
      public function setDefaultFuelType(fuelType:String) : void
      {
         for(var i:int = 0; i < this.mFuelTypeNames.length; i++)
         {
            if(this.mFuelTypeNames[i] == fuelType)
            {
               this.mDefaultFuelTypeID = this.mFuelTypeIDs[i];
               sendCommand({"setDefaultFuelType":{"fuelID":this.mDefaultFuelTypeID}});
               break;
            }
         }
      }
      
      public function get defaultFuelType() : String
      {
         var i:int = 0;
         if(this.mFuelTypeNames != null)
         {
            for(i = 0; i < this.mFuelTypeNames.length; i++)
            {
               if(this.mFuelTypeIDs[i] == this.mDefaultFuelTypeID)
               {
                  return this.mFuelTypeNames[i];
               }
            }
         }
         return null;
      }
      
      public function getSearchRadius() : void
      {
      }
      
      public function setSearchRadius(searchRadius:Distance) : void
      {
      }
      
      public function get searchRadius() : Distance
      {
         return new Distance(this.mSearchRadius);
      }
      
      public function getFavoriteStation() : void
      {
         sendCommand({"getProperties":{"props":"favoriteStation"}});
      }
      
      public function setFavoriteStation(station:FuelStation) : void
      {
         sendCommand({"setFavoriteStation":{"stationID":station.id}});
      }
      
      public function get favoriteStation() : FuelStation
      {
         return this.mFavoriteStation;
      }
      
      public function clearFavoriteStation(station:FuelStation) : void
      {
         sendCommand({"clearFavoriteStation":{"stationID":station.id}});
      }
      
      public function getStationSortField() : void
      {
         dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.STATION_SORT_FIELD));
      }
      
      public function setStationSortField(sortField:String) : void
      {
         switch(sortField)
         {
            case FuelStationSortField.BRAND:
               this.mStationSortField = sortField;
               break;
            case FuelStationSortField.PRICE:
               this.mStationSortField = sortField;
               break;
            case FuelStationSortField.DISTANCE:
               this.mStationSortField = sortField;
         }
         this.sortStations();
         this.getStationSortField();
      }
      
      public function get stationSortField() : String
      {
         return this.mStationSortField;
      }
      
      public function getStationsCount() : void
      {
         if(this.mStations != null)
         {
            dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.STATIONS_COUNT));
         }
         else
         {
            this.updateStations();
         }
      }
      
      public function get stationsCount() : uint
      {
         if(this.mStations != null)
         {
            return this.mStations.length;
         }
         return 0;
      }
      
      public function getNearestStations() : void
      {
         this.updateStations();
      }
      
      public function getStations(start:uint, end:uint) : void
      {
         var i:int = 0;
         var stations:FuelStationList = new FuelStationList(start,new Vector.<FuelStation>());
         if(start < this.mStations.length)
         {
            if(end > this.mStations.length)
            {
               end = this.mStations.length;
            }
            for(i = int(start); i <= end; i++)
            {
               this.mStations[i].favorite = this.mStations[i].id == this.mFavoriteStation.id;
               this.mStations[i].distance = this.mCoordinates.distanceTo(this.mStations[i].coordinates);
               this.mStations[i].bearing = this.mCoordinates.bearingTo(this.mStations[i].coordinates);
               stations.list.push(this.mStations[i]);
            }
         }
         dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.STATIONS,stations));
      }
      
      public function getStationDetails(station:FuelStation) : void
      {
         sendCommand({"requestDetailedStationInfo":{"stationID":station.id}});
      }
      
      public function getCoordinates() : void
      {
         dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.COORDINATES));
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
      
      private function sortStations() : void
      {
         var station:FuelStation = null;
         if(this.mStations == null)
         {
            return;
         }
         for each(station in this.mStations)
         {
            station.distance = this.mCoordinates.distanceTo(station.coordinates);
         }
         switch(this.mStationSortField)
         {
            case FuelStationSortField.BRAND:
               this.mStations = this.mStations.sort(function(xStation:FuelStation, yStation:FuelStation):int
               {
                  return xStation.brand.localeCompare(yStation.brand);
               });
               break;
            case FuelStationSortField.PRICE:
               this.mStations = this.mStations.sort(function(xStation:FuelStation, yStation:FuelStation):int
               {
                  var string:* = undefined;
                  var x:* = Number(xStation.defaultPrice.slice(1));
                  var y:* = Number(yStation.defaultPrice.slice(1));
                  if(x < y)
                  {
                     return -1;
                  }
                  if(x == y)
                  {
                     return 0;
                  }
                  return 1;
               });
               break;
            case FuelStationSortField.DISTANCE:
               this.mStations = this.mStations.sort(function(xStation:FuelStation, yStation:FuelStation):int
               {
                  var x:* = xStation.distance.miles;
                  var y:* = yStation.distance.miles;
                  if(x < y)
                  {
                     return -1;
                  }
                  if(x == y)
                  {
                     return 0;
                  }
                  return 1;
               });
         }
      }
      
      private function updateStations() : void
      {
         if(this.mCoordinates != null)
         {
            sendCommand({"getProperties":{"props":"closestStations"}});
         }
         else
         {
            this.mWaitingForStations = true;
         }
      }
      
      private function reportPosition(e:TimerEvent = null) : void
      {
      }
      
      private function setSearchArea() : void
      {
      }
      
      override protected function messageHandler(e:ConnectionEvent) : void
      {
         var o:Object = null;
         var message:String = null;
         var rtnstr:String = null;
         var rtn:int = 0;
         var i:int = 0;
         var fuel:Object = e.data;
         if(!fuel.hasOwnProperty(""))
         {
            if(fuel.hasOwnProperty("status"))
            {
               switch(fuel.status)
               {
                  case "NOT_READY":
                     this.mServiceStatus = TravelLinkStatus.NOT_READY;
                     break;
                  case "READY":
                     this.mServiceStatus = TravelLinkStatus.READY;
                     break;
                  default:
                     this.mServiceStatus = TravelLinkStatus.ERROR;
               }
               this.dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.SERVICE_STATUS,this.mServiceStatus));
            }
            else if(fuel.hasOwnProperty("fuelTypes"))
            {
               this.mFuelTypeNames = new Vector.<String>();
               this.mFuelTypeIDs = new Vector.<int>();
               for(i = 0; i < fuel.fuelTypes.length; i++)
               {
                  this.mFuelTypeNames.push(fuel.fuelTypes[i].description);
                  this.mFuelTypeIDs.push(fuel.fuelTypes[i].id);
               }
               this.dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.FUEL_TYPES));
            }
            else if(fuel.hasOwnProperty("defaultFuelType"))
            {
               this.mDefaultFuelTypeID = fuel.defaultFuelType;
               dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.DEFAULT_FUEL_TYPE));
            }
            else if(fuel.hasOwnProperty("favoriteStation"))
            {
               this.mFavoriteStation.id = fuel.favoriteStation.stationID;
               dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.FAVORITE_STATION));
            }
            else if(fuel.hasOwnProperty("closestStations"))
            {
               this.decodeStations(fuel.closestStations);
               this.sortStations();
               dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.STATIONS_COUNT));
            }
            else if(fuel.hasOwnProperty("detailedStationInfo"))
            {
               this.dispatchEvent(new TravelLinkFuelEvent(TravelLinkFuelEvent.STATION_DETAILS,this.decodeStationDetails(fuel.detailedStationInfo)));
            }
         }
      }
      
      private function decodeFuelTypes(fuelPrices:Object) : Vector.<FuelPrice>
      {
         var fuelPrice:Object = null;
         var price:FuelPrice = null;
         var prices:Vector.<FuelPrice> = new Vector.<FuelPrice>();
         for each(fuelPrice in fuelPrices)
         {
            price = new FuelPrice();
            price.id = fuelPrice.id;
            price.name = fuelPrice.description;
            price.price = fuelPrice.price;
            price.daysOld = fuelPrice.lastUpdate;
            prices.push(price);
         }
         return prices;
      }
      
      private function decodeStations(stationsObject:Object) : void
      {
         var stationObject:Object = null;
         var station:FuelStation = null;
         this.mStations = new Vector.<FuelStation>();
         for each(stationObject in stationsObject)
         {
            station = new FuelStation();
            station.id = int(stationObject.stationID);
            station.brand = stationObject.brand;
            station.defaultPrice = stationObject.price;
            station.daysOld = stationObject.lastUpdate;
            station.coordinates = new Coordinates();
            station.coordinates.latitude = Number(stationObject.latitude);
            station.coordinates.longitude = Number(stationObject.longitude);
            this.mStations.push(station);
         }
      }
      
      private function decodeStationDetails(stationDetailsObject:Object) : FuelStation
      {
         var price:FuelPrice = null;
         var station:FuelStation = new FuelStation();
         station.id = int(stationDetailsObject.stationID);
         station.brand = stationDetailsObject.brand;
         station.name = stationDetailsObject.name;
         station.address = stationDetailsObject.address;
         station.phone = stationDetailsObject.phone.split(")").join(") ");
         station.city = stationDetailsObject.city;
         station.state = stationDetailsObject.state;
         station.city = stationDetailsObject.city;
         station.zip = stationDetailsObject.zip;
         station.prices = this.decodeFuelTypes(stationDetailsObject.fuelPrices);
         for each(price in station.prices)
         {
            if(price.id == this.mDefaultFuelTypeID)
            {
               station.defaultPrice = price.price;
               station.daysOld = price.daysOld;
            }
         }
         station.coordinates = new Coordinates();
         station.coordinates.latitude = Number(stationDetailsObject.latitude);
         station.coordinates.longitude = Number(stationDetailsObject.longitude);
         station.distance = this.mCoordinates.distanceTo(station.coordinates);
         station.bearing = this.mCoordinates.bearingTo(station.coordinates);
         station.favorite = station.id == this.mFavoriteStation.id;
         return station;
      }
   }
}

