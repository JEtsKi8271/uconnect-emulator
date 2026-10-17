package com.harman.navigation.Controller.RouteCalculation.utils
{
   import com.harman.navigation.enums.RouteCalculationState;
   import com.harman.navigation.enums.RouteMode;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.routeCalculation.Destination;
   import com.nfuzion.framework.global.Framework;
   
   public class TripRoute
   {
      
      private static var mDemoModeEnabled:Boolean = false;
      
      private var mID:uint = 0;
      
      private var mDestinationsArray:Array = new Array();
      
      private var mRouteModesArray:Array = new Array();
      
      private var mRoutesArray:Array = new Array();
      
      private var mMarkRoutesOnValidRouteHandleForDestruction:Boolean = false;
      
      private var mCalculationPercentage:int = 0;
      
      private var mTrailPath:String = "";
      
      private var mTrailMode:int = RouteMode.TRAIL_GUIDANCE;
      
      private var mAutoStart:Boolean = false;
      
      public function TripRoute()
      {
         super();
         mDemoModeEnabled = NavigationPackage.peripheral.navigation.navigation.navDemoMode;
      }
      
      public function setTripID(ID:int) : void
      {
         this.mID = ID;
      }
      
      public function get ID() : int
      {
         return this.mID;
      }
      
      public function addDestination(dest:Destination) : void
      {
         this.mDestinationsArray.push(dest);
      }
      
      public function addDestinationAtPosition(dest:Destination, pos:int) : void
      {
         this.mDestinationsArray.splice(pos,0,dest);
      }
      
      public function get Destinations() : Array
      {
         return this.mDestinationsArray;
      }
      
      public function setRouteModes(modesArray:Array) : void
      {
         this.mRouteModesArray = modesArray;
      }
      
      public function get RouteModes() : Array
      {
         return this.mRouteModesArray;
      }
      
      public function setTrailPath(trailPath:String) : void
      {
         this.mTrailPath = trailPath;
      }
      
      public function get trailPath() : String
      {
         return this.mTrailPath;
      }
      
      public function setTrailMode(trailMode:int) : void
      {
         this.mTrailMode = trailMode;
      }
      
      public function get trailMode() : int
      {
         return this.mTrailMode;
      }
      
      public function setAutoStart(autoStart:Boolean) : void
      {
         this.mAutoStart = autoStart;
      }
      
      public function get autoStart() : Boolean
      {
         return this.mAutoStart;
      }
      
      public function addRouteHandle(rth:int) : void
      {
         for(var i:int = 0; i < this.mRoutesArray.length; i++)
         {
            if(Route(this.mRoutesArray[i]).routeHandle == rth)
            {
               return;
            }
         }
         var newRoute:Route = new Route();
         newRoute.setRouteHandle(rth);
         newRoute.setDestinations(this.mDestinationsArray);
         newRoute.setTrailFilePath(this.mTrailPath);
         newRoute.setTrailMode(this.mTrailMode);
         if(this.mAutoStart)
         {
            newRoute.setAutoStart(true);
            if(this.trailPath == "")
            {
               newRoute.setRouteMode(RouteMode(this.RouteModes[0]).routeMode);
            }
         }
         this.mRoutesArray.push(newRoute);
         if(this.mMarkRoutesOnValidRouteHandleForDestruction)
         {
            Framework.Trace("TripRoute(" + this.mID + ") is marked for immediate destruction.");
         }
      }
      
      public function markRoutesOnValidRouteHandleForDestruction(mark:Boolean) : void
      {
         this.mMarkRoutesOnValidRouteHandleForDestruction = mark;
      }
      
      public function get routesOnValidRouteHandleMarkedForDestruction() : Boolean
      {
         return this.mMarkRoutesOnValidRouteHandleForDestruction;
      }
      
      public function getRouteForRouteHandle(rth:int) : Route
      {
         for(var i:int = 0; i < this.mRoutesArray.length; i++)
         {
            if(Route(this.mRoutesArray[i]).routeHandle == rth)
            {
               return Route(this.mRoutesArray[i]);
            }
         }
         return null;
      }
      
      public function deleteRouteByRouteHandle(rth:int) : Boolean
      {
         for(var i:int = 0; i < this.mRoutesArray.length; i++)
         {
            if(Route(this.mRoutesArray[i]).routeHandle == rth)
            {
               this.mRoutesArray.splice(i,1);
               return true;
            }
         }
         return false;
      }
      
      public function get routes() : Array
      {
         return this.mRoutesArray;
      }
      
      public function calculateRouteCalculationPercentage() : void
      {
         var i:int = 0;
         this.mCalculationPercentage = 0;
         if(this.mRoutesArray.length > 0)
         {
            for(i = 0; i < this.mRoutesArray.length; i++)
            {
               switch(Route(this.mRoutesArray[i]).calculationState)
               {
                  case RouteCalculationState.Planning:
                  case RouteCalculationState.Planned:
                     this.mCalculationPercentage += Route(this.mRoutesArray[i]).calculationPercentage / 2;
                     break;
                  case RouteCalculationState.Calculating:
                     this.mCalculationPercentage += Route(this.mRoutesArray[i]).calculationPercentage;
                     if(this.mCalculationPercentage < 50)
                     {
                        this.mCalculationPercentage = 50;
                     }
                     break;
                  case RouteCalculationState.Calculated:
                     this.mCalculationPercentage += 100;
               }
            }
            this.mCalculationPercentage /= this.mRoutesArray.length;
         }
      }
      
      public function get calculationPercentage() : int
      {
         return this.mCalculationPercentage;
      }
      
      public function toEisString() : String
      {
         var i:int = 0;
         var erg:String = "{\"destinations\":[";
         for(i = 0; i < this.mDestinationsArray.length; i++)
         {
            if(i > 0)
            {
               erg += ",";
            }
            erg += Destination(this.mDestinationsArray[i]).toEisString();
         }
         erg += "], \"routeOptions\":[";
         for(i = 0; i < this.mRouteModesArray.length; i++)
         {
            if(i > 0)
            {
               erg += ",";
            }
            erg += RouteMode(this.mRouteModesArray[i]).routeMode;
         }
         return erg + "]}";
      }
   }
}

