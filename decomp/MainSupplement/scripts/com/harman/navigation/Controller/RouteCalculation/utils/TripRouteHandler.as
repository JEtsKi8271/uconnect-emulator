package com.harman.navigation.Controller.RouteCalculation.utils
{
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculation;
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_BlockRouteSegment;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_RouteElementInfo;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_RouteOptions;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_StartGuidance;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_StopGuidance;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_TripDestroy;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_TurnList;
   import com.harman.navigation.enums.RouteCalculationState;
   import com.harman.navigation.enums.RouteMode;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.routeCalculation.Destination;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.GuidanceInfo;
   import com.harman.navigation.utils.LocationDescription;
   import com.harman.navigation.utils.LocationDetails;
   import com.harman.navigation.utils.NavGateKeeper;
   import com.harman.navigation.utils.TurnListElement;
   import com.nfuzion.framework.global.Framework;
   
   public class TripRouteHandler
   {
      
      private var mTrips:Array = new Array();
      
      private var mRouteCalculation:RouteCalculation;
      
      private var mActiveRoute:Route = null;
      
      private var mReachedDestinationInfo:Object = null;
      
      private var mReachedDestination:LocationDescription = null;
      
      private var mPreviouslyStoppedRoute:Route = new Route();
      
      private var mGuidanceInfo:GuidanceInfo = new GuidanceInfo();
      
      private var mIsKillTrip:Boolean = false;
      
      private var mGatekeeper:NavGateKeeper = new NavGateKeeper(VServiceGlobalSettings.HMI_DISPATCH_TIMEOUT);
      
      public function TripRouteHandler(rc:RouteCalculation)
      {
         super();
         this.mRouteCalculation = rc;
      }
      
      public function addTripRoute(tripRoute:TripRoute) : void
      {
         this.mTrips.push(tripRoute);
      }
      
      public function get tripRoutes() : Array
      {
         return this.mTrips;
      }
      
      public function updateRouteHandlesByTripID(id:uint, data:Object) : Boolean
      {
         var j:int = 0;
         for(var i:int = 0; i < this.mTrips.length; i++)
         {
            if(id == TripRoute(this.mTrips[i]).ID)
            {
               if(data.hasOwnProperty("handles"))
               {
                  for(j = 0; j < (data.handles as Array).length; j++)
                  {
                     TripRoute(this.mTrips[i]).addRouteHandle(int(data.handles[j]));
                  }
               }
               return true;
            }
         }
         return false;
      }
      
      public function deleteTripRouteByID(id:int) : Boolean
      {
         for(var i:int = 0; i < this.mTrips.length; i++)
         {
            if(id == TripRoute(this.mTrips[i]).ID)
            {
               this.mTrips.splice(i,1);
               return true;
            }
         }
         return false;
      }
      
      public function deleteRoutesByRouteHandle(handles:Object) : void
      {
         var j:int = 0;
         var rth:String = null;
         if(this.mActiveRoute != null)
         {
            for(j = 0; j < (handles as Array).length; j++)
            {
               if(this.mActiveRoute.routeHandle == int((handles as Array)[j]))
               {
                  this.mActiveRoute = null;
                  this.mGuidanceInfo.reset();
                  this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE);
               }
            }
         }
         for(var i:int = 0; i < this.mTrips.length; i++)
         {
            if(TripRoute(this.mTrips[i]).routes.length > 0)
            {
               for(rth in handles)
               {
                  if(TripRoute(this.mTrips[i]).deleteRouteByRouteHandle(handles[rth]))
                  {
                  }
               }
               if(TripRoute(this.mTrips[i]).routes.length == 0)
               {
                  Framework.Trace("Destroying an empty TripRoute.");
                  this.mTrips.splice(i,0);
               }
            }
         }
         switch(this.mRouteCalculation.taskHandler.activeTaskType)
         {
            case RC_Task.TRIP_PLANNED_DESTROY_ALL:
               this.mRouteCalculation.taskHandler.reportTaskCompletion(RC_Task.TRIP_PLANNED_DESTROY_ALL);
               break;
            case RC_Task.TRIP_DESTROY:
               this.mRouteCalculation.taskHandler.reportTaskCompletion(RC_Task.TRIP_DESTROY);
         }
      }
      
      public function updateCalculationState(data:Object) : Boolean
      {
         var rteTask:RC_Task_TurnList = null;
         var newTaskDestroy:RC_Task_TripDestroy = null;
         var route:Route = null;
         var newTask:RC_Task_StartGuidance = null;
         if(this.mActiveRoute != null && (this.mActiveRoute.routeHandle == data.routeHandle || data.calcState == RouteCalculationState.Routing))
         {
            if(this.mActiveRoute.routeHandle > data.routeHandle)
            {
               Framework.Trace(" -A route is supposedly active, which should not exist anymore. Let\'s pretend we did not see this...");
               return false;
            }
            if(this.mActiveRoute.routeHandle != data.routeHandle && data.calcState == RouteCalculationState.Routing)
            {
               Framework.Trace(" -Received new active routeHandle! (" + this.mActiveRoute.routeHandle + " -> " + data.routeHandle + ")");
               this.mActiveRoute.setRouteHandle(data.routeHandle);
            }
            this.checkDestinationInfoRequest(data.routeHandle,this.mActiveRoute.calculationState,data.calcState);
            this.mActiveRoute.setCalculationState(int(data.calcState));
            switch(int(data.calcState))
            {
               case RouteCalculationState.Calculating:
                  this.mActiveRoute.purgeTurnList();
                  break;
               case RouteCalculationState.Routing:
                  rteTask = new RC_Task_TurnList(int(data.routeHandle));
                  rteTask.addToTaskHandler();
                  break;
               case RouteCalculationState.Routed:
                  Framework.Trace("Route " + int(data.routeHandle) + " == Routed");
                  newTaskDestroy = new RC_Task_TripDestroy(int(data.routeHandle));
                  newTaskDestroy.addToTaskHandler();
                  this.mPreviouslyStoppedRoute.clone(this.mActiveRoute);
                  break;
               case RouteCalculationState.Failed:
                  Framework.Trace("Route " + int(data.routeHandle) + " == Failed !");
                  this.mRouteCalculation.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED);
            }
            this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_CALCULATION_STATE);
            return true;
         }
         for(var i:int = 0; i < this.mTrips.length; i++)
         {
            route = TripRoute(this.mTrips[i]).getRouteForRouteHandle(data.routeHandle);
            if(route != null)
            {
               this.checkDestinationInfoRequest(data.routeHandle,route.calculationState,data.calcState);
               route.setCalculationState(data.calcState);
               route.setCalculationPercentage(data.calcPercent);
               if(route.calculationState == RouteCalculationState.Planned && route.autoStartEnabled)
               {
                  route.setAutoStart(false);
                  newTask = new RC_Task_StartGuidance(route.routeHandle);
                  newTask.addToTaskHandler();
               }
               TripRoute(this.mTrips[i]).calculateRouteCalculationPercentage();
               this.mRouteCalculation.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE);
               if(data.calcState == RouteCalculationState.Failed)
               {
                  Framework.Trace("RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED");
                  this.mRouteCalculation.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED);
               }
               return true;
            }
         }
         if(data.calcState == RouteCalculationState.Failed)
         {
            Framework.Trace("RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED");
            this.mRouteCalculation.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED);
         }
         return false;
      }
      
      public function get newRouteCalculationPercentage() : int
      {
         if(this.mTrips.length)
         {
            return TripRoute(this.mTrips[this.mTrips.length - 1]).calculationPercentage;
         }
         return 0;
      }
      
      public function getNewRouteRealRoadDistance(routeElementIndex:int) : int
      {
         if(this.mTrips.length)
         {
            if(TripRoute(this.mTrips[this.mTrips.length - 1]).routes.length >= 1)
            {
               return Route(TripRoute(this.mTrips[this.mTrips.length - 1]).routes[0]).getRealRoadDistanceUpToRouteElementIndex(routeElementIndex);
            }
            Framework.Trace("TripRouteHandler.getNewRouteRealRoadDistance() No TripRoute available. (" + routeElementIndex + ")");
            return 0;
         }
         return 0;
      }
      
      public function updateRouteElementInfo(data:Object) : void
      {
         var rth:String = null;
         var route:Route = null;
         if(data != null && data.hasOwnProperty("respEIS"))
         {
            rth = EisHelper.getValueOfType(data["respEIS"],"<RTH>");
            if(rth != "")
            {
               route = this.findRouteByRouteHandle(int(rth));
               if(route != null)
               {
                  if(data.hasOwnProperty("itemList"))
                  {
                     route.setTravelInfos(data["itemList"]);
                  }
               }
               else
               {
                  Framework.Trace("TripRouteHandler.updateRouteElementInfo() Route not found (" + rth + ")");
               }
            }
            else
            {
               Framework.Trace("TripRouteHandler.updateRouteElementInfo() routeHandle not recognized (" + data["respEIS"] + ")");
            }
         }
      }
      
      public function updateRouteOptionsInfo(data:Object) : void
      {
         var rth:String = null;
         var route:Route = null;
         var tripRoute:TripRoute = null;
         var i:int = 0;
         if(data != null && data.hasOwnProperty("respEIS"))
         {
            rth = EisHelper.getValueOfType(data["respEIS"],"<RTH>");
            if(rth != "")
            {
               route = this.findRouteByRouteHandle(int(rth));
               tripRoute = this.findTripRouteByRouteHandle(int(rth));
               if(route != null)
               {
                  if(data.hasOwnProperty("itemList"))
                  {
                     route.setRouteOptions(data["itemList"]);
                     if(this.mActiveRoute != null && route.routeHandle == this.mActiveRoute.routeHandle)
                     {
                        route.setRouteMode(RouteMode(NavigationPackage.peripheral.navigation.navTripAssembler.routeMode).routeMode);
                     }
                  }
                  if(tripRoute != null)
                  {
                     for(i = 0; i < tripRoute.RouteModes.length; i++)
                     {
                        if(route.routeModeFulfilled & RouteMode.ROUTE_FASTEST)
                        {
                           if(RouteMode(tripRoute.RouteModes[i]).routeMode & RouteMode.ROUTE_FASTEST)
                           {
                              route.setRouteMode(RouteMode(tripRoute.RouteModes[i]).routeMode);
                           }
                        }
                        else if(route.routeModeFulfilled & RouteMode.ROUTE_SHORTEST)
                        {
                           if(RouteMode(tripRoute.RouteModes[i]).routeMode & RouteMode.ROUTE_SHORTEST)
                           {
                              route.setRouteMode(RouteMode(tripRoute.RouteModes[i]).routeMode);
                           }
                        }
                        else if(route.routeModeFulfilled & RouteMode.ROUTE_SCENIC)
                        {
                           if(RouteMode(tripRoute.RouteModes[i]).routeMode & RouteMode.ROUTE_SCENIC)
                           {
                              route.setRouteMode(RouteMode(tripRoute.RouteModes[i]).routeMode);
                           }
                        }
                        else if(route.routeModeFulfilled & RouteMode.ROUTE_ECO)
                        {
                           if(RouteMode(tripRoute.RouteModes[i]).routeMode & RouteMode.ROUTE_ECO)
                           {
                              route.setRouteMode(RouteMode(tripRoute.RouteModes[i]).routeMode);
                           }
                        }
                     }
                  }
               }
               else
               {
                  Framework.Trace("TripRouteHandler.updateRouteElementInfo() routeHandle not recognized (" + data["respEIS"] + ")");
               }
            }
            else
            {
               Framework.Trace("TripRouteHandler.updateRouteElementInfo() we got route options but no route handle (" + data["respEIS"] + ")");
            }
         }
      }
      
      public function findRouteByRouteHandle(routeHandle:int) : Route
      {
         if(this.mActiveRoute != null)
         {
            if(this.mActiveRoute.routeHandle == routeHandle)
            {
               return this.mActiveRoute;
            }
         }
         var route:Route = null;
         for(var i:int = 0; i < this.mTrips.length; i++)
         {
            route = TripRoute(this.mTrips[i]).getRouteForRouteHandle(routeHandle);
            if(route != null)
            {
               return route;
            }
         }
         return null;
      }
      
      public function findTripRouteByRouteHandle(routeHandle:int) : TripRoute
      {
         for(var i:int = 0; i < this.mTrips.length; i++)
         {
            if(TripRoute(this.mTrips[i]).getRouteForRouteHandle(routeHandle) != null)
            {
               return this.mTrips[i];
            }
         }
         return null;
      }
      
      public function reportGuidanceStart(data:Object) : void
      {
         var j:* = 0;
         var task:RC_Task_TripDestroy = null;
         this.mActiveRoute = this.findRouteByRouteHandle(data.routeHandle);
         for(var i:int = 0; i < this.mTrips.length; i++)
         {
            if(TripRoute(this.mTrips[i]).getRouteForRouteHandle(int(data.routeHandle)) != null)
            {
               for(j = 0; j < TripRoute(this.mTrips[i]).routes.length; j++)
               {
                  if(Route(TripRoute(this.mTrips[i]).routes[j]).routeHandle != int(data.routeHandle))
                  {
                     task = new RC_Task_TripDestroy(Route(TripRoute(this.mTrips[i]).routes[j]).routeHandle);
                     task.addToTaskHandler();
                  }
                  else
                  {
                     TripRoute(this.mTrips[i]).routes.splice(j,1);
                     j--;
                  }
               }
               if(TripRoute(this.mTrips[i]).routes.length == 0)
               {
                  this.mTrips.splice(i,1);
               }
            }
         }
         this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE);
         if(this.mActiveRoute != null)
         {
         }
      }
      
      public function updateActiveRouteDescription(data:Object) : void
      {
         var rteTask:RC_Task_TurnList = null;
         var rteTask1:RC_Task_TurnList = null;
         if(this.mActiveRoute != null)
         {
            if(this.mActiveRoute.routeHandle == int(data.handle))
            {
               if(int(this.mActiveRoute.routeElement) == -1 && int(this.mActiveRoute.routeSegment) == -1)
               {
                  if(int(data.handle) != -1 && int(data.element) != -1)
                  {
                     this.mActiveRoute.purgeTurnList();
                     rteTask = new RC_Task_TurnList(int(data.handle));
                     rteTask.addToTaskHandler();
                  }
               }
               this.mActiveRoute.setRouteHandle(int(data.handle));
               if(Boolean(int(data.handle) != -1) && Boolean(int(data.element == -1)) && int(data.segment) == -1)
               {
                  Framework.Trace(" -TripRouteHandler.updateActiveRouteDescription()RouteElement-Overide!");
                  this.mActiveRoute.setRouteElement(1);
                  this.mActiveRoute.purgeTurnList();
                  rteTask1 = new RC_Task_TurnList(int(data.handle));
                  rteTask1.addToTaskHandler();
               }
               else
               {
                  this.mActiveRoute.setRouteElement(int(data.element));
               }
               this.mActiveRoute.setRouteSegment(int(data.segment));
            }
            else if(int(data.handle) == -1)
            {
               if(this.mActiveRoute.calculationState <= RouteCalculationState.Calculated)
               {
                  Framework.Trace(" TripRouteHandler.updateActiveRouteDescription() -Ignored Stopped Route!");
               }
               else
               {
                  Framework.Trace(" TripRouteHandler.updateActiveRouteDescription() -Route Stopped!");
                  this.mActiveRoute = null;
                  this.mGuidanceInfo.reset();
               }
            }
            this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE);
         }
         else
         {
            Framework.Trace("TripRouteHandler.updateActiveRouteDescription() Description does not match active RouteHandle " + int(data.handle) + " " + (this.mActiveRoute != null ? this.mActiveRoute.routeHandle : "null"));
         }
         if(int(data.handle) == -1 && int(data.element) == -1 && int(data.segment) == -1)
         {
            this.mRouteCalculation.taskHandler.reportTaskCompletion(RC_Task.GUIDANCE_STOP);
         }
      }
      
      public function updateTurnList(data:Object) : void
      {
         var rth:int = 0;
         var route:Route = null;
         if(data != null && data.hasOwnProperty("respEIS"))
         {
            rth = int(EisHelper.getValueOfType(String(data["respEIS"]),"<RTH>"));
            if(rth > 0)
            {
               route = this.findRouteByRouteHandle(rth);
               if(route != null)
               {
                  route.updateTurnList(data["itemList"]);
               }
               else
               {
                  Framework.Trace("TripRouteHandler.updateTurnList() Route not found! \' rth:" + rth + "\'");
               }
               if(this.mActiveRoute != null && rth == this.mActiveRoute.routeHandle)
               {
                  this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE);
                  this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO);
               }
               else
               {
                  this.mRouteCalculation.sendEvent(RouteCalculationEvent.NEW_ROUTE_TURNLIST);
               }
            }
            else
            {
               Framework.Trace("TripRouteHandler.updateTurnList() RouteHandle not found! \'" + rth + "\'");
            }
         }
         else
         {
            Framework.Trace("TripRouteHandler.updateTurnList() Received TurnList without respEIS!");
         }
      }
      
      public function get routeGuidanceActive() : Boolean
      {
         if(this.mActiveRoute != null)
         {
            return true;
         }
         return false;
      }
      
      public function setRouteColorForRouteHandle(colors:Array) : void
      {
         var handle:int = 0;
         var color:String = null;
         var route:Route = null;
         for(var i:int = 0; i < colors.length; i++)
         {
            handle = int(EisHelper.getValueOfType(String(colors[i]),"<RTH>"));
            color = EisHelper.getValueOfType(String(colors[i]),"<RGB>");
            if(handle > 0 && color.length > 0)
            {
               route = this.findRouteByRouteHandle(handle);
               if(route != null)
               {
                  route.setRouteColor(color);
               }
               else
               {
                  Framework.Trace("TripRouteHandler.setRouteColorForRouteHandle() Route not found! \' rth:" + handle + "\'");
               }
            }
            else
            {
               Framework.Trace("TripRouteHandler.setRouteColorForRouteHandle() Could not compute color for rth\'" + handle + "\' color\'" + color + "\'");
            }
         }
      }
      
      public function get activeRoute() : Route
      {
         return this.mActiveRoute;
      }
      
      public function stopGuidance() : int
      {
         var newTaskDestroy:RC_Task_TripDestroy = null;
         var newTask:RC_Task_StopGuidance = null;
         if(this.mActiveRoute.routeHandle != -1 && this.mActiveRoute.routeSegment == -1)
         {
            newTaskDestroy = new RC_Task_TripDestroy(this.mActiveRoute.routeHandle);
            newTaskDestroy.addToTaskHandler();
            return newTaskDestroy.ID;
         }
         newTask = new RC_Task_StopGuidance();
         newTask.addToTaskHandler();
         return newTask.ID;
      }
      
      public function killFinishedRoute() : void
      {
         var newTaskDestroy:RC_Task_TripDestroy = null;
         if(this.mActiveRoute == null)
         {
            if(this.mPreviouslyStoppedRoute.calculationState == RouteCalculationState.Routed)
            {
               newTaskDestroy = new RC_Task_TripDestroy(int(this.mPreviouslyStoppedRoute.routeHandle));
               newTaskDestroy.addToTaskHandler();
            }
         }
         else if(RouteCalculationState.Routed == int(this.mActiveRoute.calculationState))
         {
            newTaskDestroy = new RC_Task_TripDestroy(int(this.mActiveRoute.routeHandle));
            newTaskDestroy.addToTaskHandler();
         }
      }
      
      public function killRoute() : void
      {
         var newTaskDestroy_activeRoute:RC_Task_TripDestroy = null;
         if(this.mActiveRoute != null)
         {
            newTaskDestroy_activeRoute = new RC_Task_TripDestroy(int(this.mActiveRoute.routeHandle));
            newTaskDestroy_activeRoute.addToTaskHandler();
         }
      }
      
      public function onDestinationReached(data:Object) : void
      {
         this.mReachedDestinationInfo = data;
         var locPri:LocationDetails = new LocationDetails();
         var locSec:LocationDetails = new LocationDetails();
         if(this.mActiveRoute)
         {
            if(this.mActiveRoute.Destinations.length > int(data.destElement) - 1 && int(data.destElement) > 0)
            {
               locPri.addEisString(Destination(this.mActiveRoute.Destinations[data.destElement - 1]).hardDestination.getPrimaryLocation().toEIS());
               locSec.addEisString(Destination(this.mActiveRoute.Destinations[data.destElement - 1]).hardDestination.getSecondaryLocation().toEIS());
            }
            else if(this.mPreviouslyStoppedRoute.Destinations.length > data.destElement - 1 && data.destElement > 0)
            {
               locPri.addEisString(Destination(this.mPreviouslyStoppedRoute.Destinations[data.destElement - 1]).hardDestination.getPrimaryLocation().toEIS());
               locSec.addEisString(Destination(this.mPreviouslyStoppedRoute.Destinations[data.destElement - 1]).hardDestination.getSecondaryLocation().toEIS());
            }
            this.mReachedDestination = new LocationDescription();
            this.mReachedDestination.setPrimaryLocation(locPri);
            this.mReachedDestination.setSecondaryLocation(locSec);
            if(this.mActiveRoute.trailFilePath != "")
            {
               this.mReachedDestination.setName(NavigationPackage.peripheral.navigation.navigation.extractTrailNameFromPath(this.mActiveRoute.trailFilePath));
            }
            this.mIsKillTrip = true;
            this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_DESTINATION_REACHED);
         }
      }
      
      public function get isKillTrip() : Boolean
      {
         return this.mIsKillTrip;
      }
      
      public function set isKillTrip(kt:Boolean) : void
      {
         this.mIsKillTrip = kt;
      }
      
      public function get reachedDestinationInfo() : Object
      {
         return this.mReachedDestinationInfo;
      }
      
      public function get reachedDestination() : LocationDescription
      {
         return this.mReachedDestination;
      }
      
      public function onManeuverInfo(data:Object) : void
      {
         this.mGuidanceInfo.setManeuverInfo(int(data.direction),int(data.distance),int(data.distance));
         if(this.mGatekeeper.running == false)
         {
            this.mGatekeeper.start();
            this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO);
         }
      }
      
      public function onDestinationInfo(data:Object) : void
      {
         this.mGuidanceInfo.setDestinationDistance(int(data.distance));
         this.mGuidanceInfo.setDestinationTime(int(data.time));
         this.mRouteCalculation.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO);
      }
      
      public function get guidanceInfo() : GuidanceInfo
      {
         return this.mGuidanceInfo;
      }
      
      public function blockRouteSegmentManeuver(routeHandle:int, turnIndex:int) : int
      {
         var data:Object = null;
         var task:RC_Task_BlockRouteSegment = null;
         if(this.mActiveRoute != null)
         {
            if(this.mActiveRoute.routeHandle == routeHandle && this.mActiveRoute.getTurnList().turnList.length > turnIndex)
            {
               data = new Object();
               data["routeHandle"] = routeHandle;
               data["routeElement"] = TurnListElement(this.mActiveRoute.getTurnList().turnList[turnIndex]).getValue("<RTE>");
               data["routeSegment"] = TurnListElement(this.mActiveRoute.getTurnList().turnList[turnIndex]).getValue("<RSG>");
               task = new RC_Task_BlockRouteSegment(data);
               task.addToTaskHandler();
               return task.ID;
            }
            Framework.Trace("TripRouteHandler.blockRouteSegmentManeuver(" + routeHandle + ", " + turnIndex + ") RouteHandle/TurnIndex not found! (" + this.mActiveRoute.getTurnList().turnList.length + ")");
            return -1;
         }
         Framework.Trace("TripRouteHandler.blockRouteSegmentManeuver(" + routeHandle + ", " + turnIndex + ") ActiveRoute not found!");
         return -1;
      }
      
      private function checkDestinationInfoRequest(routeHandle:int, oldState:int, newState:int) : void
      {
         var rteTask:RC_Task_RouteElementInfo = null;
         var optTask:RC_Task_RouteOptions = null;
         var turnlistTask:RC_Task_TurnList = null;
         Framework.Trace(" checkDestinationInfoRequest " + routeHandle + " " + oldState + " " + newState);
         if(newState >= RouteCalculationState.Calculated && oldState <= RouteCalculationState.Calculating)
         {
            rteTask = new RC_Task_RouteElementInfo(routeHandle);
            rteTask.addToTaskHandler();
            optTask = new RC_Task_RouteOptions(routeHandle);
            optTask.addToTaskHandler();
            turnlistTask = new RC_Task_TurnList(routeHandle);
            turnlistTask.addToTaskHandler();
         }
      }
   }
}

