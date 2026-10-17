package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Style;
   import com.harman.navigation.NavigationApi;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.geographic.Coordinates;
   import com.nfuzion.geographic.Direction;
   import com.nfuzion.moduleLinkAPI.BluetoothEvent;
   import com.nfuzion.moduleLinkAPI.FuelPrice;
   import com.nfuzion.moduleLinkAPI.FuelStation;
   import com.nfuzion.moduleLinkAPI.FuelStationSortField;
   import com.nfuzion.moduleLinkAPI.TravelLinkFuelEvent;
   import com.nfuzion.moduleLinkAPI.TravelLinkStatus;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class TravelLinkFuelScreen extends TravelLinkGenericScreen
   {
      
      private static const FIND_BUTTON:String = "find_button";
      
      private static const FUEL_TYPES_BUTTON:String = "fuelType_button";
      
      private static const BRAND_BUTTON:String = "brand_button";
      
      private static const DISTANCE_BUTTON:String = "distance_button";
      
      private static const PRICE_BUTTON:String = "price_button";
      
      private static const DETAILS:String = "details";
      
      private static const PRICES:String = "prices";
      
      private static const TYPES:String = "types";
      
      private static const DEFAULT_FUELTYPE_POPUP_TIMEOUT:int = 2000;
      
      private var mCurrentDetailsView:FuelStation;
      
      private var mSubView:String = null;
      
      private var mCurrentView:MovieClip;
      
      public function TravelLinkFuelScreen()
      {
         mView = new C_TravelLinkFuelScreenView();
         cache = true;
         super();
      }
      
      override public function cleanup() : void
      {
         this.mCurrentDetailsView = null;
         this.mCurrentView = null;
         super.cleanup();
      }
      
      override protected function initView() : void
      {
         super.initView();
         pushBreadcrumb(new Breadcrumb(T.STRB_TRAVEL_LINK_BREADCRUMB,Breadcrumb.FUNCTION,goTravelLink));
         pushBreadcrumb(new Breadcrumb(T.STRB_FUEL_PRICES_BREADCRUMB,Breadcrumb.FUNCTION,this.setView,FIND_BUTTON));
         pushBreadcrumb(new Breadcrumb("",Breadcrumb.INERT));
         mView.views_group.setExclusiveChildren(true);
         mView.viewButtons_group.setRadioButtons(true);
         mView.viewButtons_group.setRequireSelection(true);
         mView.views_group.fuelBrowse_group.fuelStation_list.setRowUpdater(this.initStationsRow);
         mView.views_group.fuelBrowse_group.fuelStation_list.update();
         mView.views_group.fuelBrowse_group.fuelStation_list.setRowUpdater(this.updateStationsRow);
         mView.views_group.fuelBrowse_group.fuelStation_list.setDataRequester(Peripheral.travelLink.fuel.getStations);
         mView.views_group.fuelBrowse_group.fuelStation_list.setSelectionChanger(this.changeSelection);
         mView.views_group.fuelType_group.type_list.setRowUpdater(this.updateFuelTypesRow);
         mView.views_group.fuelType_group.type_list.setDataRequester(this.requestFuelTypesRow);
         mView.views_group.fuelType_group.type_list.setSelectionChanger(this.changeSelection);
         mView.views_group.fuelBrowse_group.columnHighlights_group.setExclusiveChildren(true);
         mView.views_group.fuelBrowse_group.sortButtons_group.setRadioButtons(true);
         mView.views_group.fuelBrowse_group.sortButtons_group.setRequireSelection(true);
         mView.views_group.fuelPrice_group.product_chain.setItemUpdater(this.updateFuelPriceItem);
         t(mView.defaultFuelType_label,"");
         t(mView.itemsInList_label,"");
         mView.list_scroller.setReportingPeriod(0);
         Peripheral.travelLink.fuel.setStationSortField(FuelStationSortField.DISTANCE);
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         switch(screenVars.favoriteData)
         {
            case "favoriteDetails":
               this.mSubView = null;
               this.mCurrentDetailsView = Peripheral.travelLink.fuel.favoriteStation;
               Peripheral.travelLink.fuel.getStationDetails(this.mCurrentDetailsView);
               mView.views_group.hideChildren();
               mView.refresh_button.visible = false;
               break;
            default:
               this.setView(FIND_BUTTON);
         }
         setViewSelection(mView.viewButtons_group,FIND_BUTTON);
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.fuelBrowse_group.fuelStation_list.onFocusCallBack));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.views_group.fuelBrowse_group.sortButtons_group.brand_button,mView.views_group.fuelBrowse_group.sortButtons_group.distance_button,mView.views_group.fuelBrowse_group.sortButtons_group.price_button,mView.views_group.fuelListingNone_group.sortButtons_group.brand_button,mView.views_group.fuelListingNone_group.sortButtons_group.distance_button,mView.views_group.fuelListingNone_group.sortButtons_group.price_button]));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[mView.viewButtons_group.find_button,mView.viewButtons_group.favorites_button,mView.viewButtons_group.fuelType_button,mView.refresh_button]));
      }
      
      override public function screenOut() : void
      {
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         attachListener(mView.viewButtons_group.favorites_button,MouseEvent.CLICK,this.onViewButtonClick);
         attachListener(mView.viewButtons_group.find_button,MouseEvent.CLICK,this.onViewButtonClick);
         attachListener(mView.viewButtons_group.fuelType_button,MouseEvent.CLICK,this.onViewButtonClick);
         attachListener(mView.back_button,MouseEvent.CLICK,this.goBack);
         attachListener(mView.travelLink_button,MouseEvent.CLICK,goTravelLink);
         attachListener(mView.views_group.fuelBrowse_group.sortButtons_group.brand_button,MouseEvent.CLICK,this.onHighlightButton);
         attachListener(mView.views_group.fuelBrowse_group.sortButtons_group.distance_button,MouseEvent.CLICK,this.onHighlightButton);
         attachListener(mView.views_group.fuelBrowse_group.sortButtons_group.price_button,MouseEvent.CLICK,this.onHighlightButton);
         attachListener(mView.views_group.fuelBrowse_group.fuelStation_list,WidgetEvent.SELECT,this.onStationsSelect);
         attachListener(mView.views_group.fuelType_group.type_list,WidgetEvent.SELECT,this.onFuelTypeSelect);
         attachListener(mView.views_group.fuelInfo_group.fuelPrices_button,MouseEvent.CLICK,this.onFuelPricesClick);
         attachListener(mView.views_group.fuelInfo_group.call_button,MouseEvent.CLICK,this.onCallClick);
         attachListener(mView.views_group.fuelInfo_group.goNow_button,MouseEvent.CLICK,this.onGoNowClick);
         attachListener(mView.views_group.fuelInfo_group.addToFavorites_button,MouseEvent.CLICK,this.onAddToFavoritesClick);
         attachListener(mView.refresh_button,MouseEvent.CLICK,this.onRefreshDataClick);
         if(Peripheral.travelLink.fuel.serviceStatus == TravelLinkStatus.READY)
         {
            this.onServiceStatus();
         }
         else
         {
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.SERVICE_STATUS,this.onServiceStatus);
            startWaiting();
         }
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_CONNECTED,this.onPhoneStateChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.BLUETOOTH_STATUS,this.onPhoneStateChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onPhoneStateChange);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onPhoneStateChange);
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.views_group.fuelBrowse_group.sortButtons_group.brand_button.value_label,T.STRB_BRAND);
         t(mView.views_group.fuelBrowse_group.sortButtons_group.distance_button.value_label,T.STRB_DISTANCE);
         t(mView.views_group.fuelBrowse_group.sortButtons_group.price_button.value_label,T.STRB_PRICE);
         t(mView.views_group.fuelType_group.listTitle_translate,T.STRB_SELECT_DEFAULT_FUEL_TYPE);
         t(mView.views_group.fuelInfo_group.call_button.value_label,T.STRB_CALL_TRAVELLINK);
         t(mView.views_group.fuelInfo_group.goNow_button.value_label,T.STRB_GO_NOW_TRAVELLINK);
         t(mView.views_group.fuelInfo_group.addToFavorites_button.value_label,T.STRB_ADD);
         t(mView.views_group.fuelInfo_group.fuelPrices_button.value_label,T.STRB_FUEL_PRICES_TRAVELLINKFUEL);
         t(mView.refresh_button.value_label,T.STRB_REFRESH_DATA);
         t(mView.viewButtons_group.favorites_button.value_label,T.STRB_FAVOURITES);
         t(mView.viewButtons_group.find_button.value_label,T.STRB_FIND);
         t(mView.viewButtons_group.fuelType_button.value_label,T.STRB_FUEL_TYPE);
         t(mView.views_group.fuelListingNone_group.label_translate,T.STRB_NO_DATA_AVAILABLE);
         t(mView.views_group.fuelListingNone_group.sortButtons_group.brand_button.value_label,T.STRB_BRAND);
         t(mView.views_group.fuelListingNone_group.sortButtons_group.distance_button.value_label,T.STRB_DISTANCE);
         t(mView.views_group.fuelListingNone_group.sortButtons_group.price_button.value_label,T.STRB_PRICE);
         t(mView.defaultFuelType_label,this.translateWellKnownFuelTypes(Peripheral.travelLink.fuel.defaultFuelType));
         mView.views_group.fuelBrowse_group.fuelStation_list.update();
         mView.views_group.fuelPrice_group.product_chain.update();
         mView.views_group.fuelType_group.type_list.update();
      }
      
      private function initStationsRow(row:MovieClip, rowIndex:int, station:FuelStation, stationIndex:int) : void
      {
         var button:MovieClip = row.fuelStation_button;
         button.setEnabled(false);
         button.setInteractive(false);
         button.favorite_icon.visible = false;
         button.favorite_icon.gotoAndStop("fav");
         button.brand_label.visible = false;
         button.distance_label.visible = false;
         button.price_label.visible = false;
         button.date_label.visible = false;
         button.direction_icon.visible = false;
      }
      
      private function updateStationsRow(row:MovieClip, rowIndex:int, station:FuelStation, stationIndex:int) : void
      {
         var button:MovieClip = row.fuelStation_button;
         var tempDirection:Direction = new Direction();
         var currentDirection:Number = 360 - Number(NavigationApi.api.posPositionInformation.getType("<DIR>")) / 255 * 360;
         if(station != null)
         {
            button.setEnabled(true);
            button.setInteractive(true);
            button.brand_label.visible = true;
            button.distance_label.visible = true;
            button.price_label.visible = true;
            button.date_label.visible = true;
            button.favorite_icon.visible = station.favorite;
            t(button.brand_label,Format.nameCase(station.brand));
            if(isNaN(station.distance.miles))
            {
               t(button.distance_label,T.STRB_NA);
            }
            else if(useUSDistanceUnits())
            {
               t(button.distance_label,[station.distance.miles.toFixed(Style.TravelLinkFuelScreen.DISTANCE_PRECISION),T.STRB_MI]);
            }
            else
            {
               t(button.distance_label,[station.distance.kilometers.toFixed(Style.TravelLinkFuelScreen.DISTANCE_PRECISION),T.STRB_KM]);
            }
            if(station.defaultPrice != null)
            {
               t(button.price_label,station.defaultPrice);
            }
            else
            {
               t(button.price_label,T.STRB_NA);
            }
            t(button.date_label,this.translateDaysOld(station.daysOld));
            tempDirection.degrees = station.bearing.degrees - currentDirection;
            if(tempDirection.degrees < 0)
            {
               tempDirection.degrees = (tempDirection.degrees + 360) % 360;
            }
            if(tempDirection.ordinal != "")
            {
               button.direction_icon.visible = true;
               button.direction_icon.gotoAndStop(tempDirection.ordinal);
            }
            else
            {
               button.direction_icon.visible = false;
            }
         }
         else
         {
            button.setEnabled(false);
            button.setInteractive(false);
            button.favorite_icon.visible = false;
            button.brand_label.visible = false;
            button.distance_label.visible = false;
            button.price_label.visible = false;
            button.date_label.visible = false;
            button.direction_icon.visible = false;
         }
      }
      
      private function updateFuelTypesRow(row:MovieClip, rowIndex:int, fuelType:String, fuelTypeIndex:int) : void
      {
         var button:MovieClip = row.fuelType_button;
         if(fuelType != null)
         {
            button.visible = true;
            t(button.name_label,this.translateWellKnownFuelTypes(fuelType));
         }
         else
         {
            button.visible = false;
         }
      }
      
      private function translateWellKnownFuelTypes(fuelType:String) : String
      {
         switch(fuelType)
         {
            case "Regular":
               return compose(T.STRB_REGULAR);
            case "Mid-Range":
               return compose(T.STRB_MID_RANGE);
            case "Premium":
               return compose(T.STRB_PREMIUM);
            case "Diesel":
               return compose(T.STRB_DIESEL);
            default:
               return fuelType;
         }
      }
      
      private function requestFuelTypesRow(start:int, end:int) : void
      {
         var i:int = 0;
         var view:Vector.<String> = new Vector.<String>();
         if(end >= Peripheral.travelLink.fuel.fuelTypes.length)
         {
            end = Peripheral.travelLink.fuel.fuelTypes.length - 1;
         }
         if(start < Peripheral.travelLink.fuel.fuelTypes.length)
         {
            for(i = start; i <= end; i++)
            {
               view.push(Peripheral.travelLink.fuel.fuelTypes[i]);
            }
         }
         mView.views_group.fuelType_group.type_list.setData({
            "offset":start,
            "list":view
         });
      }
      
      private function setView(view:String) : void
      {
         switch(view)
         {
            case FIND_BUTTON:
               setViewSelection(mView.viewButtons_group,view);
               this.mSubView = null;
               mView.list_scroller.visible = true;
               mView.views_group.fuelBrowse_group.show();
               popBreadcrumb();
               pushBreadcrumb(new Breadcrumb(T.STRB_FIND_BREADCRUMB,Breadcrumb.FUNCTION,this.setView,FIND_BUTTON));
               mView.views_group.fuelType_group.type_list.detachScroller();
               mView.views_group.fuelBrowse_group.fuelStation_list.attachScroller(mView.list_scroller);
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.views_group.fuelBrowse_group.fuelStation_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.views_group.fuelBrowse_group.fuelStation_list.selectEventHandler);
               mView.refresh_button.visible = true;
               mView.itemsInList_label.visible = true;
               this.mCurrentDetailsView = null;
               this.mCurrentView = mView.views_group.fuelBrowse_group;
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.fuelBrowse_group.fuelStation_list.onFocusCallBack));
               break;
            case FAVORITES_BUTTON:
               goFavorite();
               break;
            case FUEL_TYPES_BUTTON:
               setViewSelection(mView.viewButtons_group,view);
               this.mSubView = DETAILS;
               mView.list_scroller.visible = true;
               mView.views_group.fuelType_group.show();
               popBreadcrumb();
               pushBreadcrumb(new Breadcrumb(T.STRB_FUEL_TYPES_BREADCRUMB,Breadcrumb.FUNCTION,this.setView,FUEL_TYPES_BUTTON));
               swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.views_group.fuelType_group.type_list.scrollEventHandler);
               swapListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.views_group.fuelType_group.type_list.selectEventHandler);
               mView.views_group.fuelBrowse_group.fuelStation_list.detachScroller();
               mView.views_group.fuelType_group.type_list.attachScroller(mView.list_scroller);
               mView.refresh_button.visible = false;
               mView.itemsInList_label.visible = false;
               mView.views_group.fuelType_group.type_list.requestData();
               this.mCurrentView = mView.views_group.fuelType_group;
               Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.views_group.fuelType_group.type_list.onFocusCallBack));
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.views_group.fuelBrowse_group.sortButtons_group.brand_button,mView.views_group.fuelBrowse_group.sortButtons_group.distance_button,mView.views_group.fuelBrowse_group.sortButtons_group.price_button,mView.views_group.fuelListingNone_group.sortButtons_group.brand_button,mView.views_group.fuelListingNone_group.sortButtons_group.distance_button,mView.views_group.fuelListingNone_group.sortButtons_group.price_button]));
      }
      
      private function updateFuelPriceItem(item:MovieClip, fuelPrice:FuelPrice) : void
      {
         t(item.price_label,fuelPrice.price);
         t(item.product_label,this.translateWellKnownFuelTypes(fuelPrice.name));
      }
      
      override protected function positionUpdate(coordinates:Coordinates) : void
      {
         mView.views_group.fuelBrowse_group.fuelStation_list.requestData();
      }
      
      private function showDetails() : void
      {
         mView.views_group.fuelInfo_group.show();
         this.mSubView = DETAILS;
      }
      
      override protected function onWaitingTimeout() : void
      {
         Framework.Trace("TLM: Please wait 4min timeout");
         mView.views_group.fuelListingNone_group.show();
      }
      
      override protected function onFromTLFavScreen(fromTLFavScreen:Boolean) : void
      {
         if(fromTLFavScreen)
         {
            mView.viewButtons_group.setSelection(FAVORITES_BUTTON);
         }
      }
      
      override protected function back(e:Event = null) : void
      {
         this.goBack();
      }
      
      private function goBack(e:MouseEvent = null) : void
      {
         if(!isBackAfterJustAddedFavorite())
         {
            if(isFromTLFavScreen)
            {
               super.back();
            }
            else if(this.mCurrentView == mView.views_group.fuelBrowse_group)
            {
               super.back();
            }
            else if(this.mCurrentView == mView.views_group.fuelType_group)
            {
               this.setView(FIND_BUTTON);
            }
            else if(this.mCurrentView == mView.views_group.fuelInfo_group)
            {
               this.setView(FIND_BUTTON);
            }
            else if(this.mCurrentView == mView.views_group.fuelPrice_group)
            {
               this.mCurrentView = mView.views_group.fuelInfo_group;
               this.showDetails();
            }
            else
            {
               super.back();
            }
         }
      }
      
      private function onFuelPricesClick(e:MouseEvent) : void
      {
         var fuelPrice:MovieClip = mView.views_group.fuelPrice_group;
         fuelPrice.show();
         fuelPrice.favorite_icon.visible = this.mCurrentDetailsView.favorite;
         t(fuelPrice.name_label,Format.nameCase(this.mCurrentDetailsView.name));
         t(fuelPrice.info_label,[T.STRB_LAST_UPDATED,this.translateDaysOld(this.mCurrentDetailsView.daysOld)]);
         fuelPrice.product_chain.setLinks(this.mCurrentDetailsView.prices);
         this.mSubView = PRICES;
         this.mCurrentView = mView.views_group.fuelPrice_group;
      }
      
      private function onCallClick(e:MouseEvent) : void
      {
         if(phoneAvailable)
         {
            dial(this.mCurrentDetailsView.phone);
         }
         else if(!Peripheral.vehicleStatus.speedLockOut)
         {
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "status":"no phone paired",
               "timeout":30000
            });
         }
         else
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
      }
      
      private function onGoNowClick(e:MouseEvent) : void
      {
         var addressArray:Array = this.mCurrentDetailsView.address.split(" ");
         var houseNumber:String = addressArray[0];
         addressArray.shift();
         var street:String = addressArray.join(" ");
         var navString:String = "<GEO>" + this.mCurrentDetailsView.coordinates.longitude.toFixed(6) + " " + this.mCurrentDetailsView.coordinates.latitude.toFixed(6) + "<*>" + "<CTR>United States<*>" + "<CUSTOM_NAME>" + Format.nameCase(this.mCurrentDetailsView.name) + "<*>" + "<TEL>" + this.mCurrentDetailsView.phone + "<*>" + "<ZIP>" + this.mCurrentDetailsView.zip + "<*>" + "<CTY>" + Format.nameCase(this.mCurrentDetailsView.city) + "<*>" + "<HNO>" + houseNumber + "<*>" + "<STR>" + Format.nameCase(street) + "<*>";
         Peripheral.navigation.navDomainControl.setExternalDestination(navString,"mainbackground/menu/travellinkfuelscreen");
      }
      
      private function onAddToFavoritesClick(e:MouseEvent) : void
      {
         var cityStateZip:String = Format.nameCase(this.mCurrentDetailsView.city) + ", " + this.mCurrentDetailsView.state + " " + this.mCurrentDetailsView.zip;
         var favAction:String = Peripheral.travelLink.fuel.favoriteStation.id != -1 ? Peripheral.travelLink.replaceFavorite : Peripheral.travelLink.addFavorite;
         var favObj:Object = {
            "line1":Format.nameCase(this.mCurrentDetailsView.name),
            "line2":Format.nameCase(this.mCurrentDetailsView.address),
            "line3":cityStateZip,
            "line4":this.mCurrentDetailsView.phone,
            "action":favAction,
            "service":Peripheral.travelLink.TLFuel
         };
         addToFavoritesPopup(favObj);
      }
      
      override protected function onConfirmedAddToFavorites() : void
      {
         Peripheral.travelLink.fuel.setFavoriteStation(this.mCurrentDetailsView);
         Peripheral.travelLink.fuel.getStationDetails(this.mCurrentDetailsView);
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         JustAddedFavorite = true;
      }
      
      private function onStationDetails(e:TravelLinkFuelEvent) : void
      {
         var fuelInfo:MovieClip = null;
         var stationDetails:FuelStation = e.data as FuelStation;
         if(this.mCurrentDetailsView != null && stationDetails.id == this.mCurrentDetailsView.id)
         {
            popBreadcrumb();
            pushBreadcrumb(new Breadcrumb(T.STRB_INFORMATION_BREADCRUMB,Breadcrumb.FUNCTION,this.showDetails));
            swapListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL);
            swapListener(Peripheral.hardControls,HardControlEvent.SELECT);
            mView.refresh_button.visible = false;
            mView.itemsInList_label.visible = false;
            mView.list_scroller.visible = false;
            this.mCurrentDetailsView = stationDetails;
            fuelInfo = mView.views_group.fuelInfo_group;
            fuelInfo.show();
            fuelInfo.favorite_icon.visible = this.mCurrentDetailsView.favorite;
            t(fuelInfo.name_label,Format.nameCase(this.mCurrentDetailsView.name));
            t(fuelInfo.address_label,Format.nameCase(this.mCurrentDetailsView.address) + "\n" + Format.nameCase(this.mCurrentDetailsView.city) + ", " + this.mCurrentDetailsView.state + "  " + this.mCurrentDetailsView.zip);
            t(fuelInfo.phone_label,this.mCurrentDetailsView.phone);
            fuelInfo.addToFavorites_button.setEnabled(!this.mCurrentDetailsView.favorite);
            fuelInfo.addToFavorites_button.setInteractive(!this.mCurrentDetailsView.favorite);
            fuelInfo.call_button.setEnabled(phoneAvailable);
            fuelInfo.call_button.setInteractive(true);
            fuelInfo.goNow_button.setEnabled(Peripheral.navigation.navigation.navIsReady);
            fuelInfo.goNow_button.setInteractive(Peripheral.navigation.navigation.navIsReady);
            this.mSubView = DETAILS;
            this.mCurrentView = mView.views_group.fuelInfo_group;
         }
      }
      
      private function onStationsSelect(e:WidgetEvent) : void
      {
         this.mCurrentDetailsView = e.data.data;
         Peripheral.travelLink.fuel.getStationDetails(this.mCurrentDetailsView);
         mView.refresh_button.visible = false;
         mView.itemsInList_label.visible = false;
         mView.views_group.hideChildren();
         Framework.focusManager.setFocus(FocusPriority.REGULAR);
         Framework.focusManager.delFocus(Framework.focusManager.getFocus());
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,[mView.views_group.fuelInfo_group.fuelPrices_button,mView.views_group.fuelInfo_group.call_button,mView.views_group.fuelInfo_group.goNow_button,mView.views_group.fuelInfo_group.addToFavorites_button]));
      }
      
      private function onFuelTypeSelect(e:WidgetEvent) : void
      {
         Peripheral.travelLink.fuel.setDefaultFuelType(e.data.data);
         Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
         this.setView(FIND_BUTTON);
         this.mSubView = DETAILS;
      }
      
      private function onHighlightButton(e:MouseEvent) : void
      {
         var sortField:String = null;
         switch(e.currentTarget.name)
         {
            case BRAND_BUTTON:
               sortField = FuelStationSortField.BRAND;
               break;
            case DISTANCE_BUTTON:
               sortField = FuelStationSortField.DISTANCE;
               break;
            case PRICE_BUTTON:
               sortField = FuelStationSortField.PRICE;
         }
         if(sortField)
         {
            Peripheral.travelLink.fuel.setStationSortField(sortField);
            Peripheral.travelLink.fuel.getNearestStations();
         }
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function onSortField(e:TravelLinkFuelEvent) : void
      {
         var highlights:MovieClip = mView.views_group.fuelBrowse_group.columnHighlights_group;
         var buttons:MovieClip = mView.views_group.fuelBrowse_group.sortButtons_group;
         switch(Peripheral.travelLink.fuel.stationSortField)
         {
            case FuelStationSortField.BRAND:
               highlights.brand_simple.show();
               buttons.setSelection("brand_button");
               break;
            case FuelStationSortField.DISTANCE:
               highlights.distance_simple.show();
               buttons.setSelection("distance_button");
               break;
            case FuelStationSortField.PRICE:
               highlights.price_simple.show();
               buttons.setSelection("price_button");
         }
         mView.views_group.fuelBrowse_group.fuelStation_list.setPosition(0);
         mView.views_group.fuelBrowse_group.fuelStation_list.setCursor(0);
         mView.views_group.fuelBrowse_group.fuelStation_list.requestData();
      }
      
      private function onFuelTypes(e:TravelLinkFuelEvent) : void
      {
         mView.views_group.fuelType_group.type_list.setLength(Peripheral.travelLink.fuel.fuelTypes.length);
         mView.views_group.fuelType_group.type_list.requestData();
         mView.views_group.fuelType_group.type_list.setCursor(0);
         mView.views_group.fuelType_group.type_list.setPosition(0);
      }
      
      private function onStationsCount(e:TravelLinkFuelEvent) : void
      {
         var count:int = int(Peripheral.travelLink.fuel.stationsCount);
         mView.views_group.fuelBrowse_group.fuelStation_list.setLength(count);
         t(mView.itemsInList_label,Format.itemsInList(count));
         mView.views_group.fuelBrowse_group.fuelStation_list.setCursor(0);
         mView.views_group.fuelBrowse_group.fuelStation_list.setPosition(0);
         mView.views_group.fuelBrowse_group.fuelStation_list.requestData();
      }
      
      private function onStations(e:TravelLinkFuelEvent) : void
      {
         stopWaiting();
         mView.views_group.fuelBrowse_group.fuelStation_list.setData(e.data);
      }
      
      private function onDefaultFuelType(e:TravelLinkFuelEvent) : void
      {
         var type:String = Peripheral.travelLink.fuel.defaultFuelType;
         if(type == null)
         {
            type = "";
         }
         type = this.translateWellKnownFuelTypes(type);
         if(mView.defaultFuelType_label.text != "" && mView.defaultFuelType_label.text != type)
         {
            Framework.popupManager.show(DynamicPopupNames.OPTIONS_DEFAULT_FUEL_TYPE,"errorpopupscreen",{
               "type":PopupType.OPTIONS,
               "body":compose(["\n",T.STRB_ERROR_BODY_FUEL_TYPE_CHANGED]) + type,
               "closeButton":true,
               "timeout":DEFAULT_FUELTYPE_POPUP_TIMEOUT
            });
         }
         t(mView.defaultFuelType_label,type);
         Peripheral.travelLink.fuel.getNearestStations();
      }
      
      private function onViewButtonClick(e:MouseEvent) : void
      {
         if(e.currentTarget.name != FAVORITES_BUTTON)
         {
            isFromTLFavScreen = false;
         }
         this.setView(e.currentTarget.name);
         JustAddedFavorite = false;
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function onRefreshDataClick(e:MouseEvent) : void
      {
         Peripheral.travelLink.fuel.getNearestStations();
         startWaiting();
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function onServiceStatus(e:TravelLinkFuelEvent = null) : void
      {
         if(Peripheral.travelLink.fuel.serviceStatus == TravelLinkStatus.READY)
         {
            detachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.SERVICE_STATUS,this.onServiceStatus);
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.DEFAULT_FUEL_TYPE,this.onDefaultFuelType);
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.STATIONS_COUNT,this.onStationsCount);
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.FUEL_TYPES,this.onFuelTypes);
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.STATION_SORT_FIELD,this.onSortField);
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.FAVORITE_STATION,this.onFavoriteStation);
            Peripheral.travelLink.fuel.getStationSortField();
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.STATIONS,this.onStations);
            attachListener(Peripheral.travelLink.fuel,TravelLinkFuelEvent.STATION_DETAILS,this.onStationDetails);
            if(!screenVars.favoriteData)
            {
               Peripheral.travelLink.fuel.getNearestStations();
               startWaiting();
            }
            attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_CONNECTED,this.onPhoneStateChange);
            attachListener(Peripheral.bluetooth,BluetoothEvent.BLUETOOTH_STATUS,this.onPhoneStateChange);
            attachListener(Peripheral.bluetooth,BluetoothEvent.DEVICE_CONNECT_OK,this.onPhoneStateChange);
            attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onPhoneStateChange);
         }
      }
      
      private function onFavoriteStation(e:TravelLinkFuelEvent) : void
      {
         if(Boolean(this.mCurrentDetailsView) && this.mCurrentDetailsView.id >= 0)
         {
            Peripheral.travelLink.fuel.getStationDetails(this.mCurrentDetailsView);
         }
         mView.views_group.fuelBrowse_group.fuelStation_list.requestData();
      }
      
      private function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         (row.getChildAt(0) as MovieClip).setSelected(selected);
      }
      
      private function onPhoneStateChange(e:BluetoothEvent) : void
      {
         if(mView.views_group.fuelInfo_group.visible)
         {
            mView.views_group.fuelInfo_group.call_button.setEnabled(phoneAvailable);
         }
      }
      
      private function translateDaysOld(daysOld:String) : String
      {
         if(daysOld == null)
         {
            return compose(T.STRB_NA);
         }
         if(daysOld == ">2 Days")
         {
            return compose(T.STRB_FUEL_GREATER_THAN_2_DAYS);
         }
         return daysOld;
      }
   }
}

