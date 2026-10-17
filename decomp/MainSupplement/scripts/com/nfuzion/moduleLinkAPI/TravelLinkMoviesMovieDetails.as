package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesMovieDetails
   {
      
      public var index:uint;
      
      public var movieId:uint;
      
      public var title:String = "";
      
      public var rating:String = "";
      
      public var runTime:uint;
      
      public var actors:String = "";
      
      public var synopsis:String = "";
      
      public function TravelLinkMoviesMovieDetails(data:Object = null, index:uint = 0)
      {
         super();
         this.index = index;
         if(null != data)
         {
            if(data.hasOwnProperty("id"))
            {
               this.movieId = data.id;
            }
            if(data.hasOwnProperty("title"))
            {
               this.title = data.title;
            }
            if(data.hasOwnProperty("rating"))
            {
               this.rating = data.rating;
            }
            if(data.hasOwnProperty("runtime"))
            {
               this.runTime = data.runtime;
            }
            if(data.hasOwnProperty("actors"))
            {
               this.actors = data.actors;
            }
            if(data.hasOwnProperty("synopsis"))
            {
               this.synopsis = data.synopsis;
            }
         }
      }
   }
}

