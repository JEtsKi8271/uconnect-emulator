package com.harman.navigation.Controller.RouteCalculation
{
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.utils.GuidanceInfo;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface IRouteCalculation extends IModule
   {
      
      function createNewTrip(param1:TripRoute, param2:Boolean) : int;
      
      function createNewTripTrail(param1:TripRoute) : int;
      
      function get trips() : Array;
      
      function get lastPlannedTrip() : TripRoute;
      
      function destroyTrips() : int;
      
      function killRoute() : void;
      
      function killFinishedRoute() : void;
      
      function startGuidance(param1:int, param2:Boolean, param3:int = -1) : int;
      
      function get lastCreatedTripRoute() : TripRoute;
      
      function getNewTripRealRoadDistance(param1:int) : int;
      
      function changeTrip(param1:int, param2:String) : void;
      
      function getNewRouteCalculationState() : void;
      
      function get newRouteCalculationPercentage() : int;
      
      function setRouteColorForRouteHandle(param1:Array) : void;
      
      function getActiveRouteCalculationState() : void;
      
      function get activeRouteCalculationState() : int;
      
      function getActiveRouteGuidanceState() : void;
      
      function get activeRouteGuidanceState() : Boolean;
      
      function get activeRoute() : Route;
      
      function getTurnList() : void;
      
      function get turnList() : Object;
      
      function stopGuidance() : int;
      
      function get reachedDestination() : LocationDescription;
      
      function get isKillTrip() : Boolean;
      
      function set isKillTrip(param1:Boolean) : void;
      
      function getDestReached() : void;
      
      function getGuidanceInfo() : void;
      
      function get guidanceInfo() : GuidanceInfo;
      
      function blockRouteSegmentManeuver(param1:int, param2:int) : int;
      
      function blockRouteAhead(param1:int) : int;
      
      function get distanceToFinalDestination() : int;
      
      function startTmcRelatedReroute(param1:int) : void;
      
      function killRejectedTmcReroute(param1:int) : void;
      
      function getRgActiveRouteTravelTime() : int;
      
      function getRgActiveRouteDistance() : int;
      
      function getRgTmcAlternativeRouteDistance() : int;
      
      function getRgTmcAlternativeRouteTravelTime() : int;
   }
}

