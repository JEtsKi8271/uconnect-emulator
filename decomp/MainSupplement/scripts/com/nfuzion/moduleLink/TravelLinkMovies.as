package com.nfuzion.moduleLink
{
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.geographic.Distance;
   import com.nfuzion.moduleLinkAPI.ITravelLinkMovies;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   import com.nfuzion.moduleLinkAPI.TravelLinkMoviesEvent;
   import com.nfuzion.moduleLinkAPI.TravelLinkMoviesMovieDetails;
   import com.nfuzion.moduleLinkAPI.TravelLinkMoviesMovieList;
   import com.nfuzion.moduleLinkAPI.TravelLinkMoviesMovieListing;
   import com.nfuzion.moduleLinkAPI.TravelLinkMoviesTheater;
   import com.nfuzion.moduleLinkAPI.TravelLinkMoviesTheaterDetails;
   import com.nfuzion.moduleLinkAPI.TravelLinkMoviesTheaterList;
   import com.nfuzion.span.Client;
   import flash.events.Event;
   import flash.events.TimerEvent;
   
   public class TravelLinkMovies extends Module implements ITravelLinkMovies
   {
      
      private static const IS_TEST:Boolean = false;
      
      private static const dbusIdentifier:String = "XMMovies";
      
      private static const dbusId:String = "id";
      
      private static const dbusSignalServiceStatus:String = "status";
      
      private static const dbusSignalCurrentLocation:String = "currentLocation";
      
      private static const dbusSignalFavoriteTheater:String = "favoriteTheater";
      
      private static const dbusSignalClosestTheaters:String = "theaters";
      
      private static const dbusSignalTheatersForMovie:String = "theatersForMovie";
      
      private static const dbusSignalTheaterInfo:String = "theaterInfo";
      
      private static const dbusSignalClosestMovies:String = "movies";
      
      private static const dbusSignalMovieInfo:String = "movieInfo";
      
      private static const dbusSignalMovieTimes:String = "movieTimes";
      
      private static const dbusMethodClosestTheather:String = "updateClosestTheaters";
      
      private static const dbusMethodTheatherInfo:String = "getTheaterInfo";
      
      private static const dbusMethodMovieListings:String = "getMovieListings";
      
      private static const dbusMethodMovieDetails:String = "getMovieDetails";
      
      private static const dbusMethodAvailMovies:String = "updateAvailableMovies";
      
      private static const dbusMethodTheatersForMovie:String = "getTheatersForMovie";
      
      private static const dbusMethodSetFavoriteTheater:String = "setFavoriteTheaterID";
      
      private static const dbusMethodDeleteFavoriteTheater:String = "clearFavoriteTheaterID";
      
      private static const dbusMethodRouteToTheather:String = "routeToTheater";
      
      private static const ASCENDING:String = "ascending";
      
      private static const DESCENDING:String = "descending";
      
      private var client:Client;
      
      private var connection:Connection;
      
      private var mServiceStatus:String = "";
      
      private var mCoordinates:Coordinates = new Coordinates();
      
      private var mLastCoordinates:Coordinates = new Coordinates();
      
      private var mSearchRadius:Distance = new Distance();
      
      private var mClosestTheaters:TravelLinkMoviesTheaterList = new TravelLinkMoviesTheaterList();
      
      private var mClosestMovies:TravelLinkMoviesMovieList = new TravelLinkMoviesMovieList();
      
      private var mTheaterListing:TravelLinkMoviesMovieListing = new TravelLinkMoviesMovieListing();
      
      private var mTheaterDetails:TravelLinkMoviesTheaterDetails = new TravelLinkMoviesTheaterDetails();
      
      private var mMovieDetails:TravelLinkMoviesMovieDetails = new TravelLinkMoviesMovieDetails();
      
      private var mFavoritesList:Vector.<int> = new Vector.<int>();
      
      private var mXMMoviesServiceAvailable:Boolean = false;
      
      public function TravelLinkMovies()
      {
         super();
         this.connection = Connection.share();
         this.client = this.connection.span;
         this.client.addEventListener(Event.CONNECT,this.connected);
         if(this.client.connected)
         {
            this.connected();
         }
         this.client.addEventListener(Event.CLOSE,this.disconnected);
         this.connection.addEventListener(ConnectionEvent.TRAVELLINK_MOVIES,this.messageHandler);
         this.connection.addEventListener(ConnectionEvent.CONFIGURED,this.loadConfiguration);
         if(this.connection.configured)
         {
            this.loadConfiguration();
         }
      }
      
      override protected function subscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case TravelLinkMoviesEvent.MOVIES_SERVICE_STATUS:
               this.sendSubscribe(dbusSignalServiceStatus);
               break;
            case TravelLinkMoviesEvent.CLOSEST_THEATER_LIST:
               this.sendSubscribe(dbusSignalClosestTheaters);
         }
      }
      
      override protected function unsubscribe(signalName:String) : void
      {
         switch(signalName)
         {
            case TravelLinkMoviesEvent.MOVIES_SERVICE_STATUS:
               this.sendUnsubscribe(dbusSignalServiceStatus);
               break;
            case TravelLinkMoviesEvent.CLOSEST_THEATER_LIST:
               this.sendUnsubscribe(dbusSignalClosestTheaters);
         }
      }
      
      override public function getAll() : void
      {
      }
      
      override public function isReady() : Boolean
      {
         return this.client.connected;
      }
      
      public function init() : void
      {
      }
      
      public function requestServiceStatus() : void
      {
         this.sendGetPropertyCommand(dbusSignalServiceStatus);
      }
      
      public function get serviceStatus() : String
      {
         return this.mServiceStatus;
      }
      
      public function requestCurrentLocation() : void
      {
         this.sendGetPropertyCommand(dbusSignalCurrentLocation);
      }
      
      public function get currentLocation() : Coordinates
      {
         return this.mLastCoordinates;
      }
      
      public function setCoordinates(coordinates:Coordinates) : void
      {
         var firstReport:Boolean = false;
         if(this.mCoordinates.latitude == 0 && this.mCoordinates.longitude == 0)
         {
            firstReport = true;
         }
         if(this.mLastCoordinates.latitude == 0 && this.mLastCoordinates.longitude == 0)
         {
            this.mLastCoordinates.latitude = 42.493112;
            this.mLastCoordinates.longitude = -83.358078;
         }
         if(!(coordinates.latitude == 0 && coordinates.longitude == 0))
         {
            this.mCoordinates = coordinates;
         }
         if(firstReport)
         {
         }
      }
      
      public function get coordinates() : Coordinates
      {
         return this.mCoordinates;
      }
      
      public function setSearchRadius(searchRadius:Distance) : void
      {
      }
      
      public function get searchRadius() : Distance
      {
         return this.mSearchRadius;
      }
      
      public function requestClosestTheathers() : void
      {
         this.sendCommand(dbusMethodClosestTheather,null,null);
      }
      
      public function getClosestTheathers(sort:String) : TravelLinkMoviesTheaterList
      {
         return this.mClosestTheaters;
      }
      
      public function requestClosestMovies() : void
      {
         this.sendCommand(dbusMethodAvailMovies,null,null);
      }
      
      public function getClosestMovies(sort:String) : TravelLinkMoviesMovieList
      {
         if(sort == DESCENDING)
         {
            this.mClosestMovies.sort(DESCENDING);
         }
         else
         {
            this.mClosestMovies.sort(ASCENDING);
         }
         return this.mClosestMovies;
      }
      
      public function requestMovieListings(theaterId:uint) : void
      {
         this.sendCommand(dbusMethodMovieListings,dbusId,theaterId,false);
      }
      
      public function getMovieListings(sort:String) : TravelLinkMoviesMovieListing
      {
         return this.mTheaterListing;
      }
      
      public function requestTheathersForMovie(movieId:uint) : void
      {
         this.sendCommand(dbusMethodTheatersForMovie,dbusId,movieId,false);
      }
      
      public function getTheathersForMovie(sort:String) : TravelLinkMoviesTheaterList
      {
         return this.mClosestTheaters;
      }
      
      public function requestTheaterDetails(theaterId:uint) : void
      {
         this.sendCommand(dbusMethodTheatherInfo,dbusId,theaterId,false);
      }
      
      public function getTheaterDetails() : TravelLinkMoviesTheaterDetails
      {
         return this.mTheaterDetails;
      }
      
      public function requestMovieDetails(movieId:uint) : void
      {
         this.sendCommand(dbusMethodMovieDetails,dbusId,movieId,false);
      }
      
      public function getMovieDetails() : TravelLinkMoviesMovieDetails
      {
         return this.mMovieDetails;
      }
      
      public function requestFavoriteTheater() : void
      {
         this.sendGetPropertyCommand(dbusSignalFavoriteTheater);
      }
      
      public function setFavoriteTheater(theaterId:uint) : void
      {
         this.sendCommand(dbusMethodSetFavoriteTheater,dbusId,theaterId,false);
      }
      
      public function deleteFavoriteTheater(theaterId:uint) : void
      {
         this.sendCommand(dbusMethodDeleteFavoriteTheater,dbusId,theaterId,false);
      }
      
      public function get favoriteTheaterIdList() : Vector.<int>
      {
         return this.mFavoritesList;
      }
      
      public function setRouteToTheater(theaterId:uint) : void
      {
         this.sendCommand(dbusMethodRouteToTheather,dbusId,theaterId,false);
      }
      
      private function reportPosition(e:TimerEvent = null) : void
      {
      }
      
      private function connected(e:Event = null) : void
      {
         this.sendAvailableRequest();
         if(this.connection.configured)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
            this.sendMultiSubscribe([dbusSignalServiceStatus,dbusSignalFavoriteTheater,dbusSignalClosestTheaters,dbusSignalTheaterInfo,dbusSignalClosestMovies,dbusSignalMovieInfo,dbusSignalMovieTimes,dbusSignalTheatersForMovie,dbusSignalCurrentLocation]);
         }
      }
      
      private function onServiceReady() : void
      {
         var tempCoordinates:Coordinates = new Coordinates();
         this.setCoordinates(tempCoordinates);
      }
      
      private function disconnected(e:Event) : void
      {
         this.dispatchEvent(new ModuleEvent(ModuleEvent.NOT_READY));
      }
      
      private function loadConfiguration(e:Event = null) : void
      {
         if(this.client.connected)
         {
            this.dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      private function sendSubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendMultiSubscribe(signalsArray:Array) : void
      {
         var message:String = null;
         var i:uint = 0;
         for(message = "{\"Type\":\"Subscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signals\": ["; i < signalsArray.length; )
         {
            message = message + "\"" + signalsArray[i] + "\"";
            if(signalsArray[i + 1])
            {
               message += ",";
            }
            i++;
         }
         message += "]}";
         this.client.send(message);
      }
      
      private function sendUnsubscribe(signalName:String) : void
      {
         var message:String = null;
         message = "{\"Type\":\"Unsubscribe\", \"Dest\":\"" + dbusIdentifier + "\", \"Signal\": \"" + signalName + "\"}";
         this.client.send(message);
      }
      
      private function sendCommand(commandName:String, valueName:String, value:Object, addQuotesOnValue:Boolean = true) : void
      {
         var message:String = null;
         if(valueName == null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": {}}}";
         }
         else if(value is String)
         {
            if(addQuotesOnValue == true)
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": \"" + value + "\"}}}";
            }
            else
            {
               message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value + "}}}";
            }
         }
         else
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"" + commandName + "\": { \"" + valueName + "\": " + value.toString() + "}}}";
         }
         this.client.send(message);
      }
      
      private function sendGetPropertyCommand(property:String) : void
      {
         var message:String = null;
         if(property != null)
         {
            message = "{\"Type\":\"Command\", \"Dest\":\"" + dbusIdentifier + "\", \"packet\": { \"getProperties\":{\"props\":[\"" + property + "\"]}}}";
            this.client.send(message);
         }
      }
      
      private function setSearchArea() : void
      {
      }
      
      private function procFavorites(data:Object = null) : void
      {
         var fav:Object = null;
         var id:int = 0;
         if(null != data)
         {
            while(this.mFavoritesList.length > 0)
            {
               this.mFavoritesList.pop();
            }
         }
         if(data.hasOwnProperty(dbusSignalFavoriteTheater))
         {
            for each(fav in data)
            {
               if(fav.hasOwnProperty("id"))
               {
                  id = fav.id as int;
                  this.mFavoritesList.push(id);
               }
            }
         }
         this.updateFavorites();
      }
      
      private function updateFavorites() : void
      {
         var id:int = 0;
         var t:TravelLinkMoviesTheater = new TravelLinkMoviesTheater();
         for each(t in this.mClosestTheaters.list)
         {
            t.isFavorite = false;
            for each(id in this.mFavoritesList)
            {
               if(t.theaterId == id)
               {
                  t.isFavorite = true;
               }
            }
         }
         for each(id in this.mFavoritesList)
         {
            if(this.mTheaterDetails.theaterId == id)
            {
               this.mTheaterDetails.isFavorite = true;
            }
         }
      }
      
      public function messageHandler(e:ConnectionEvent) : void
      {
         var tlm:Object = e.data;
         if(tlm.hasOwnProperty("dBusServiceAvailable"))
         {
            if(tlm.dBusServiceAvailable == "true" && this.mXMMoviesServiceAvailable == false)
            {
               this.mXMMoviesServiceAvailable = true;
               this.requestServiceStatus();
            }
            else if(tlm.dBusServiceAvailable == "false")
            {
               this.mXMMoviesServiceAvailable = false;
            }
         }
         if(!tlm.hasOwnProperty(dbusMethodClosestTheather))
         {
            if(!tlm.hasOwnProperty(dbusMethodAvailMovies))
            {
               if(!tlm.hasOwnProperty(dbusMethodMovieListings))
               {
                  if(!tlm.hasOwnProperty(dbusMethodMovieDetails))
                  {
                     if(!tlm.hasOwnProperty(dbusMethodTheatherInfo))
                     {
                        if(!tlm.hasOwnProperty(dbusMethodTheatersForMovie))
                        {
                           if(tlm.hasOwnProperty(dbusSignalServiceStatus))
                           {
                              this.mServiceStatus = tlm.status;
                              if(this.mServiceStatus == "READY")
                              {
                                 this.onServiceReady();
                              }
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.MOVIES_SERVICE_STATUS));
                           }
                           else if(tlm.hasOwnProperty(dbusSignalCurrentLocation))
                           {
                              if(tlm.currentLocation.latitude != 0)
                              {
                                 this.mLastCoordinates.latitude = tlm.currentLocation.latitude / 1000000;
                              }
                              if(tlm.currentLocation.longitude != 0)
                              {
                                 this.mLastCoordinates.longitude = tlm.currentLocation.longitude / 1000000;
                              }
                           }
                           else if(tlm.hasOwnProperty(dbusSignalClosestTheaters))
                           {
                              this.mClosestTheaters = new TravelLinkMoviesTheaterList(tlm.theaters);
                              if(this.mClosestTheaters.length > 0)
                              {
                                 this.requestFavoriteTheater();
                              }
                           }
                           else if(tlm.hasOwnProperty(dbusSignalTheatersForMovie))
                           {
                              this.mClosestTheaters = new TravelLinkMoviesTheaterList(tlm.theatersForMovie);
                              this.updateFavorites();
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.MOVIE_LOCATION_LIST));
                           }
                           else if(tlm.hasOwnProperty(dbusSignalClosestMovies))
                           {
                              this.mClosestMovies = new TravelLinkMoviesMovieList(tlm);
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.CLOSEST_MOVIE_LIST));
                           }
                           else if(tlm.hasOwnProperty(dbusSignalMovieInfo))
                           {
                              this.mMovieDetails = new TravelLinkMoviesMovieDetails(tlm.movieInfo);
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.DETAILED_MOVIE_INFO));
                           }
                           else if(tlm.hasOwnProperty(dbusSignalFavoriteTheater))
                           {
                              this.procFavorites(tlm);
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.CLOSEST_THEATER_LIST));
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.FAVORITE_THEATER));
                           }
                           else if(tlm.hasOwnProperty(dbusSignalTheaterInfo))
                           {
                              this.mTheaterDetails = new TravelLinkMoviesTheaterDetails(tlm.theaterInfo);
                              this.updateFavorites();
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.DETAILED_THEATHER_INFO));
                           }
                           else if(tlm.hasOwnProperty(dbusSignalMovieTimes))
                           {
                              this.mTheaterListing = new TravelLinkMoviesMovieListing(tlm.movieTimes);
                              this.dispatchEvent(new TravelLinkMoviesEvent(TravelLinkMoviesEvent.MOVIE_SCHEDULE_LIST));
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function sendAvailableRequest() : void
      {
         var message:String = "{\"Type\":\"subscribeNameHasOwnerNotification\", \"Dest\":\"" + dbusIdentifier + "\"}";
         this.client.send(message);
      }
   }
}

