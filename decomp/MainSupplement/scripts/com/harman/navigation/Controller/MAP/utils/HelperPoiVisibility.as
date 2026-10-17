package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.MapController;
   import com.harman.navigation.Controller.MAP.MapControllerEvent;
   import com.harman.navigation.Controller.MAP.enums.MapAppearanceTypes;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.VisibleObject;
   import com.nfuzion.framework.global.Framework;
   
   public class HelperPoiVisibility
   {
      
      private var mParent:MapController;
      
      private var mPoiVisListCount:Array = new Array();
      
      private var mPoiVisibilities:Array = new Array();
      
      private var mPoiVisibilitiesSaved:Array = new Array();
      
      public function HelperPoiVisibility(parent:MapController)
      {
         super();
         this.mParent = parent;
         NavigationApi.api.addEventListener(NavigationEvent.NAV_LANGUAGE_CHANGED,this.onLanguageChange,false,0,true);
      }
      
      public function get PoiVisibilities() : Array
      {
         return this.mPoiVisibilities;
      }
      
      public function getPoiVisibilities() : void
      {
         if(VServiceGlobalSettings.navMarketConfig == VServiceGlobalSettings.MARKET_JAPAN)
         {
            NavigationApi.api.mapGetPoiVisibilities();
         }
         else if(this.mPoiVisibilities.length == 0)
         {
            NavigationApi.api.mapGetPoiVisibilities();
         }
         else
         {
            this.mParent.sendEvent(MapControllerEvent.MAP_POI_VISIBILITY);
         }
      }
      
      public function onMapPoiVisListCount(e:NavigationEvent) : void
      {
         this.mPoiVisListCount = NavigationApi.api.mapPoiVisListCount;
         this.mParent.sendEvent(MapControllerEvent.MAP_POI_VIS_LISTCOUNT);
      }
      
      public function onMapPoiVisibilityUpdate(e:NavigationEvent) : void
      {
         this.mPoiVisibilities = NavigationApi.api.mapPoiVisibilities;
         this.mParent.sendEvent(MapControllerEvent.MAP_POI_VISIBILITY);
      }
      
      public function handleGeneralPoiVisibility() : void
      {
         var arrString:String = null;
         var i:int = 0;
         var j:int = 0;
         var tmp:VisibleObject = null;
         if(this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_POI_ICONS))
         {
            if(this.mPoiVisibilitiesSaved.length > 0)
            {
               arrString = "";
               for(i = 0; i < this.mPoiVisibilitiesSaved.length; i++)
               {
                  if(arrString.length > 0)
                  {
                     arrString += ", ";
                  }
                  arrString += "\"<CAT>" + VisibleObject(this.mPoiVisibilitiesSaved[i]).name + "<*>" + "<CAT_NNG>" + VisibleObject(this.mPoiVisibilitiesSaved[i]).id + "<*>" + "<VIS>" + (VisibleObject(this.mPoiVisibilitiesSaved[i]).visible == true ? "1" : "0") + "<*>\"";
               }
               NavigationApi.api.mapSetPoiVisibilities(arrString);
               Framework.Trace("mMapAppearance.isSet: " + this.mPoiVisibilitiesSaved.length);
            }
            else
            {
               Framework.Trace("mPoiVisibilitiesSaved: no data");
               if(this.mPoiVisibilities.length > 0)
               {
                  NavigationApi.api.mapSetPoiVisibility(VisibleObject(this.mPoiVisibilities[0]).id,true);
               }
            }
         }
         else
         {
            this.mPoiVisibilitiesSaved.splice(0,this.mPoiVisibilitiesSaved.length);
            for(j = 0; j < this.mPoiVisibilities.length; j++)
            {
               tmp = new VisibleObject();
               tmp.clone(VisibleObject(this.mPoiVisibilities[j]));
               this.mPoiVisibilitiesSaved.push(tmp);
            }
            if(this.mPoiVisibilities.length > 0)
            {
               NavigationApi.api.mapSetPoiVisibility(VisibleObject(this.mPoiVisibilities[0]).id,false);
               Framework.Trace("!mMapAppearance.isSet");
            }
            else
            {
               Framework.Trace("MapController.handleGeneralPoiVisibility() length = 0!");
            }
         }
      }
      
      private function onLanguageChange(e:NavigationEvent) : void
      {
         if(!NavigationApi.api.langIsLanguageChangeInProgress)
         {
            Framework.Trace("HelperPoiVisibility.onLanguageChange()");
            NavigationApi.api.mapGetPoiVisibilities();
         }
      }
   }
}

