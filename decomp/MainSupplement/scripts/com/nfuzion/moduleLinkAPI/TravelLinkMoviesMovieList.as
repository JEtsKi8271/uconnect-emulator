package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesMovieList
   {
      
      private var mMovieList:Vector.<TravelLinkMoviesMovie> = new Vector.<TravelLinkMoviesMovie>();
      
      public function TravelLinkMoviesMovieList(data:Object = null)
      {
         var movie:Object = null;
         var m:TravelLinkMoviesMovie = null;
         super();
         if(null != data)
         {
            if(data.hasOwnProperty("movies"))
            {
               for each(movie in data.movies)
               {
                  m = new TravelLinkMoviesMovie(movie);
                  this.mMovieList.push(m);
               }
               this.mMovieList.sort(this.compareTitleAscending);
            }
         }
      }
      
      public function get length() : int
      {
         return this.mMovieList.length;
      }
      
      public function get list() : Vector.<TravelLinkMoviesMovie>
      {
         return this.mMovieList;
      }
      
      public function sort(sortType:String) : void
      {
         if(sortType == "descending")
         {
            this.mMovieList.sort(this.compareTitleDescending);
         }
         else
         {
            this.mMovieList.sort(this.compareTitleAscending);
         }
      }
      
      public function deleteList() : void
      {
         while(this.mMovieList.length > 0)
         {
            this.mMovieList.pop();
         }
      }
      
      public function getMovieByIndex(index:int) : TravelLinkMoviesMovie
      {
         return this.mMovieList[index];
      }
      
      public function getMovieByRange(start:int, end:int) : Vector.<TravelLinkMoviesMovie>
      {
         var i:int = 0;
         var movieList:Vector.<TravelLinkMoviesMovie> = new Vector.<TravelLinkMoviesMovie>();
         if(this.mMovieList.length == 0)
         {
            return movieList;
         }
         if(end >= this.mMovieList.length)
         {
            end = this.mMovieList.length - 1;
         }
         if(start < this.mMovieList.length)
         {
            for(i = start; i <= end; i++)
            {
               movieList.push(this.mMovieList[i]);
            }
         }
         return movieList;
      }
      
      public function startCharactersAvailable() : Vector.<String>
      {
         var availableChars:Vector.<String> = new Vector.<String>();
         if(null == this.mMovieList)
         {
            return availableChars;
         }
         var index:uint = 0;
         while(index < this.mMovieList.length)
         {
            availableChars.push(this.mMovieList[index].title.charAt(0));
            index++;
         }
         return availableChars;
      }
      
      private function compareTitleAscending(i:TravelLinkMoviesMovie, j:TravelLinkMoviesMovie) : Number
      {
         if(i.title < j.title)
         {
            return -1;
         }
         if(i.title > j.title)
         {
            return 1;
         }
         return 0;
      }
      
      private function compareTitleDescending(i:TravelLinkMoviesMovie, j:TravelLinkMoviesMovie) : Number
      {
         if(i.title < j.title)
         {
            return 1;
         }
         if(i.title > j.title)
         {
            return -1;
         }
         return 0;
      }
   }
}

