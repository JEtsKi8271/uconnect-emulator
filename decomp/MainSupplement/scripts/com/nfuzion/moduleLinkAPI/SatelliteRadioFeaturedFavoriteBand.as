package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioFeaturedFavoriteBand
   {
      
      private var mBandId:int;
      
      private var mDescription:String;
      
      private var mLongName:String;
      
      private var mName:String;
      
      private var mVerboseName:String;
      
      public function SatelliteRadioFeaturedFavoriteBand()
      {
         super();
      }
      
      public function get bandId() : int
      {
         return this.mBandId;
      }
      
      public function get description() : String
      {
         return this.mDescription;
      }
      
      public function get longName() : String
      {
         return this.mLongName;
      }
      
      public function get name() : String
      {
         return this.mName;
      }
      
      public function get verboseName() : String
      {
         return this.mVerboseName;
      }
      
      public function fillFrom(obj:Object) : void
      {
         if(obj != null)
         {
            this.mBandId = obj.bandID;
            this.mDescription = obj.description;
            this.mLongName = obj.longName;
            this.mName = obj.name;
            this.mVerboseName = obj.verboseName;
         }
      }
   }
}

