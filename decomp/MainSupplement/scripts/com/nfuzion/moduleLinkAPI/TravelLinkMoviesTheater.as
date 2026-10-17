package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesTheater
   {
      
      public var index:uint;
      
      public var theaterId:uint;
      
      public var isActive:Boolean;
      
      public var isFavorite:Boolean;
      
      public var description:String = "";
      
      public var bearing:Number = 0;
      
      public var distance:Number = 0;
      
      public var latitude:Number;
      
      public var longitude:Number;
      
      public function TravelLinkMoviesTheater(data:Object = null, index:uint = 0)
      {
         super();
         this.index = index;
         if(null != data)
         {
            if(data.hasOwnProperty("id"))
            {
               this.theaterId = data.id;
            }
            if(data.hasOwnProperty("active"))
            {
               this.isActive = data.active;
            }
            if(data.hasOwnProperty("description"))
            {
               this.description = data.description;
            }
            if(data.hasOwnProperty("bearing"))
            {
               this.bearing = data.bearing;
            }
            if(data.hasOwnProperty("distance"))
            {
               this.distance = data.distance;
            }
            if(data.hasOwnProperty("latitude"))
            {
               this.latitude = data.latitude;
            }
            if(data.hasOwnProperty("longitude"))
            {
               this.longitude = data.longitude;
            }
         }
      }
      
      public function get direction() : String
      {
         if(this.bearing >= 0 && this.bearing < 22.5)
         {
            return "north";
         }
         if(this.bearing >= 22.5 && this.bearing < 67.5)
         {
            return "northeast";
         }
         if(this.bearing >= 67.5 && this.bearing < 112.5)
         {
            return "east";
         }
         if(this.bearing >= 112.5 && this.bearing < 157.5)
         {
            return "southeast";
         }
         if(this.bearing >= 157.5 && this.bearing < 202.5)
         {
            return "south";
         }
         if(this.bearing >= 202.5 && this.bearing < 247.5)
         {
            return "southwest";
         }
         if(this.bearing >= 247.5 && this.bearing < 292.5)
         {
            return "west";
         }
         if(this.bearing >= 292.5 && this.bearing < 337.5)
         {
            return "northwest";
         }
         if(this.bearing >= 337.5 && this.bearing < 360)
         {
            return "north";
         }
         return "";
      }
   }
}

