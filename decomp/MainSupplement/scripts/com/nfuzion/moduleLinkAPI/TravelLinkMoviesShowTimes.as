package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesShowTimes
   {
      
      private var mMovieId:uint;
      
      private var mTitle:String;
      
      private var mShowTimes:Vector.<String> = new Vector.<String>();
      
      public function TravelLinkMoviesShowTimes(data:Object = null)
      {
         var time:Object = null;
         var timeStr:String = null;
         super();
         if(null != data)
         {
            if(data.hasOwnProperty("movieID"))
            {
               this.mMovieId = data.movieID;
            }
            if(data.hasOwnProperty("title"))
            {
               this.mTitle = data.title;
            }
            if(data.hasOwnProperty("showtimes"))
            {
               for each(time in data.showtimes)
               {
                  timeStr = new String(time);
                  this.mShowTimes.push(timeStr);
               }
            }
         }
      }
      
      public function get numberOfShowTimes() : Number
      {
         return this.mShowTimes.length;
      }
      
      public function get showTimes() : Vector.<String>
      {
         return this.mShowTimes;
      }
      
      public function get movieId() : uint
      {
         return this.mMovieId;
      }
      
      public function get movieTitle() : String
      {
         return this.mTitle;
      }
   }
}

