package com.harman.navigation.utils
{
   public class LocationDescription
   {
      
      private var dbIndex:int = -1;
      
      private var mPrimaryLocation:LocationDetails = new LocationDetails();
      
      private var mSecondaryLocation:LocationDetails = new LocationDetails();
      
      public function LocationDescription(key:int = -1)
      {
         super();
         if(key != -1)
         {
            this.dbIndex = key;
         }
      }
      
      public function getPrimaryLocation() : LocationDetails
      {
         return this.mPrimaryLocation;
      }
      
      public function setPrimaryLocation(loc:LocationDetails) : void
      {
         this.mPrimaryLocation = loc;
      }
      
      public function getSecondaryLocation() : LocationDetails
      {
         return this.mSecondaryLocation;
      }
      
      public function setSecondaryLocation(loc:LocationDetails) : void
      {
         this.mSecondaryLocation = loc;
      }
      
      public function get databaseKey() : int
      {
         return this.dbIndex;
      }
      
      public function clone(src:LocationDescription) : void
      {
         if(src.databaseKey != -1)
         {
            this.dbIndex = src.databaseKey;
         }
         this.mPrimaryLocation.clone(src.getPrimaryLocation());
         this.mSecondaryLocation.clone(src.getSecondaryLocation());
      }
      
      public function setName(newName:String) : void
      {
         this.mPrimaryLocation.setCustomName(newName);
         if(this.mPrimaryLocation != this.mSecondaryLocation)
         {
            this.mSecondaryLocation.setCustomName("");
         }
      }
   }
}

