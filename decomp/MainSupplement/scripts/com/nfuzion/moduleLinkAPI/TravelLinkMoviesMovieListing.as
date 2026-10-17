package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesMovieListing
   {
      
      private var mTheaterId:uint;
      
      private var mTheaterName:String;
      
      private var mDate:String;
      
      private var mMovies:Vector.<TravelLinkMoviesShowTimes> = new Vector.<TravelLinkMoviesShowTimes>();
      
      public function TravelLinkMoviesMovieListing(data:Object = null)
      {
         var movie:Object = null;
         var m:TravelLinkMoviesShowTimes = null;
         super();
         if(null != data)
         {
            if(data.hasOwnProperty("theaterID"))
            {
               this.mTheaterId = data.theatherID;
            }
            if(data.hasOwnProperty("description"))
            {
               this.mTheaterName = data.description;
            }
            if(data.hasOwnProperty("date"))
            {
               this.mDate = data.date;
            }
            if(data.hasOwnProperty("shows"))
            {
               for each(movie in data.shows)
               {
                  m = new TravelLinkMoviesShowTimes(movie);
                  this.mMovies.push(m);
               }
               this.mMovies.sort(this.compareTitleAscending);
            }
         }
      }
      
      public function get date() : String
      {
         return this.mDate;
      }
      
      public function get theaterId() : uint
      {
         return this.mTheaterId;
      }
      
      public function get theaterName() : String
      {
         return this.mTheaterName;
      }
      
      public function get listing() : Vector.<TravelLinkMoviesShowTimes>
      {
         return this.mMovies;
      }
      
      public function get length() : int
      {
         return this.mMovies.length;
      }
      
      public function deleteList() : void
      {
         while(this.mMovies.length > 0)
         {
            this.mMovies.pop();
         }
      }
      
      public function getListingByIndex(index:int) : TravelLinkMoviesShowTimes
      {
         return this.mMovies[index];
      }
      
      public function getListingByRange(start:int, end:int) : Vector.<TravelLinkMoviesShowTimes>
      {
         var i:int = 0;
         var movieList:Vector.<TravelLinkMoviesShowTimes> = new Vector.<TravelLinkMoviesShowTimes>();
         if(this.mMovies.length == 0)
         {
            return movieList;
         }
         if(end >= this.mMovies.length)
         {
            end = this.mMovies.length - 1;
         }
         if(start < this.mMovies.length)
         {
            for(i = start; i <= end; i++)
            {
               movieList.push(this.mMovies[i]);
            }
         }
         return movieList;
      }
      
      private function compareTitleAscending(i:TravelLinkMoviesShowTimes, j:TravelLinkMoviesShowTimes) : Number
      {
         if(i.movieTitle < j.movieTitle)
         {
            return -1;
         }
         if(i.movieTitle > j.movieTitle)
         {
            return 1;
         }
         return 0;
      }
   }
}

