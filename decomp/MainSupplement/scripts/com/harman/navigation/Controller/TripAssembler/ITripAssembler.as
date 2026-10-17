package com.harman.navigation.Controller.TripAssembler
{
   import com.harman.navigation.enums.RouteMode;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.moduleLinkAPI.IModule;
   
   public interface ITripAssembler extends IModule
   {
      
      function addLocationDescription(param1:LocationDescription) : void;
      
      function setDestinationMode(param1:int) : void;
      
      function get destinationMode() : int;
      
      function setTripAsDestination(param1:Array) : void;
      
      function onBack() : void;
      
      function onClose() : void;
      
      function forceBackToNavMainMenu() : void;
      
      function setSecondaryMode(param1:int) : void;
      
      function getActiveMenu() : void;
      
      function getActiveMenuRepeat() : void;
      
      function get activeMenu() : int;
      
      function switchToMenu(param1:int) : void;
      
      function getDestinations() : void;
      
      function get destinations() : Array;
      
      function getRouteMode() : void;
      
      function get routeMode() : RouteMode;
      
      function setRouteMode(param1:RouteMode, param2:Boolean) : void;
      
      function startGuidance(param1:int, param2:Boolean = true) : void;
      
      function getCalculationProgress() : void;
      
      function get calculationProgress() : int;
      
      function getCalculationFailed() : void;
      
      function get calculationFailed() : Boolean;
      
      function getIsRecalculation() : void;
      
      function get isRecalculation() : Boolean;
      
      function get isAlteringRoute() : Boolean;
      
      function getIsAlteringRoute() : void;
      
      function removeDestinationFromActiveRoute(param1:int) : void;
      
      function enableRoundTrip(param1:Boolean) : void;
      
      function getRoundTripMode() : void;
      
      function get roundTripMode() : Boolean;
      
      function setNewDestinationOrder(param1:Array) : void;
      
      function get lastAddedLocationDescription() : LocationDescription;
      
      function get lastAddedLocationIndex() : int;
      
      function getActiveRouteMode() : void;
      
      function get activeRouteMode() : RouteMode;
      
      function setActiveRouteMode(param1:RouteMode) : void;
      
      function setTrailDestination(param1:int, param2:int) : void;
      
      function getTrailName() : void;
      
      function get trailName() : String;
      
      function calculateTrailRoute() : void;
      
      function positionSelectOnlyDestination() : void;
      
      function positionSelectFirstStopover() : void;
      
      function positionSelectLastStopover() : void;
      
      function positionSelectStopoverIndex(param1:int) : void;
      
      function positionReplaceStopoverIndex(param1:int) : void;
      
      function get positionSelectActiveRoute() : Array;
   }
}

