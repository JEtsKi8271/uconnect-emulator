package screens.NA_EU.RES_640x480
{
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import ancillary.Style;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.StructureEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class PhoneRecentCallScreen extends GenericScreen
   {
      
      private static const MAX_FAVORITES:int = 7;
      
      private static const ALL_CALLS_BUTTON:String = "allCalls_button";
      
      private static const INCOMING_CALLS_BUTTON:String = "incomingCalls_button";
      
      private static const OUTGOING_CALLS_BUTTON:String = "outgoingCalls_button";
      
      private static const MISSED_CALLS_BUTTON:String = "missedCalls_button";
      
      private static const MAX_CALL_COUNT:uint = 20;
      
      private static const CALL:int = 0;
      
      private static const ADD_TO_FAVS:int = 1;
      
      private static const SEND_TEXT_MSG:int = 2;
      
      private var mID:int = 0;
      
      private var mMenuState:int = 0;
      
      private var mCurrentCallList:String = "allCallsList";
      
      private var mLastCallOffset:int = 0;
      
      private var mDetails:Vector.<Object> = null;
      
      private var mRequestedList:Boolean = false;
      
      private var mCallListCount:int = 0;
      
      private var mContactNameDisplayed:Boolean = false;
      
      private var mAddingFavorite:Boolean = false;
      
      private var DETAILS_CURSOR_POS_NO_NAME:int = 0;
      
      private var DETAILS_CURSOR_POS_NAME_AVAILABLE:int = 1;
      
      private var mSendTextMsgNumber:String = "";
      
      private var mSendTextMsgName:String = "";
      
      private var mFavNumber:String = "";
      
      private var mFavName:String = "";
      
      private var mFavNumberType:String = "";
      
      private var mCallName:String = "";
      
      private var mPhonebookContact:PhoneBookContact = new PhoneBookContact();
      
      private var setupFavList:Boolean = false;
      
      public function PhoneRecentCallScreen()
      {
         mView = new C_PhoneRecentCallScreenView();
         super();
      }
      
      override protected function initView() : void
      {
         super.initView();
         mView.viewButtons_group.setRadioButtons(true);
         mView.viewButtons_group.setSelection(ALL_CALLS_BUTTON);
         mView.viewButtons_group.setRequireSelection(true);
         mView.phone_list.setSelectionChanger(this.changeSelection);
         mView.phone_list.setBufferSize(Style.PhoneRecentCallScreen.LIST_BUFFER_SIZE);
         mView.phone_scroller.setReportingPeriod(Style.PlayerBrowseScreen.SCROLLER_REPORTING_PERIOD);
         this.mRequestedList = false;
      }
      
      override public function cleanup() : void
      {
         this.mCurrentCallList = null;
         this.mDetails = null;
         this.mPhonebookContact = null;
         super.cleanup();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         switch(screenVars.value)
         {
            case "all":
               mView.viewButtons_group.setSelection(ALL_CALLS_BUTTON);
               break;
            case "incoming":
               mView.viewButtons_group.setSelection(INCOMING_CALLS_BUTTON);
               break;
            case "missed":
               mView.viewButtons_group.setSelection(MISSED_CALLS_BUTTON);
               break;
            case "outgoing":
               mView.viewButtons_group.setSelection(OUTGOING_CALLS_BUTTON);
         }
         this.setView(mView.viewButtons_group.getSelection());
         mView.cancel_button.visible = false;
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.phone_list.onFocusCallBack));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.viewButtons_group.allCalls_button,mView.viewButtons_group.incomingCalls_button,mView.viewButtons_group.outgoingCalls_button,mView.viewButtons_group.missedCalls_button]));
      }
      
      override public function screenOut() : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_RECENT_CALLS);
         mView.viewButtons_group.setSelection(ALL_CALLS_BUTTON);
         this.mAddingFavorite = false;
         this.mDetails = null;
         super.screenOut();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         mView.phone_list.attachScroller(mView.phone_scroller);
         attachListener(mView.close_button,MouseEvent.CLICK,close);
         attachListener(mView.back_button,MouseEvent.CLICK,this.goBack);
         attachListener(mView.cancel_button,MouseEvent.CLICK,this.onCancelAddFavorites,false,0,true);
         attachListener(mView.viewButtons_group,WidgetEvent.SELECT,this.onViewButton);
         attachListener(mView.phone_list,WidgetEvent.SELECT,this.onListSelect);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange,false,0,true);
         attachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.phone_list.scrollEventHandler);
         attachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.phone_list.selectEventHandler);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.gotoPhoneMainScreen,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.FAVORITES_LIST,this.onHandleFavoritesData,false,0,true);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_GET_DETAILS,this.onVRSmsGetDetails,false,0,true);
         Framework.structure.addEventListener(StructureEvent.REFRESH_STRUCTURE,this.onRefresh,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         super.removeListeners();
         detachListener(mView.close_button,MouseEvent.CLICK,close);
         detachListener(mView.back_button,MouseEvent.CLICK,this.goBack);
         detachListener(mView.cancel_button,MouseEvent.CLICK,this.onCancelAddFavorites);
         detachListener(mView.viewButtons_group,WidgetEvent.SELECT,this.onViewButton);
         detachListener(mView.phone_list,WidgetEvent.SELECT,this.onListSelect);
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.phone_list.scrollEventHandler);
         detachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.phone_list.selectEventHandler);
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.gotoPhoneMainScreen);
         detachListener(Peripheral.phonebook,PhoneBookEvent.FAVORITES_LIST,this.onHandleFavoritesData);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_GET_DETAILS,this.onVRSmsGetDetails);
         Framework.structure.removeEventListener(StructureEvent.REFRESH_STRUCTURE,this.onRefresh);
         mView.phone_list.detachScroller();
      }
      
      protected function gotoPhoneMainScreen(e:BluetoothEvent) : void
      {
         if(Peripheral.bluetooth.currentHFPDevice == null)
         {
            Framework.Trace("------------>ENTERED gotoPhoneMainScreen PhoneBookScreen");
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
      
      private function onHandleFavoritesData(e:PhoneBookEvent) : void
      {
         var fav_contact:PhoneBookContact = null;
         var idx:int = 0;
         var idx_vec:int = 0;
         var vec_list:Vector.<PhoneBookContact> = new Vector.<PhoneBookContact>();
         var vec:Vector.<PhoneBookContact> = Peripheral.phonebook.favoritesList(this.mID);
         for(idx_vec = 0; idx_vec < vec.length; idx_vec++)
         {
            if(vec[idx_vec].favIndex < 1 || vec[idx_vec].favIndex > MAX_FAVORITES)
            {
               Peripheral.phonebook.deleteFavorite(vec[idx_vec]);
            }
         }
         for(idx = 0; idx < 5; idx++)
         {
            for(idx_vec = 0; idx_vec < vec.length; idx_vec++)
            {
               if(vec[idx_vec].favIndex - 1 == idx)
               {
                  vec_list.push(new PhoneBookContact(vec[idx_vec],idx));
               }
            }
            if(vec_list.length <= idx)
            {
               fav_contact = new PhoneBookContact();
               fav_contact.formattedName = "XXX";
               fav_contact.favIndex = 255;
               vec_list.push(new PhoneBookContact(fav_contact,idx));
            }
         }
         if(this.setupFavList == true)
         {
            mView.phone_list.setData({
               "offset":0,
               "list":vec_list
            });
            this.setupFavList = false;
         }
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.cancel_button.value_label,T.STRB_CANCEL);
         t(mView.viewButtons_group.allCalls_button.value_label,T.STRB_ALL_CALLS);
         t(mView.viewButtons_group.incomingCalls_button.value_label,T.STRB_INCOMING_CALLS);
         t(mView.viewButtons_group.outgoingCalls_button.value_label,T.STRB_OUTGOING_CALLS);
         t(mView.viewButtons_group.missedCalls_button.value_label,T.STRB_MISSED_CALLS);
         mView.updateCategoriesButtonLabel();
         mView.phone_list.update();
      }
      
      private function updateCallRow(row:MovieClip, rowNumber:int, data:PhoneCallListEntry, dataIndex:int) : void
      {
         var foundName:Boolean = false;
         this.hideListButtonsElements(row);
         if(data != null && this.mCallListCount > 0)
         {
            row.call_group.visible = true;
            switch(data.StorageType)
            {
               case PhoneCallListEntry.DIALED:
                  row.call_group.callType_icon.gotoAndStop("outgoing");
                  break;
               case PhoneCallListEntry.RECEIVED:
                  row.call_group.callType_icon.gotoAndStop("incoming");
                  break;
               case PhoneCallListEntry.MISSED:
                  row.call_group.callType_icon.gotoAndStop("missed");
            }
            switch(data.callType)
            {
               case "workNumber":
                  row.call_group.nbrtype.gotoAndStop("work");
                  row.call_group.nbrtype.visible = true;
                  break;
               case "mobileNumber":
                  row.call_group.nbrtype.gotoAndStop("mobile");
                  row.call_group.nbrtype.visible = true;
                  break;
               case "homeNumber":
                  row.call_group.nbrtype.gotoAndStop("home");
                  row.call_group.nbrtype.visible = true;
                  break;
               case "otherNumber":
                  row.call_group.nbrtype.gotoAndStop("circle");
                  row.call_group.nbrtype.visible = true;
                  break;
               default:
                  row.call_group.nbrtype.visible = false;
            }
            foundName = false;
            if(data.phoneNumber == Peripheral.phonebook.towingAssistanceNumber && data.phoneNumber != "")
            {
               t(row.call_group.name_label,T.STRB_PHONE_TOWING_ASSISTANCE);
               foundName = true;
            }
            else if(data.phoneNumber == Peripheral.phonebook.emergencyNumber && data.phoneNumber != "")
            {
               t(row.call_group.name_label,T.STRB_MENU_EMERGENCY);
               foundName = true;
            }
            else if(data.phoneNumber != data.firstName)
            {
               t(row.call_group.name_label,data.firstName);
               if(row.call_group.name_label.text != "" && data.lastName != "")
               {
                  row.call_group.name_label.text += " " + data.lastName;
                  t(row.call_group.name_label,row.call_group.name_label.text);
               }
               foundName = true;
            }
            if(row.call_group.name_label.text == "" || foundName == false)
            {
               if(data.phoneNumber == "")
               {
                  t(row.call_group.name_label,T.STRB_PHONE_PRIVATE_NUMBER_2);
               }
               else
               {
                  t(row.call_group.name_label,Format.phoneNumber(data.phoneNumber));
               }
            }
         }
         else if(rowNumber == 0 && this.mRequestedList && this.mCallListCount <= 0)
         {
            t(row.details_group.name_label,T.STRB_PHONE_NO_RECENT_CALLS);
            row.details_group.numberType_icon.visible = false;
            row.details_group.dial_group.visible = false;
            row.details_group.visible = true;
            row.call_group.visible = false;
         }
         else
         {
            this.hideListButtonsElements(row);
         }
      }
      
      private function requestCallListData(start:int, end:int) : void
      {
         this.mLastCallOffset = start;
         var length:int = end - start + 1;
         Peripheral.phoneCallList.requestCallList(this.mCurrentCallList,start,length);
      }
      
      private function updateFavoritesRow(row:MovieClip, rowIndex:int, data:PhoneBookContact, dataIndex:int) : void
      {
         var label:String = null;
         var type:String = null;
         this.hideListButtonsElements(row);
         t(row.details_group.select_label,T.STRB_SELECT_PHONEBOOK);
         row.details_group.visible = true;
         this.setRowEnabled(row,true);
         if(data != null)
         {
            label = "";
            type = null;
            if(data.homeNumber != "")
            {
               row.details_group.name_label.textColor = 16777215;
               label = Format.phoneNumber(data.homeNumber);
               type = "home";
            }
            else if(data.mobileNumber != "")
            {
               row.details_group.name_label.textColor = 16777215;
               label = Format.phoneNumber(data.mobileNumber);
               type = "mobile";
            }
            else if(data.workNumber != "")
            {
               row.details_group.name_label.textColor = 16777215;
               label = Format.phoneNumber(data.workNumber);
               type = "work";
            }
            else if(data.otherNumber != "")
            {
               row.details_group.name_label.textColor = 16777215;
               label = Format.phoneNumber(data.otherNumber);
               type = "circle";
            }
            else if(data.favIndex == 255)
            {
               type = null;
            }
            if("" != data.formattedName)
            {
               label = data.formattedName;
            }
            row.details_group.name_label.text = label;
            if(type != null)
            {
               row.details_group.numberType_icon.gotoAndStop(type);
               row.details_group.numberType_icon.visible = true;
            }
            row.details_group.dial_group.visible = false;
            row.options_button.visible = false;
            t(mView.itemsInList_label,Format.itemsInList(5));
         }
         else
         {
            this.hideListButtonsElements(row);
         }
         row.details_group.select_label.visible = this.mAddingFavorite;
      }
      
      private function requestFavoritesData(start:int, end:int) : void
      {
         var length:int = end - start + 1;
         this.mID = Peripheral.phonebook.requestFavoritesByRange(0,MAX_FAVORITES);
      }
      
      private function updateDetailsRow(row:MovieClip, rowNumber:int, data:Object, dataIndex:int) : void
      {
         var dialButton:Boolean = false;
         this.hideListButtonsElements(row);
         row.details_group.select_label.visible = false;
         row.row_button.setInteractive(true);
         row.row_button.setEnabled(true);
         if(data != null)
         {
            row.details_group.visible = true;
            this.setRowEnabled(row,data.dial);
            t(row.details_group.name_label,data.name);
            if(data.type == "none")
            {
               row.details_group.numberType_icon.visible = false;
            }
            else
            {
               row.details_group.numberType_icon.visible = true;
               row.details_group.numberType_icon.gotoAndStop(data.type);
            }
            row.details_group.dial_group.visible = data.dial;
            dialButton = (Peripheral.bluetoothPhone.getHoldingCall() == null || Peripheral.bluetoothPhone.getActiveCall() == null) && Peripheral.bluetoothPhone.conferenceCall() == null;
            row.details_group.setLabelFont(dialButton);
            row.row_button.setInteractive(dialButton);
            row.row_button.setEnabled(dialButton);
            if(data.dial)
            {
               row.options_button.visible = true;
            }
            else
            {
               row.options_button.visible = false;
            }
            row.details_group.dial_group.dial_translate.text = compose(T.STRB_CALL_RECENT);
            if(0 == rowNumber && !this.mContactNameDisplayed)
            {
               mView.phone_list.setCursor(this.DETAILS_CURSOR_POS_NO_NAME);
            }
            else if(1 == rowNumber && this.mContactNameDisplayed)
            {
               mView.phone_list.setCursor(this.DETAILS_CURSOR_POS_NAME_AVAILABLE);
            }
            if(1 == rowNumber)
            {
               if(data.dial)
               {
                  row.details_group.dial_group.visible = true;
                  row.options_button.visible = true;
                  row.options_button.setEnabled(true);
                  row.options_button.setInteractive(true);
               }
               else
               {
                  row.details_group.dial_group.visible = false;
                  row.options_button.visible = false;
                  row.options_button.setEnabled(false);
                  row.options_button.setInteractive(false);
               }
            }
         }
         else
         {
            row.options_button.visible = false;
         }
      }
      
      private function setRowEnabled(row:MovieClip, enable:Boolean) : void
      {
      }
      
      private function requestDetailsListData(start:int, end:int) : void
      {
         var data:Vector.<Object> = new Vector.<Object>();
         for(var i:int = start; i <= end; i++)
         {
            data.push(this.mDetails[i]);
         }
         mView.phone_list.setData({
            "offset":start,
            "list":data
         });
      }
      
      private function exitDetails() : void
      {
         this.mDetails = null;
         this.setView(mView.viewButtons_group.getSelection());
      }
      
      private function setView(view:String) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_RECENT_CALLS);
         mView.phone_list.setLength(0);
         mView.phone_list.setRowUpdater(this.updateCallRow);
         mView.phone_list.setDataRequester(this.requestCallListData);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.ALL_CALLS_LIST,mView.phone_list.dataEventHandler);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.DIALED_CALLS_LIST,mView.phone_list.dataEventHandler);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.MISSED_CALLS_LIST,mView.phone_list.dataEventHandler);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.RECEIVED_CALLS_LIST,mView.phone_list.dataEventHandler);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.ALL_CALLS_COUNT,this.onCount);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.DIALED_CALLS_COUNT,this.onCount);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.MISSED_CALLS_COUNT,this.onCount);
         attachListener(Peripheral.phoneCallList,PhoneCallListEvent.RECEIVED_CALLS_COUNT,this.onCount);
         switch(view)
         {
            case ALL_CALLS_BUTTON:
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.ALL_CALLS_LIST,mView.phone_list.dataEventHandler);
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.ALL_CALLS_COUNT,this.onCount);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_ALL_CALLS_BREADCRUMB,Breadcrumb.FUNCTION,this.exitDetails));
               this.mCurrentCallList = PhoneCallListEvent.ALL_CALLS_LIST;
               break;
            case OUTGOING_CALLS_BUTTON:
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.DIALED_CALLS_LIST,mView.phone_list.dataEventHandler);
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.DIALED_CALLS_COUNT,this.onCount);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_OUTGOING_CALLS_BREADCRUMB,Breadcrumb.FUNCTION,this.exitDetails));
               this.mCurrentCallList = PhoneCallListEvent.DIALED_CALLS_LIST;
               break;
            case INCOMING_CALLS_BUTTON:
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.RECEIVED_CALLS_LIST,mView.phone_list.dataEventHandler);
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.RECEIVED_CALLS_COUNT,this.onCount);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_INCOMING_CALLS_BREADCRUMB,Breadcrumb.FUNCTION,this.exitDetails));
               this.mCurrentCallList = PhoneCallListEvent.RECEIVED_CALLS_LIST;
               break;
            case MISSED_CALLS_BUTTON:
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.MISSED_CALLS_LIST,mView.phone_list.dataEventHandler);
               attachListener(Peripheral.phoneCallList,PhoneCallListEvent.MISSED_CALLS_COUNT,this.onCount);
               this.initBreadcrumbs();
               pushBreadcrumb(new Breadcrumb(T.STRB_MISSED_CALLS_BREADCRUMB,Breadcrumb.FUNCTION,this.exitDetails));
               this.mCurrentCallList = PhoneCallListEvent.MISSED_CALLS_LIST;
         }
         this.mAddingFavorite = false;
         mView.cancel_button.visible = this.mAddingFavorite;
         this.onCount();
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
      }
      
      private function initBreadcrumbs() : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_RECENT_CALLS_BREADCRUMB,Breadcrumb.FUNCTION,this.exitDetails));
      }
      
      private function goDetail() : void
      {
         this.mAddingFavorite = false;
         var row:MovieClip = mView.phone_list.reserveHeader(false);
         row.visible = true;
         pushBreadcrumb(new Breadcrumb(T.STRB_ENTRY_DETAILS_BREADCRUMB));
         mView.phone_list.setLength(0);
         mView.phone_list.setRowUpdater(this.updateDetailsRow);
         mView.phone_list.setDataRequester(this.requestDetailsListData);
         mView.phone_list.setLength(this.mDetails.length);
         mView.itemsInList_label.text = "";
         mView.cancel_button.visible = this.mAddingFavorite;
      }
      
      private function goFavorites() : void
      {
         this.setupFavList = true;
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SELECT_CONTACT_UPDATE_BREADCRUMB));
         var row:MovieClip = mView.phone_list.reserveHeader(true);
         row.visible = false;
         mView.phone_list.setLength(0);
         mView.phone_list.setRowUpdater(this.updateFavoritesRow);
         mView.phone_list.setDataRequester(this.requestFavoritesData);
         mView.phone_list.setLength(5);
         mView.cancel_button.visible = this.mAddingFavorite;
      }
      
      private function onDeviceChange(e:BluetoothEvent) : void
      {
         if(Peripheral.bluetooth.currentHFPDevice == null)
         {
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
      
      private function onCount(e:PhoneCallListEvent = null) : void
      {
         var itemCount:int = 0;
         var updateList:Boolean = false;
         if(this.mDetails == null)
         {
            switch(this.mCurrentCallList)
            {
               case PhoneCallListEvent.ALL_CALLS_LIST:
                  itemCount = int(Peripheral.phoneCallList.allCallsCount);
                  if(MAX_CALL_COUNT == Peripheral.phoneCallList.missedCallsCount || MAX_CALL_COUNT == Peripheral.phoneCallList.receivedCallsCount)
                  {
                     updateList = true;
                  }
                  break;
               case PhoneCallListEvent.DIALED_CALLS_LIST:
                  itemCount = int(Peripheral.phoneCallList.dialedCallsCount);
                  break;
               case PhoneCallListEvent.RECEIVED_CALLS_LIST:
                  itemCount = int(Peripheral.phoneCallList.receivedCallsCount);
                  if(MAX_CALL_COUNT == itemCount)
                  {
                     updateList = true;
                  }
                  break;
               case PhoneCallListEvent.MISSED_CALLS_LIST:
                  itemCount = int(Peripheral.phoneCallList.missedCallsCount);
                  if(MAX_CALL_COUNT == itemCount)
                  {
                     updateList = true;
                  }
            }
            if(itemCount != this.mCallListCount || updateList)
            {
               mView.phone_list.setDataRequester(this.requestCallListData);
            }
            this.mRequestedList = true;
            this.mCallListCount = itemCount;
            if(itemCount == 0)
            {
               t(mView.itemsInList_label,Format.itemsInList(0));
               itemCount = 1;
            }
            else if(itemCount == -1)
            {
               this.mRequestedList = false;
               itemCount = 0;
               mView.itemsInList_label.text = "";
            }
            else
            {
               t(mView.itemsInList_label,Format.itemsInList(itemCount));
            }
            mView.phone_list.setLength(itemCount);
         }
      }
      
      override protected function back(e:Event = null) : void
      {
         this.goBack(null);
      }
      
      private function goBack(e:MouseEvent) : void
      {
         if(Boolean(this.mDetails) && !this.mAddingFavorite)
         {
            this.exitDetails();
         }
         else if(Boolean(this.mDetails) && this.mAddingFavorite)
         {
            popBreadcrumb();
            this.goDetail();
         }
         else
         {
            super.back(e);
         }
      }
      
      private function onCancelAddFavorites(e:MouseEvent) : void
      {
         clearBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_RECENT_CALLS_BREADCRUMB));
         switch(this.mCurrentCallList)
         {
            case PhoneCallListEvent.ALL_CALLS_LIST:
               pushBreadcrumb(new Breadcrumb(T.STRB_ALL_CALLS_BREADCRUMB));
               break;
            case PhoneCallListEvent.RECEIVED_CALLS_LIST:
               pushBreadcrumb(new Breadcrumb(T.STRB_INCOMING_CALLS_BREADCRUMB));
               break;
            case PhoneCallListEvent.MISSED_CALLS_LIST:
               pushBreadcrumb(new Breadcrumb(T.STRB_MISSED_CALLS_BREADCRUMB));
               break;
            case PhoneCallListEvent.DIALED_CALLS_LIST:
               pushBreadcrumb(new Breadcrumb(T.STRB_OUTGOING_CALLS_BREADCRUMB));
         }
         this.goDetail();
      }
      
      private function onViewButton(e:WidgetEvent) : void
      {
         if(this.mDetails)
         {
            this.exitDetails();
         }
         var row:MovieClip = mView.phone_list.reserveHeader(false);
         row.visible = true;
         this.setView(e.data.targetName);
      }
      
      private function onListSelect(e:WidgetEvent) : void
      {
         var dialName:String = null;
         var numberType:String = null;
         var mContact:PhoneBookContact = null;
         var name:String = null;
         var num:String = null;
         var temp_array:Array = null;
         if(this.mDetails == null && this.mCallListCount <= 0)
         {
            return;
         }
         if(e.data.targetName == "options_button")
         {
            this.mSendTextMsgNumber = e.data.data.name;
            this.mFavNumber = e.data.data.name;
            this.mFavNumberType = e.data.data.type;
            Framework.popupManager.show(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE,Screens.POPUP_OPTIONS,{
               "timeout":0,
               "type":PopupType.OPTIONS,
               "title":T.STRB_OPTIONS,
               "ids":[ADD_TO_FAVS,SEND_TEXT_MSG],
               "labels":[T.STRB_ADD_TO_FAVS,T.STRB_SMS_SEND_TEXT_MSG],
               "highlight":[false,false],
               "enabled":[true,Peripheral.smsMessaging.isSendSupported],
               "callBack":this.onOptionsCallBack
            });
            return;
         }
         if(e.data.data.hasOwnProperty("callType"))
         {
            Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumberType = e.data.data.callType;
         }
         if(e.data.data.hasOwnProperty("dial"))
         {
            if(e.data.data.dial == true)
            {
               if(Framework.focusManager.cursorActive)
               {
                  this.mSendTextMsgNumber = e.data.data.name;
                  this.mFavNumber = e.data.data.name;
                  this.mFavNumberType = e.data.data.type;
                  Framework.popupManager.show(DynamicPopupNames.MASERATI_OPTIONS_RECENT_CALLS,Screens.POPUP_OPTIONS,{
                     "timeout":0,
                     "type":PopupType.OPTIONS,
                     "title":T.STRB_OPTIONS,
                     "ids":[CALL,ADD_TO_FAVS,SEND_TEXT_MSG],
                     "labels":[T.STRB_CALL,T.STRB_ADD_TO_FAVS,T.STRB_SMS_SEND_TEXT_MSG],
                     "highlight":[false,false,false],
                     "enabled":[true,true,Peripheral.smsMessaging.isSendSupported],
                     "callBack":this.onOptionsCallBack
                  });
               }
               else
               {
                  dialName = null;
                  numberType = e.data.data.type;
                  switch(numberType)
                  {
                     case "home":
                        numberType = "homeNumber";
                        break;
                     case "mobile":
                        numberType = "mobileNumber";
                        break;
                     case "work":
                        numberType = "workNumber";
                        break;
                     default:
                        numberType = "otherNumber";
                  }
                  if(this.mDetails[0].dial == false)
                  {
                     dialName = this.mCallName;
                  }
                  Peripheral.bluetoothPhone.bluetoothHFP.dial(e.data.data.name,dialName,numberType);
                  Framework.structure.goto(Screens.MAIN_PHONE);
               }
               return;
            }
            return;
         }
         if(this.mAddingFavorite)
         {
            mContact = e.data.data;
            this.mAddingFavorite = false;
            mContact.formattedName = this.mPhonebookContact.formattedName;
            mContact.homeNumber = "";
            mContact.mobileNumber = "";
            mContact.workNumber = "";
            mContact.otherNumber = "";
            switch(this.mFavNumberType)
            {
               case "home":
                  if("" != this.mPhonebookContact.homeNumber)
                  {
                     mContact.homeNumber = this.mPhonebookContact.homeNumber;
                  }
                  break;
               case "mobile":
                  if("" != this.mPhonebookContact.mobileNumber)
                  {
                     mContact.mobileNumber = this.mPhonebookContact.mobileNumber;
                  }
                  break;
               case "work":
                  if("" != this.mPhonebookContact.workNumber)
                  {
                     mContact.workNumber = this.mPhonebookContact.workNumber;
                  }
                  break;
               default:
                  if("" != this.mPhonebookContact.otherNumber)
                  {
                     mContact.otherNumber = this.mPhonebookContact.otherNumber;
                  }
            }
            Framework.popupManager.show(DynamicPopupNames.PHONE_COPIED_TO_FAVORITES,"phonepairingpopup",{
               "type":PopupType.PRIMARY,
               "status":"copied to favorites",
               "timeout":2000
            });
            if(1 <= mContact.favIndex && 5 >= mContact.favIndex)
            {
               Peripheral.bluetoothPhone.phoneBook.replaceFavorite(mContact);
            }
            this.goDetail();
            return;
         }
         var call:PhoneCallListEntry = e.data.data;
         this.mDetails = new Vector.<Object>();
         if(call.phoneNumber != call.firstName)
         {
            name = "";
            if(call.phoneNumber == Peripheral.phonebook.towingAssistanceNumber)
            {
               name = Peripheral.localeEngine.getText(T.STRB_PHONE_TOWING_ASSISTANCE);
            }
            else if(call.phoneNumber == Peripheral.phonebook.emergencyNumber)
            {
               name = Peripheral.localeEngine.getText(T.STRB_MENU_EMERGENCY);
            }
            else
            {
               name = call.firstName;
            }
            this.mSendTextMsgName = name;
            this.mCallName = name;
            this.mFavName = name;
            if(name != "" && call.lastName != "")
            {
               name += " " + call.lastName;
               this.mSendTextMsgName = name;
               this.mCallName = name;
            }
            if("" == name)
            {
               this.mSendTextMsgName = "";
               this.mFavName = "";
               name = compose(T.STRB_NO_NAME);
               this.mCallName = "";
            }
            if(name != "")
            {
               this.mDetails.push({
                  "name":name,
                  "dial":false,
                  "type":"contact"
               });
            }
         }
         this.mContactNameDisplayed = this.mDetails.length > 0;
         var callType:String = "";
         switch(call.callType)
         {
            case "workNumber":
               callType = "work";
               break;
            case "mobileNumber":
               callType = "mobile";
               break;
            case "homeNumber":
               callType = "home";
               break;
            case "otherNumber":
               callType = "circle";
               break;
            default:
               callType = "none";
         }
         var dialButton:Boolean = Peripheral.bluetoothPhone.getHoldingCall() == null || Peripheral.bluetoothPhone.getActiveCall() == null;
         if(call.phoneNumber == "")
         {
            num = compose(T.STRB_PHONE_PRIVATE_NUMBER_2);
            this.mDetails.push({
               "name":num,
               "dial":false,
               "type":callType
            });
         }
         else
         {
            this.mDetails.push({
               "name":Format.phoneNumber(call.phoneNumber),
               "dial":dialButton,
               "type":callType
            });
         }
         if(call.timeStamp != "")
         {
            temp_array = call.timeStamp.split(" ");
            if(temp_array.length > 1)
            {
               this.mDetails.push({
                  "name":Format.timeOfDay(temp_array[1]),
                  "dial":false,
                  "type":"none"
               });
            }
            if(temp_array.length > 0)
            {
               this.mDetails.push({
                  "name":Format.dateFormat(temp_array[0]),
                  "dial":false,
                  "type":"none"
               });
            }
         }
         this.goDetail();
      }
      
      private function onRefresh(evt:StructureEvent) : void
      {
         screenVars = evt.vars;
         this.initScreen();
      }
      
      private function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function hideListButtonsElements(_button:MovieClip) : void
      {
         _button.call_group.visible = false;
         _button.details_group.visible = false;
         _button.options_button.visible = false;
      }
      
      private function onVRSmsGetDetails(evt:VoiceRecognitionEvent) : void
      {
         var result:String = null;
         var phoneNumber:String = null;
         var senderName:String = null;
         var phoneCategory:String = null;
         if(evt.mData.messageIndex == -1)
         {
            result = "failure";
            phoneNumber = "";
            senderName = "";
            phoneCategory = null;
            phoneNumber = Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber;
            senderName = Peripheral.smsMessaging.outgoingMessageRecipientName;
            result = "success";
            phoneCategory = this.mFavNumberType;
            if(senderName == phoneNumber)
            {
               senderName = "";
            }
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,result,null,phoneNumber,false,senderName,phoneCategory);
         }
         Framework.structure.goto(Screens.MAIN_PHONE);
      }
      
      private function onOptionsCallBack(o:Object) : void
      {
         var dialName:String = null;
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_RECENT_CALLS);
         switch(o.id)
         {
            case CALL:
               dialName = null;
               if(this.mDetails[0].dial == false)
               {
                  dialName = this.mCallName;
               }
               Peripheral.bluetoothPhone.bluetoothHFP.dial(mView.phone_list.getSelectedData().name,dialName);
               Framework.structure.goto(Screens.MAIN_PHONE);
               break;
            case ADD_TO_FAVS:
               this.mPhonebookContact.formattedName = this.mFavName;
               this.mPhonebookContact.homeNumber = "";
               this.mPhonebookContact.mobileNumber = "";
               this.mPhonebookContact.workNumber = "";
               this.mPhonebookContact.otherNumber = "";
               switch(this.mFavNumberType)
               {
                  case "home":
                     this.mPhonebookContact.homeNumber = this.mFavNumber;
                     break;
                  case "mobile":
                     this.mPhonebookContact.mobileNumber = this.mFavNumber;
                     break;
                  case "work":
                     this.mPhonebookContact.workNumber = this.mFavNumber;
                     break;
                  default:
                     this.mPhonebookContact.otherNumber = this.mFavNumber;
               }
               if(MAX_FAVORITES > Peripheral.phonebook.favoritesCount)
               {
                  this.mAddingFavorite = false;
                  Framework.popupManager.show(DynamicPopupNames.PHONE_COPIED_TO_FAVORITES,"phonepairingpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"copied to favorites",
                     "timeout":2000
                  });
                  this.mPhonebookContact.favIndex = 0;
                  Peripheral.bluetoothPhone.phoneBook.addFavorite(this.mPhonebookContact);
               }
               else
               {
                  this.mAddingFavorite = true;
                  this.goFavorites();
               }
               break;
            case SEND_TEXT_MSG:
               Peripheral.smsMessaging.outgoingMessageRecipientName = this.mSendTextMsgName;
               Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = this.mSendTextMsgNumber;
               if(Peripheral.vehicleStatus.speedLockOut)
               {
                  Peripheral.smsMessaging.startSMSDictation("new",true);
               }
               else
               {
                  Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen",{"state":"newMessageInit"});
               }
               this.mSendTextMsgName = "";
               this.mSendTextMsgNumber = "";
         }
      }
   }
}

