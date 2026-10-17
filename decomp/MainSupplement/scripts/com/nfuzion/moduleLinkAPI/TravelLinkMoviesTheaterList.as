package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesTheaterList
   {
      
      private var mTheaterList:Vector.<TravelLinkMoviesTheater> = new Vector.<TravelLinkMoviesTheater>();
      
      public function TravelLinkMoviesTheaterList(data:Object = null)
      {
         var index:uint = 0;
         var theater:Object = null;
         var m:TravelLinkMoviesTheater = null;
         super();
         if(null != data)
         {
            index = 0;
            for each(theater in data)
            {
               m = new TravelLinkMoviesTheater(theater,index++);
               this.mTheaterList.push(m);
            }
            this.mTheaterList.sort(this.compareDistanceAscending);
         }
      }
      
      public function get length() : int
      {
         return this.mTheaterList.length;
      }
      
      public function get list() : Vector.<TravelLinkMoviesTheater>
      {
         return this.mTheaterList;
      }
      
      public function sort(sortType:String) : void
      {
         if(sortType == "ascendingName")
         {
            this.mTheaterList.sort(this.compareNameAscending);
         }
         else if(sortType == "ascendingDistance")
         {
            this.mTheaterList.sort(this.compareDistanceAscending);
         }
      }
      
      public function filterFavoritesOnly() : void
      {
         this.mTheaterList = this.mTheaterList.filter(this.isFavorite,this);
      }
      
      public function setBearing(index:uint, bearing:Number) : void
      {
         this.mTheaterList[index].bearing = bearing;
      }
      
      public function setDistance(index:uint, distance:Number) : void
      {
         this.mTheaterList[index].distance = distance;
      }
      
      public function getLatitude(index:uint) : Number
      {
         return this.mTheaterList[index].latitude;
      }
      
      public function getLongitude(index:uint) : Number
      {
         return this.mTheaterList[index].longitude;
      }
      
      public function deleteList() : void
      {
         while(this.mTheaterList.length > 0)
         {
            this.mTheaterList.pop();
         }
      }
      
      public function getTheaterByIndex(index:int) : TravelLinkMoviesTheater
      {
         return this.mTheaterList[index];
      }
      
      public function getTheaterByRange(start:int, end:int) : Vector.<TravelLinkMoviesTheater>
      {
         var i:int = 0;
         var theaterList:Vector.<TravelLinkMoviesTheater> = new Vector.<TravelLinkMoviesTheater>();
         if(this.mTheaterList.length == 0)
         {
            return theaterList;
         }
         if(end >= this.mTheaterList.length)
         {
            end = this.mTheaterList.length - 1;
         }
         if(start < this.mTheaterList.length)
         {
            for(i = start; i <= end; i++)
            {
               theaterList.push(this.mTheaterList[i]);
            }
         }
         return theaterList;
      }
      
      private function compareNameAscending(i:TravelLinkMoviesTheater, j:TravelLinkMoviesTheater) : Number
      {
         if(i.description < j.description)
         {
            return -1;
         }
         if(i.description > j.description)
         {
            return 1;
         }
         return 0;
      }
      
      private function compareDistanceAscending(i:TravelLinkMoviesTheater, j:TravelLinkMoviesTheater) : Number
      {
         if(i.distance < j.distance)
         {
            return -1;
         }
         if(i.distance > j.distance)
         {
            return 1;
         }
         return 0;
      }
      
      private function isFavorite(item:TravelLinkMoviesTheater, index:int, vector:Vector.<TravelLinkMoviesTheater>) : Boolean
      {
         return item.isFavorite;
      }
      
      public function makeFakeData() : void
      {
         var theater:TravelLinkMoviesTheater = null;
         this.deleteList();
         for(var i:int = 0; i < 36; i++)
         {
            theater = new TravelLinkMoviesTheater();
            theater.index = i;
            theater.theaterId = 1000 + i;
            theater.description = "Movie Theater Name " + i;
            theater.distance = 5 + i;
            theater.bearing = 10 * i;
            theater.isActive = true;
            theater.isFavorite = false;
            this.mTheaterList.push(theater);
         }
      }
   }
}

