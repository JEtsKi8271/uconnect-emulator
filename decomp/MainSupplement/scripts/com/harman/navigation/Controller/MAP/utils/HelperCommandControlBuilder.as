package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.MapController;
   import com.harman.navigation.Controller.MAP.enums.CpmPosition;
   import com.harman.navigation.Controller.MAP.enums.EisTypes;
   import com.harman.navigation.Controller.MAP.enums.MapAppearanceTypes;
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.Controller.MAP.enums.MapZoomLevels;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.tmc.TmcTypes;
   import com.nfuzion.framework.global.Framework;
   
   public class HelperCommandControlBuilder
   {
      
      private var mParent:MapController;
      
      public function HelperCommandControlBuilder(parent:MapController)
      {
         super();
         this.mParent = parent;
      }
      
      public function get controlCommands() : Object
      {
         var newCmds:Object = new Object();
         newCmds = this.mParent.getMapSettings(this.mParent.mapConfiguration).transmissionCommandObject;
         var settings:MapSettings = this.mParent.getMapSettings(this.mParent.mapConfiguration);
         newCmds[EisTypes.MVI] = "1";
         newCmds[EisTypes.MAS] = "" + this.mParent.appearanceStyle;
         switch(this.mParent.mapConfiguration)
         {
            case MapConfiguration.UNDEFINED:
               break;
            case MapConfiguration.MAP_FULL:
               if(this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_HIGHWAY_MODE) && NavigationPackage.peripheral.navigation.navigation.posNextHighwayExits.itemCount != 0)
               {
                  newCmds[EisTypes.MEP] = this.mapIsNorthUp() ? (NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState ? CpmPosition.FULL_HIGHWAY_NORTH_UP_IN_ROUTE : CpmPosition.FULL_HIGHWAY_NORTH_UP_NO_ROUTE) : CpmPosition.FULL_HIGHWAY_HEADING_UP;
               }
               else
               {
                  newCmds[EisTypes.MEP] = this.mapIsNorthUp() ? (NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState ? CpmPosition.FULL_NORTH_UP_IN_ROUTE : CpmPosition.FULL_NORTH_UP_NO_ROUTE) : CpmPosition.FULL_HEADING_UP;
               }
               break;
            case MapConfiguration.MAP_HALF_MAP:
            case MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED:
               newCmds[EisTypes.MEP] = this.mapIsNorthUp() ? CpmPosition.HALF_NORTH_UP : CpmPosition.HALF_HEADING_UP;
               break;
            case MapConfiguration.MAP_MEDIA:
               newCmds[EisTypes.MEP] = this.mapIsNorthUp() ? CpmPosition.MEDIA_NORTH_UP : CpmPosition.MEDIA_HEADING_UP;
               break;
            case MapConfiguration.MAP_HALF_LIKE_FULL_MAP:
               newCmds[EisTypes.MEP] = this.mapIsNorthUp() ? CpmPosition.HALF_NORTH_UP : CpmPosition.HALF_HEADING_UP;
               break;
            case MapConfiguration.MAP_GARAGE:
               Framework.Trace("HelperCommanControlBuilder.controlCommands(MAP_GARAGE) icons:" + NavigationPackage.peripheral.navigation.navMapControl.vehicleIcons.length + " ");
               newCmds[EisTypes.MPI_NNG] = this.mParent.activeVehicleIconID;
               break;
            case MapConfiguration.MAP_CONFIRM_ROUTE:
            case MapConfiguration.MAP_GRAPHICAL_WEATHER:
            case MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION:
            case MapConfiguration.MAP_SCROLLING:
            case MapConfiguration.MAP_ZOOM_ROUTE_SEGMENT:
            case MapConfiguration.MAP_ZOOM_TMC:
            case MapConfiguration.MAP_ROUTE_OVERVIEW:
         }
         this.addElevationAngle(newCmds);
         if(this.mParent.mapConfiguration != MapConfiguration.UNDEFINED)
         {
            newCmds[EisTypes.MRP] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_PARK_AREAS) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.MRR] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_RAILROADS) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.MCA] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_CITY_AREAS) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.MRN] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_RIVER_NAMES) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.M3L] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_3D_LANDMARKS) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.M3T] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_3D_TERRAIN) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.M3C] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_3D_CITY) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.MSC] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_SAFETY_CAMERA) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
            newCmds[EisTypes.MRF] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_FOREST_AREAS) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
         }
         this.addJunctionViewAndLaneRecommendation(newCmds);
         this.addTmcAndSpeedAndFlow(newCmds);
         return newCmds;
      }
      
      private function mapIsNorthUp() : Boolean
      {
         if(this.mapUserSettingIsNorthUp() || this.zoomLevelIsInAutoNorthUpMode() && this.mapAutoZoomIsOff() || this.zoomLevelIsInAutoNorthUpMode() && this.mapAutoZoomIsOverride())
         {
            return true;
         }
         return false;
      }
      
      private function mapUserSettingIsNorthUp() : Boolean
      {
         return this.mParent.getMapSettings(this.mParent.mapConfiguration).heading == MapSettingTypes.ORIENTATION_NORTH_UP;
      }
      
      private function zoomLevelIsInAutoNorthUpMode() : Boolean
      {
         return this.mParent.getMapSettings(this.mParent.mapConfiguration).zoomLevel >= NavGlobalSettings.MAP_AUTO_NORTH_UP_LEVEL;
      }
      
      private function mapAutoZoomIsOff() : Boolean
      {
         return this.mParent.getMapSettings(this.mParent.mapConfiguration).autoZoomSetting == MapZoomLevels.LEVEL_AUTO_OFF;
      }
      
      private function mapAutoZoomIsOverride() : Boolean
      {
         return this.mParent.getMapSettings(this.mParent.mapConfiguration).autoZoomOveride;
      }
      
      private function addElevationAngle(newCmds:Object) : void
      {
         var settings:MapSettings = this.mParent.getMapSettings(this.mParent.mapConfiguration);
         if(settings.viewType == MapSettingTypes.VIEW_TYPE_3D || settings.viewType == MapSettingTypes.VIEW_TYPE_BIRD)
         {
            newCmds[EisTypes.MEV] = "0";
         }
         else
         {
            newCmds[EisTypes.MEV] = "";
         }
      }
      
      private function addJunctionViewAndLaneRecommendation(newCmds:Object) : void
      {
         if(this.mParent.mapConfiguration == MapConfiguration.MAP_FULL)
         {
            if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState)
            {
               if(this.mParent.junctionViewManualOverideActive || !this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_JUNCTION_VIEW))
               {
                  newCmds[EisTypes.SJV] = "" + MapSettingTypes.DISABLED;
                  newCmds[EisTypes.MSP] = "" + MapSettingTypes.DISABLED;
                  newCmds[EisTypes.MLR] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_LANE_RECOMMENDATION) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
                  this.mParent.updateJunctionViewVisibleState(false);
               }
               else if(NavigationPackage.peripheral.navigation.navigation.posJunctionViewState == true)
               {
                  newCmds[EisTypes.SJV] = "" + MapSettingTypes.ENABLED;
                  newCmds[EisTypes.MSP] = "" + MapSettingTypes.ENABLED;
                  newCmds[EisTypes.MLR] = "" + MapSettingTypes.LANE_RECOMMENDATION_MODE_OFF;
                  this.mParent.updateJunctionViewVisibleState(true);
               }
               else
               {
                  newCmds[EisTypes.SJV] = "" + MapSettingTypes.DISABLED;
                  newCmds[EisTypes.MSP] = "" + MapSettingTypes.DISABLED;
                  newCmds[EisTypes.MLR] = "" + (this.mParent.mapAppearanceSettings.isSet(MapAppearanceTypes.SHOW_LANE_RECOMMENDATION) ? MapSettingTypes.ENABLED : MapSettingTypes.DISABLED);
                  this.mParent.updateJunctionViewVisibleState(false);
               }
            }
            else
            {
               newCmds[EisTypes.SJV] = "" + MapSettingTypes.DISABLED;
               newCmds[EisTypes.MSP] = "" + MapSettingTypes.DISABLED;
               newCmds[EisTypes.MLR] = "" + MapSettingTypes.DISABLED;
               this.mParent.updateJunctionViewVisibleState(false);
            }
         }
         else
         {
            newCmds[EisTypes.SJV] = "" + MapSettingTypes.DISABLED;
            newCmds[EisTypes.MSP] = "" + MapSettingTypes.DISABLED;
            newCmds[EisTypes.MLR] = "" + MapSettingTypes.DISABLED;
            this.mParent.updateJunctionViewVisibleState(false);
         }
      }
      
      private function addTmcAndSpeedAndFlow(newCmds:Object) : void
      {
         if(this.mParent.mapConfiguration == MapConfiguration.MAP_ZOOM_TMC)
         {
            newCmds[EisTypes.MTF] = "" + MapSettingTypes.ENABLED;
            newCmds[EisTypes.MTI] = "" + MapSettingTypes.ENABLED;
         }
         else
         {
            switch(this.mParent.tmcSetting)
            {
               case TmcTypes.MAP_ALL_DISABLED:
                  newCmds[EisTypes.MTF] = "" + MapSettingTypes.DISABLED;
                  newCmds[EisTypes.MTI] = "" + MapSettingTypes.DISABLED;
                  break;
               case TmcTypes.MAP_SHOW_SPEED_AND_FLOW_ONLY:
                  newCmds[EisTypes.MTF] = "" + MapSettingTypes.ENABLED;
                  newCmds[EisTypes.MTI] = "" + MapSettingTypes.DISABLED;
                  break;
               case TmcTypes.MAP_SHOW_TMC_ONLY:
                  newCmds[EisTypes.MTF] = "" + MapSettingTypes.DISABLED;
                  newCmds[EisTypes.MTI] = "" + MapSettingTypes.ENABLED;
                  break;
               case TmcTypes.MAP_SHOW_ALL:
                  newCmds[EisTypes.MTF] = "" + MapSettingTypes.ENABLED;
                  newCmds[EisTypes.MTI] = "" + MapSettingTypes.ENABLED;
            }
         }
      }
   }
}

