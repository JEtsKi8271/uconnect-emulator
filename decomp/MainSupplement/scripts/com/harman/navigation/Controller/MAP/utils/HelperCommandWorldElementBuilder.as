package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.MapController;
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.enums.RouteCalculationState;
   import com.harman.navigation.global.NavigationPackage;
   
   public class HelperCommandWorldElementBuilder
   {
      
      private var mParent:MapController;
      
      public function HelperCommandWorldElementBuilder(parent:MapController)
      {
         super();
         this.mParent = parent;
      }
      
      public function get controlWorldElements() : Array
      {
         var elementArray:Array = new Array();
         this.addZoomToLocation(elementArray);
         this.addActiveRoute(elementArray);
         this.addPlannedRoutes(elementArray);
         this.addTmCRoute(elementArray);
         return elementArray;
      }
      
      private function addZoomToLocation(elementArray:Array) : void
      {
         switch(this.mParent.mapConfiguration)
         {
            case MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION:
               this.checkForZoomLocation(elementArray,MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION);
               break;
            case MapConfiguration.MAP_ZOOM_ROUTE_SEGMENT:
               this.checkForZoomLocation(elementArray,MapConfiguration.MAP_ZOOM_ROUTE_SEGMENT);
               break;
            case MapConfiguration.MAP_GRAPHICAL_WEATHER:
               this.checkForZoomLocation(elementArray,MapConfiguration.MAP_GRAPHICAL_WEATHER);
               break;
            case MapConfiguration.MAP_SCROLLING:
               this.checkForZoomLocation(elementArray,MapConfiguration.MAP_SCROLLING);
               break;
            case MapConfiguration.MAP_ZOOM_TMC:
               this.checkForZoomLocation(elementArray,MapConfiguration.MAP_ZOOM_TMC);
               break;
            case MapConfiguration.MAP_CONFIRM_ROUTE:
            case MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED:
            case MapConfiguration.MAP_FULL:
            case MapConfiguration.MAP_MEDIA:
            case MapConfiguration.MAP_HALF_MAP:
            case MapConfiguration.UNDEFINED:
            case MapConfiguration.MAP_GARAGE:
            case MapConfiguration.MAP_CONFIRM_TMC_REROUTE:
            case MapConfiguration.MAP_ROUTE_OVERVIEW:
         }
      }
      
      private function checkForZoomLocation(elementArray:Array, mapConfigID:int) : void
      {
         if(this.getGeoCoordinate(mapConfigID).length > 10)
         {
            elementArray.push(this.createZoomFunction(this.getGeoCoordinate(mapConfigID)));
         }
      }
      
      private function getGeoCoordinate(mapConfigID:int) : String
      {
         return this.mParent.getMapSettings(mapConfigID).geoCoordinate;
      }
      
      private function createZoomFunction(geo:String) : Object
      {
         var zoomFunction:Object = new Object();
         var itemArray:Array = new Array();
         itemArray.push("<GEO>" + geo + "<*>");
         zoomFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM;
         zoomFunction["ITEMS"] = itemArray;
         return zoomFunction;
      }
      
      private function addPlannedRoutes(elementArray:Array) : void
      {
         var zoomHighlightFunction:Object = new Object();
         var rh:Array = this.getAllPlannedRouteHandles();
         if(rh.length > 0)
         {
            zoomHighlightFunction["ITEMS"] = rh;
            switch(this.mParent.mapConfiguration)
            {
               case MapConfiguration.MAP_CONFIRM_ROUTE:
                  zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM | MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE;
                  break;
               case MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED:
                  zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE;
                  break;
               case MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION:
               case MapConfiguration.MAP_ZOOM_ROUTE_SEGMENT:
               case MapConfiguration.MAP_GRAPHICAL_WEATHER:
               case MapConfiguration.MAP_SCROLLING:
               case MapConfiguration.MAP_ZOOM_TMC:
               case MapConfiguration.MAP_FULL:
               case MapConfiguration.MAP_MEDIA:
               case MapConfiguration.MAP_HALF_MAP:
               case MapConfiguration.UNDEFINED:
               case MapConfiguration.MAP_GARAGE:
               case MapConfiguration.MAP_CONFIRM_TMC_REROUTE:
               case MapConfiguration.MAP_ROUTE_OVERVIEW:
               default:
                  zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_HIDE;
            }
            elementArray.push(zoomHighlightFunction);
         }
      }
      
      private function getAllPlannedRouteHandles() : Array
      {
         var plannedRoutes:Array = null;
         var i:* = 0;
         var handles:Array = new Array();
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip != null)
         {
            plannedRoutes = NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip.routes;
            for(i = int(plannedRoutes.length - 1); i >= 0; i--)
            {
               if(Route(plannedRoutes[i]).routeHandle > 0)
               {
                  if(i == 0 || Route(plannedRoutes[i]).calculationState >= RouteCalculationState.Planned)
                  {
                     handles.push("<RTH>" + Route(plannedRoutes[i]).routeHandle + "<*>");
                  }
               }
            }
         }
         return handles;
      }
      
      private function addActiveRoute(elementArray:Array) : void
      {
         var zoomHighlightFunction:Object = new Object();
         var rh:Array = new Array();
         if(Boolean(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRouteGuidanceState) && NavigationPackage.peripheral.navigation.navTripAssembler.isAlteringRoute == false)
         {
            rh.push("<RTH>" + NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.routeHandle + "<*>");
            if(rh.length > 0)
            {
               zoomHighlightFunction["ITEMS"] = rh;
               switch(this.mParent.mapConfiguration)
               {
                  case MapConfiguration.MAP_CONFIRM_TMC_REROUTE:
                     return;
                  case MapConfiguration.MAP_CONFIRM_ROUTE:
                  case MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED:
                  case MapConfiguration.MAP_ZOOM_TMC:
                  case MapConfiguration.MAP_GRAPHICAL_WEATHER:
                     zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_HIDE;
                     break;
                  case MapConfiguration.MAP_ROUTE_OVERVIEW:
                     zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM | MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE;
                     break;
                  case MapConfiguration.MAP_FULL:
                  case MapConfiguration.MAP_MEDIA:
                  case MapConfiguration.MAP_HALF_MAP:
                  case MapConfiguration.UNDEFINED:
                  case MapConfiguration.MAP_GARAGE:
                  case MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION:
                  case MapConfiguration.MAP_ZOOM_ROUTE_SEGMENT:
                  case MapConfiguration.MAP_SCROLLING:
                  case MapConfiguration.MAP_FULL:
                  case MapConfiguration.MAP_MEDIA:
                  case MapConfiguration.MAP_HALF_MAP:
                  case MapConfiguration.UNDEFINED:
                  default:
                     zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE;
               }
               elementArray.push(zoomHighlightFunction);
            }
         }
      }
      
      private function addTmCRoute(elementArray:Array) : void
      {
         var i:String = null;
         var routes:Object = NavigationPackage.peripheral.navigation.navigation.tmcManualReRouteAlternatives;
         if(routes == null)
         {
            return;
         }
         var zoomHighlightFunction:Object = new Object();
         var rh:Array = new Array();
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute != null)
         {
            rh.push("<RTH>" + NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute.routeHandle + "<*>");
         }
         if(routes.hasOwnProperty("routeList"))
         {
            for(i in routes.routeList)
            {
               rh.push("<RTH>" + routes.routeList[i] + "<*>");
            }
         }
         if(rh.length > 0)
         {
            zoomHighlightFunction["ITEMS"] = rh;
            switch(this.mParent.mapConfiguration)
            {
               case MapConfiguration.MAP_CONFIRM_TMC_REROUTE:
                  zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM | MapSettingTypes.WORLD_ELEMENT_FUNCTION_ZOOM_ROUTE_DIFFERENCES | MapSettingTypes.WORLD_ELEMENT_FUNCTION_VISIBLE;
                  break;
               case MapConfiguration.MAP_CONFIRM_ROUTE:
               case MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED:
               case MapConfiguration.MAP_ZOOM_TMC:
               case MapConfiguration.MAP_GRAPHICAL_WEATHER:
               case MapConfiguration.MAP_FULL:
               case MapConfiguration.MAP_MEDIA:
               case MapConfiguration.MAP_HALF_MAP:
               case MapConfiguration.UNDEFINED:
               case MapConfiguration.MAP_GARAGE:
               case MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION:
               case MapConfiguration.MAP_ZOOM_ROUTE_SEGMENT:
               case MapConfiguration.MAP_SCROLLING:
               case MapConfiguration.MAP_FULL:
               case MapConfiguration.MAP_MEDIA:
               case MapConfiguration.MAP_HALF_MAP:
               case MapConfiguration.MAP_ROUTE_OVERVIEW:
               case MapConfiguration.UNDEFINED:
               default:
                  zoomHighlightFunction["WEF"] = MapSettingTypes.WORLD_ELEMENT_FUNCTION_HIDE;
            }
            elementArray.push(zoomHighlightFunction);
         }
      }
   }
}

