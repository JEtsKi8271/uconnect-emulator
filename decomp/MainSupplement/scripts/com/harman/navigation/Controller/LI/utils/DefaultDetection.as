package com.harman.navigation.Controller.LI.utils
{
   import com.harman.navigation.Controller.LI.LocationInputController;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.enums.SortOption;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.LocationDetails;
   import com.nfuzion.framework.global.Framework;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   use namespace NavigationNamespace;
   
   public class DefaultDetection
   {
      
      private var mParent:LocationInputController;
      
      private var mPosCountry:String = "";
      
      private var mPosState:String = "";
      
      private var mPosCity:String = "";
      
      private var mDetailCountry:String = "";
      
      private var mDetailState:String = "";
      
      private var mDetailCity:String = "";
      
      private var mCountryRequestRetryCounter:int = 20;
      
      private var mPositionRequestRetryCounter:int = 1;
      
      private var mPositionRequestTimer:Timer = null;
      
      public function DefaultDetection(parent:LocationInputController)
      {
         super();
         Framework.Trace("DefaultDetection()");
         this.mParent = parent;
         NavigationApi.impl = NavigationImpl.create();
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETDETAILS,this.onGetDetails,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETDETAILS_FAILED,this.onGetDetailsFailed,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.LI_GETLIST,this.onGetList,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPosPosition,false,0,true);
         NavigationApi.api.posGetPositionInformation();
      }
      
      private function requestCountryList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType("<IFT>","LI");
         loc.addType("<CTR>",this.mPosCountry);
         Framework.Trace("DefaultDetection.requestCountryList() " + loc.toEIS());
         NavigationApi.api.liGetList(loc,1,50,SortOption.DEFAULT);
      }
      
      private function requestStateList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType("<IFT>","LI");
         loc.addType("<CTR>",EisHelper.getValueOfType(this.mDetailCountry,"<CTR>"));
         loc.addType("<CTR_NNG>",EisHelper.getValueOfType(this.mDetailCountry,"<CTR_NNG>"));
         loc.addType("<STA>",this.mPosState);
         Framework.Trace("DefaultDetection.requestStateList() " + loc.toEIS());
         NavigationApi.api.liGetList(loc,1,50,SortOption.DEFAULT);
      }
      
      private function requestCityList() : void
      {
         var loc:LocationDetails = new LocationDetails();
         loc.addType("<IFT>","LI");
         loc.addType("<CTR>",EisHelper.getValueOfType(this.mDetailCountry,"<CTR>"));
         loc.addType("<CTR_NNG>",EisHelper.getValueOfType(this.mDetailCountry,"<CTR_NNG>"));
         loc.addType("<STA>",EisHelper.getValueOfType(this.mDetailState,"<STA>"));
         loc.addType("<STA_NNG>",EisHelper.getValueOfType(this.mDetailState,"<STA_NNG>"));
         loc.addType("<CTY>",this.mPosCity);
         Framework.Trace("DefaultDetection.requestCityList() " + loc.toEIS());
         NavigationApi.api.liGetList(loc,1,50,SortOption.DEFAULT);
      }
      
      private function detectionFinished() : void
      {
         Framework.Trace("DefaultDetection.detectionFinished()");
         NavigationApi.api.removeEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPosPosition);
         NavigationApi.api.removeEventListener(NavigationEvent.LI_GETDETAILS,this.onGetDetails);
         NavigationApi.api.removeEventListener(NavigationEvent.LI_GETDETAILS_FAILED,this.onGetDetailsFailed);
         NavigationApi.api.removeEventListener(NavigationEvent.LI_GETLIST,this.onGetList);
         this.mParent.setDefaultCountry(this.mDetailCountry);
         this.mParent.setDefaultState(this.mDetailState,true);
         this.mParent.setDefaultCity(this.mDetailCity);
         this.mParent.setDefaultDetectionComplete();
      }
      
      private function onPositionRequestTimer(e:TimerEvent) : void
      {
         NavigationApi.api.posGetPositionInformation();
      }
      
      private function onPosPosition(e:NavigationEvent) : void
      {
         Framework.Trace("DefaultDetection.onPosPosition( " + LocationDetails(NavigationApi.api.posPositionInformation).getType("<GEO>") + " )");
         if(LocationDetails(NavigationApi.api.posPositionInformation).getType("<GEO>") != "")
         {
            NavigationApi.api.liGetDetails(LocationDetails(NavigationApi.api.posPositionInformation).getType("<IFT>") + "<GEO>" + LocationDetails(NavigationApi.api.posPositionInformation).getType("<GEO>") + "<*>");
            NavigationApi.api.removeEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPosPosition);
            if(this.mPositionRequestTimer.running)
            {
               this.mPositionRequestTimer.stop();
            }
         }
         else
         {
            Framework.Trace(" -No position available");
            if(this.mPositionRequestRetryCounter >= 0)
            {
               this.mPositionRequestTimer = new Timer(5000,1);
               this.mPositionRequestTimer.addEventListener(TimerEvent.TIMER,this.onPositionRequestTimer,false,0,true);
               this.mPositionRequestTimer.start();
               --this.mPositionRequestRetryCounter;
            }
            else
            {
               this.detectionFinished();
            }
         }
      }
      
      private function onGetDetails(e:NavigationEvent) : void
      {
         var loc:LocationDetails = NavigationApi.api.liDetails;
         this.mPosCountry = loc.getType("<CTR>");
         this.mPosState = loc.getType("<STA>");
         this.mPosCity = loc.getType("<CTY>");
         if(this.mPosCountry != "")
         {
            this.requestCountryList();
         }
         else
         {
            this.detectionFinished();
         }
      }
      
      private function onGetDetailsFailed(e:NavigationEvent) : void
      {
         Framework.Trace("DefaultDetection.onGetDetailsFailed()");
         this.detectionFinished();
      }
      
      private function onGetList(e:NavigationEvent) : void
      {
         var i:int = 0;
         if(NavigationApi.api.liList.length > 0)
         {
            for(i = 0; i < NavigationApi.api.liList.length; i++)
            {
               Framework.Trace("DefaultDetection.list " + i + " " + NavigationApi.api.liList[i]);
            }
            if(this.mDetailCountry == "")
            {
               if(String(EisHelper.getValueOfType(String(NavigationApi.api.liList[0]),"<CTR_NNG>")).length <= 4 && this.mCountryRequestRetryCounter > 0)
               {
                  Framework.Trace("DefaultDetection.onGetList(Country) RETRY " + String(NavigationApi.api.liList[0]) + " - " + this.mCountryRequestRetryCounter);
                  --this.mCountryRequestRetryCounter;
                  this.requestCountryList();
                  return;
               }
               this.mDetailCountry = NavigationApi.api.liList[0];
               Framework.Trace("DefaultDetection.onGetList(country) = \'" + this.mDetailCountry + "\'");
               this.requestStateList();
            }
            else if(this.mDetailState == "")
            {
               this.mDetailState = NavigationApi.api.liList[0];
               Framework.Trace("DefaultDetection.onGetList(state) = \'" + this.mDetailState + "\'");
               this.requestCityList();
            }
            else if(this.mDetailCity == "")
            {
               this.mDetailCity = NavigationApi.api.liList[0];
               Framework.Trace("DefaultDetection.onGetList(state) = \'" + this.mDetailCity + "\'");
               this.detectionFinished();
            }
            else
            {
               this.detectionFinished();
            }
         }
         else
         {
            this.detectionFinished();
         }
      }
   }
}

