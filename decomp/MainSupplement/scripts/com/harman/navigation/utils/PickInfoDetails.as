package com.harman.navigation.utils
{
   public class PickInfoDetails
   {
      
      public var latitude:Number = 0;
      
      public var longitude:Number = 0;
      
      private var mLocation:LocationDetails = new LocationDetails();
      
      private var mPOIs:Array = new Array();
      
      private var mTMCMessages:Array = new Array();
      
      public function PickInfoDetails()
      {
         super();
      }
      
      public function get location() : LocationDetails
      {
         return this.mLocation;
      }
      
      public function get POIs() : Array
      {
         return this.mPOIs;
      }
      
      public function get TMCMessages() : Array
      {
         return this.mTMCMessages;
      }
      
      public function setLocation(locEIS:String) : void
      {
         this.mLocation.addEisString(locEIS);
      }
      
      public function addPOI(locEIS:String) : void
      {
         var poi:LocationDetails = new LocationDetails();
         poi.addEisString(locEIS);
         this.mPOIs.push(poi);
      }
      
      public function addTMC(locEIS:String) : void
      {
         this.mTMCMessages.push(locEIS);
      }
   }
}

