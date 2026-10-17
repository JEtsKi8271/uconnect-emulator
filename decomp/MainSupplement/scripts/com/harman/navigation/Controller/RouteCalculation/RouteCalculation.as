package com.harman.navigation.Controller.RouteCalculation
{
   import com.harman.navigation.Controller.RouteCalculation.enums.RC_Task;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_BlockRouteAhead;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_PersistRoute;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_StartGuidance;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_TripChange;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_TripCreateNew;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_TripDestroy;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_TripRoutesPlannedDestroy;
   import com.harman.navigation.Controller.RouteCalculation.enums.tasks.RC_Task_TurnList;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.Controller.RouteCalculation.utils.TaskHandler;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRouteHandler;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.enums.RouteCalculationState;
   import com.harman.navigation.enums.StartupState;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.routeCalculation.Destination;
   import com.harman.navigation.routeCalculation.GuidanceRestarter;
   import com.harman.navigation.utils.GuidanceInfo;
   import com.harman.navigation.utils.LocationDescription;
   import com.nfuzion.framework.global.Framework;
   import flash.events.EventDispatcher;
   
   public class RouteCalculation extends EventDispatcher implements IRouteCalculation
   {
      
      private var mTaskHandler:TaskHandler;
      
      private var mTripRouteHandler:TripRouteHandler;
      
      private var mGuidanceRestarter:GuidanceRestarter;
      
      public function RouteCalculation()
      {
         super();
         this.mTaskHandler = new TaskHandler(this);
         this.mTripRouteHandler = new TripRouteHandler(this);
         RC_Task.setRouteCalculationCtrl(this);
         NavigationApi.api.addEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_NEW_TRIP,this.onNewTripResponse,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_NEW_TRIP_FILE,this.onNewTripFileResponse,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_NEW_TRIP_FAIL,this.onNewTripFail,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_NEW_TRIP_FILE_FAIL,this.onNewTripFail,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_CALCULATION_STATE,this.onCalculationState,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_DESTROY_TRIP,this.onTripDestroyed,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_UPDATE_ROUTE_ELEMENT,this.onRouteElementUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_UPDATE_AVOIDANCE_TYPES,this.onRouteOptionsUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_START_GUIDANCE,this.onStartedGuidance,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_ACTIVE_ROUTE_DESCRIPTION,this.onActiveRouteDescription,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_UPDATE_TURN_LIST,this.onTurnListUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_DESTINATION_REACHED,this.onDestinationReached,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_NEXT_MANEUVER_INFO,this.onManeuverInfo,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_NEXT_DESTINATION_INFO,this.onDestinationInfo,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_BLOCK_ROUTE,this.onRouteBlockUpdate,false,0,true);
         NavigationApi.api.addEventListener(NavigationEvent.RT_CHANGE_TRIP_RESPONSE,this.onChangeTripResponse,false,0,true);
      }
      
      public function createNewTrip(trip:TripRoute, deleteExistingRouteTrips:Boolean) : int
      {
         var newTaskDestroy:RC_Task_TripRoutesPlannedDestroy = null;
         if(deleteExistingRouteTrips)
         {
            newTaskDestroy = new RC_Task_TripRoutesPlannedDestroy();
            newTaskDestroy.addToTaskHandler();
         }
         var newTaskCreate:RC_Task = new RC_Task_TripCreateNew(trip);
         newTaskCreate.addToTaskHandler();
         return newTaskCreate.ID;
      }
      
      public function createNewTripTrail(trip:TripRoute) : int
      {
         var newTaskCreate:RC_Task = new RC_Task_TripCreateNew(trip);
         newTaskCreate.addToTaskHandler();
         return newTaskCreate.ID;
      }
      
      public function get trips() : Array
      {
         return this.mTripRouteHandler.tripRoutes;
      }
      
      public function get lastPlannedTrip() : TripRoute
      {
         if(this.mTripRouteHandler.tripRoutes.length > 0)
         {
            return TripRoute(this.mTripRouteHandler.tripRoutes[this.mTripRouteHandler.tripRoutes.length - 1]);
         }
         return null;
      }
      
      public function destroyTrips() : int
      {
         var newTaskDestroy:RC_Task_TripRoutesPlannedDestroy = new RC_Task_TripRoutesPlannedDestroy();
         newTaskDestroy.addToTaskHandler();
         return newTaskDestroy.ID;
      }
      
      public function startGuidance(routeHandle:int, resetTripComputer:Boolean, overwriteRouteMode:int = -1) : int
      {
         var deleteTask:RC_Task_TripDestroy = null;
         var route:Route = this.mTripRouteHandler.findRouteByRouteHandle(routeHandle);
         if(overwriteRouteMode != -1)
         {
            route.setRouteMode(overwriteRouteMode);
         }
         if(this.mTripRouteHandler.activeRoute != null)
         {
            deleteTask = new RC_Task_TripDestroy(this.mTripRouteHandler.activeRoute.routeHandle);
            deleteTask.addToTaskHandler();
         }
         var taskPersist:RC_Task_PersistRoute = new RC_Task_PersistRoute(route);
         taskPersist.addToTaskHandler();
         var newTask:RC_Task_StartGuidance = new RC_Task_StartGuidance(routeHandle);
         newTask.addToTaskHandler();
         if(resetTripComputer)
         {
            this.tripComputerStart();
         }
         else
         {
            this.tripComputerRestart();
         }
         return newTask.ID;
      }
      
      public function getNewTripRealRoadDistance(routeElementIndex:int) : int
      {
         return this.mTripRouteHandler.getNewRouteRealRoadDistance(routeElementIndex);
      }
      
      public function get lastCreatedTripRoute() : TripRoute
      {
         if(this.mTripRouteHandler.tripRoutes.length > 0)
         {
            return TripRoute(this.mTripRouteHandler.tripRoutes[this.mTripRouteHandler.tripRoutes.length - 1]);
         }
         return null;
      }
      
      public function changeTrip(routeHandle:int, alternativeInterchange:String) : void
      {
         var taskChangeTrip:RC_Task_TripChange = new RC_Task_TripChange(routeHandle,alternativeInterchange);
         taskChangeTrip.addToTaskHandler();
      }
      
      public function setRouteColorForRouteHandle(colors:Array) : void
      {
         Framework.Trace("RouteCalculation.rgSetRouteColors( " + colors.length + " )");
         this.mTripRouteHandler.setRouteColorForRouteHandle(colors);
      }
      
      public function get activeRoute() : Route
      {
         return this.mTripRouteHandler.activeRoute;
      }
      
      public function getTurnList() : void
      {
      }
      
      public function get turnList() : Object
      {
         return new Object();
      }
      
      public function getNewRouteCalculationState() : void
      {
         this.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE);
      }
      
      public function get newRouteCalculationPercentage() : int
      {
         return this.mTripRouteHandler.newRouteCalculationPercentage;
      }
      
      public function getActiveRouteCalculationState() : void
      {
         this.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_CALCULATION_STATE);
      }
      
      public function get activeRouteCalculationState() : int
      {
         return this.mTripRouteHandler.activeRoute.calculationState;
      }
      
      public function getActiveRouteGuidanceState() : void
      {
         this.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE);
      }
      
      public function get activeRouteGuidanceState() : Boolean
      {
         return this.mTripRouteHandler.routeGuidanceActive;
      }
      
      public function stopGuidance() : int
      {
         var taskPersist:RC_Task_PersistRoute = new RC_Task_PersistRoute(new Route());
         taskPersist.addToTaskHandler();
         this.tripComputerStop();
         return this.mTripRouteHandler.stopGuidance();
      }
      
      public function killRoute() : void
      {
         var taskPersist:RC_Task_PersistRoute = new RC_Task_PersistRoute(new Route());
         taskPersist.addToTaskHandler();
         this.tripComputerStop();
         this.mTripRouteHandler.killRoute();
      }
      
      public function killFinishedRoute() : void
      {
         this.mTripRouteHandler.killFinishedRoute();
      }
      
      public function get reachedDestination() : LocationDescription
      {
         return this.mTripRouteHandler.reachedDestination;
      }
      
      public function getGuidanceInfo() : void
      {
         this.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO);
      }
      
      public function get guidanceInfo() : GuidanceInfo
      {
         return this.mTripRouteHandler.guidanceInfo;
      }
      
      public function blockRouteSegmentManeuver(routeHandle:int, turnIndex:int) : int
      {
         return this.mTripRouteHandler.blockRouteSegmentManeuver(routeHandle,turnIndex);
      }
      
      public function blockRouteAhead(distance:int) : int
      {
         var taskBlockAhead:RC_Task_BlockRouteAhead = null;
         if(this.mTripRouteHandler.activeRoute == null || this.mTripRouteHandler.activeRoute.routeHandle == -1)
         {
            Framework.Trace("RouteCalculation.blockRouteAhead( " + distance + " ) No RouteHandle to proceed!");
            return -1;
         }
         taskBlockAhead = new RC_Task_BlockRouteAhead(this.mTripRouteHandler.activeRoute.routeHandle,distance);
         taskBlockAhead.addToTaskHandler();
         return taskBlockAhead.ID;
      }
      
      public function get distanceToFinalDestination() : int
      {
         var distance:int = 0;
         var i:int = 0;
         if(this.mTripRouteHandler.activeRoute == null)
         {
            return -1;
         }
         distance = this.guidanceInfo.destinationDistance;
         this.mTripRouteHandler.activeRoute.routeElement;
         for(i = this.mTripRouteHandler.activeRoute.routeElement; i < this.mTripRouteHandler.activeRoute.Destinations.length; i++)
         {
            distance += Destination(this.mTripRouteHandler.activeRoute.Destinations[i]).realRoadDistance;
         }
         return distance;
      }
      
      public function startTmcRelatedReroute(routeHandle:int) : void
      {
         var overidenRouteHandle:int = 0;
         var newTask:RC_Task_StartGuidance = null;
         var listTask:RC_Task_TurnList = null;
         var deleteTask:RC_Task_TripDestroy = null;
         if(this.mTripRouteHandler.activeRoute != null)
         {
            overidenRouteHandle = this.mTripRouteHandler.activeRoute.routeHandle;
            this.mTripRouteHandler.activeRoute.setRouteHandle(routeHandle);
            this.mTripRouteHandler.activeRoute.purgeTurnList();
            newTask = new RC_Task_StartGuidance(routeHandle);
            newTask.addToTaskHandler();
            listTask = new RC_Task_TurnList(routeHandle);
            listTask.addToTaskHandler();
            deleteTask = new RC_Task_TripDestroy(overidenRouteHandle);
            deleteTask.addToTaskHandler();
         }
      }
      
      public function killRejectedTmcReroute(routeHandle:int) : void
      {
         var deleteTask:RC_Task_TripDestroy = new RC_Task_TripDestroy(routeHandle);
         deleteTask.addToTaskHandler();
      }
      
      public function startupGuidanceRestart(trip:TripRoute) : void
      {
         Framework.Trace("RouteCalculation.startupGuidanceRestart()");
         if(trip != null)
         {
            trip.setAutoStart(true);
            this.createNewTrip(trip,true);
            this.tripComputerRestart();
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenuStackPassive(1);
         }
         else
         {
            this.tripComputerStop();
         }
         NavigationPackage.peripheral.navigation.navigation.reportGuidanceRestarterFinished();
      }
      
      public function startupTrailRestart(trail:String, mode:int) : void
      {
         var trailTrip:TripRoute = null;
         Framework.Trace("RouteCalculation.startupTrailRestart( " + trail + " , " + mode + " )");
         if(trail != "")
         {
            trailTrip = new TripRoute();
            trailTrip.setAutoStart(true);
            trailTrip.setTrailPath(trail);
            trailTrip.setTrailMode(mode);
            this.createNewTripTrail(trailTrip);
            NavigationPackage.peripheral.navigation.navDomainControl.switchToMenuStackPassive(1);
            this.tripComputerRestart();
         }
         else
         {
            this.tripComputerStop();
         }
         NavigationPackage.peripheral.navigation.navigation.reportGuidanceRestarterFinished();
      }
      
      public function get guidanceRestarter() : GuidanceRestarter
      {
         return this.mGuidanceRestarter;
      }
      
      public function getRgActiveRouteTravelTime() : int
      {
         return 0;
      }
      
      public function getRgActiveRouteDistance() : int
      {
         return 0;
      }
      
      public function getRgTmcAlternativeRouteTravelTime() : int
      {
         return 0;
      }
      
      public function getRgTmcAlternativeRouteDistance() : int
      {
         return 0;
      }
      
      private function onNewTripResponse(e:NavigationEvent) : void
      {
         var taskID:int = int(this.mTaskHandler.activeTaskID);
         if(!this.mTaskHandler.isActiveTaskOfTaskType(RC_Task.TRIP_CREATE_NEW))
         {
            Framework.Trace("RouteCalculation.onNewTripResponse() ERROR - TaskType mismatch (" + this.mTaskHandler.activeTaskType + ")");
         }
         if(this.mTripRouteHandler.updateRouteHandlesByTripID(taskID,e.data))
         {
            Framework.Trace("RouteCalculation.onNewTripResponse() success");
            this.mTaskHandler.reportTaskCompletion(RC_Task.TRIP_CREATE_NEW);
            this.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE);
         }
         else
         {
            Framework.Trace("RouteCalculation.onNewTripResponse() fail");
         }
      }
      
      private function onNewTripFileResponse(e:NavigationEvent) : void
      {
         var taskID:int = int(this.mTaskHandler.activeTaskID);
         if(!this.mTaskHandler.isActiveTaskOfTaskType(RC_Task.TRIP_CREATE_NEW))
         {
            Framework.Trace("RouteCalculation.onNewTripFileResponse() ERROR - TaskType mismatch (" + this.mTaskHandler.activeTaskType + ")");
         }
         if(this.mTripRouteHandler.updateRouteHandlesByTripID(taskID,e.data))
         {
            Framework.Trace("RouteCalculation.onNewTripFileResponse() success");
            this.mTaskHandler.reportTaskCompletion(RC_Task.TRIP_CREATE_NEW);
            this.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_STATE);
         }
         else
         {
            Framework.Trace("RouteCalculation.onNewTripResponse() fail");
         }
      }
      
      private function onNewTripFail(e:NavigationEvent) : void
      {
         var taskID:int = int(this.mTaskHandler.activeTaskID);
         if(this.mTripRouteHandler.deleteTripRouteByID(taskID))
         {
            this.mTaskHandler.clearQueueStack(taskID);
            Framework.Trace("RouteCalculation.onNewTripFail() TripRoute deleted successful.");
         }
         else
         {
            Framework.Trace("RouteCalculation.onNewTripFail() TripRoute not found.");
         }
         this.mTaskHandler.reportTaskCompletion(RC_Task.TRIP_CREATE_NEW);
         this.sendEvent(RouteCalculationEvent.NEW_ROUTE_CALCULATION_FAILED);
      }
      
      private function onCalculationState(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.updateCalculationState(e.data);
         if(e.data.calcState == RouteCalculationState.Routed)
         {
            this.tripComputerStop();
         }
      }
      
      private function onTripDestroyed(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.deleteRoutesByRouteHandle(e.data.handles);
      }
      
      private function onRouteElementUpdate(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.updateRouteElementInfo(e.data);
         this.mTaskHandler.reportTaskCompletion(RC_Task.ROUTE_ELEMENT_INFO);
         this.sendEvent(RouteCalculationEvent.NEW_ROUTE_ELEMENT_INFO_UPDATE);
      }
      
      private function onRouteOptionsUpdate(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.updateRouteOptionsInfo(e.data);
         this.mTaskHandler.reportTaskCompletion(RC_Task.ROUTE_OPTIONS);
         this.sendEvent(RouteCalculationEvent.NEW_ROUTE_OPTIONS_UPDATE);
      }
      
      private function onStartedGuidance(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.reportGuidanceStart(e.data);
         this.mTaskHandler.reportTaskCompletion(RC_Task.GUIDANCE_START);
         this.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_STATE);
      }
      
      private function onActiveRouteDescription(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.updateActiveRouteDescription(e.data);
      }
      
      private function onTurnListUpdate(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.updateTurnList(e.data);
         this.mTaskHandler.reportTaskCompletion(RC_Task.TURN_LIST);
      }
      
      private function onDestinationReached(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.onDestinationReached(e.data);
         var save:Route = new Route();
         save.clone(this.activeRoute);
         while(save.Destinations.length > e.data.destCount - e.data.destElement)
         {
            save.Destinations.splice(0,1);
         }
         var taskPersist:RC_Task_PersistRoute = new RC_Task_PersistRoute(save);
         taskPersist.addToTaskHandler();
      }
      
      public function getDestReached() : void
      {
         this.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_DESTINATION_REACHED);
      }
      
      public function get isKillTrip() : Boolean
      {
         return this.mTripRouteHandler.isKillTrip;
      }
      
      public function set isKillTrip(kt:Boolean) : void
      {
         this.mTripRouteHandler.isKillTrip = kt;
      }
      
      private function onManeuverInfo(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.onManeuverInfo(e.data);
      }
      
      private function onDestinationInfo(e:NavigationEvent) : void
      {
         this.mTripRouteHandler.onDestinationInfo(e.data);
      }
      
      private function onRouteBlockUpdate(e:NavigationEvent) : void
      {
         if(this.mTaskHandler.isActiveTaskOfTaskType(RC_Task.BLOCK_ROUTE_SEGMENT))
         {
            this.mTaskHandler.reportTaskCompletion(RC_Task.BLOCK_ROUTE_SEGMENT);
         }
         else if(this.mTaskHandler.isActiveTaskOfTaskType(RC_Task.BLOCK_ROUTE_AHEAD))
         {
            this.mTaskHandler.reportTaskCompletion(RC_Task.BLOCK_ROUTE_AHEAD);
         }
         if(String(e.data) == "2")
         {
            this.sendEvent(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO_ERROR);
         }
      }
      
      private function onNavStartupState(evt:NavigationEvent) : void
      {
         if(NavigationPackage.peripheral.navigation != null)
         {
            if(NavigationPackage.peripheral.navigation.navigation.navStartupState >= StartupState.INIT)
            {
               NavigationApi.api.removeEventListener(NavigationEvent.NAV_STARTUP_STATE,this.onNavStartupState);
               this.mGuidanceRestarter = new GuidanceRestarter(this);
            }
         }
      }
      
      private function onChangeTripResponse(e:NavigationEvent) : void
      {
         this.mTaskHandler.reportTaskCompletion(RC_Task.TRIP_CHANGE);
         this.sendEvent(RouteCalculationEvent.CHANGE_TRIP_RESPONSE);
      }
      
      private function tripComputerStart() : void
      {
         NavigationPackage.peripheral.navigation.navNDR.tripComputerReset();
         NavigationPackage.peripheral.navigation.navNDR.tripComputerStart();
      }
      
      private function tripComputerRestart() : void
      {
         NavigationPackage.peripheral.navigation.navNDR.tripComputerStart();
      }
      
      private function tripComputerStop() : void
      {
         NavigationPackage.peripheral.navigation.navNDR.tripComputerStop();
      }
      
      public function sendEvent(eventType:String, payload:Object = null, reqID:int = -1) : void
      {
         dispatchEvent(new RouteCalculationEvent(eventType,payload,reqID));
      }
      
      public function get tripRouteHandler() : TripRouteHandler
      {
         return this.mTripRouteHandler;
      }
      
      public function get taskHandler() : TaskHandler
      {
         return this.mTaskHandler;
      }
      
      public function getAll() : void
      {
      }
      
      public function hello() : void
      {
      }
      
      public function isReady() : Boolean
      {
         return true;
      }
      
      public function addInterest(signalName:String) : void
      {
      }
      
      public function removeInterest(signalName:String) : void
      {
      }
      
      public function destroyInterest(signalName:String) : void
      {
      }
      
      public function interested(signalName:String) : Boolean
      {
         return false;
      }
      
      public function totalInterest(signalName:String) : uint
      {
         return 0;
      }
   }
}

