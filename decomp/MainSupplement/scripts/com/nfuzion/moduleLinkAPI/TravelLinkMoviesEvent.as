package com.nfuzion.moduleLinkAPI
{
   import flash.events.Event;
   
   public class TravelLinkMoviesEvent extends Event
   {
      
      public static const MOVIES_SERVICE_STATUS:String = "moviesServiceStatus";
      
      public static const COORDINATES:String = "coordinates";
      
      public static const SEARCH_RADIUS:String = "searchRadius";
      
      public static const CLOSEST_THEATER_LIST:String = "closestTheatersList";
      
      public static const FAVORITE_THEATER:String = "favoriteTheater";
      
      public static const CLOSEST_MOVIE_LIST:String = "closestMovieList";
      
      public static const MOVIE_SCHEDULE_LIST:String = "movieScheduleList";
      
      public static const MOVIE_LOCATION_LIST:String = "movieLocationList";
      
      public static const DETAILED_THEATHER_INFO:String = "theaterInfo";
      
      public static const DETAILED_MOVIE_INFO:String = "detailedMovieInfo";
      
      public var mData:Object = null;
      
      public function TravelLinkMoviesEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.mData = data;
      }
   }
}

