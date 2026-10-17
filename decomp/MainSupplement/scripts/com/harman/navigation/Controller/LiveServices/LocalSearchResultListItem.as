package com.harman.navigation.Controller.LiveServices
{
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   
   public class LocalSearchResultListItem
   {
      
      private var mValid:Boolean = false;
      
      private var mTomTomID:int = -1;
      
      private var mIndex:int = -1;
      
      private var mDistance:Number = -1;
      
      private var mAddress:String = "";
      
      private var mBrandIcon:String = "";
      
      private var mLat:Number = 0;
      
      private var mLong:Number = 0;
      
      private var mLocationDescription:LocationDescription = new LocationDescription();
      
      public function LocalSearchResultListItem(data:Object)
      {
         var locDetPri:LocationDetails = null;
         super();
         if(data != null)
         {
            if(data.hasOwnProperty("id"))
            {
               this.mTomTomID = data.id;
            }
            if(data.hasOwnProperty("latitude"))
            {
               this.mLat = data.latitude;
            }
            if(data.hasOwnProperty("longitude"))
            {
               this.mLong = data.longitude;
            }
            if(data.hasOwnProperty("formattedAddress"))
            {
               this.mAddress = data.formattedAddress;
            }
            if(data.hasOwnProperty("logo"))
            {
               this.mBrandIcon = data.logo;
            }
            if(data.hasOwnProperty("distance"))
            {
               this.mDistance = Number(data.distance);
            }
            locDetPri = new LocationDetails();
            if(data.hasOwnProperty("name"))
            {
               locDetPri.addType("<POI>",data.name);
            }
            if(data.hasOwnProperty("phone"))
            {
               locDetPri.addType("<TEL>",data.phone);
            }
            if(data.hasOwnProperty("country"))
            {
               locDetPri.addType("<CTR>",data.country);
            }
            if(data.hasOwnProperty("state"))
            {
               locDetPri.addType("<STA>",data.states);
            }
            if(data.hasOwnProperty("province"))
            {
               locDetPri.addType("<STA>",data.province);
            }
            if(data.hasOwnProperty("city"))
            {
               locDetPri.addType("<CTY>",data.city);
            }
            if(data.hasOwnProperty("zipcode"))
            {
               locDetPri.addType("<ZIP>",data.zipcode);
            }
            if(data.hasOwnProperty("street"))
            {
               locDetPri.addType("<STR>",data.street);
            }
            if(data.hasOwnProperty("houseNumber"))
            {
               locDetPri.addType("<HNO>",data.houseNumber);
            }
            if(data.hasOwnProperty("website"))
            {
               locDetPri.addType("<WWW>",data.website);
            }
            if(data.hasOwnProperty("latitude") && data.hasOwnProperty("longitude"))
            {
               locDetPri.addType("<GEO>",data.longitude + " " + data.latitude);
            }
            this.mLocationDescription.setPrimaryLocation(locDetPri);
            this.mLocationDescription.setSecondaryLocation(locDetPri);
            this.mValid = true;
         }
      }
      
      public function get valid() : Boolean
      {
         return this.mValid;
      }
      
      public function get index() : int
      {
         return this.mIndex;
      }
      
      public function get tomtomID() : int
      {
         return this.mTomTomID;
      }
      
      public function get distance() : Number
      {
         return this.mDistance;
      }
      
      public function get locationDescription() : LocationDescription
      {
         return this.mLocationDescription;
      }
      
      public function get geoCoordinate() : String
      {
         return this.mLocationDescription.getPrimaryLocation().getType("<GEO>");
      }
      
      public function get title() : String
      {
         return this.mLocationDescription.getPrimaryLocation().getType("<POI>");
      }
      
      public function get address() : String
      {
         if(this.mAddress != "")
         {
            return this.mAddress;
         }
         return NavigationPackage.peripheral.navigation.navVServices.hmiUtils.getOneLineDescription(this.mLocationDescription);
      }
   }
}

