package peripheral
{
   import ancillary.Ancillary;
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.*;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.*;
   import core.enums.PopupType;
   import flash.events.*;
   import locale.T;
   
   public class KeySensePinManager
   {
      
      private static const MAX_PIN_ATTEMPTS:int = 3;
      
      private static const LOCKOUT_TIME:int = 30;
      
      private var mPopupState:String = "";
      
      private var mKeySensePin:String = "FFFF";
      
      private var mEnteredPin:String = "";
      
      private var mNumFailedAttemps:int = 0;
      
      private var mLockoutTime:int = 30;
      
      public function KeySensePinManager()
      {
         Peripheral.vehicleStatus.addEventListener(VehicleStatusEvent.KEYSENSE_TIMER_VALUE,this.onTimerUpdate,false,0,true);
         this.mNumFailedAttemps = Peripheral.persistency.getValue(PersistencyKeys.KEY_TEENSENSE_FAILED_ATTEMPTS).value;
         this.mLockoutTime = Peripheral.vehicleStatus.KeySensePinTimer;
         super();
      }
      
      public function KeySenseActivation() : void
      {
         if(Peripheral.vehicleStatus.keySenseSecurityPIN == "FFFF")
         {
            this.mPopupState = "no_pin";
            this.displayPopup(this.mPopupState);
         }
         else
         {
            this.mNumFailedAttemps = Peripheral.persistency.getValue(PersistencyKeys.KEY_TEENSENSE_FAILED_ATTEMPTS).value;
            this.mLockoutTime = Peripheral.vehicleStatus.KeySensePinTimer;
            this.mPopupState = "get_pin";
            if(this.mNumFailedAttemps >= MAX_PIN_ATTEMPTS && this.mLockoutTime != 0)
            {
               this.displayPopup("max_attempts");
            }
            else
            {
               this.displayPopup(this.mPopupState);
            }
         }
      }
      
      public function set enteredPin(_pin:String) : void
      {
         if(this.mEnteredPin == _pin)
         {
            Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            this.displayPopup("not_4_digits");
         }
         else
         {
            this.mEnteredPin = _pin;
         }
      }
      
      public function get enteredPin() : String
      {
         return this.mEnteredPin;
      }
      
      public function get lockoutTime() : int
      {
         return this.mLockoutTime;
      }
      
      private function onTimerUpdate(e:VehicleStatusEvent) : void
      {
         if(this.mLockoutTime != Peripheral.vehicleStatus.KeySensePinTimer)
         {
            this.mLockoutTime = Peripheral.vehicleStatus.KeySensePinTimer;
            if(this.mLockoutTime == 0)
            {
               if(this.mNumFailedAttemps != 0)
               {
                  this.mNumFailedAttemps = 0;
                  Peripheral.persistency.write(PersistencyKeys.KEY_TEENSENSE_FAILED_ATTEMPTS,{"value":this.mNumFailedAttemps});
               }
               if(this.mPopupState == "get_pin" && Framework.popupManager.active == DynamicPopupNames.TWOITEM_KEYSENSE_PIN)
               {
                  this.displayPopup("get_pin");
                  Framework.popupManager.dequeue(DynamicPopupNames.TWOITEM_KEYSENSE_PIN);
               }
            }
         }
      }
      
      public function onKeyPad(o:Object) : void
      {
         if(o.hasOwnProperty("input"))
         {
            this.enteredPin = o.input;
         }
         if(o.name == "go_button")
         {
            if(this.mEnteredPin.length != 4)
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
               this.displayPopup("not_4_digits");
            }
            else if(this.mPopupState == "get_pin" && this.mEnteredPin == Peripheral.vehicleStatus.keySenseSecurityPIN)
            {
               this.mEnteredPin = "";
               if(this.mNumFailedAttemps != 0)
               {
                  this.mNumFailedAttemps = 0;
                  Peripheral.persistency.write(PersistencyKeys.KEY_TEENSENSE_FAILED_ATTEMPTS,{"value":this.mNumFailedAttemps});
               }
               Framework.structure.goto(Screens.SETTINGS_KEYSENSE_MAIN);
               Framework.popupManager.dequeue(DynamicPopupNames.KEYSENSE_PIN_KEYPAD);
            }
            else if(o.mEnabled)
            {
               if(this.mPopupState == "get_new_pin")
               {
                  this.mKeySensePin = this.mEnteredPin;
                  Framework.popupManager.dequeue(DynamicPopupNames.KEYSENSE_PIN_KEYPAD);
                  this.mPopupState = "confirming_pin";
                  this.displayPopup("confirm_pin");
               }
               else if(this.mPopupState == "get_pin")
               {
                  ++this.mNumFailedAttemps;
                  Peripheral.persistency.write(PersistencyKeys.KEY_TEENSENSE_FAILED_ATTEMPTS,{"value":this.mNumFailedAttemps});
                  if(this.mNumFailedAttemps < MAX_PIN_ATTEMPTS)
                  {
                     this.displayPopup("failed_pin_entry");
                  }
                  else
                  {
                     Peripheral.vehicleStatus.setKeySensePinTimerState("active");
                     this.mLockoutTime = Peripheral.vehicleStatus.KeySensePinTimer;
                     this.displayPopup("max_attempts");
                     Framework.popupManager.dequeue(DynamicPopupNames.KEYSENSE_PIN_KEYPAD);
                  }
               }
            }
            else
            {
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_REJECTION);
            }
         }
         else if(o.name == "close_button")
         {
            this.mEnteredPin = "";
            Framework.popupManager.dequeue(DynamicPopupNames.KEYSENSE_PIN_KEYPAD);
         }
      }
      
      public function onPopupResponse(btn:Object) : void
      {
         if(btn == "btnLeft_button")
         {
            if(this.mPopupState == "no_pin")
            {
               if(Peripheral.vehicleStatus.speedLockOut)
               {
                  this.displayPopup("locked_out");
               }
               else
               {
                  this.mPopupState = "get_new_pin";
                  this.displayPopup("enter_new_pin");
               }
            }
            else if(this.mPopupState == "confirming_pin")
            {
               Peripheral.vehicleStatus.keySenseSecurityPIN = this.mKeySensePin;
               Peripheral.audioMixerManager.sendConfirmationTone(Peripheral.audioMixerManager.TONE_SET);
               this.mPopupState = "pin_saved";
               this.displayPopup("pin_saved");
            }
         }
         else if(btn == "btnRight_button")
         {
            if(this.mPopupState == "no_pin")
            {
               Framework.popupManager.close();
            }
            else if(this.mPopupState == "confirming_pin")
            {
               this.mPopupState = "get_new_pin";
               this.displayPopup("enter_new_pin");
            }
         }
         Framework.popupManager.dequeue(DynamicPopupNames.TWOITEM_KEYSENSE_PIN);
      }
      
      public function onInfoPopupClose(o:Object) : void
      {
         if(this.mPopupState == "pin_saved")
         {
            Framework.structure.goto(Screens.SETTINGS_KEYSENSE_MAIN);
            Framework.popupManager.dequeue(DynamicPopupNames.KEYSENSE_PIN_INFO);
         }
      }
      
      private function displayPopup(name:String) : void
      {
         switch(name)
         {
            case "no_pin":
               Framework.popupManager.show(DynamicPopupNames.TWOITEM_KEYSENSE_PIN,Screens.POPUP_KEYSENSE_PIN,{
                  "type":PopupType.PRIMARY,
                  "status":"no_pin",
                  "callBack":this.onPopupResponse
               });
               break;
            case "enter_new_pin":
               Framework.popupManager.show(DynamicPopupNames.KEYSENSE_PIN_KEYPAD,Screens.POPUP_KEYPAD,{
                  "type":PopupType.PRIMARY,
                  "input":"",
                  "title":T.STRB_KEYSENSE,
                  "message":T.STRB_ENTER_A_4_DIGIT_PIN_TO_ML,
                  "callBack":this.onKeyPad,
                  "label":T.STRB_OK,
                  "hidedigits":false,
                  "icon":"keysense"
               });
               break;
            case "confirm_pin":
               Framework.popupManager.show(DynamicPopupNames.TWOITEM_KEYSENSE_PIN,Screens.POPUP_KEYSENSE_PIN,{
                  "type":PopupType.PRIMARY,
                  "status":"confirm_pin",
                  "callBack":this.onPopupResponse
               });
               break;
            case "get_pin":
               Framework.popupManager.show(DynamicPopupNames.KEYSENSE_PIN_KEYPAD,Screens.POPUP_KEYPAD,{
                  "type":PopupType.PRIMARY,
                  "input":"",
                  "title":T.STRB_KEYSENSE,
                  "message":T.STRB_PLEASE_ENTER_KEYSENSE_PIN_ML,
                  "callBack":this.onKeyPad,
                  "label":T.STRB_OK,
                  "hidedigits":true,
                  "icon":"keysense"
               });
               break;
            case "failed_pin_entry":
               Framework.popupManager.show(DynamicPopupNames.TWOITEM_KEYSENSE_PIN,Screens.POPUP_KEYSENSE_PIN,{
                  "type":PopupType.PRIMARY,
                  "status":"failed_pin_entry"
               });
               break;
            case "max_attempts":
               Framework.popupManager.show(DynamicPopupNames.TWOITEM_KEYSENSE_PIN,Screens.POPUP_KEYSENSE_PIN,{
                  "type":PopupType.PRIMARY,
                  "status":"max_attempts"
               });
               break;
            case "pin_saved":
               Framework.popupManager.show(DynamicPopupNames.KEYSENSE_PIN_INFO,Screens.POPUP_INFO,{
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_KEYSENSE,
                  "message":T.STRB_PIN_SAVED,
                  "caption1":T.STRB_OK,
                  "callBack":this.onInfoPopupClose,
                  "icon":"keysense"
               });
               break;
            case "not_4_digits":
               if(this.mEnteredPin != "")
               {
                  this.mEnteredPin = "";
               }
               Framework.popupManager.show(DynamicPopupNames.KEYSENSE_PIN_INFO,Screens.POPUP_INFO,{
                  "type":PopupType.PRIMARY,
                  "title":T.STRB_KEYSENSE,
                  "message":T.STRB_PIN_MUST_BE_4_DIG,
                  "caption1":T.STRB_OK,
                  "icon":"keysense"
               });
               break;
            case "locked_out":
               Ancillary.definedDynamicPopups.show(DynamicPopupNames.SPEED_LOCKOUT);
         }
      }
   }
}

