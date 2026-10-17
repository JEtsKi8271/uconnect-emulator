package com.nfuzion.moduleLink
{
   import com.harman.moduleLink.VersionInfo;
   import com.harman.moduleLinkAPI.ProductVariantID;
   import com.nfuzion.moduleLinkAPI.ITravelLink;
   import com.nfuzion.moduleLinkAPI.ITravelLinkFuel;
   import com.nfuzion.moduleLinkAPI.ITravelLinkLandWeather;
   import com.nfuzion.moduleLinkAPI.ITravelLinkMovies;
   import com.nfuzion.moduleLinkAPI.ITravelLinkSports;
   import com.nfuzion.moduleLinkAPI.Module;
   import com.nfuzion.moduleLinkAPI.ModuleEvent;
   
   public class TravelLink extends Module implements ITravelLink
   {
      
      private static var instance:TravelLink;
      
      private var mFuel:TravelLinkFuel;
      
      private var mSports:TravelLinkSports;
      
      private var mLandWeather:TravelLinkLandWeather;
      
      private var mMovies:TravelLinkMovies;
      
      public function TravelLink()
      {
         super();
         this.mFuel = new TravelLinkFuel();
         this.mFuel.addEventListener(ModuleEvent.READY,this.subModuleReady);
         this.mMovies = new TravelLinkMovies();
         this.mMovies.addEventListener(ModuleEvent.READY,this.subModuleReady);
         this.mSports = new TravelLinkSports();
         this.mLandWeather = new TravelLinkLandWeather();
         this.mLandWeather.addEventListener(ModuleEvent.READY,this.subModuleReady);
      }
      
      public static function getInstance() : TravelLink
      {
         if(instance == null)
         {
            instance = new TravelLink();
         }
         return instance;
      }
      
      private function subModuleReady(e:ModuleEvent) : void
      {
         e.target.removeEventListener(ModuleEvent.READY,this.subModuleReady);
         if(this.isReady())
         {
            dispatchEvent(new ModuleEvent(ModuleEvent.READY));
         }
      }
      
      override public function isReady() : Boolean
      {
         return this.mFuel.isReady() && this.mMovies.isReady() && this.mLandWeather.isReady();
      }
      
      public function get isAvailable() : Boolean
      {
         var DESTINATION_USA:String = "2";
         var VARIANT_VP4:String = "VP4";
         var HAS_SDARS:String = "YES";
         var vehDestination:String = VehConfig.getInstance().vehicleDestination;
         var productVariant:ProductVariantID = VersionInfo.getInstance().productVariantID;
         if(vehDestination == DESTINATION_USA)
         {
            if(productVariant.VARIANT_MODEL == VARIANT_VP4 && productVariant.VARIANT_SDARS == HAS_SDARS)
            {
               return true;
            }
         }
         return false;
      }
      
      public function get fuel() : ITravelLinkFuel
      {
         return this.mFuel;
      }
      
      public function get landWeather() : ITravelLinkLandWeather
      {
         return this.mLandWeather;
      }
      
      public function get movies() : ITravelLinkMovies
      {
         return this.mMovies;
      }
      
      public function get sports() : ITravelLinkSports
      {
         return this.mSports;
      }
      
      public function get TLFuel() : String
      {
         return "TLFuel";
      }
      
      public function get TLLandWeather() : String
      {
         return "TLLandWeather";
      }
      
      public function get TLMovies() : String
      {
         return "TLMovies";
      }
      
      public function get TLSports() : String
      {
         return "TLSports";
      }
      
      public function get addFavorite() : String
      {
         return "add";
      }
      
      public function get replaceFavorite() : String
      {
         return "replace";
      }
      
      public function get deleteFavorite() : String
      {
         return "delete";
      }
      
      public function get reportFavoritesFull() : String
      {
         return "reportFull";
      }
   }
}

