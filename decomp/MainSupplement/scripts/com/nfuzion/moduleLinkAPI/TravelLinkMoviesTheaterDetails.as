package com.nfuzion.moduleLinkAPI
{
   public class TravelLinkMoviesTheaterDetails
   {
      
      public var index:uint;
      
      public var theaterId:uint;
      
      public var isActive:Boolean;
      
      public var isFavorite:Boolean;
      
      public var description:String = "";
      
      public var street:String = "";
      
      public var city:String = "";
      
      public var state:String = "";
      
      public var zip:String = "";
      
      public var phone:String = "";
      
      public var latitude:Number;
      
      public var longitude:Number;
      
      public function TravelLinkMoviesTheaterDetails(data:Object = null, index:uint = 0)
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
            if(data.hasOwnProperty("street"))
            {
               this.street = data.street;
            }
            if(data.hasOwnProperty("city"))
            {
               this.city = data.city;
            }
            if(data.hasOwnProperty("state"))
            {
               this.state = data.state;
            }
            if(data.hasOwnProperty("zip"))
            {
               this.zip = data.zip;
            }
            if(data.hasOwnProperty("phone"))
            {
               this.phone = data.phone;
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
   }
}

