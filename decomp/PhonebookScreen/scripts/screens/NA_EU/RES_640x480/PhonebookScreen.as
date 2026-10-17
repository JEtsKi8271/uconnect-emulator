package screens.NA_EU.RES_640x480
{
   import ancillary.Ancillary;
   import ancillary.Breadcrumb;
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import ancillary.Style;
   import com.harman.moduleLinkAPI.*;
   import com.harman.navigation.enums.Shortcuts;
   import com.harman.navigation.global.vServices.*;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import core.events.MessageEvent;
   import events.GlobalEvent;
   import events.HardControlEvent;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.utils.Timer;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class PhonebookScreen extends GenericScreen
   {
      
      private static const MAX_FAVORITES:int = 7;
      
      private static const MAX_ITEMS_PER_PAGE:int = 6;
      
      private static const EMERGENCY_NUM_POS:int = MAX_FAVORITES - 2;
      
      private static const TOWING_ASSIS_NUM_POS:int = MAX_FAVORITES - 1;
      
      private static const EMERGENCY_FAV_INDEX:int = MAX_FAVORITES - 1;
      
      private static const TOWING_ASSIS_FAV_INDEX:int = MAX_FAVORITES;
      
      private static const NO_VIEW:int = 0;
      
      private static const MOBILE_VIEW:int = 1;
      
      private static const DETAIL_VIEW:int = 2;
      
      private static const FAVORITES_VIEW:int = 3;
      
      private static const ADD_FROM_MOBILE:int = 0;
      
      private static const ADD_TO_FAVS:int = 1;
      
      private static const ADD_TO_NAV:int = 2;
      
      private static const REMOVE_FROM_FAVS:int = 3;
      
      private static const EDIT_NUMBER:int = 4;
      
      private static const RESET_TO_DEFAULT:int = 5;
      
      private static const SEND_TEXT_MSG:int = 6;
      
      private static const CALL:int = 7;
      
      private static const INITIAL_DETAILS_CURSOR_POS:int = 1;
      
      private var mMenuState:int = 0;
      
      private var mListPosition:int = 0;
      
      private var mId:int = 0;
      
      private var mLastOffset:int = 0;
      
      private var mLastLength:int = 0;
      
      private var mRetry:int = 0;
      
      private var mfavIndex:int = 0;
      
      private var mCurrentView:int = 0;
      
      private var mNbrOfFavorites:int = 2;
      
      private var mLastMobilePosition:int = 0;
      
      private var mDetailData:Array = null;
      
      private var mBreadcrumbs:Array = new Array();
      
      private var mAddingFavorite:Boolean = false;
      
      private var mAddingNAVFavorite:Boolean = false;
      
      private var mContact:PhoneBookContact = null;
      
      private var mPhonebookContact:PhoneBookContact = new PhoneBookContact();
      
      private var mFavNumber:String = "";
      
      private var mCalledNumber:String = "";
      
      private var mFavNumberType:String = "";
      
      private var mSpecialNumber:String = "";
      
      private var mEmergencyNumber:String = "";
      
      private var mTowingAssistanceNumber:String = "";
      
      private var mSendTextMsgNumber:String = "";
      
      private var mSendTextMsgName:String = "";
      
      private var mSearchResultActive:Boolean = false;
      
      private var mSearchedString:String = "";
      
      private var mEcellPresent:Boolean = false;
      
      private var mCalldetailScreenPresent:Boolean = false;
      
      private var mFocusCommandButtons:FocusObject = new FocusObject(Layers.MIDDLE,FocusPriority.REGULAR,[mView.alpha_button,mView.search_button,mView.btnClearResults_button,mView.cancel_button]);
      
      private var mTimeOutTimer:Timer = new Timer(10000);
      
      public function PhonebookScreen()
      {
         mView = new PhonebookScreenView();
         super();
      }
      
      override public function screenOut() : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS);
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         Framework.popupManager.dequeue(DynamicPopupNames.PHONE_COPIED_TO_FAVORITES);
         this.mSearchedString = "";
         this.mAddingFavorite = false;
         this.mCalldetailScreenPresent = false;
         mView.phonebook_list.setPosition(0);
         if(this.mTimeOutTimer.running)
         {
            this.mTimeOutTimer.stop();
            detachListener(this.mTimeOutTimer,TimerEvent.TIMER,this.onTimeOutTimer);
         }
         super.screenOut();
      }
      
      override public function cleanup() : void
      {
         this.mDetailData = null;
         this.mBreadcrumbs = null;
         this.mContact = null;
         this.mPhonebookContact = null;
         Peripheral.phonebook.multiNumberFromMessageFlag = false;
         super.cleanup();
      }
      
      override protected function addListeners() : void
      {
         super.addListeners();
         Framework.popupManager.addEventListener(GlobalEvent.OPTIONS_POPUP_CLOSED,this.onOptionsPopupClosed,false,0,true);
         Framework.popupManager.addEventListener(GlobalEvent.OPTIONS_POPUP_BUTTON,this.onOptionsPopupButton,false,0,true);
         attachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.phonebook_list.scrollEventHandler);
         attachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.phonebook_list.selectEventHandler);
         attachListener(Framework.messenger,MessageEvent.MESSAGE,this.onMessage);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.COUNT,this.onCount,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.CONTACT_LIST,this.handleMobileData,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.CONTACT,this.onPhoneBookContact,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.FAVORITES_LIST,this.handleFavoritesData,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.EMERGENCY_NUMBER,this.onSpecialNumberUpdate,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.TOWING_ASSISTANCE_NUMBER,this.onSpecialNumberUpdate,false,0,true);
         attachListener(Peripheral.phonebook,PhoneBookEvent.FAVORITE_UPDATED,this.onFavoriteUpdated,false,0,true);
         attachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent,false,0,true);
         attachListener(mView.phonebook_list,WidgetEvent.SELECT,this.onListSelect,false,0,true);
         attachListener(mView.phonebook_scroller,WidgetEvent.POSITION,this.onListPosition,false,0,true);
         attachListener(mView.back_button,MouseEvent.CLICK,this.goBack,false,0,true);
         attachListener(mView.close_button,MouseEvent.CLICK,close,false,0,true);
         attachListener(mView.mobile_button,MouseEvent.CLICK,this.onMobileClick,false,0,true);
         attachListener(mView.favorites_button,MouseEvent.CLICK,this.onFavoritesClick,false,0,true);
         attachListener(mView.cancel_button,MouseEvent.CLICK,this.cancelAddFavorites,false,0,true);
         attachListener(mView.alpha_button,MouseEvent.CLICK,this.onAlphaClick,false,0,true);
         attachListener(mView.search_button,MouseEvent.CLICK,this.onSearchClick,false,0,true);
         attachListener(mView.btnClearResults_button,MouseEvent.CLICK,this.onClearResultsClick,false,0,true);
         attachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_GET_DETAILS,this.onVRSmsGetDetails,false,0,true);
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange,false,0,true);
      }
      
      override protected function removeListeners() : void
      {
         Framework.popupManager.removeEventListener(GlobalEvent.OPTIONS_POPUP_CLOSED,this.onOptionsPopupClosed);
         Framework.popupManager.removeEventListener(GlobalEvent.OPTIONS_POPUP_BUTTON,this.onOptionsPopupButton);
         detachListener(Peripheral.hardControls,HardControlEvent.VERTICAL_SCROLL,mView.phonebook_list.scrollEventHandler);
         detachListener(Peripheral.hardControls,HardControlEvent.SELECT,mView.phonebook_list.selectEventHandler);
         detachListener(Framework.messenger,MessageEvent.MESSAGE,this.onMessage);
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.phonebook,PhoneBookEvent.COUNT,this.onCount);
         detachListener(Peripheral.phonebook,PhoneBookEvent.CONTACT_LIST,this.handleMobileData);
         detachListener(Peripheral.phonebook,PhoneBookEvent.CONTACT,this.onPhoneBookContact);
         detachListener(Peripheral.phonebook,PhoneBookEvent.FAVORITES_LIST,this.handleFavoritesData);
         detachListener(Peripheral.phonebook,PhoneBookEvent.EMERGENCY_NUMBER,this.onSpecialNumberUpdate);
         detachListener(Peripheral.phonebook,PhoneBookEvent.TOWING_ASSISTANCE_NUMBER,this.onSpecialNumberUpdate);
         detachListener(Peripheral.phonebook,PhoneBookEvent.FAVORITE_UPDATED,this.onFavoriteUpdated);
         detachListener(Peripheral.vehicleStatus,VehicleStatusEvent.SPEED_LOCK_OUT,this.onSpeedLockOutEvent);
         detachListener(mView.phonebook_list,WidgetEvent.SELECT,this.onListSelect);
         detachListener(mView.phonebook_scroller,WidgetEvent.POSITION,this.onListPosition);
         detachListener(mView.back_button,MouseEvent.CLICK,this.goBack);
         detachListener(mView.close_button,MouseEvent.CLICK,close);
         detachListener(mView.mobile_button,MouseEvent.CLICK,this.onMobileClick);
         detachListener(mView.favorites_button,MouseEvent.CLICK,this.onFavoritesClick);
         detachListener(mView.cancel_button,MouseEvent.CLICK,this.cancelAddFavorites);
         detachListener(mView.alpha_button,MouseEvent.CLICK,this.onAlphaClick);
         detachListener(mView.search_button,MouseEvent.CLICK,this.onSearchClick);
         detachListener(mView.btnClearResults_button,MouseEvent.CLICK,this.onClearResultsClick);
         detachListener(Peripheral.voiceRecognition,VoiceRecognitionEvent.SMS_GET_DETAILS,this.onVRSmsGetDetails);
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateChange);
         super.removeListeners();
      }
      
      override protected function initView() : void
      {
         super.initView();
         if(Peripheral.versionInfo.productVariantID.VARIANT_ECELL != "YES")
         {
            this.mEcellPresent = false;
         }
         else
         {
            this.mEcellPresent = true;
         }
         breadcrumbTextField = mView.title.labelValue;
         mView.phonebook_scroller.setReportingPeriod(Style.PlayerBrowseScreen.SCROLLER_REPORTING_PERIOD);
         mView.phonebook_scroller.setPopupUpdater(this.updateScrollerPopup);
         mView.phonebook_list.attachScroller(mView.phonebook_scroller);
         mView.phonebook_list.setBufferSize(Style.PhoneBookScreen.LIST_BUFFER_SIZE);
         mView.btnClearResults_button.visible = false;
         mView.btnClearResults_button.value_label.text = compose(T.STRB_SEARCH_CLEAR_RESULTS);
         mView.searchDescription.visible = false;
         mView.phonebook_list.row_0_group.underline.visible = false;
         mView.phonebook_list.row_1_group.underline.visible = false;
         mView.phonebook_list.row_2_group.underline.visible = false;
         mView.phonebook_list.row_3_group.underline.visible = false;
         mView.phonebook_list.row_4_group.underline.visible = false;
         mView.phonebook_list.row_5_group.underline.visible = false;
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         this.hideTheAlphaJumpButton();
         if(null != screenVars)
         {
            switch(screenVars.show)
            {
               case "favorites":
                  this.goFavorites();
                  break;
               case "AddFromNav":
                  this.mAddingFavorite = true;
                  this.mAddingNAVFavorite = true;
                  this.goMobile();
                  break;
               case "mobile":
                  this.goMobile();
                  break;
               case "search":
                  this.showContact(screenVars.contact);
                  this.mCalldetailScreenPresent = true;
                  break;
               case "details":
                  this.showContact(screenVars.contact);
                  this.mCalldetailScreenPresent = true;
                  break;
               default:
                  this.goMobile();
            }
         }
         else
         {
            this.goMobile();
         }
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MAXIMUM,null,mView.phonebook_list.onFocusCallBack));
         Framework.focusManager.addFocus(new FocusObject(Layers.MIDDLE,FocusPriority.MINIMUM,[mView.mobile_button,mView.favorites_button]));
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.alpha_button.value_label,T.STRB_ALPHA_PLAYERBROWSE);
         t(mView.search_button.value_label,T.STRB_SEARCH);
         t(mView.cancel_button.value_label,T.STRB_CANCEL);
         t(mView.cancel_button.labelLetters,T.STRB_CANCEL_PHONEBOOK);
         t(mView.mobile_button.value_label,T.STRB_MOBILE_BUTTON);
         t(mView.favorites_button.value_label,T.STRB_FAVOURITES);
         mView.phonebook_list.update();
      }
      
      private function initBreadcrumbs() : void
      {
         clearBreadcrumbs();
         if(FAVORITES_VIEW == this.mCurrentView)
         {
            pushBreadcrumb(new Breadcrumb(T.STRB_PHONEBOOK_BREADCRUMB,Breadcrumb.FUNCTION,this.goFavorites));
         }
         else
         {
            pushBreadcrumb(new Breadcrumb(T.STRB_PHONEBOOK_BREADCRUMB,Breadcrumb.FUNCTION,this.goMobile));
         }
      }
      
      private function onMobileClick(e:MouseEvent) : void
      {
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
         this.mAddingFavorite = false;
         if(!mView.mobile_button.getSelected())
         {
            this.goMobile();
         }
      }
      
      private function onFavoritesClick(e:MouseEvent) : void
      {
         Framework.focusManager.setFocus(FocusPriority.MAXIMUM);
         if(true == Peripheral.phonebook.phonebookSyncUpdateStatus)
         {
            Peripheral.phonebook.refreshPhonebook();
         }
         if(!mView.favorites_button.getSelected())
         {
            this.goFavorites();
         }
      }
      
      private function onAlphaClick(e:MouseEvent) : void
      {
         Framework.popupManager.show(DynamicPopupNames.ALPHA_JUMP,Screens.POPUP_ALPHAJUMP,{
            "type":PopupType.SPELLER,
            "availableCharacters":Peripheral.phonebook.contactStartCharactersAvailable()
         });
      }
      
      private function onSearchClick(e:MouseEvent) : void
      {
         if(Peripheral.vehicleStatus.speedLockOut)
         {
            Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
         else
         {
            Ancillary.definedDynamicPopups.popup(DynamicPopupNames.PHONEBOOK_SMART_SPELLER,{
               "screen":DynamicPopupNames.PHONEBOOK_SMART_SPELLER,
               "availableCharacters":Peripheral.phonebook.nextSmartSpeller
            });
         }
      }
      
      private function onClearResultsClick(e:MouseEvent) : void
      {
         Peripheral.phonebook.requestFilteredCount("");
         this.goMobile();
      }
      
      private function cancelAddFavorites(e:MouseEvent) : void
      {
         this.mAddingFavorite = false;
         switch(this.mCurrentView)
         {
            case FAVORITES_VIEW:
               if(mView.cancel_button.visible)
               {
                  this.goDetail();
               }
               else
               {
                  this.goMobile();
               }
               break;
            case MOBILE_VIEW:
            case DETAIL_VIEW:
               if(this.mAddingNAVFavorite)
               {
                  this.mAddingNAVFavorite = false;
                  Peripheral.navigation.navDomainControl.requestShortcut(Shortcuts.NAVIGATION_DOMAIN);
               }
               else
               {
                  this.goFavorites();
               }
         }
      }
      
      override protected function back(e:Event = null) : void
      {
         this.goBack(null);
      }
      
      private function goBack(e:MouseEvent) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS);
         if(!this.mAddingFavorite)
         {
            switch(this.mCurrentView)
            {
               case DETAIL_VIEW:
                  if(this.mSearchResultActive)
                  {
                     this.onSearchResultsScreen(false);
                  }
                  else
                  {
                     this.goMobile(false);
                     if(Boolean(Peripheral.phonebook.multipleContactNumberPresent) && Boolean(Peripheral.phonebook.multiNumberFromMessageFlagGet))
                     {
                        Peripheral.phonebook.multiNumberFromMessageFlag = false;
                        Framework.structure.gotolastScreen();
                     }
                  }
                  break;
               default:
                  Framework.structure.back();
            }
         }
         else
         {
            switch(this.mCurrentView)
            {
               case FAVORITES_VIEW:
                  this.mAddingFavorite = false;
                  this.goMobile();
                  break;
               case MOBILE_VIEW:
                  this.mAddingFavorite = false;
                  if(this.mAddingNAVFavorite)
                  {
                     this.mAddingNAVFavorite = false;
                     Peripheral.navigation.navDomainControl.requestShortcut(Shortcuts.LI_FAVORITES);
                  }
                  else
                  {
                     this.goFavorites();
                  }
                  break;
               case DETAIL_VIEW:
                  this.goMobile(false);
            }
         }
      }
      
      private function onDeviceChange(e:BluetoothEvent) : void
      {
         if(Peripheral.bluetooth.currentHFPDevice == null)
         {
            if(Framework.popupManager.active == DynamicPopupNames.PHONEBOOK_SMART_SPELLER)
            {
               Framework.popupManager.close();
               Framework.popupManager.dispatch(GlobalEvent.APP_SPELLER_POPUP_CLOSED);
            }
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
      
      private function onDialOk(e:BluetoothEvent) : void
      {
         Framework.messenger.send({
            "type":"phone number",
            "value":this.mCalledNumber
         });
         Framework.structure.goto(Screens.MAIN_PHONE);
      }
      
      private function handleMobileData(e:PhoneBookEvent) : void
      {
         var vec:Vector.<PhoneBookContact> = null;
         if(this.mCurrentView == MOBILE_VIEW)
         {
            vec = Peripheral.phonebook.contactsList(this.mId);
            if(vec.length > 0 && this.mLastOffset == vec[0].index && this.mLastLength <= vec.length)
            {
               this.mRetry = 0;
               mView.phonebook_list.setData({
                  "offset":this.mLastOffset,
                  "list":vec
               });
            }
            else
            {
               ++this.mRetry;
               if(this.mRetry < 10)
               {
                  if(Global.region == TunerRegion.JAPAN)
                  {
                     this.mId = Peripheral.phonebook.requestContactsList(this.mLastOffset,this.mLastLength,"","ascending",this.mSearchedString);
                  }
                  else
                  {
                     this.mId = Peripheral.phonebook.requestContactsList(this.mLastOffset,this.mLastLength,"formattedName","ascending",this.mSearchedString);
                  }
               }
               else if(this.mRetry < 11)
               {
                  mView.phonebook_list.setLength(Peripheral.phonebook.contactsCount);
                  mView.phonebook_list.update();
               }
            }
         }
      }
      
      private function handleFavoritesData(e:PhoneBookEvent) : void
      {
         var fav_contact:PhoneBookContact = null;
         var idx:int = 0;
         var idx_vec:int = 0;
         var vec_list:Vector.<PhoneBookContact> = new Vector.<PhoneBookContact>();
         var vec:Vector.<PhoneBookContact> = Peripheral.phonebook.favoritesList(this.mId);
         for(idx_vec = 0; idx_vec < vec.length; idx_vec++)
         {
            if(vec[idx_vec].favIndex < 1 || vec[idx_vec].favIndex > MAX_FAVORITES)
            {
               Peripheral.phonebook.deleteFavorite(vec[idx_vec]);
            }
         }
         if(this.mCurrentView == FAVORITES_VIEW)
         {
            for(idx = 0; idx < MAX_FAVORITES; idx++)
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
            mView.phonebook_list.setData({
               "offset":this.mLastOffset,
               "list":vec_list
            });
         }
      }
      
      private function onSpecialNumberUpdate(e:PhoneBookEvent) : void
      {
         if(FAVORITES_VIEW == this.mCurrentView)
         {
            this.goFavorites();
         }
      }
      
      private function onCount(e:PhoneBookEvent) : void
      {
         if(this.mCurrentView == MOBILE_VIEW)
         {
            t(mView.itemCount_label,Format.itemsInList(Peripheral.phonebook.contactsCount));
            if(Peripheral.phonebook.contactsCount == 0)
            {
               mView.phonebook_list.setLength(1);
            }
            else
            {
               mView.phonebook_list.setLength(Peripheral.phonebook.contactsCount);
            }
         }
         else if(this.mCurrentView == FAVORITES_VIEW)
         {
            if(this.mAddingFavorite)
            {
               t(mView.itemCount_label,Format.itemsInList(Peripheral.phonebook.favoritesCount - 2));
               mView.phonebook_list.setLength(MAX_FAVORITES + 1);
            }
            else
            {
               t(mView.itemCount_label,Format.itemsInList(Peripheral.phonebook.favoritesCount - 2));
               mView.phonebook_list.setLength(MAX_FAVORITES);
            }
         }
      }
      
      private function requestMobileData(start:int, end:int) : void
      {
         this.mLastOffset = start;
         var length:int = end - start + 1;
         this.mLastLength = length;
         this.mRetry = 0;
         if(Global.region == TunerRegion.JAPAN)
         {
            this.mId = Peripheral.phonebook.requestContactsList(start,length,"","ascending",this.mSearchedString);
         }
         else
         {
            this.mId = Peripheral.phonebook.requestContactsList(start,length,"formattedName","ascending",this.mSearchedString);
         }
      }
      
      private function requestFavoritesData(start:int, end:int) : void
      {
         this.mLastOffset = start;
         var length:int = end - start + 1;
         this.mLastLength = length;
         Peripheral.phonebook.requestFavoritesCount();
      }
      
      private function requestDetailData(start:int, end:int) : void
      {
         var list:Array = new Array();
         for(var i:int = start; i <= end; i++)
         {
            list.push(this.mDetailData[i]);
         }
         mView.phonebook_list.setData({
            "offset":start,
            "list":list
         });
      }
      
      private function updateFavoritesRow(row:MovieClip, rowIndex:int, data:PhoneBookContact, dataIndex:int) : void
      {
         var label:String = null;
         var type:String = null;
         var dialButton:Boolean = false;
         var callList:Vector.<BluetoothCall> = null;
         t(row.detail_group.call_widget.value_label,T.STRB_CALL_PHONEBOOK);
         t(row.select_label,T.STRB_SELECT_PHONEBOOK);
         row.contact_group.visible = false;
         row.detail_group.visible = true;
         row.options_button.visible = true;
         this.setRowEnabled(row,true);
         if(data != null)
         {
            label = "";
            type = null;
            dialButton = Peripheral.bluetoothPhone.getHoldingCall() == null || Peripheral.bluetoothPhone.getActiveCall() == null || this.mAddingFavorite;
            if(dialButton)
            {
               row.detail_group.call_widget.value_label.textColor = 16777215;
            }
            else
            {
               row.detail_group.call_widget.value_label.textColor = 10066329;
            }
            if(data.favIndex != 255)
            {
               this.setRowEnabled(row,dialButton);
            }
            if(data.homeNumber != "")
            {
               label = Format.phoneNumber(data.homeNumber);
               type = "home";
            }
            else if(data.mobileNumber != "")
            {
               label = Format.phoneNumber(data.mobileNumber);
               type = "mobile";
            }
            else if(data.workNumber != "")
            {
               label = Format.phoneNumber(data.workNumber);
               type = "work";
            }
            else if(data.otherNumber != "")
            {
               label = Format.phoneNumber(data.otherNumber);
               if(data.formattedName != "")
               {
                  type = "circle";
               }
               else
               {
                  type = "undefined";
               }
            }
            else if(data.favIndex == 255)
            {
               type = null;
            }
            if("" != data.formattedName)
            {
               label = data.formattedName;
            }
            if(EMERGENCY_FAV_INDEX == data.favIndex)
            {
               label = compose(T.STRB_MENU_EMERGENCY);
               type = "circle";
            }
            if(TOWING_ASSIS_FAV_INDEX == data.favIndex)
            {
               label = compose(T.STRB_PHONE_TOWING_ASSISTANCE);
               type = "circle";
            }
            if(type != null && type != "undefined")
            {
               if(type == "circle" && (EMERGENCY_FAV_INDEX == data.favIndex || TOWING_ASSIS_FAV_INDEX == data.favIndex))
               {
                  Format.colorize(row.detail_group.name_label,label,Style.OTHER_CALL_COLOR);
               }
               else
               {
                  t(row.detail_group.name_label,label);
                  row.detail_group.name_label.textColor = 16777215;
               }
               row.detail_group.type_icon.gotoAndStop(type);
               row.detail_group.type_icon.visible = true;
               row.detail_group.call_widget.visible = !this.mAddingFavorite;
            }
            else if(type == "undefined")
            {
               t(row.detail_group.name_label,label);
               row.detail_group.name_label.textColor = 16777215;
               row.detail_group.type_icon.visible = false;
               row.detail_group.call_widget.visible = !this.mAddingFavorite;
            }
            else
            {
               callList = Peripheral.bluetoothPhone.currentCalls;
               if(callList.length > 0 || this.mTimeOutTimer.running)
               {
                  if(callList.length > 1 && (callList[0].callState == "active" && callList[1].callState == "active"))
                  {
                     row.detail_group.name_label.text = compose(T.STRB_EMPTY);
                  }
                  else if(callList.length >= 1 && callList[0].audio == false)
                  {
                     this.setRowEnabled(row,false);
                     row.detail_group.name_label.text = compose(T.STRB_EMPTY);
                  }
                  else
                  {
                     row.detail_group.name_label.text = compose(T.STRB_HOLD_TO_SET_PHONE);
                  }
               }
               else
               {
                  row.detail_group.name_label.text = compose(T.STRB_EMPTY);
               }
               row.detail_group.name_label.textColor = 10066329;
               row.detail_group.type_icon.visible = false;
               row.detail_group.call_widget.visible = false;
            }
            if(rowIndex == 0)
            {
               this.updateScrollerPopup(mView.phonebook_scroller.decoration.popup);
            }
            if(row.detail_group.name_label.text != compose(T.STRB_MENU_EMERGENCY) && row.detail_group.name_label.text != compose(T.STRB_PHONE_TOWING_ASSISTANCE))
            {
               row.options_button.visible = !this.mAddingFavorite;
               row.options_button.setEnabled(true);
               row.options_button.setInteractive(true);
            }
            else if(this.mEcellPresent)
            {
               row.options_button.setEnabled(!this.mEcellPresent);
               row.options_button.setInteractive(!this.mEcellPresent);
            }
            if(EMERGENCY_FAV_INDEX == data.favIndex || TOWING_ASSIS_FAV_INDEX == data.favIndex)
            {
               if(this.mAddingFavorite)
               {
                  row.select_label.visible = !this.mAddingFavorite;
               }
            }
            else
            {
               row.select_label.visible = this.mAddingFavorite;
            }
         }
         else
         {
            row.detail_group.visible = false;
            row.options_button.visible = false;
            row.select_label.visible = false;
         }
      }
      
      private function updateMobileRow(row:MovieClip, rowIndex:int, data:PhoneBookContact, dataIndex:int) : void
      {
         var label:String = null;
         row.detail_group.call_widget.value_label.text = compose(T.STRB_CALL_PHONEBOOK);
         row.select_label.text = compose(T.STRB_SELECT_PHONEBOOK);
         this.setRowEnabled(row,false);
         if(Peripheral.phonebook.contactsCount == 0)
         {
            row.contact_group.visible = false;
            row.detail_group.visible = true;
            if(rowIndex == 0)
            {
               row.detail_group.name_label.text = compose(T.STRB_PHONE_NO_CONTACTS);
               row.options_button.visible = false;
               row.detail_group.type_icon.visible = false;
               row.detail_group.call_widget.visible = false;
               row.select_label.visible = false;
               row.options_button.visible = false;
               this.setRowEnabled(row,true);
            }
            else
            {
               row.detail_group.visible = false;
               row.options_button.visible = false;
               row.select_label.visible = false;
            }
         }
         else
         {
            row.detail_group.visible = false;
            row.options_button.visible = false;
            row.select_label.visible = false;
            if(data != null)
            {
               row.contact_group.visible = true;
               this.setRowEnabled(row,true);
               label = "";
               label = data.formattedName;
               t(row.contact_group.name_label,label);
               if(rowIndex == 0)
               {
                  this.updateScrollerPopup(mView.phonebook_scroller.decoration.popup);
               }
               if(this.mSearchResultActive)
               {
                  Format.underline(row.underline,row.contact_group.name_label,this.mSearchedString);
               }
            }
            else
            {
               row.underline.visible = false;
               row.contact_group.visible = false;
            }
         }
         if(rowIndex == 0 && Peripheral.phonebook.smartSpellerCount == 0 && this.mSearchResultActive == true)
         {
            row.detail_group.name_label.text = compose(T.STRB_SEARCH_NO_RESULTS_FOUND);
            row.detail_group.visible = true;
            row.options_button.visible = false;
            row.detail_group.type_icon.visible = false;
            row.detail_group.call_widget.visible = false;
            row.select_label.visible = false;
            row.options_button.visible = false;
            Peripheral.phonebook.forceRequestContactsList(0,0,"");
         }
      }
      
      private function updateDetailRow(row:MovieClip, rowIndex:int, data:Object, dataIndex:int) : void
      {
         var callsList:Vector.<BluetoothCall> = null;
         var dialButton:Boolean = false;
         var callData:BluetoothCall = null;
         var isCallConferenced:Boolean = false;
         row.detail_group.call_widget.value_label.text = compose(T.STRB_CALL_PHONEBOOK);
         row.select_label.text = compose(T.STRB_SELECT_PHONEBOOK);
         row.contact_group.visible = false;
         row.detail_group.name_label.textColor = 16777215;
         if(Peripheral.bluetoothPhone.getPrimaryCall() != null)
         {
            callData = Peripheral.bluetoothPhone.getPrimaryCall();
         }
         else if(Peripheral.bluetoothPhone.bluetoothHFP.getLastCallData() != null)
         {
            callData = Peripheral.bluetoothPhone.bluetoothHFP.getLastCallData();
         }
         if(callData != null)
         {
            callsList = Peripheral.bluetoothPhone.currentCalls;
            if(callsList.length > 1)
            {
               if(callsList[0].callState == "active" && callsList[1].callState == "active")
               {
                  isCallConferenced = true;
               }
               else
               {
                  isCallConferenced = false;
               }
            }
         }
         this.setRowEnabled(row,false);
         if(data != null)
         {
            row.detail_group.visible = true;
            this.setRowEnabled(row,true);
            row.detail_group.type_icon.visible = true;
            if(data.type == "name")
            {
               t(row.detail_group.name_label,data.text);
               row.options_button.visible = false;
               row.detail_group.call_widget.visible = false;
               row.select_label.visible = false;
               row.options_button.visible = false;
            }
            else
            {
               t(row.detail_group.name_label,Format.phoneNumber(data.text));
               row.options_button.visible = true;
               row.detail_group.call_widget.visible = true;
               if(!this.mAddingFavorite)
               {
                  if(data.text != "")
                  {
                     dialButton = (Peripheral.bluetoothPhone.getHoldingCall() == null || Peripheral.bluetoothPhone.getActiveCall() == null) && !isCallConferenced;
                     if(dialButton)
                     {
                        row.detail_group.call_widget.value_label.textColor = 16777215;
                     }
                     else
                     {
                        row.detail_group.call_widget.value_label.textColor = 10066329;
                     }
                     this.setRowEnabled(row,dialButton);
                  }
                  if(INITIAL_DETAILS_CURSOR_POS == rowIndex)
                  {
                     mView.phonebook_list.setCursor(INITIAL_DETAILS_CURSOR_POS);
                  }
               }
               else
               {
                  row.detail_group.call_widget.visible = false;
               }
               row.select_label.visible = this.mAddingFavorite;
               row.options_button.visible = !this.mAddingFavorite;
            }
            switch(data.type)
            {
               case "name":
                  row.detail_group.type_icon.gotoAndStop("contact");
                  row.detail_group.type_icon.visible = true;
                  break;
               case "home":
                  row.detail_group.type_icon.gotoAndStop("home");
                  row.detail_group.type_icon.visible = true;
                  break;
               case "mobile":
                  row.detail_group.type_icon.gotoAndStop("mobile");
                  row.detail_group.type_icon.visible = true;
                  break;
               case "work":
                  row.detail_group.type_icon.gotoAndStop("work");
                  row.detail_group.type_icon.visible = true;
                  break;
               case "other":
                  row.detail_group.type_icon.gotoAndStop("circle");
                  row.detail_group.type_icon.visible = true;
                  break;
               default:
                  row.detail_group.type_icon.visible = false;
            }
         }
         else
         {
            row.detail_group.visible = false;
            row.options_button.visible = false;
            row.select_label.visible = false;
         }
      }
      
      private function changeSelection(row:MovieClip, selected:Boolean) : void
      {
         row.row_button.setSelected(selected);
      }
      
      private function hideTheAlphaJumpButton() : void
      {
         if(Global.region == TunerRegion.CHINA || Global.region == TunerRegion.JAPAN || Global.region == TunerRegion.KOREA)
         {
            mView.alpha_button.visible = false;
            mView.search_button.x = mView.alpha_button.x;
         }
         else
         {
            mView.alpha_button.visible = true;
         }
      }
      
      private function setRowEnabled(row:MovieClip, enable:Boolean) : void
      {
         row.row_button.setInteractive(enable);
         row.row_button.setEnabled(enable);
      }
      
      private function goFavorites() : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS);
         Peripheral.phonebook.lastModePhonebookScreen = "favorites";
         this.mCurrentView = FAVORITES_VIEW;
         mView.btnClearResults_button.visible = false;
         mView.searchDescription.visible = false;
         this.mSearchResultActive = false;
         this.mEmergencyNumber = Peripheral.phonebook.emergencyNumber;
         this.mTowingAssistanceNumber = Peripheral.phonebook.towingAssistanceNumber;
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(this.mAddingFavorite ? T.STRB_SELECT_CONTACT_UPDATE_BREADCRUMB : T.STRB_FAVOURITES_BREADCRUMB));
         var row:MovieClip = mView.phonebook_list.reserveHeader(this.mAddingFavorite);
         row.visible = !this.mAddingFavorite;
         row.contact_group.visible = this.mAddingFavorite;
         row.detail_group.visible = this.mAddingFavorite;
         mView.itemCount_label.visible = true;
         t(mView.itemCount_label,Format.itemsInList(Peripheral.phonebook.favoritesCount - 2));
         mView.phonebook_scroller.setPageSize(MAX_ITEMS_PER_PAGE);
         mView.phonebook_list.setLength(0);
         mView.phonebook_list.setRowUpdater(this.updateFavoritesRow);
         mView.phonebook_list.setDataRequester(this.requestFavoritesData);
         mView.phonebook_list.setLength(MAX_FAVORITES);
         mView.phonebook_scroller.setValue(0);
         mView.phonebook_scroller.visible = true;
         mView.favorites_button.setEnabled(true);
         mView.favorites_button.setHighlight(true);
         mView.favorites_button.setInteractive(true);
         mView.mobile_button.setHighlight(false);
         mView.mobile_button.setInteractive(true);
         mView.alpha_button.visible = false;
         mView.search_button.visible = false;
         mView.cancel_button.visible = this.mAddingFavorite;
         this.checkMiddleFocus();
      }
      
      private function goMobile(resetView:Boolean = true) : void
      {
         Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS);
         Peripheral.phonebook.lastModePhonebookScreen = "mobile";
         this.mCurrentView = MOBILE_VIEW;
         Peripheral.phonebook.startIndex = -1;
         this.mSearchResultActive = false;
         this.mSearchedString = "";
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(this.mAddingFavorite ? T.STRB_SELECT_CONTACT_FAVORITES_BREADCRUMB : T.STRB_MOBILE_BREADCRUMB));
         mView.itemCount_label.visible = true;
         t(mView.itemCount_label,Format.itemsInList(Peripheral.phonebook.contactsCount));
         var row:MovieClip = mView.phonebook_list.reserveHeader(true);
         row.contact_group.visible = false;
         row.detail_group.visible = false;
         row.options_button.visible = false;
         row.select_label.visible = false;
         mView.phonebook_scroller.setPageSize(MAX_ITEMS_PER_PAGE - 1);
         mView.phonebook_scroller.setPopupPageThreshold(1);
         mView.phonebook_list.setLength(0);
         mView.phonebook_list.setRowUpdater(this.updateMobileRow);
         mView.phonebook_list.setDataRequester(this.requestMobileData);
         mView.phonebook_list.setLength(Peripheral.phonebook.contactsCount);
         mView.phonebook_list.setPosition(resetView ? 0 : this.mLastMobilePosition);
         mView.phonebook_list.setSelectionChanger(this.changeSelection);
         mView.phonebook_list.update();
         mView.favorites_button.setHighlight(false);
         mView.favorites_button.setEnabled(!this.mAddingFavorite);
         mView.favorites_button.setInteractive(!this.mAddingFavorite);
         mView.mobile_button.setHighlight(true);
         mView.mobile_button.setInteractive(true);
         this.hideTheAlphaJumpButton();
         mView.search_button.visible = true;
         mView.cancel_button.visible = this.mAddingFavorite;
         if(Peripheral.vehicleStatus.speedLockOut)
         {
            mView.search_button.setEnabled(false);
         }
         else
         {
            mView.search_button.setEnabled(true);
            mView.search_button.setInteractive(true);
         }
         mView.btnClearResults_button.visible = false;
         mView.searchDescription.visible = false;
         this.checkMiddleFocus();
      }
      
      private function goDetail() : void
      {
         var row:MovieClip = null;
         this.mCurrentView = DETAIL_VIEW;
         this.initBreadcrumbs();
         row = mView.phonebook_list.reserveHeader(false);
         row.visible = true;
         mView.itemCount_label.visible = false;
         if(this.mAddingFavorite)
         {
            pushBreadcrumb(new Breadcrumb(T.STRB_SELECT_CONTACT_NUMBER_BREADCRUMB));
         }
         else
         {
            pushBreadcrumb(new Breadcrumb(T.STRB_MOBILE_BREADCRUMB,Breadcrumb.FUNCTION,this.goMobile));
            pushBreadcrumb(new Breadcrumb(T.STRB_CONTACT_DETAILS_BREADCRUMB));
         }
         mView.phonebook_scroller.setPageSize(MAX_ITEMS_PER_PAGE);
         mView.phonebook_scroller.setValue(0);
         mView.phonebook_list.setLength(0);
         mView.phonebook_list.setRowUpdater(this.updateDetailRow);
         mView.phonebook_list.setDataRequester(this.requestDetailData);
         mView.phonebook_list.setLength(this.mDetailData.length);
         mView.phonebook_list.setSelectionChanger(this.changeSelection);
         mView.phonebook_list.update();
         mView.favorites_button.setHighlight(false);
         mView.favorites_button.setEnabled(!this.mAddingFavorite);
         mView.favorites_button.setInteractive(!this.mAddingFavorite);
         mView.mobile_button.setHighlight(true);
         mView.mobile_button.setInteractive(false);
         mView.alpha_button.visible = false;
         mView.search_button.visible = false;
         mView.searchDescription.visible = false;
         mView.btnClearResults_button.visible = false;
         mView.cancel_button.visible = this.mAddingFavorite;
         this.checkMiddleFocus();
      }
      
      private function onListSelect(e:WidgetEvent) : void
      {
         var dial:Boolean = false;
         var numberType:String = null;
         var obj:Object = new Object();
         switch(this.mCurrentView)
         {
            case FAVORITES_VIEW:
               obj = this.onFavoritesListSelect(e);
               mView.phonebook_list.update();
               break;
            case MOBILE_VIEW:
               this.onMobileListSelect(e);
               this.mLastMobilePosition = e.data.dataIndex;
               break;
            case DETAIL_VIEW:
               obj = this.onDetailsListSelect(e);
         }
         if(obj != null && obj.number != null)
         {
            dial = Peripheral.bluetoothPhone.getHoldingCall() == null || Peripheral.bluetoothPhone.getActiveCall() == null;
            if(dial)
            {
               this.mCalledNumber = obj.number;
               if(obj.name == compose(T.STRB_MENU_EMERGENCY) && this.mEcellPresent)
               {
                  Peripheral.ecallsvc.startECall();
               }
               else if(obj.name == compose(T.STRB_PHONE_TOWING_ASSISTANCE) && this.mEcellPresent)
               {
                  Peripheral.appManager.startXlet("3bbeae36-1542-11e1-b393-31614824019b","true");
               }
               else if(obj.number != "")
               {
                  numberType = "";
                  if(obj.numberType != null)
                  {
                     switch(obj.numberType)
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
                  }
                  Peripheral.bluetoothPhone.bluetoothHFP.dial(obj.number,obj.name,numberType);
                  Framework.structure.goto(Screens.MAIN_PHONE);
               }
            }
         }
      }
      
      private function onMobileListSelect(e:WidgetEvent) : String
      {
         var contact:PhoneBookContact = e.data.data;
         this.mDetailData = new Array();
         var label:String = "";
         if(contact.formattedName != "")
         {
            label = contact.formattedName;
         }
         this.mDetailData.push({
            "text":label,
            "type":"name"
         });
         if(contact.homeNumber)
         {
            this.mDetailData.push({
               "text":contact.homeNumber,
               "type":"home"
            });
         }
         if(contact.mobileNumber)
         {
            this.mDetailData.push({
               "text":contact.mobileNumber,
               "type":"mobile"
            });
         }
         if(contact.workNumber)
         {
            this.mDetailData.push({
               "text":contact.workNumber,
               "type":"work"
            });
         }
         if(contact.otherNumber)
         {
            this.mDetailData.push({
               "text":contact.otherNumber,
               "type":"other"
            });
         }
         this.goDetail();
         return null;
      }
      
      private function onDetailsListSelect(e:WidgetEvent) : Object
      {
         var contact:PhoneBookContact = null;
         var obj:Object = null;
         var row:MovieClip = e.data.visual;
         var targetName:String = e.data.targetName;
         var detail:Object = e.data.data;
         if(targetName == "options_button")
         {
            this.mContact = contact;
            this.mFavNumberType = "";
            this.mSendTextMsgNumber = "";
            this.mSendTextMsgName = "";
            if(detail.type != "name")
            {
               this.mSendTextMsgNumber = this.mFavNumber = detail.text;
               this.mSendTextMsgName = this.mDetailData[0].text;
               this.mFavNumberType = detail.type;
               if(Framework.focusManager.cursorActive)
               {
                  Framework.popupManager.show(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS,Screens.POPUP_OPTIONS,{
                     "timeout":0,
                     "type":PopupType.OPTIONS,
                     "title":T.STRB_OPTIONS,
                     "ids":[CALL,ADD_TO_FAVS,SEND_TEXT_MSG],
                     "labels":[T.STRB_CALL,T.STRB_ADD_TO_FAVS,T.STRB_SMS_SEND_TEXT_MSG],
                     "highlight":[false,false,false,false,false],
                     "enabled":[true,true,Peripheral.smsMessaging.isSendSupported,false,false],
                     "callBack":this.onOptionsCallBack
                  });
               }
               else
               {
                  Framework.popupManager.show(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS,Screens.POPUP_OPTIONS,{
                     "timeout":0,
                     "type":PopupType.OPTIONS,
                     "title":T.STRB_OPTIONS,
                     "ids":[ADD_TO_FAVS,SEND_TEXT_MSG],
                     "labels":[T.STRB_ADD_TO_FAVS,T.STRB_SMS_SEND_TEXT_MSG],
                     "highlight":[false,false,false,false,false],
                     "enabled":[true,Peripheral.smsMessaging.isSendSupported,false,false,false],
                     "callBack":this.onOptionsCallBack
                  });
               }
            }
         }
         else if(!this.mAddingFavorite)
         {
            if(Framework.focusManager.cursorActive)
            {
               this.mContact = contact;
               this.mFavNumberType = "";
               this.mSendTextMsgNumber = "";
               this.mSendTextMsgName = "";
               if(detail.type != "name")
               {
                  this.mSendTextMsgNumber = this.mFavNumber = detail.text;
                  this.mSendTextMsgName = this.mDetailData[0].text;
                  this.mFavNumberType = detail.type;
                  Framework.popupManager.show(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS,Screens.POPUP_OPTIONS,{
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
            }
            else if(detail.type != "name")
            {
               return {
                  "number":detail.text,
                  "name":this.mDetailData[0].text,
                  "numberType":detail.type
               };
            }
         }
         else if(this.mAddingNAVFavorite)
         {
            this.mAddingNAVFavorite = false;
            if(Peripheral.navigation.navDomainControl.addContactToFavoriteDestinationsAvailable)
            {
               Peripheral.navigation.navDomainControl.addContactToFavoriteDestinations(this.mDetailData[0].text,detail.text,{
                  "screenName":"mainbackground/menu/PhonebookScreen",
                  "show":"AddFromNav"
               });
            }
         }
         else
         {
            this.mAddingFavorite = false;
            this.mPhonebookContact.formattedName = this.mDetailData[0].text;
            this.mPhonebookContact.homeNumber = detail.type == "home" ? detail.text : "";
            this.mPhonebookContact.workNumber = detail.type == "work" ? detail.text : "";
            this.mPhonebookContact.mobileNumber = detail.type == "mobile" ? detail.text : "";
            this.mPhonebookContact.otherNumber = detail.type == "other" ? detail.text : "";
            if("home" == detail.type || "mobile" == detail.type || "work" == detail.type || "other" == detail.type)
            {
               if(0 <= this.mfavIndex && 4 >= this.mfavIndex)
               {
                  this.mPhonebookContact.favIndex = this.mfavIndex + 1;
               }
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               Peripheral.bluetoothPhone.phoneBook.addFavorite(this.mPhonebookContact);
               this.goFavorites();
            }
         }
         return null;
      }
      
      private function onFavoritesListSelect(e:WidgetEvent) : Object
      {
         var obj:Object = null;
         var row:MovieClip = e.data.visual;
         this.mContact = e.data.data;
         this.mfavIndex = e.data.dataIndex;
         if(EMERGENCY_FAV_INDEX == this.mContact.favIndex)
         {
            this.mSpecialNumber = "emergencyNumber";
         }
         else if(TOWING_ASSIS_FAV_INDEX == this.mContact.favIndex)
         {
            this.mSpecialNumber = "towingAssistance";
         }
         if(e.data.targetName == "options_button")
         {
            if(this.mContact.homeNumber == "" && this.mContact.mobileNumber == "" && this.mContact.otherNumber == "" && this.mContact.workNumber == "" && this.mContact.formattedName != "Emergency" && this.mContact.formattedName != "Towing Assistance")
            {
               Framework.popupManager.show(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":T.STRB_OPTIONS,
                  "ids":[ADD_FROM_MOBILE],
                  "labels":[T.STRB_ADD_FROM_MOBILE],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,true,true,true]
               });
            }
            else if(EMERGENCY_FAV_INDEX == this.mContact.favIndex || TOWING_ASSIS_FAV_INDEX == this.mContact.favIndex)
            {
               Framework.popupManager.show(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":T.STRB_OPTIONS,
                  "ids":[EDIT_NUMBER,RESET_TO_DEFAULT],
                  "labels":[T.STRB_PHONE_EDIT_NUMBER,T.STRB_RESET_TO_DEFAULT],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,true,true,true,true]
               });
            }
            else
            {
               this.mSendTextMsgName = this.mContact.formattedName;
               if("" != this.mContact.mobileNumber)
               {
                  this.mSendTextMsgNumber = this.mContact.mobileNumber;
               }
               if("" != this.mContact.workNumber)
               {
                  this.mSendTextMsgNumber = this.mContact.workNumber;
               }
               if("" != this.mContact.homeNumber)
               {
                  this.mSendTextMsgNumber = this.mContact.homeNumber;
               }
               if("" != this.mContact.otherNumber)
               {
                  this.mSendTextMsgNumber = this.mContact.otherNumber;
               }
               Framework.popupManager.show(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE,"popupoptions",{
                  "timeout":0,
                  "type":PopupType.OPTIONS,
                  "title":T.STRB_OPTIONS,
                  "ids":[REMOVE_FROM_FAVS],
                  "labels":[T.STRB_REMOVE_FROM_FAVS],
                  "highlight":[false,false,false,false,false],
                  "enabled":[true,Peripheral.smsMessaging.isSendSupported,false,false,false]
               });
            }
         }
         else
         {
            if(!this.mAddingFavorite)
            {
               obj = new Object();
               if(this.mContact.homeNumber != "")
               {
                  obj.number = this.mContact.homeNumber;
               }
               else if(this.mContact.mobileNumber != "")
               {
                  obj.number = this.mContact.mobileNumber;
               }
               else if(this.mContact.workNumber != "")
               {
                  obj.number = this.mContact.workNumber;
               }
               else if(this.mContact.otherNumber != "")
               {
                  obj.number = this.mContact.otherNumber;
               }
               else if(Peripheral.bluetoothPhone.currentCalls.length > 0 || this.mTimeOutTimer.running)
               {
                  this.storeFavourite(this.mfavIndex + 1);
               }
               if("Emergency" == this.mContact.formattedName)
               {
                  obj.name = compose(T.STRB_MENU_EMERGENCY);
                  obj.number = Peripheral.phonebook.emergencyNumber;
               }
               else if("Towing Assistance" == this.mContact.formattedName)
               {
                  obj.name = compose(T.STRB_PHONE_TOWING_ASSISTANCE);
                  obj.number = Peripheral.phonebook.towingAssistanceNumber;
               }
               else
               {
                  obj.name = this.mContact.formattedName;
               }
               if(Framework.focusManager.cursorActive)
               {
                  if(this.mContact.homeNumber == "" && this.mContact.mobileNumber == "" && this.mContact.otherNumber == "" && this.mContact.workNumber == "" && this.mContact.formattedName != "Emergency" && this.mContact.formattedName != "Towing Assistance")
                  {
                     Framework.popupManager.show(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE,Screens.POPUP_OPTIONS,{
                        "timeout":0,
                        "type":PopupType.OPTIONS,
                        "title":T.STRB_OPTIONS,
                        "ids":[ADD_FROM_MOBILE],
                        "labels":[T.STRB_ADD_FROM_MOBILE],
                        "highlight":[false],
                        "enabled":[true]
                     });
                  }
                  else
                  {
                     Framework.popupManager.show(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS,Screens.POPUP_OPTIONS,{
                        "timeout":0,
                        "type":PopupType.OPTIONS,
                        "title":T.STRB_OPTIONS,
                        "ids":[CALL,REMOVE_FROM_FAVS,SEND_TEXT_MSG],
                        "labels":[T.STRB_CALL,T.STRB_REMOVE_FROM_FAVS,T.STRB_SMS_SEND_TEXT_MSG],
                        "highlight":[false,false,false],
                        "enabled":[true,true,Peripheral.smsMessaging.isSendSupported],
                        "callBack":this.onOptionsCallBack
                     });
                  }
                  return null;
               }
               return obj;
            }
            if(!(this.mContact.formattedName == "Emergency" || this.mContact.formattedName == "Towing Assistance"))
            {
               this.mAddingFavorite = false;
               this.mContact.formattedName = this.mPhonebookContact.formattedName;
               this.mContact.homeNumber = "";
               this.mContact.mobileNumber = "";
               this.mContact.workNumber = "";
               this.mContact.otherNumber = "";
               switch(this.mFavNumberType)
               {
                  case "home":
                     if("" != this.mPhonebookContact.homeNumber)
                     {
                        this.mContact.homeNumber = this.mPhonebookContact.homeNumber;
                     }
                     break;
                  case "mobile":
                     if("" != this.mPhonebookContact.mobileNumber)
                     {
                        this.mContact.mobileNumber = this.mPhonebookContact.mobileNumber;
                     }
                     break;
                  case "work":
                     if("" != this.mPhonebookContact.workNumber)
                     {
                        this.mContact.workNumber = this.mPhonebookContact.workNumber;
                     }
                     break;
                  case "other":
                     if("" != this.mPhonebookContact.otherNumber)
                     {
                        this.mContact.otherNumber = this.mPhonebookContact.otherNumber;
                     }
               }
               Framework.popupManager.show(DynamicPopupNames.PHONE_COPIED_TO_FAVORITES,"phonepairingpopup",{
                  "type":PopupType.PRIMARY,
                  "status":"copied to favorites",
                  "timeout":2000
               });
               if(1 <= this.mContact.favIndex && MAX_ITEMS_PER_PAGE - 1 >= this.mContact.favIndex)
               {
                  Peripheral.bluetoothPhone.phoneBook.replaceFavorite(this.mContact);
               }
               else if(255 == this.mContact.favIndex)
               {
                  this.mPhonebookContact.favIndex = this.mfavIndex + 1;
                  Peripheral.bluetoothPhone.phoneBook.addFavorite(this.mPhonebookContact);
               }
               this.goDetail();
            }
         }
         return null;
      }
      
      private function onListPosition(e:WidgetEvent) : void
      {
         switch(this.mCurrentView)
         {
            case MOBILE_VIEW:
               if(e.data != null)
               {
                  this.mLastMobilePosition = e.data;
               }
         }
      }
      
      private function onMessage(evt:MessageEvent) : void
      {
         var jumpCharacter:String = null;
         var newIndex:int = 0;
         if(evt.message.type == "alpha number")
         {
            jumpCharacter = evt.message.value;
            newIndex = int(Peripheral.phonebook.indexFromStartCharacter(jumpCharacter));
            mView.phonebook_scroller.setValue(newIndex);
            mView.phonebook_list.setCursor(newIndex);
         }
         else if(evt.message.type == "smart speller")
         {
            this.mSearchedString = evt.message.searchString;
            this.onSearchResultsScreen();
         }
         else if(evt.message.type == "screen transition")
         {
            switch(evt.message.value)
            {
               case "favorites":
                  this.goFavorites();
                  break;
               case "mobile":
               default:
                  this.goMobile();
            }
         }
      }
      
      private function showContact(contact:Object) : void
      {
         this.mDetailData = new Array();
         this.mDetailData.push({
            "text":contact.formattedName,
            "type":"name"
         });
         if(contact.homeNumber)
         {
            this.mDetailData.push({
               "text":contact.homeNumber,
               "type":"home"
            });
         }
         if(contact.mobileNumber)
         {
            this.mDetailData.push({
               "text":contact.mobileNumber,
               "type":"mobile"
            });
         }
         if(contact.workNumber)
         {
            this.mDetailData.push({
               "text":contact.workNumber,
               "type":"work"
            });
         }
         if(contact.otherNumber)
         {
            this.mDetailData.push({
               "text":contact.otherNumber,
               "type":"other"
            });
         }
         this.goDetail();
      }
      
      private function onPhoneBookContact(evt:PhoneBookEvent) : void
      {
         if(evt.m_data.result != null)
         {
            this.showContact(evt.m_data.result[0]);
         }
      }
      
      private function onFavoriteUpdated(evt:PhoneBookEvent) : void
      {
         if(this.mCurrentView == FAVORITES_VIEW)
         {
            mView.phonebook_scroller.setValue(0);
            mView.phonebook_list.setDataRequester(this.requestFavoritesData);
         }
      }
      
      private function updateScrollerPopup(popup:MovieClip) : void
      {
         var text:String = "";
         if(MOBILE_VIEW == this.mCurrentView)
         {
            text = mView.phonebook_list.row_1_group.contact_group.name_label.text.charAt(0);
         }
         else if(FAVORITES_VIEW == this.mCurrentView)
         {
            mView.phonebook_scroller.decoration.popup.visible = false;
            text = mView.phonebook_list.row_0_group.detail_group.name_label.text.charAt(0);
         }
         popup.value_label.text = text.toUpperCase();
      }
      
      private function storeFavourite(favId:uint) : void
      {
         var contactId:int = 0;
         var callsList:Vector.<BluetoothCall> = null;
         var favoritesContacts:Vector.<PhoneBookContact> = Peripheral.bluetoothPhone.phoneBook.favoritesList(Peripheral.bluetoothPhone.phoneBook.requestFavoritesByRange(0,MAX_FAVORITES));
         var flag:Boolean = false;
         var length:int = int(favoritesContacts.length);
         while(length)
         {
            if(favoritesContacts[--length].favIndex == favId)
            {
               contactId = int(favoritesContacts[length].id);
               flag = true;
            }
         }
         var callNumber:String = "";
         var data:PhoneBookContact = new PhoneBookContact(null,favId);
         var contact_name:String = "";
         var callData:BluetoothCall = null;
         var isCallConferenced:Boolean = false;
         if(Peripheral.bluetoothPhone.getPrimaryCall() != null)
         {
            callData = Peripheral.bluetoothPhone.getPrimaryCall();
         }
         else if(Peripheral.bluetoothPhone.bluetoothHFP.getLastCallData() != null)
         {
            callData = Peripheral.bluetoothPhone.bluetoothHFP.getLastCallData();
         }
         if(callData != null)
         {
            callsList = Peripheral.bluetoothPhone.currentCalls;
            if(callsList.length > 1)
            {
               if(callsList[0].callState == "active" && callsList[1].callState == "active")
               {
                  isCallConferenced = true;
               }
               else
               {
                  isCallConferenced = false;
               }
            }
            callNumber = callData.number;
            if(callData.callerID != "" && callData.callerID != null)
            {
               contact_name = callData.callerID;
               switch(callData.numberType)
               {
                  case "homeNumber":
                     data.homeNumber = callNumber;
                     break;
                  case "mobileNumber":
                     data.mobileNumber = callNumber;
                     break;
                  case "workNumber":
                     data.workNumber = callNumber;
                     break;
                  default:
                     data.otherNumber = callNumber;
               }
               data.formattedName = callData.callerID;
            }
            else
            {
               contact_name = callNumber;
               data.otherNumber = callNumber;
            }
            if(12 < contact_name.length)
            {
               contact_name = contact_name.substr(0,10) + "...";
            }
            data.favIndex = favId;
            if(!isCallConferenced)
            {
               if(!flag)
               {
                  if(1 <= data.favIndex && 5 >= data.favIndex)
                  {
                     Peripheral.bluetoothPhone.phoneBook.addFavorite(data);
                  }
               }
               else
               {
                  data.id = contactId;
                  if(1 <= data.favIndex && 5 >= data.favIndex)
                  {
                     Peripheral.bluetoothPhone.phoneBook.replaceFavorite(data);
                  }
               }
            }
         }
      }
      
      private function onOptionsPopupClosed(e:GlobalEvent) : void
      {
      }
      
      private function onOptionsPopupButton(e:GlobalEvent) : void
      {
         if(Framework.popupManager.active == DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE)
         {
            switch(e.data.id)
            {
               case ADD_FROM_MOBILE:
                  this.mAddingFavorite = true;
                  this.goMobile();
                  break;
               case ADD_TO_FAVS:
                  this.mPhonebookContact.formattedName = this.mDetailData[0].text;
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
                     case "other":
                        this.mPhonebookContact.otherNumber = this.mFavNumber;
                  }
                  this.mAddingFavorite = true;
                  this.goFavorites();
                  break;
               case ADD_TO_NAV:
                  if(Peripheral.navigation.navDomainControl.addContactToFavoriteDestinationsAvailable)
                  {
                     Peripheral.navigation.navDomainControl.addContactToFavoriteDestinations(this.mDetailData[0].text,this.mFavNumber,{
                        "screenName":"mainbackground/menu/PhonebookScreen",
                        "show":"AddFromNav"
                     });
                  }
                  else
                  {
                     Framework.Trace("<Phonebook Screen> Failed to add to Navigation");
                  }
                  break;
               case REMOVE_FROM_FAVS:
                  Peripheral.phonebook.deleteFavorite(this.mContact);
                  break;
               case EDIT_NUMBER:
                  Framework.popupManager.show(DynamicPopupNames.PHONE_DIALING,"phonedialpadpopup",{
                     "type":PopupType.PRIMARY,
                     "specialNumber":true,
                     "specialNumberType":this.mSpecialNumber
                  });
                  break;
               case RESET_TO_DEFAULT:
                  Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
                     "type":PopupType.PRIMARY,
                     "status":"reset to default",
                     "specialNumberType":this.mSpecialNumber
                  });
                  break;
               case SEND_TEXT_MSG:
                  Peripheral.smsMessaging.outgoingMessageRecipientName = this.mSendTextMsgName;
                  Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = this.mSendTextMsgNumber;
                  Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumberType = this.mFavNumberType;
                  if(Peripheral.vehicleStatus.speedLockOut)
                  {
                     Peripheral.smsMessaging.startSMSDictation("new",true);
                  }
                  else
                  {
                     Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen","newMessageInit");
                  }
                  this.mSendTextMsgName = "";
                  this.mSendTextMsgNumber = "";
            }
            Framework.popupManager.dequeue(DynamicPopupNames.OPTIONS_PHONEBOOK_FAVORITE);
         }
      }
      
      private function onSearchResultsScreen(resetView:Boolean = true) : void
      {
         this.mCurrentView = MOBILE_VIEW;
         var row:MovieClip = mView.phonebook_list.reserveHeader(true);
         row.contact_group.visible = false;
         row.detail_group.visible = false;
         row.options_button.visible = false;
         row.select_label.visible = false;
         Peripheral.phonebook.startIndex = -1;
         this.mSearchResultActive = true;
         mView.btnClearResults_button.visible = true;
         mView.cancel_button.visible = false;
         mView.btnClearResults_button.value_label.text = compose(T.STRB_SEARCH_CLEAR_RESULTS);
         mView.searchDescription.visible = true;
         mView.alpha_button.visible = false;
         mView.search_button.visible = false;
         t(mView.searchDescription,[T.STRB_SEARCH_RESULTS_FOR,this.mSearchedString]);
         this.initBreadcrumbs();
         pushBreadcrumb(new Breadcrumb(T.STRB_SEARCH_RESULTS_BREADCRUMB));
         mView.phonebook_list.setLength(0);
         mView.phonebook_list.setRowUpdater(this.updateMobileRow);
         mView.phonebook_list.setDataRequester(this.requestMobileData);
         mView.phonebook_list.setLength(Peripheral.phonebook.smartSpellerCount);
         mView.phonebook_list.setPosition(resetView ? 0 : this.mLastMobilePosition);
         mView.itemCount_label.visible = true;
         t(mView.itemCount_label,Format.itemsInList(Peripheral.phonebook.smartSpellerCount));
         this.checkMiddleFocus();
      }
      
      private function onSpeedLockOutEvent(e:VehicleStatusEvent) : void
      {
         if(Peripheral.vehicleStatus.speedLockOut)
         {
            mView.search_button.setEnabled(false);
         }
         else
         {
            mView.search_button.setEnabled(true);
            mView.search_button.setInteractive(true);
         }
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
            if(senderName == phoneNumber)
            {
               senderName = "";
            }
            phoneCategory = this.mFavNumberType;
            Peripheral.voiceRecognition.emitSmsVRResponse(int(evt.mData.context),evt.mData.methodName,result,null,phoneNumber,false,senderName,phoneCategory);
         }
         Framework.structure.goto(Screens.MAIN_PHONE);
      }
      
      private function checkMiddleFocus() : void
      {
         if(Boolean(mView.alpha_button.visible) || Boolean(mView.search_button.visible) || Boolean(mView.btnClearResults_button.visible))
         {
            Framework.focusManager.addFocus(this.mFocusCommandButtons);
         }
         else
         {
            Framework.focusManager.delFocus(this.mFocusCommandButtons);
         }
      }
      
      private function onOptionsCallBack(o:Object) : void
      {
         var detail:Object = null;
         var obj:Object = null;
         var dial:Boolean = false;
         var numberType:String = null;
         Framework.popupManager.dequeue(DynamicPopupNames.MASERATI_OPTIONS_PHONEBOOK_CONTACT_DETAILS);
         switch(o.id)
         {
            case CALL:
               detail = mView.phonebook_list.getSelectedData();
               if(detail.type != "name")
               {
                  obj = {
                     "number":detail.text,
                     "name":this.mDetailData[0].text,
                     "numberType":detail.type
                  };
               }
               if(obj != null && obj.number != null)
               {
                  dial = Peripheral.bluetoothPhone.getHoldingCall() == null || Peripheral.bluetoothPhone.getActiveCall() == null;
                  if(dial)
                  {
                     this.mCalledNumber = obj.number;
                     if(obj.name == compose(T.STRB_MENU_EMERGENCY) && this.mEcellPresent)
                     {
                        Peripheral.ecallsvc.startECall();
                     }
                     else if(obj.name == compose(T.STRB_PHONE_TOWING_ASSISTANCE) && this.mEcellPresent)
                     {
                        Peripheral.appManager.startXlet("3bbeae36-1542-11e1-b393-31614824019b","true");
                     }
                     else if(obj.number != "")
                     {
                        numberType = "";
                        if(obj.numberType != null)
                        {
                           switch(obj.numberType)
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
                        }
                        Peripheral.bluetoothPhone.bluetoothHFP.dial(obj.number,obj.name,numberType);
                        Framework.structure.goto(Screens.MAIN_PHONE);
                     }
                  }
               }
               break;
            case ADD_TO_FAVS:
               this.mPhonebookContact.formattedName = this.mDetailData[0].text;
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
                  case "other":
                     this.mPhonebookContact.otherNumber = this.mFavNumber;
               }
               this.mAddingFavorite = true;
               this.goFavorites();
               break;
            case REMOVE_FROM_FAVS:
               Peripheral.phonebook.deleteFavorite(this.mContact);
               break;
            case ADD_FROM_MOBILE:
               this.mAddingFavorite = true;
               this.goMobile();
               break;
            case SEND_TEXT_MSG:
               Peripheral.smsMessaging.outgoingMessageRecipientName = this.mSendTextMsgName;
               Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumber = this.mSendTextMsgNumber;
               Peripheral.smsMessaging.outgoingMessageRecipientPhoneNumberType = this.mFavNumberType;
               if(Peripheral.vehicleStatus.speedLockOut)
               {
                  Peripheral.smsMessaging.startSMSDictation("new",true);
               }
               else
               {
                  Framework.structure.goto("mainbackground/menu/smsmessaginglistscreen","newMessageInit");
               }
               this.mSendTextMsgName = "";
               this.mSendTextMsgNumber = "";
         }
      }
      
      private function onCallStateChange(evt:BluetoothEvent) : void
      {
         if(Peripheral.bluetoothPhone.currentCalls.length > 0)
         {
            if(this.mCurrentView == FAVORITES_VIEW)
            {
               mView.phonebook_list.setRowUpdater(this.updateFavoritesRow);
            }
         }
         else
         {
            attachListener(this.mTimeOutTimer,TimerEvent.TIMER,this.onTimeOutTimer,false,0,true);
            this.mTimeOutTimer.start();
         }
         mView.phonebook_list.requestData();
      }
      
      private function onTimeOutTimer(evt:TimerEvent = null) : void
      {
         this.mTimeOutTimer.stop();
         detachListener(this.mTimeOutTimer,TimerEvent.TIMER,this.onTimeOutTimer);
         if(Peripheral.phonebook.lastModePhonebookScreen == "favorites")
         {
            mView.phonebook_list.setRowUpdater(this.updateFavoritesRow);
         }
      }
   }
}

