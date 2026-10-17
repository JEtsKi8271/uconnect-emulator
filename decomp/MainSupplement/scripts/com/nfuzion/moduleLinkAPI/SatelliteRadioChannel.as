package com.nfuzion.moduleLinkAPI
{
   public class SatelliteRadioChannel
   {
      
      public var number:int = 65535;
      
      public var sid:int = 0;
      
      public var index:int = 0;
      
      public var name:String = "";
      
      public var shortName:String = "";
      
      public var category:String = "";
      
      public var categoryNum:int = 0;
      
      public var mature:Boolean = false;
      
      public var subscribed:Boolean = false;
      
      public var logoUrl:String = "";
      
      public var primaryLargeLogoUrl:String = "";
      
      public var secondarylargeLogoUrl:String = "";
      
      public var backgroundImageUrl:String = "";
      
      public var presetNum:int = -1;
      
      public var skip:Boolean = false;
      
      public var lock:Boolean = false;
      
      public var replay:Boolean = true;
      
      public var artist:String = "";
      
      public var title:String = "";
      
      public var composer:String = "";
      
      public var content:String = "";
      
      public var duration:Number = 0;
      
      public var timestamp:Date = new Date(1970,1,1);
      
      public var isSongFavorite:Boolean = false;
      
      public var isArtistFavorite:Boolean = false;
      
      public function SatelliteRadioChannel()
      {
         super();
      }
      
      public function isEqual(ch:SatelliteRadioChannel) : Boolean
      {
         return ch.sid == this.sid && ch.number == this.number;
      }
      
      public function updateInfo(ch:SatelliteRadioChannel) : void
      {
         this.number = ch.number;
         this.sid = ch.sid;
         this.name = ch.name;
         this.shortName = ch.shortName;
         this.category = ch.category;
         this.categoryNum = ch.categoryNum;
         this.mature = ch.mature;
         this.subscribed = ch.subscribed;
         this.logoUrl = ch.logoUrl;
         this.primaryLargeLogoUrl = ch.primaryLargeLogoUrl;
         this.secondarylargeLogoUrl = ch.secondarylargeLogoUrl;
         this.backgroundImageUrl = ch.backgroundImageUrl;
         this.replay = this.sid != 0;
         this.presetNum = ch.presetNum;
      }
   }
}

