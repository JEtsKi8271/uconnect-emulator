package screens.NA_EU.RES_640x480
{
   import ancillary.DynamicPopupNames;
   import ancillary.Format;
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.framework.screenTemplates.GenericScreen;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.FocusObject;
   import core.enums.FocusPriority;
   import core.enums.Layers;
   import core.enums.PopupType;
   import events.WidgetEvent;
   import flash.display.MovieClip;
   import flash.events.*;
   import locale.T;
   import peripheral.Peripheral;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class PhoneDialPadPopup extends GenericScreen
   {
      
      private static const DIAL_DIGITS_ALLOWED:int = 32;
      
      private static const DIAL_DASH_COUNT:int = 2;
      
      private static const DISPLAY_CHAR_COUNT:int = 17;
      
      protected var mFinalString:String = "";
      
      protected var mDoneBtnStatus:Boolean = false;
      
      public function PhoneDialPadPopup()
      {
         mView = new C_DialPadPopupView();
         super();
      }
      
      override protected function initScreen() : void
      {
         super.initScreen();
         if(!mIsCached)
         {
            Framework.autoAssigner.assignChildren(view);
         }
         this.initView();
         Framework.focusManager.addFocus(new FocusObject(Layers.POPUPS,FocusPriority.REGULAR,[view.btns_group.btnOne_button,view.btns_group.btnTwo_button,view.btns_group.btnThree_button,view.btns_group.btnFour_button,view.btns_group.btnFive_button,view.btns_group.btnSix_button,view.btns_group.btnSeven_button,view.btns_group.btnEight_button,view.btns_group.btnNine_button,view.btns_group.btnStar_button,view.btns_group.btnZero_button,view.btns_group.btnPound_button,view.btns_group.done_button,view.btns_group.btnCall_button,view.btns_group.btnBackspaceButton]));
      }
      
      override protected function initView() : void
      {
         view.btns_group.btnBackspaceButton.setEnabled(false);
         super.initView();
         view.dialPadDisplay.labelValue.text = "";
         this.mFinalString = "";
         if(Boolean(screenVars) && screenVars.specialNumber == true)
         {
            view.labelTitle_translate.text = compose(T.STRB_PHONE_EDIT_NUMBER);
            view.btns_group.btnBackspaceButton.visible = true;
            view.btns_group.btnCall_button.visible = false;
            if("emergencyNumber" == screenVars.specialNumberType)
            {
               view.dialPadDisplay.labelValue.text = Format.phoneNumber(Peripheral.phonebook.emergencyNumber);
            }
            if("towingAssistance" == screenVars.specialNumberType)
            {
               view.dialPadDisplay.labelValue.text = Format.phoneNumber(Peripheral.phonebook.towingAssistanceNumber);
            }
            mView.btns_group.done_button.show();
         }
         else if(Boolean(screenVars) && screenVars.touchTone == true)
         {
            t(view.labelTitle_translate,T.STRB_TOUCH_TONE);
            view.btns_group.btnBackspaceButton.visible = false;
            view.btns_group.btnCall_button.visible = false;
            mView.btns_group.done_button.hide();
            this.displayNumber(false);
         }
         else
         {
            t(view.labelTitle_translate,T.STRB_DIRECT_DIALING);
            view.btns_group.btnBackspaceButton.visible = this.isCallAllowed();
            view.btns_group.btnCall_button.visible = this.isCallAllowed();
            mView.btns_group.done_button.hide();
            this.displayNumber(true);
         }
         view.btns_group.btnBackspaceButton.delay = 500;
         view.btns_group.btnBackspaceButton.auto = 200;
      }
      
      override protected function addListeners() : void
      {
         var dialButton:MovieClip = null;
         super.addListeners();
         attachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateEvent);
         attachListener(view.btns_group.btnClose_button,MouseEvent.CLICK,this.closeScreenEvent);
         attachListener(view.btns_group.btnBackspaceButton,WidgetEvent.CLICK,this.btnBackspaceClickEvent);
         attachListener(view.btns_group.btnCall_button,MouseEvent.CLICK,this.btnCallClickEvent);
         attachListener(view.btns_group.done_button,MouseEvent.CLICK,this.btnDoneClickEvent);
         attachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange,false,0,true);
         var dialButtonArray:Array = [view.btns_group.btnZero_button,view.btns_group.btnOne_button,view.btns_group.btnTwo_button,view.btns_group.btnThree_button,view.btns_group.btnFour_button,view.btns_group.btnFive_button,view.btns_group.btnSix_button,view.btns_group.btnSeven_button,view.btns_group.btnEight_button,view.btns_group.btnNine_button,view.btns_group.btnStar_button,view.btns_group.btnPound_button];
         var i:int = -1;
         while(++i < dialButtonArray.length)
         {
            dialButton = dialButtonArray[i] as MovieClip;
            dialButton.i = i;
            attachListener(dialButton,WidgetEvent.CLICK,this.keypadPressEvent);
            attachListener(dialButton,WidgetEvent.LONG_PRESS,this.longKeypadPressEvent);
         }
      }
      
      override protected function removeListeners() : void
      {
         var dialButton:MovieClip = null;
         super.removeListeners();
         detachListener(Peripheral.bluetooth,BluetoothEvent.SERVICE_DISCONNECTED,this.onDeviceChange);
         detachListener(Peripheral.bluetoothPhone,BluetoothEvent.CALL_STATE,this.onCallStateEvent);
         detachListener(view.btns_group.btnClose_button,MouseEvent.CLICK,this.closeScreenEvent);
         detachListener(view.btns_group.btnBackspaceButton,WidgetEvent.CLICK,this.btnBackspaceClickEvent);
         detachListener(view.btns_group.btnCall_button,MouseEvent.CLICK,this.btnCallClickEvent);
         detachListener(view.btns_group.done_button,MouseEvent.CLICK,this.btnDoneClickEvent);
         var dialButtonArray:Array = [view.btns_group.btnZero_button,view.btns_group.btnOne_button,view.btns_group.btnTwo_button,view.btns_group.btnThree_button,view.btns_group.btnFour_button,view.btns_group.btnFive_button,view.btns_group.btnSix_button,view.btns_group.btnSeven_button,view.btns_group.btnEight_button,view.btns_group.btnNine_button,view.btns_group.btnStar_button,view.btns_group.btnPound_button];
         var i:int = -1;
         while(++i < dialButtonArray.length)
         {
            dialButton = dialButtonArray[i];
            dialButton.i = i;
            detachListener(dialButton,WidgetEvent.CLICK,this.keypadPressEvent);
            detachListener(dialButton,WidgetEvent.LONG_PRESS,this.longKeypadPressEvent);
         }
      }
      
      override protected function changeLocale(e:Event = null) : void
      {
         super.changeLocale(e);
         t(mView.btns_group.btnTwo_button.labelLetters,T.STRB_ABC);
         t(mView.btns_group.btnThree_button.labelLetters,T.STRB_DEF);
         t(mView.btns_group.btnFour_button.labelLetters,T.STRB_GHI);
         t(mView.btns_group.btnFive_button.labelLetters,T.STRB_JKL);
         t(mView.btns_group.btnSix_button.labelLetters,T.STRB_MNO);
         t(mView.btns_group.btnSeven_button.labelLetters,T.STRB_PQRS);
         t(mView.btns_group.btnEight_button.labelLetters,T.STRB_TUV);
         t(mView.btns_group.btnNine_button.labelLetters,T.STRB_WXYZ);
         t(mView.btns_group.btnCall_button.value_label,T.STRB_CALL);
         t(mView.btns_group.done_button.value_label,T.STRB_DONE);
      }
      
      protected function closeScreenEvent(e:Event) : void
      {
         Framework.popupManager.close();
      }
      
      protected function enableDoneButton() : void
      {
         if(this.mDoneBtnStatus)
         {
            view.btns_group.done_button.setInteractive(true);
            view.btns_group.done_button.setEnabled(true);
         }
         else
         {
            view.btns_group.done_button.setInteractive(false);
            view.btns_group.done_button.setEnabled(false);
         }
      }
      
      protected function onCallStateEvent(e:Event) : void
      {
         if(Peripheral.bluetoothPhone.getActiveCall() == null)
         {
            if(Framework.structure.currentBranch == Screens.MAIN_PHONE)
            {
               Framework.popupManager.close();
            }
         }
      }
      
      private function onDeviceChange(e:BluetoothEvent) : void
      {
         if(!this.isPhoneConnected())
         {
            Framework.popupManager.close();
            Framework.structure.goto(Screens.MAIN_PHONE);
            Framework.popupManager.show(DynamicPopupNames.PHONE_PAIRING,"phonepairingpopup",{
               "type":PopupType.SECONDARY,
               "status":"no phone connected",
               "timeout":3000
            });
         }
      }
      
      private function btnBackspaceClickEvent(e:Event) : void
      {
         if("" == this.mFinalString)
         {
            this.mFinalString = view.dialPadDisplay.labelValue.text;
         }
         this.backBtnPress();
      }
      
      private function btnCallClickEvent(e:Event) : void
      {
         this.callBtnPress();
      }
      
      protected function btnDoneClickEvent(e:Event) : void
      {
         if(this.mFinalString.length > 0 && null != screenVars)
         {
            Peripheral.phonebook.editSpecialNumber(this.mFinalString,screenVars.specialNumberType);
         }
         Framework.popupManager.close();
      }
      
      private function keypadPressEvent(e:Event) : void
      {
         if(Boolean(screenVars) && Boolean(screenVars.touchTone == true) && screenVars.specialNumber == true)
         {
            this.keypadPress(e.target.i);
         }
         else if(Boolean(screenVars) && screenVars.touchTone == true)
         {
            this.keypadPressTT(e.target.i);
         }
         else
         {
            this.keypadPress(e.target.i);
         }
         Framework.focusManager.refresh();
      }
      
      private function longKeypadPressEvent(e:Event) : void
      {
         if(0 == e.target.i)
         {
            this.longKeypadPress(e.target.i);
         }
         else
         {
            this.keypadPress(e.target.i);
         }
         Framework.focusManager.refresh();
      }
      
      private function displayNumber(dialing:Boolean) : void
      {
         var formattedNumber:String = null;
         var digitsInDisplay:int = 14;
         var dash_count:int = 0;
         if(dialing == true)
         {
            dash_count = DIAL_DASH_COUNT;
            formattedNumber = Format.phoneNumber(this.mFinalString);
         }
         else
         {
            formattedNumber = this.mFinalString;
         }
         if(formattedNumber.length <= digitsInDisplay + dash_count)
         {
            view.dialPadDisplay.labelValue.text = formattedNumber + "_";
         }
         else if(formattedNumber.length == DIAL_DIGITS_ALLOWED + dash_count)
         {
            view.dialPadDisplay.labelValue.text = "..." + formattedNumber.substr(formattedNumber.length - DISPLAY_CHAR_COUNT + 3);
         }
         else
         {
            view.dialPadDisplay.labelValue.text = "..." + formattedNumber.substr(formattedNumber.length - DISPLAY_CHAR_COUNT + 3 + 1) + "_";
         }
         if(formattedNumber.length > 0)
         {
            view.btns_group.btnCall_button.setInteractive(true);
            view.btns_group.btnCall_button.setEnabled(true);
            this.mDoneBtnStatus = true;
         }
         else
         {
            view.btns_group.btnCall_button.setInteractive(false);
            view.btns_group.btnCall_button.setEnabled(false);
            this.mDoneBtnStatus = false;
         }
         this.enableDoneButton();
      }
      
      private function keypadPressTT(value:int) : void
      {
         var keyPress:String = null;
         if(this.mFinalString.length < DIAL_DIGITS_ALLOWED)
         {
            if(value == 10)
            {
               keyPress = "*";
               this.mFinalString += "*";
            }
            else if(value == 11)
            {
               keyPress = "#";
               this.mFinalString += "#";
            }
            else
            {
               keyPress = value.toString();
               this.mFinalString += value;
            }
            Framework.Trace("TouchTone: " + keyPress);
            Peripheral.bluetooth.sendDTMFTone(keyPress);
            this.displayNumber(false);
         }
      }
      
      private function keypadPress(value:int) : void
      {
         if(this.mFinalString.length < DIAL_DIGITS_ALLOWED + DIAL_DASH_COUNT)
         {
            if(value == 10)
            {
               this.mFinalString += "*";
            }
            else if(value == 11)
            {
               this.mFinalString += "#";
            }
            else
            {
               this.mFinalString += value;
            }
            view.btns_group.btnBackspaceButton.setEnabled(true);
            this.displayNumber(true);
         }
         Framework.focusManager.refresh();
      }
      
      private function longKeypadPress(value:int) : void
      {
         if(this.mFinalString.length < DIAL_DIGITS_ALLOWED + DIAL_DASH_COUNT)
         {
            if(value == 0)
            {
               this.mFinalString += "+";
            }
            this.displayNumber(true);
         }
         Framework.focusManager.refresh();
      }
      
      private function backBtnPress() : void
      {
         this.mFinalString = this.mFinalString.slice(0,-1);
         this.displayNumber(true);
         if(this.mFinalString.length < 1)
         {
            view.btns_group.btnBackspaceButton.setEnabled(false);
         }
         else
         {
            view.btns_group.btnBackspaceButton.setEnabled(true);
         }
         Framework.focusManager.refresh();
      }
      
      private function callBtnPress() : void
      {
         if(this.mFinalString.length > 0)
         {
            Peripheral.bluetoothPhone.dial(this.mFinalString);
            Framework.structure.goto(Screens.MAIN_PHONE);
         }
      }
      
      private function isCallAllowed() : Boolean
      {
         var bCallAllowed:Boolean = true;
         if(Peripheral.bluetoothPhone.getActiveCall() != null && Peripheral.bluetoothPhone.bluetoothHFP.featureList.indexOf("PHONE_FEATURE_SWAP") == -1)
         {
            bCallAllowed = false;
         }
         return bCallAllowed;
      }
      
      protected function isPhoneConnected() : Boolean
      {
         var i:uint = 0;
         var btDeviceList:Vector.<BluetoothDevice> = Peripheral.bluetooth.getPairedDeviceListWithService("HFP");
         var numConnected:int = 0;
         if(btDeviceList.length > 0)
         {
            for(i = 0; i < btDeviceList.length; i++)
            {
               if(btDeviceList[i].HfpConnected == true)
               {
                  numConnected++;
               }
            }
         }
         return numConnected > 0;
      }
   }
}

