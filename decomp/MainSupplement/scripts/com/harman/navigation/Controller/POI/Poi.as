package com.harman.navigation.Controller.POI
{
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationApi;
   import com.harman.navigation.enums.PoiSearchArea;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.*;
   import com.harman.navigation.routeCalculation.Destination;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   
   public class Poi extends PoiSearchResult
   {
      
      private static var CALCULATOR:VServiceDistanceCalculator;
      
      private var _primaryDetails:LocationDetails;
      
      private var _secondaryDetails:LocationDetails;
      
      public function Poi()
      {
         super();
      }
      
      private static function get calculator() : VServiceDistanceCalculator
      {
         if(CALCULATOR == null)
         {
            CALCULATOR = new VServiceDistanceCalculator();
         }
         return CALCULATOR;
      }
      
      public static function fromPrimaryDetails(details:LocationDetails) : Poi
      {
         var poi:Poi = new Poi();
         poi._primaryDetails = details;
         return poi;
      }
      
      public static function geoStringToLatLong(geoStr:String) : Array
      {
         return [Number(geoStr.substring(geoStr.indexOf(" ") + 1,geoStr.length - 1)),Number(geoStr.substring(0,geoStr.indexOf(" ")))];
      }
      
      public function compareDistanceTo(poi2:Poi) : int
      {
         var dist1:Number = this.distanceCurrentUnits;
         var dist2:Number = poi2.distanceCurrentUnits;
         if(dist1 < dist2)
         {
            return -1;
         }
         if(dist1 > dist2)
         {
            return 1;
         }
         return 0;
      }
      
      public function get locationDescription() : LocationDescription
      {
         var ld:LocationDescription = new LocationDescription();
         ld.setPrimaryLocation(this._primaryDetails);
         ld.setSecondaryLocation(this._secondaryDetails);
         return ld;
      }
      
      override public function get label() : String
      {
         return this._primaryDetails.getType("<POI>");
      }
      
      public function get primaryDetails() : LocationDetails
      {
         return this._primaryDetails;
      }
      
      public function get secondaryDetails() : LocationDetails
      {
         return this._secondaryDetails;
      }
      
      public function set secondaryDetails(val:LocationDetails) : void
      {
         this._secondaryDetails = val;
      }
      
      public function get address() : String
      {
         return this._primaryDetails.getType("<REF>");
      }
      
      public function get position() : String
      {
         return this._primaryDetails.getType("<GEO>");
      }
      
      public function get distanceString() : String
      {
         var locDetOfSearchCity:LocationDetails = null;
         var locOfDestination:LocationDetails = null;
         if(NavigationPackage.peripheral.navigation.navPoiInput.poiSearchAreaCurrent == PoiSearchArea.IN_A_CITY)
         {
            locDetOfSearchCity = NavigationPackage.peripheral.navigation.navPoiInput.poiSearchCity.getSecondaryLocation();
            return calculator.getDistanceBetweenTwoLocations(locDetOfSearchCity.getType("<GEO>"),this.position);
         }
         if(NavigationPackage.peripheral.navigation.navPoiInput.poiSearchAreaCurrent == PoiSearchArea.NEAR_DESTINATION)
         {
            locOfDestination = Destination(RouteCalculationApi.api.activeRoute.Destinations[RouteCalculationApi.api.activeRoute.Destinations.length - 1]).hardDestination.getSecondaryLocation();
            return calculator.getDistanceBetweenTwoLocations(locOfDestination.getType("<GEO>"),this.position);
         }
         return calculator.getDistanceToPositionString(this.position);
      }
      
      public function get distanceCurrentUnits() : Number
      {
         var locDetOfSearchCity:LocationDetails = null;
         var locOfDestination:LocationDetails = null;
         if(NavigationPackage.peripheral.navigation.navPoiInput.poiSearchAreaCurrent == PoiSearchArea.IN_A_CITY)
         {
            locDetOfSearchCity = NavigationPackage.peripheral.navigation.navPoiInput.poiSearchCity.getSecondaryLocation();
            return calculator.getDistanceBetweenTwoLocationsNum(locDetOfSearchCity.getType("<GEO>"),this.position);
         }
         if(NavigationPackage.peripheral.navigation.navPoiInput.poiSearchAreaCurrent == PoiSearchArea.NEAR_DESTINATION)
         {
            locOfDestination = Destination(RouteCalculationApi.api.activeRoute.Destinations[RouteCalculationApi.api.activeRoute.Destinations.length - 1]).hardDestination.getSecondaryLocation();
            return calculator.getDistanceBetweenTwoLocationsNum(locOfDestination.getType("<GEO>"),this.position);
         }
         return calculator.getDistanceToPosition(this.position);
      }
      
      public function get directionTo() : int
      {
         var srcLatLon:Array = null;
         var destLatLon:Array = null;
         var relPosition:int = 0;
         var distance_VP_DEST:Number = NaN;
         var compareLatitude:Number = NaN;
         var compareLongitude:Number = NaN;
         var distance_CP_VP:Number = NaN;
         var distance_CP_DEST:Number = NaN;
         var vehicleDirectionNew:Number = NaN;
         var angle:Number = NaN;
         if(NavigationPackage.peripheral.navigation.navPoiInput.poiSearchAreaCurrent == PoiSearchArea.IN_A_CITY || NavigationPackage.peripheral.navigation.navPoiInput.poiSearchAreaCurrent == PoiSearchArea.NEAR_DESTINATION)
         {
            return undefined;
         }
         srcLatLon = geoStringToLatLong(NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<GEO>"));
         destLatLon = geoStringToLatLong(this.position);
         relPosition = VServiceDirectionTracker.getRelativePosition(srcLatLon[0],srcLatLon[1],destLatLon[0],destLatLon[1]);
         distance_VP_DEST = Math.sqrt(Math.pow(destLatLon[0] - srcLatLon[0],2) + Math.pow(destLatLon[1] - srcLatLon[1],2));
         compareLatitude = srcLatLon[0] + distance_VP_DEST;
         compareLongitude = Number(srcLatLon[1]);
         distance_CP_VP = compareLatitude - srcLatLon[0];
         distance_CP_DEST = Math.sqrt(Math.pow(destLatLon[0] - compareLatitude,2) + Math.pow(destLatLon[1] - compareLongitude,2));
         vehicleDirectionNew = Number(NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<DIR>")) / 255 * 360;
         angle = VServiceDirectionTracker.calcDestinationDirection(relPosition,vehicleDirectionNew,VServiceDirectionTracker.calcAngleC(distance_CP_VP,distance_VP_DEST,distance_CP_DEST));
         return VServiceDistanceListController.getImageIdForAngle(angle);
      }
   }
}

