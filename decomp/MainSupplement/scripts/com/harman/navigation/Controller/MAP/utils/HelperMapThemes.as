package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.MapController;
   import com.harman.navigation.Controller.MAP.MapControllerEvent;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.VisibleObject;
   import com.nfuzion.framework.global.Framework;
   
   public class HelperMapThemes
   {
      
      private var mParent:MapController;
      
      private var mMapThemes:Array = new Array();
      
      private var mMapThemeID:String = "0";
      
      private var mMapThemeName:String = "";
      
      public function HelperMapThemes(parent:MapController)
      {
         super();
         this.mParent = parent;
         NavigationApi.api.addEventListener(NavigationEvent.MAP_THEMES_CHANGE,this.onMapThemesUpdateMapThemeChange,false,0,true);
      }
      
      public function get availableMapThemes() : Array
      {
         return this.mMapThemes;
      }
      
      public function get activeMapThemeID() : String
      {
         return this.mMapThemeID;
      }
      
      public function get activeMapThemeName() : String
      {
         var theme:VisibleObject = null;
         Framework.Trace("activeMapThemeName: mMapThemeName= " + this.mMapThemeName);
         if(this.mMapThemeName == "")
         {
            theme = this.getVisibleObjectFromID(this.mMapThemeID);
            if(theme != null)
            {
               this.mMapThemeName = theme.name;
            }
         }
         return this.mMapThemeName;
      }
      
      public function setActiveMapThemeID(mapTheme:VisibleObject, transmitToNav:Boolean = true) : void
      {
         var theme:VisibleObject = null;
         if(mapTheme.name == "")
         {
            theme = this.getVisibleObjectFromID(mapTheme.id);
            if(theme != null && theme.name != "")
            {
               mapTheme = theme;
            }
         }
         this.mMapThemeName = mapTheme.name;
         this.mMapThemeID = mapTheme.id;
         if(int(this.mMapThemeID) < 0)
         {
            Framework.Trace("setActiveMapThemeID(" + mapTheme.id + ") illegal -> fallback to \'0\' ");
            this.mMapThemeID = "0";
            this.mMapThemeName = "";
            transmitToNav = false;
         }
         if(transmitToNav)
         {
            NavigationApi.api.mapSendControlCmd("<MID>map<*><MST>" + this.mMapThemeName + "<*><MST_NNG>" + this.mMapThemeID + "<*>");
         }
      }
      
      public function onMapThemesUpdate(e:NavigationEvent) : void
      {
         var found:Boolean = false;
         this.mMapThemes = NavigationApi.api.mapThemes;
         var i:int = 0;
         var mMapTheme:VisibleObject = new VisibleObject();
         if(this.mMapThemeID != "" || this.mMapThemeID != "0")
         {
            found = false;
            for(i = 0; i < this.mMapThemes.length; i++)
            {
               if(VisibleObject(this.mMapThemes[i]).id == this.mMapThemeID)
               {
                  mMapTheme = VisibleObject(this.mMapThemes[i]);
                  found = true;
                  mMapTheme.setVisible(true);
                  break;
               }
            }
         }
         if(found == false)
         {
            this.setDefaultMapThemeNasedOnVehicleConfig();
         }
         this.mParent.sendEvent(MapControllerEvent.MAP_THEMES);
      }
      
      private function onMapThemesUpdateMapThemeChange(e:NavigationEvent) : void
      {
         NavigationApi.api.mapGetMapThemes();
      }
      
      private function getVisibleObjectFromID(id:String) : VisibleObject
      {
         if(this.mMapThemes.length == 0)
         {
            this.mMapThemes = NavigationApi.api.mapThemes;
         }
         for(var i:int = 0; i < this.mMapThemes.length; i++)
         {
            if(id == VisibleObject(this.mMapThemes[i]).id)
            {
               return VisibleObject(this.mMapThemes[i]);
            }
         }
         return null;
      }
      
      public function setDefaultMapThemeNasedOnVehicleConfig() : void
      {
         var found:Boolean = false;
         var defaultThemeName:String = this.defaultMapThemeNameBasedonVehicleConfig();
         for(var i:int = 0; i < this.mMapThemes.length; i++)
         {
            if(VisibleObject(this.mMapThemes[i]).name == defaultThemeName)
            {
               found = true;
               this.mParent.setMapTheme(VisibleObject(this.mMapThemes[i]));
               break;
            }
         }
         if(!found && (this.mMapThemes != null && this.mMapThemes.length > 0))
         {
            this.mParent.setMapTheme(VisibleObject(this.mMapThemes[0]));
         }
         else
         {
            NavigationApi.api.mapGetMapThemes();
         }
      }
      
      private function defaultMapThemeNameBasedonVehicleConfig() : String
      {
         var brand:String = NavigationPackage.peripheral.vehConfig.vehicleBrand;
         var defConfig:String = "";
         switch(brand)
         {
            case "12":
            case "2":
            case "3":
            case "1":
            case "9":
            case "11":
         }
         return "Fiat";
      }
   }
}

