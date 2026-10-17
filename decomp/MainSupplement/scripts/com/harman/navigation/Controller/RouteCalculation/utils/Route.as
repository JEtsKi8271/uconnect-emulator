package com.harman.navigation.Controller.RouteCalculation.utils
{
   import com.harman.navigation.routeCalculation.Destination;
   import com.harman.navigation.utils.EisHelper;
   import com.nfuzion.framework.global.Framework;
   
   public class Route
   {
      
      private var mRouteHandle:int = -1;
      
      private var mRouteElement:int = -1;
      
      private var mRouteSegment:int = -1;
      
      private var mCalculationState:int = 0;
      
      private var mRouteMode:int = 0;
      
      private var mRouteModeFulfilled:int = 0;
      
      private var mCalculationPercent:int = 0;
      
      private var mDestinations:Array = new Array();
      
      private var mTrailFilePath:String = "";
      
      private var mTrailMode:int = -1;
      
      private var mRouteColor:String = "";
      
      private var mTurnList:TurnList = new TurnList();
      
      private var mAutoStart:Boolean = false;
      
      private var mRouteStopped:Boolean = false;
      
      private var mDeleteOnValidRTH:Boolean = false;
      
      public function Route()
      {
         super();
      }
      
      public function clone(route:Route) : void
      {
         var destination:Destination = null;
         this.mCalculationPercent = route.calculationPercentage;
         this.mCalculationState = route.calculationState;
         this.mTrailFilePath = route.trailFilePath;
         this.mTrailMode = route.trailMode;
         this.mRouteHandle = route.routeHandle;
         this.mRouteColor = route.routeColor;
         this.mRouteMode = route.routeMode;
         this.mRouteModeFulfilled = route.routeModeFulfilled;
         this.mAutoStart = route.mAutoStart;
         this.mRouteStopped = route.mRouteStopped;
         for(var i:int = 0; i < route.Destinations.length; i++)
         {
            destination = new Destination();
            destination.clone(Destination(route.Destinations[i]));
            this.mDestinations.push(destination);
         }
      }
      
      public function setRouteHandle(handle:int) : void
      {
         this.mRouteHandle = handle;
      }
      
      public function get routeHandle() : int
      {
         return this.mRouteHandle;
      }
      
      public function setRouteElement(element:int) : void
      {
         this.mRouteElement = element;
      }
      
      public function get routeElement() : int
      {
         return this.mRouteElement;
      }
      
      public function setRouteSegment(segment:int) : void
      {
         this.mRouteSegment = segment;
      }
      
      public function get routeSegment() : int
      {
         return this.mRouteSegment;
      }
      
      public function setCalculationState(state:int) : void
      {
         this.mCalculationState = state;
      }
      
      public function get calculationState() : int
      {
         return this.mCalculationState;
      }
      
      public function setRouteMode(mode:int) : void
      {
         Framework.Trace("setRouteMode " + mode + " for " + this.routeHandle);
         this.mRouteMode = mode;
      }
      
      public function setRouteModeFulfilled(mode:int) : void
      {
         Framework.Trace(" setRouteModeFulfilled " + mode + " for " + this.routeHandle);
         this.mRouteModeFulfilled = mode;
      }
      
      public function get routeMode() : int
      {
         return this.mRouteMode;
      }
      
      public function get routeModeFulfilled() : int
      {
         return this.mRouteModeFulfilled;
      }
      
      public function setCalculationPercentage(percent:int) : void
      {
         this.mCalculationPercent = percent;
      }
      
      public function get calculationPercentage() : int
      {
         return this.mCalculationPercent;
      }
      
      public function setDestinations(destinations:Array) : void
      {
         var myClone:Destination = null;
         this.mDestinations.splice(0,this.mDestinations.length);
         for(var i:int = 0; i < destinations.length; i++)
         {
            myClone = new Destination();
            myClone.clone(Destination(destinations[i]));
            this.mDestinations.push(myClone);
         }
      }
      
      public function get Destinations() : Array
      {
         return this.mDestinations;
      }
      
      public function setTrailFilePath(path:String) : void
      {
         this.mTrailFilePath = path;
      }
      
      public function get trailFilePath() : String
      {
         return this.mTrailFilePath;
      }
      
      public function setTrailMode(mode:int) : void
      {
         this.mTrailMode = mode;
      }
      
      public function get trailMode() : int
      {
         return this.mTrailMode;
      }
      
      public function setRouteColor(color:String) : void
      {
         this.mRouteColor = color;
      }
      
      public function get routeColor() : String
      {
         return this.mRouteColor;
      }
      
      public function setAutoStart(setAuto:Boolean) : void
      {
         this.mAutoStart = setAuto;
      }
      
      public function get autoStartEnabled() : Boolean
      {
         return this.mAutoStart;
      }
      
      public function setRouteStopped(stopped:Boolean) : void
      {
         this.mRouteStopped = stopped;
      }
      
      public function get routeStopped() : Boolean
      {
         return this.mRouteStopped;
      }
      
      public function setDeleteRouteOnValidRouteHandleAvailable(deleteRoute:Boolean) : void
      {
         this.mDeleteOnValidRTH = deleteRoute;
      }
      
      public function get deleteRouteOnValidRouteHandleAvailable() : Boolean
      {
         return this.mDeleteOnValidRTH;
      }
      
      public function setTravelInfos(itemList:Array) : void
      {
         for(var i:int = 0; i < itemList.length; i++)
         {
            if(this.mDestinations.length > i)
            {
               Destination(this.mDestinations[i]).setTravelInfos(int(EisHelper.getValueOfType(String(itemList[i]),"<RRD>")),int(EisHelper.getValueOfType(String(itemList[i]),"<AID>")),int(EisHelper.getValueOfType(String(itemList[i]),"<TRT>")));
            }
         }
      }
      
      public function setRouteOptions(itemList:Array) : void
      {
         this.mRouteModeFulfilled = int(EisHelper.getValueOfType(String(itemList[0]),"<RTO>"));
         Framework.Trace("VL: setRouteOptions (RouteModeFulfilled:" + this.mRouteModeFulfilled + " RouteMode:" + this.mRouteMode + ") for RTH " + this.routeHandle);
         for(var i:int = 0; i < itemList.length; i++)
         {
            if(this.mDestinations.length > i)
            {
               Destination(this.mDestinations[i]).setRouteOptions(String(itemList[i]));
            }
         }
      }
      
      public function getRealRoadDistanceUpToRouteElementIndex(routeElementIndex:int) : int
      {
         var distance:int = 0;
         var i:int = 0;
         while(i <= routeElementIndex && i < this.mDestinations.length)
         {
            distance += Destination(this.mDestinations[i]).realRoadDistance;
            i++;
         }
         return distance;
      }
      
      public function updateTurnList(routeSegments:Array) : void
      {
         Framework.Trace("Route.setRouteSegments() Received a complete turnlist update ( " + routeSegments.length + " )");
         this.mTurnList.setTurnList(routeSegments);
         this.mTurnList.setTurnListUpdatePending(false);
      }
      
      public function purgeTurnList() : void
      {
         this.mTurnList.setTurnList(new Array());
         this.mTurnList.setTurnListUpdatePending(true);
      }
      
      public function getTurnList() : TurnList
      {
         return this.mTurnList;
      }
      
      public function setTurnListUpdatePending(pending:Boolean) : void
      {
         this.mTurnList.setTurnListUpdatePending(pending);
      }
      
      public function get turnListUpdatePending() : Boolean
      {
         return this.mTurnList.turnListUpdatePending;
      }
      
      public function get routeTravelInfo() : String
      {
         var rrd:int = 0;
         var trt:int = 0;
         for(var i:int = 0; i < this.mDestinations.length; i++)
         {
            rrd += Destination(this.mDestinations[i]).realRoadDistance;
            trt += Destination(this.mDestinations[i]).travelTime;
         }
         return String("<RRD>" + rrd + "<*><TRT>" + trt + "<*>");
      }
      
      public function get avoidanceTypesOnRoute() : int
      {
         var types:int = 0;
         for(var i:int = 0; i < this.mDestinations.length; i++)
         {
            types |= int(EisHelper.getValueOfType(Destination(this.mDestinations[i]).routeOptions,"<RAT>"));
         }
         return types;
      }
   }
}

