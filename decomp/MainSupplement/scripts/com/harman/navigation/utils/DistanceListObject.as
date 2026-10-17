package com.harman.navigation.utils
{
   public class DistanceListObject
   {
      
      private var mTitle:String = "";
      
      private var mSubTitle:String = "";
      
      private var mIcon:String = "";
      
      private var mLongitude:Number = 0;
      
      private var mLatitude:Number = 0;
      
      private var mDistance:String = "";
      
      private var mDirection:int = 1;
      
      private var mRealDistance:Number = 0;
      
      private var mListIndex:int = 0;
      
      private var mIdentifier:int = 1;
      
      public function DistanceListObject()
      {
         super();
      }
      
      public function setTitle(title:String) : void
      {
         this.mTitle = title;
      }
      
      public function setSubtitle(subtitle:String) : void
      {
         this.mSubTitle = subtitle;
      }
      
      public function setIcon(icon:String) : void
      {
         this.mIcon = icon;
      }
      
      public function setDistance(distance:String) : void
      {
         this.mDistance = distance;
      }
      
      public function setDirection(direction:int) : void
      {
         this.mDirection = direction;
      }
      
      public function setIdentifier(identifier:int) : void
      {
         this.mIdentifier = identifier;
      }
      
      public function setRealDistance(distance:Number) : void
      {
         this.mRealDistance = distance;
      }
      
      public function setListIndex(index:int) : void
      {
         this.mListIndex = index;
      }
      
      public function setGeo(geo:String) : void
      {
         this.mLongitude = Number(geo.substring(0,geo.indexOf(" ")));
         this.mLatitude = Number(geo.substring(geo.indexOf(" ") + 1,geo.length - 1));
      }
      
      public function get title() : String
      {
         return this.mTitle;
      }
      
      public function get subtitle() : String
      {
         return this.mSubTitle;
      }
      
      public function get icon() : String
      {
         return this.mIcon;
      }
      
      public function get longitude() : Number
      {
         return this.mLongitude;
      }
      
      public function get latitude() : Number
      {
         return this.mLatitude;
      }
      
      public function get distance() : String
      {
         return this.mDistance;
      }
      
      public function get direction() : int
      {
         return this.mDirection;
      }
      
      public function get identifier() : int
      {
         return this.mIdentifier;
      }
      
      public function get realDistance() : Number
      {
         return this.mRealDistance;
      }
      
      public function get listIndex() : int
      {
         return this.mListIndex;
      }
   }
}

