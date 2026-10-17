package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesMovie
   {
      
      public var index:uint;
      
      public var movieId:uint;
      
      public var title:String = "";
      
      public var rating:String = "";
      
      public function TravelLinkMoviesMovie(data:Object = null, index:uint = 0)
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
         }
      }
   }
}

