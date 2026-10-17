package com.harman.navigation.Controller.Interchange
{
   import com.harman.navigation.Controller.RouteCalculation.RouteCalculationEvent;
   import com.harman.navigation.Controller.RouteCalculation.utils.Route;
   import com.harman.navigation.Controller.RouteCalculation.utils.TripRoute;
   import com.harman.navigation.Controller.RouteCalculation.utils.TurnList;
   import com.harman.navigation.DomainControl.menuStack.NavMenus;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.global.vServices.VServiceGlobalSettings;
   import com.harman.navigation.utils.EisHelper;
   import com.harman.navigation.utils.TurnListElement;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.Module;
   
   public class InterchangeController extends Module implements IInterchange
   {
      
      private var mBusy:Boolean = false;
      
      private var mStreetnameTagsAlternatives:Array = new Array();
      
      private var mStreetnameTagsDirections:Array = new Array();
      
      private var mScreens:Array = new Array();
      
      private var mInterchangeListType:int = 0;
      
      private var mLastRouteSegment:int = -1;
      
      private var mIsLoop:Boolean = false;
      
      public function InterchangeController()
      {
         this.mStreetnameTagsAlternatives.push("<EXT>");
         this.mStreetnameTagsAlternatives.push("<STR>");
         this.mStreetnameTagsDirections.push("<EXT>");
         if(VServiceGlobalSettings.navMarketConfig == VServiceGlobalSettings.MARKET_JAPAN)
         {
            NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.NEW_ROUTE_TURNLIST,this.onNewRouteTurnList,false,0,true);
            NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.ACTIVE_ROUTE_GUIDANCE_INFO,this.onGuidanceInfoChange,false,0,true);
            NavigationPackage.peripheral.navigation.navRouteCalculation.addEventListener(RouteCalculationEvent.CHANGE_TRIP_RESPONSE,this.onChangeTripResponse,false,0,true);
         }
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.RT_INTERCHANGE_CURRENT,this.onInterchangeCurrent,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.RT_INTERCHANGE_CUR_FAILED,this.onInterchangeCurrentFail,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.RT_INTERCHANGE_ALTERNATIVES,this.onInterchangeAlternatives,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.RT_INTERCHANGE_ALT_FAILED,this.onInterchangeAlternativesFail,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.RT_INTERCHANGE_DIRECTIONS,this.onInterchangeDirections,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.RT_INTERCHANGE_DIR_FAILED,this.onInterchangeDirectionsFail,false,0,true);
         super();
      }
      
      public function get interchangePresent() : Boolean
      {
         var tmp:int = 0;
         var i:int = 0;
         var list:TurnList = this.getTurnlist();
         if(list != null)
         {
            for(i = 0; i < list.turnList.length; i++)
            {
               tmp = int(TurnListElement(list.turnList[i]).getValue("<IC>"));
               if(tmp == Interchange.LIST_ENTRY || tmp == Interchange.LIST_EXIT)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function initializeNewSession() : void
      {
         this.mScreens.splice(0,this.mScreens.length);
         this.requestListOptions();
      }
      
      public function getInterchangeScreen() : void
      {
         this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
      }
      
      public function get interchangeScreen() : InterchangeListScreen
      {
         if(this.mScreens.length > 0)
         {
            return this.mScreens[this.mScreens.length - 1];
         }
         return null;
      }
      
      public function selectListItem(index:int) : void
      {
         Framework.Trace("InterChangeCtrl.selectListItem( " + index + " )");
         if(this.mScreens.length == 1)
         {
            this.mInterchangeListType = int(EisHelper.getValueOfType(InterchangeListItem(InterchangeListScreen(this.mScreens[0]).list[index]).request,"<IC>"));
         }
         if(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list != null && InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list.length > 0)
         {
            if(InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[index]).enabled)
            {
               InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).selectedItem = index;
               switch(InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[index]).listEntryType)
               {
                  case Interchange.LIST_ENTRY_TYPE_HAS_BRANCH:
                     NavigationPackage.peripheral.navigation.navigation.rtGetInterchangeList(InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[index]).request);
                     break;
                  case Interchange.LIST_ENTRY_TYPE_IS_END_NODE:
                     NavigationPackage.peripheral.navigation.navRouteCalculation.changeTrip(this.getRoute().routeHandle,InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[index]).request);
                     break;
                  case Interchange.LIST_ENTRY_TYPE_USE_BACK:
                     this.onBack();
                     break;
                  default:
                     Framework.Trace(" - Unsupported ListEntryType (" + InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[index]).listEntryType + ")");
               }
            }
            else
            {
               Framework.Trace(" -disabled listItem selected (Request ignored)");
            }
         }
      }
      
      public function onBack() : Boolean
      {
         Framework.Trace("InterChangeCtrl.onBack()");
         if(this.mScreens.length > 1)
         {
            this.mScreens.pop();
            this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
            return true;
         }
         return false;
      }
      
      private function onNewRouteTurnList(e:RouteCalculationEvent) : void
      {
         this.initializeNewSession();
      }
      
      private function onGuidanceInfoChange(e:RouteCalculationEvent) : void
      {
         var route:Route = null;
         if(TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip) == null || TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip).routes[0] == null)
         {
            route = this.getRoute();
            if(route != null && route.routeSegment != this.mLastRouteSegment)
            {
               this.mLastRouteSegment = route.routeSegment;
               this.requestListOptions();
            }
         }
      }
      
      private function onInterchangeCurrent(e:NavigationEvent) : void
      {
         this.buildListOptions();
      }
      
      private function onInterchangeCurrentFail(e:NavigationEvent) : void
      {
         var newListScreen:InterchangeListScreen = this.noResultsFoundList;
         newListScreen.title = NavigationPackage.translations.STRB_OPTIONS;
         this.mScreens.splice(0,this.mScreens.length);
         this.mScreens.push(newListScreen);
         this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
      }
      
      private function onInterchangeAlternatives(e:NavigationEvent) : void
      {
         this.buildListInterchangeAlternatives();
      }
      
      private function onInterchangeAlternativesFail(e:NavigationEvent) : void
      {
         var newListScreen:InterchangeListScreen = this.noResultsFoundList;
         newListScreen.title = NavigationPackage.translations.STRB_SELECT_ROAD;
         this.mScreens.push(newListScreen);
         this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
      }
      
      private function onInterchangeDirections(e:NavigationEvent) : void
      {
         this.buildListInterchangeDirections();
      }
      
      private function onInterchangeDirectionsFail(e:NavigationEvent) : void
      {
         var newListScreen:InterchangeListScreen = this.noResultsFoundList;
         newListScreen.title = NavigationPackage.translations.STRB_SELECT_ROAD;
         this.mScreens.push(newListScreen);
         this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
      }
      
      private function onChangeTripResponse(e:RouteCalculationEvent) : void
      {
         this.mScreens.splice(0,this.mScreens.length);
         if(NavigationPackage.peripheral.navigation.navDomainControl.navActiveMenu == NavMenus.MENU_FLOW_TRIP_ASSEMBLER)
         {
            NavigationPackage.peripheral.navigation.navTripAssembler.onBack();
         }
         else
         {
            NavigationPackage.peripheral.navigation.navDomainControl.onBackButtonPress();
         }
      }
      
      private function sendEvent(eventType:String) : void
      {
         dispatchEvent(new InterchangeEvent(eventType));
      }
      
      private function getTurnlist() : TurnList
      {
         if(TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip) != null)
         {
            if(TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip).routes[0] != null)
            {
               return Route(TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip).routes[0]).getTurnList();
            }
            return null;
         }
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute != null)
         {
            return Route(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute).getTurnList();
         }
         return null;
      }
      
      private function getRoute() : Route
      {
         if(TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip) != null)
         {
            if(TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip).routes[0] != null)
            {
               return Route(TripRoute(NavigationPackage.peripheral.navigation.navRouteCalculation.lastPlannedTrip).routes[0]);
            }
         }
         if(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute != null)
         {
            return Route(NavigationPackage.peripheral.navigation.navRouteCalculation.activeRoute);
         }
         return null;
      }
      
      private function get noResultsFoundList() : InterchangeListScreen
      {
         var newListScreen:InterchangeListScreen = new InterchangeListScreen();
         newListScreen.addListItem(this.noResultsFoundListItem);
         return newListScreen;
      }
      
      private function get noResultsFoundListItem() : InterchangeListItem
      {
         var newEntry:InterchangeListItem = new InterchangeListItem();
         newEntry.title = this.getText(NavigationPackage.translations.STRB_SEARCH_NO_RESULTS_FOUND);
         newEntry.request = "";
         newEntry.listEntryType = Interchange.LIST_ENTRY_TYPE_IS_END_NODE;
         newEntry.enabled = false;
         return newEntry;
      }
      
      private function getText(textBundle:uint) : String
      {
         return NavigationPackage.peripheral.localeEngine.getText(textBundle);
      }
      
      private function checkSelectFunctionality(alternative:String) : Boolean
      {
         var listEntry:InterchangeListItem = null;
         var geo:String = EisHelper.getValueOfType(alternative,"<GEO>");
         if(geo == "")
         {
            return false;
         }
         for(var i:* = int(this.mScreens.length - 1); i >= 0; i--)
         {
            listEntry = InterchangeListItem(InterchangeListScreen(this.mScreens[i]).list[InterchangeListScreen(this.mScreens[i]).selectedItem]);
            if(listEntry)
            {
               if(EisHelper.getValueOfType(listEntry.request,"<GEO>") == geo)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      private function getEndNodeText(useBrackets:Boolean) : String
      {
         switch(this.mInterchangeListType)
         {
            case Interchange.LIST_ENTRY:
               return (useBrackets ? " (" : "") + this.getText(NavigationPackage.translations.STRB_UP) + (useBrackets ? ")" : " - ");
            case Interchange.LIST_EXIT:
               return (useBrackets ? " (" : "") + this.getText(NavigationPackage.translations.STRB_DOWN) + (useBrackets ? ")" : " - ");
            default:
               return "";
         }
      }
      
      private function requestListOptions() : void
      {
         var route:Route = this.getRoute();
         if(route != null)
         {
            NavigationPackage.peripheral.navigation.navigation.rtGetInterchangeList("<IFT>RT<*><RTH>" + route.routeHandle + "<*><IC><*>");
         }
      }
      
      private function buildListOptions() : void
      {
         var newEntry:InterchangeListItem = null;
         var newExit:InterchangeListItem = null;
         var newListScreen:InterchangeListScreen = new InterchangeListScreen();
         newListScreen.title = NavigationPackage.translations.STRB_OPTIONS;
         var route:Route = this.getRoute();
         var current:Array = NavigationPackage.peripheral.navigation.navigation.rtInterchangeCurrent;
         for(var i:int = 0; i < current.length; i++)
         {
            newEntry = new InterchangeListItem();
            switch(int(EisHelper.getValueOfType(String(current[i]),"<IC>")))
            {
               case Interchange.LIST_ENTRY:
                  newEntry.title = this.getText(NavigationPackage.translations.STRB_ENTRANCE) + " " + EisHelper.extractTextStringForTags(String(current[i]),this.mStreetnameTagsAlternatives);
                  newEntry.request = "<IFT>RT<*><RTH>" + route.routeHandle + "<*>" + String(current[i]) + "<ICT><*>";
                  newEntry.enabled = true;
                  newEntry.listEntryType = Interchange.LIST_ENTRY_TYPE_HAS_BRANCH;
                  newListScreen.addListItem(newEntry);
                  break;
               case Interchange.LIST_EXIT:
                  newExit = new InterchangeListItem();
                  newEntry.title = this.getText(NavigationPackage.translations.STRB_EXIT) + " " + EisHelper.extractTextStringForTags(String(current[i]),this.mStreetnameTagsAlternatives);
                  newEntry.request = "<IFT>RT<*><RTH>" + route.routeHandle + "<*>" + String(current[i]) + "<ICT><*>";
                  newEntry.enabled = true;
                  newEntry.listEntryType = Interchange.LIST_ENTRY_TYPE_HAS_BRANCH;
                  newListScreen.addListItem(newEntry);
            }
         }
         if(newListScreen.list.length == 0)
         {
            newListScreen.addListItem(this.noResultsFoundListItem);
         }
         this.mScreens.splice(0,this.mScreens.length,newListScreen);
         this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
      }
      
      private function buildListInterchangeAlternatives() : void
      {
         var newEntry:InterchangeListItem = null;
         var str:String = null;
         var ic:String = null;
         var ict:String = null;
         var icd:String = null;
         var newListScreen:InterchangeListScreen = new InterchangeListScreen();
         switch(int(EisHelper.getValueOfType(InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).selectedItem]).request,"<IC>")))
         {
            case Interchange.LIST_ENTRY:
               newListScreen.title = NavigationPackage.translations.STRB_CHANGE_ENTRANCE_IC;
               break;
            case Interchange.LIST_EXIT:
               newListScreen.title = NavigationPackage.translations.STRB_CHANGE_EXIT_IC;
               break;
            default:
               Framework.Trace("IC_Ctrl.buildListInterchangeAlternatives() No Interchange listType found for \'" + int(EisHelper.getValueOfType(InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).selectedItem]).request,"<IC>")) + "\' \'" + InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).selectedItem]).request + "\'");
         }
         var route:Route = this.getRoute();
         var alternatives:Array = NavigationPackage.peripheral.navigation.navigation.rtInterchangeAlternatives;
         for(var i:int = 0; i < alternatives.length; i++)
         {
            newEntry = new InterchangeListItem();
            if(String(alternatives[i]).indexOf("<SEL>1<*>") != -1)
            {
               newEntry.enabled = false;
            }
            else
            {
               newEntry.enabled = true;
            }
            switch(int(EisHelper.getValueOfType(String(alternatives[i]),"<ICT>")))
            {
               case Interchange.TYPE_INTERCHANGE:
               case Interchange.TYPE_SMART_INTERCHANGE:
                  newEntry.title = EisHelper.extractTextStringForTags(String(alternatives[i]),this.mStreetnameTagsAlternatives);
                  newEntry.request = String(alternatives[i]);
                  newEntry.listEntryType = Interchange.LIST_ENTRY_TYPE_IS_END_NODE;
                  newListScreen.addListItem(newEntry);
                  break;
               case Interchange.TYPE_JUNCTION:
                  newEntry.title = EisHelper.extractTextStringForTags(String(alternatives[i]),this.mStreetnameTagsAlternatives) + " (" + this.getText(NavigationPackage.translations.STRB_JUNCTION) + ")";
                  newEntry.request = "<IFT>RT<*><RTH>" + route.routeHandle + "<*>" + String(alternatives[i]) + "<ICD><*>";
                  newEntry.listEntryType = Interchange.LIST_ENTRY_TYPE_HAS_BRANCH;
                  if(this.checkSelectFunctionality(String(alternatives[i])))
                  {
                     this.mIsLoop = true;
                  }
                  newListScreen.addListItem(newEntry);
                  break;
               default:
                  Framework.Trace("IC_Ctrl.buildListInterchangeAlternatives() Unsupported InterchangeType found for \'" + String(alternatives[i]) + "\'");
            }
         }
         if(newListScreen.list.length == 0)
         {
            newListScreen.addListItem(this.noResultsFoundListItem);
         }
         if(this.mIsLoop)
         {
            while(this.mScreens.length > 1)
            {
               str = InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).selectedItem]).request;
               ic = EisHelper.getValueOfType(str,"<IC>");
               ict = EisHelper.getValueOfType(str,"<ICT>");
               icd = EisHelper.getValueOfType(str,"<ICD>");
               if(0 == int(ic) && 0 == int(ict) && 0 != int(icd) || 0 == int(ic) && 0 != int(ict) && 0 == int(icd))
               {
                  this.mScreens.pop();
               }
            }
            this.mIsLoop = false;
         }
         this.mScreens.push(newListScreen);
         this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
      }
      
      private function buildListInterchangeDirections() : void
      {
         var directions:Array = null;
         var icn:String = null;
         var i:int = 0;
         var newEntry:InterchangeListItem = null;
         var newListScreen:InterchangeListScreen = new InterchangeListScreen();
         newListScreen.title = NavigationPackage.translations.STRB_SELECT_ROAD;
         var route:Route = this.getRoute();
         if(route != null)
         {
            directions = NavigationPackage.peripheral.navigation.navigation.rtInterchangeDirections;
            icn = new String("<ICN>" + EisHelper.getValueOfType(InterchangeListItem(InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).list[InterchangeListScreen(this.mScreens[this.mScreens.length - 1]).selectedItem]).request,"<ICN>") + "<*>");
            for(i = 0; i < directions.length; i++)
            {
               newEntry = new InterchangeListItem();
               switch(int(EisHelper.getValueOfType(String(directions[i]),"<ICT>")))
               {
                  case Interchange.DIRECTION_OUTBOUND:
                     newEntry.title = EisHelper.extractTextStringForTags(String(directions[i]),this.mStreetnameTagsDirections);
                     newEntry.request = "<IFT>RT<*><RTH>" + route.routeHandle + "<*>" + String(directions[i]) + "<ICT><*>";
                     newEntry.listEntryType = Interchange.LIST_ENTRY_TYPE_HAS_BRANCH;
                     break;
                  default:
                     newEntry.title = EisHelper.extractTextStringForTags(String(directions[i]),this.mStreetnameTagsDirections);
                     newEntry.request = "<IFT>RT<*><RTH>" + route.routeHandle + "<*>" + icn + String(directions[i]) + "<ICT><*>";
                     newEntry.listEntryType = Interchange.LIST_ENTRY_TYPE_HAS_BRANCH;
               }
               newListScreen.addListItem(newEntry);
            }
            if(newListScreen.list.length == 0)
            {
               newListScreen.addListItem(this.noResultsFoundListItem);
            }
            this.mScreens.push(newListScreen);
            this.sendEvent(InterchangeEvent.IC_SCREEN_UPDATE);
         }
      }
   }
}

