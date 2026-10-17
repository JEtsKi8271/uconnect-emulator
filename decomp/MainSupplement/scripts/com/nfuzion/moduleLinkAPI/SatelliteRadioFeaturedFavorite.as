package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioFeaturedFavorite
   {
      
      private var mChannelID:int;
      
      private var mName:String;
      
      public function SatelliteRadioFeaturedFavorite()
      {
         super();
      }
      
      public function get channelId() : int
      {
         return this.mChannelID;
      }
      
      public function get name() : String
      {
         return this.mName;
      }
      
      public function fillFrom(obj:Object) : void
      {
         if(obj != null)
         {
            this.mChannelID = obj.channelID;
            this.mName = obj.name;
         }
      }
   }
}

