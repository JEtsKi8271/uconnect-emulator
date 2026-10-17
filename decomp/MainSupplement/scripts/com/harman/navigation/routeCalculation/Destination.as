package com.harman.navigation.routeCalculation
{
   import com.harman.navigation.utils.LocationDescription;
   
   public class Destination
   {
      
      private var mHardDestination:LocationDescription = new LocationDescription();
      
      private var mSoftDestinations:Array = new Array();
      
      private var mDistanceRealRoad:int = 0;
      
      private var mDistanceAir:int = 0;
      
      private var mTravelTime:int = 0;
      
      private var mRouteOptions:String = "";
      
      public function Destination()
      {
         super();
      }
      
      public function clone(destination:Destination) : void
      {
         var softDest:LocationDescription = null;
         this.mHardDestination.clone(destination.hardDestination);
         for(var i:int = 0; i < destination.softDestinations.length; i++)
         {
            softDest = new LocationDescription();
            softDest.clone(destination.softDestinations[i]);
         }
         this.mDistanceRealRoad = destination.realRoadDistance;
         this.mDistanceAir = destination.airDistance;
         this.mTravelTime = destination.travelTime;
      }
      
      public function get hardDestination() : LocationDescription
      {
         return this.mHardDestination;
      }
      
      public function get softDestinations() : Array
      {
         return this.mSoftDestinations;
      }
      
      public function setHardDestination(hardLoc:LocationDescription) : void
      {
         this.mHardDestination = hardLoc;
      }
      
      public function addSoftDestination(softDest:LocationDescription) : void
      {
         this.mSoftDestinations.push(softDest);
      }
      
      public function addSoftDestinationAtPosition(softDest:LocationDescription, pos:int) : void
      {
         this.mSoftDestinations.splice(pos,0,softDest);
      }
      
      public function removeSoftDestination(pos:int) : void
      {
         this.mSoftDestinations.splice(pos,1);
      }
      
      public function toEisString() : String
      {
         var i:int = 0;
         var erg:String = "{\"hard\":\"";
         erg += this.mHardDestination.getSecondaryLocation().toEIS().split("\"").join("\\\"");
         erg += "\"";
         if(this.mSoftDestinations.length > 0)
         {
            erg += ",\"soft\":[";
            for(i = 0; i < this.mSoftDestinations.length; i++)
            {
               if(i > 0)
               {
                  erg += ",";
               }
               erg += LocationDescription(this.mSoftDestinations[i]).getSecondaryLocation().toEIS().split("\"").join("\\\"");
            }
            erg += "]";
         }
         return erg + "}";
      }
      
      public function setTravelInfos(rrd:int, aid:int, trt:int) : void
      {
         this.mDistanceRealRoad = rrd;
         this.mDistanceAir = aid;
         this.mTravelTime = trt;
      }
      
      public function get airDistance() : int
      {
         return this.mDistanceAir;
      }
      
      public function get realRoadDistance() : int
      {
         return this.mDistanceRealRoad;
      }
      
      public function get travelTime() : int
      {
         return this.mTravelTime;
      }
      
      public function setRouteOptions(routeOptions:String) : void
      {
         this.mRouteOptions = routeOptions;
      }
      
      public function get routeOptions() : String
      {
         return this.mRouteOptions;
      }
      
      public function toString() : String
      {
         var ret:String = "";
         ret += "Primary: " + this.mHardDestination.getPrimaryLocation().toEIS() + "\n";
         ret += "Secondy: " + this.mHardDestination.getSecondaryLocation().toEIS() + "\n";
         ret += " RRD: " + this.mDistanceRealRoad;
         ret += " AID: " + this.mDistanceAir;
         return ret + (" TRT: " + this.mTravelTime);
      }
   }
}

