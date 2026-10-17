package com.nfuzion.moduleLinkAPI
{
   public class DataServicesSubscriptionStatus
   {
      
      public static const subscribedNo:int = 0;
      
      public static const subscribedYes:int = 1;
      
      public static const subscribedUnknown:int = 255;
      
      public var mTrafficSubStatus:int = 255;
      
      public var mFuelSubStatus:int = 255;
      
      public var mMoviesSubStatus:int = 255;
      
      public var mLandWeatherSubStatus:int = 255;
      
      public var mSportsSubStatus:int = 255;
      
      public var mGraphicalWeatherSubStatus:int = 255;
      
      public var mSecurityAlertsSubStatus:int = 255;
      
      public var mChannelArtSubStatus:int = 255;
      
      public function DataServicesSubscriptionStatus()
      {
         super();
      }
   }
}

