package com.harman.navigation.locationInput
{
   import com.harman.navigation.Navigation;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.SpellerInfo;
   import com.nfuzion.framework.global.Framework;
   
   public class LocationInputManager
   {
      
      private static const REQUEST_DETAILS_OPTIONS_ALL:String = "\"requestedFields\":[\"<ALL>\"]";
      
      private var mNavService:Navigation;
      
      private var mListResult:Array = new Array();
      
      private var mSpellResult:SpellerInfo = new SpellerInfo();
      
      private var mDetailsResult:LocationDetails = new LocationDetails();
      
      private var mAvailableInformation:Array = new Array();
      
      public function LocationInputManager(naviService:Navigation)
      {
         super();
         this.mNavService = naviService;
         this.init();
      }
      
      public function liGetList(loc:LocationDetails, listStart:int, listCount:int, sortOption:int) : void
      {
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"" + this.mNavService.performDoubleQuoteCheck(loc.toEIS()) + "\"" + ",\"inresultCount\":" + listCount + ",\"insortOption\":" + sortOption + ",\"instartIndex\":" + listStart + ",\"cancelPreviousRequest\":false}");
      }
      
      public function liGetListRequestFields(loc:LocationDetails, listStart:int, listCount:int, sortOption:int, infieldOptions:String) : void
      {
         this.mNavService.sendCommand("\"Info_GetList\":{\"inputEIS\":\"" + this.mNavService.performDoubleQuoteCheck(loc.toEIS()) + "\"" + ",\"inresultCount\":" + listCount + ",\"insortOption\":" + sortOption + ",\"instartIndex\":" + listStart + ",\"infieldOptions\":[" + infieldOptions + "]" + ",\"cancelPreviousRequest\":false}");
      }
      
      public function liGetSpell(loc:LocationDetails) : void
      {
         this.mNavService.sendCommand("\"Info_GetSpell\":{\"inputEIS\":\"" + this.mNavService.performDoubleQuoteCheck(loc.toEIS()) + "\"}");
      }
      
      public function getLiList() : Array
      {
         return this.mListResult;
      }
      
      public function getLiSpell() : SpellerInfo
      {
         return this.mSpellResult;
      }
      
      public function liGetDetails(eisString:String) : void
      {
         this.mNavService.sendCommand("\"Info_GetDetails\":{\"inputEIS\":\"<IFT>LI<*>" + this.mNavService.performDoubleQuoteCheck(eisString) + "\"," + REQUEST_DETAILS_OPTIONS_ALL + "}");
      }
      
      public function getLiDetails() : LocationDetails
      {
         return this.mDetailsResult;
      }
      
      public function onInfo_GetList(resp:Object) : void
      {
         var i:int = 0;
         this.mListResult.splice(0,this.mListResult.length);
         if(resp.Info_GetList.resultCode == 1)
         {
            Framework.Trace("Nav.LI.onInfo_GetList response for (" + resp.Info_GetList.respEIS + ")");
            for(i = 0; i < resp.Info_GetList.itemList.length; i++)
            {
               this.mListResult.push(String(resp.Info_GetList.itemList[i]));
            }
         }
         else if(!this.considerGetListErrors(resp))
         {
            Framework.Trace("## ERROR ## Navigation.LocationInputManager.onInfo_GetList resultCode=" + resp.Info_GetList.resultCode);
         }
         this.mNavService.sendEvent(NavigationEvent.LI_GETLIST);
      }
      
      public function liGetAvailableInformation(eisString:String) : void
      {
         this.mNavService.sendCommand("\"Info_GetAvailableInformation\":{\"inputEIS\":\"" + eisString + "\"}");
      }
      
      public function onInfo_GetAvailableInformation(resp:Object) : void
      {
         Framework.Trace("onInfo_GetAvailableInformation");
         if(resp.hasOwnProperty("Info_GetAvailableInformation"))
         {
            if(resp.Info_GetAvailableInformation.hasOwnProperty("availableTypes"))
            {
               this.mAvailableInformation = resp.Info_GetAvailableInformation.availableTypes;
            }
         }
         this.mNavService.sendEvent(NavigationEvent.LI_GETAVAILABLEINFO,Object(resp.Info_GetAvailableInformation));
      }
      
      public function get availableInformation() : Array
      {
         return this.mAvailableInformation;
      }
      
      public function onInfo_GetDetails(resp:Object) : void
      {
         this.mDetailsResult = new LocationDetails();
         if(resp.Info_GetDetails.resultCode == 1)
         {
            Framework.Trace("LocationInputManager.onInfo_GetDetails");
            this.mDetailsResult.addEisStringGetDetails(resp.Info_GetDetails.outputEIS);
         }
         else
         {
            this.mSpellResult.reset();
            Framework.Trace("!!! Navigation.LocationInputManager.Info_GetDetails resultCode=" + resp.Info_GetDetails.resultCode);
            this.mNavService.sendEvent(NavigationEvent.LI_GETDETAILS_FAILED);
         }
         this.mNavService.sendEvent(NavigationEvent.LI_GETDETAILS);
      }
      
      public function onInfo_GetSpell(resp:Object) : void
      {
         if(resp.Info_GetSpell.resultCode == 1)
         {
            this.mSpellResult.setCharacters(String(resp.Info_GetSpell.nextAvailableCharacters));
            this.mSpellResult.setEisString(String(resp.Info_GetSpell.respEIS));
            this.mSpellResult.setCount(int(resp.Info_GetSpell.count));
            this.mSpellResult.setFullMatch(String(resp.Info_GetSpell.isFullMatch) == "true" ? true : false);
         }
         else
         {
            Framework.Trace("!!! Navigation.LocationInputManager.onInfo_GetSpell resultCode=" + resp.Info_GetSpell.resultCode);
            if(String(resp.Info_GetSpell.respEIS).indexOf("<CTY_NNG>") >= 0 || String(resp.Info_GetSpell.respEIS).indexOf("<ZIP_NNG>") >= 0)
            {
               Framework.Trace(" Continue with HouseNumber Speller without available Housenumbers...");
               this.mSpellResult.setCharacters(String(resp.Info_GetSpell.nextAvailableCharacters));
               this.mSpellResult.setEisString(String(resp.Info_GetSpell.respEIS));
               this.mSpellResult.setCount(int(resp.Info_GetSpell.count));
               this.mSpellResult.setFullMatch(true);
               this.mNavService.sendEvent(NavigationEvent.LI_GETSPELL_FAILED);
               return;
            }
            if(String(resp.Info_GetSpell.respEIS).indexOf("<CTY>") >= 0 || String(resp.Info_GetSpell.respEIS).indexOf("<ZIP>") >= 0 || String(resp.Info_GetSpell.respEIS).indexOf("<STR>") >= 0)
            {
               this.mNavService.sendEvent(NavigationEvent.LI_GETSPELL_FAILED);
            }
            else
            {
               this.mSpellResult.reset();
            }
         }
         this.mNavService.sendEvent(NavigationEvent.LI_GETSPELL);
      }
      
      private function init() : void
      {
      }
      
      private function considerGetListErrors(resp:Object) : Boolean
      {
         return false;
      }
   }
}

