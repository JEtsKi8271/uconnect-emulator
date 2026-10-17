package peripheral
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.harman.moduleLinkAPI.AntiTheftEvent;
   import com.harman.moduleLinkAPI.AntiTheftStates;
   import com.nfuzion.framework.global.Framework;
   import core.enums.PopupType;
   import core.events.StructureEvent;
   import events.StartupEvent;
   import flash.events.EventDispatcher;
   
   public class AntiTheftManager extends EventDispatcher
   {
      
      public function AntiTheftManager()
      {
         super();
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_STATE_WAITFORVIN,this.onWaitForVin,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_STATE_ENTERPIN,this.onEnterPin,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_STATE_WRONGPIN,this.onWrongPin,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_STATE_UNLOCKED,this.onUnlocked,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_STATE_LOCKED,this.onLocked,false,0,true);
         Peripheral.antiTheft.addEventListener(AntiTheftEvent.ANTI_THEFT_STATE_FORCED_FOTA_UPDATE,this.onLocked,false,0,true);
         Framework.messenger.addEventListener(StartupEvent.READY,this.onReady,false,0,true);
      }
      
      private function onWaitForVin(e:AntiTheftEvent) : void
      {
         this.showAntiTheftScreen();
      }
      
      private function onEnterPin(e:AntiTheftEvent) : void
      {
         this.showAntiTheftScreen();
      }
      
      private function onWrongPin(e:AntiTheftEvent) : void
      {
         this.showAntiTheftScreen();
      }
      
      private function onUnlocked(e:AntiTheftEvent) : void
      {
         this.showAntiTheftScreen();
      }
      
      private function onLocked(e:AntiTheftEvent) : void
      {
         this.showAntiTheftScreen();
      }
      
      private function showAntiTheftScreen(_state:String = "") : void
      {
         var _antiTheftState:String = _state != "" ? _state : Peripheral.antiTheft.antiTheftState;
         switch(_antiTheftState)
         {
            case AntiTheftStates.WAIT_FOR_VIN:
               if(this.isBlockedByAntiTheft())
               {
                  Framework.popupManager.show(DynamicPopupNames.ANTITHEFT_POPUP,Screens.POPUP_ANTITHEFT,{
                     "type":PopupType.ANTITHEFT,
                     "antiTheftState":_antiTheftState
                  });
               }
               break;
            case AntiTheftStates.ENTER_PIN:
               if(this.isBlockedByAntiTheft())
               {
                  Framework.popupManager.show(DynamicPopupNames.ANTITHEFT_KEYPAD,Screens.POPUP_ANTITHEFTKEYPAD,{"type":PopupType.ANTITHEFT});
               }
               break;
            case AntiTheftStates.WRONG_PIN:
               if(this.isBlockedByAntiTheft())
               {
                  Framework.popupManager.show(DynamicPopupNames.ANTITHEFT_POPUP,Screens.POPUP_ANTITHEFT,{
                     "type":PopupType.ANTITHEFT,
                     "antiTheftState":_antiTheftState
                  });
               }
               break;
            case AntiTheftStates.UNLOCKED:
               Framework.structure.removeEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto);
               Framework.popupManager.dequeue(DynamicPopupNames.ANTITHEFT_POPUP);
               Framework.popupManager.dequeue(DynamicPopupNames.ANTITHEFT_KEYPAD);
               break;
            case AntiTheftStates.LOCKED:
               if(this.isBlockedByAntiTheft())
               {
                  Framework.popupManager.show(DynamicPopupNames.ANTITHEFT_POPUP,Screens.POPUP_ANTITHEFT,{
                     "type":PopupType.ANTITHEFT,
                     "antiTheftState":_antiTheftState
                  });
                  Peripheral.antiTheft.reqAntiTheftLockTime();
               }
               break;
            case AntiTheftStates.FORCED_FOTA_UPDATE:
               Peripheral.fotaStateManager.otaInstallConfirm({"installType":1});
         }
      }
      
      private function onReady(e:StartupEvent) : void
      {
         Framework.structure.addEventListener(StructureEvent.AFTER_GOTO,this.onAfterGoto,false,0,true);
         this.showAntiTheftScreen(Global.antiTheftState);
         Peripheral.antiTheft.reqAntiTheftState();
      }
      
      private function onAfterGoto(e:StructureEvent) : void
      {
         switch(Framework.structure.currentBranch)
         {
            case Screens.MAIN_HVAC:
            case Screens.DISPLAY_OFF:
               Framework.popupManager.dequeue(DynamicPopupNames.ANTITHEFT_POPUP);
               Framework.popupManager.dequeue(DynamicPopupNames.ANTITHEFT_KEYPAD);
               break;
            default:
               this.showAntiTheftScreen();
         }
      }
      
      private function isBlockedByAntiTheft() : Boolean
      {
         switch(Framework.structure.currentBranch)
         {
            case Screens.MAIN_HVAC:
            case Screens.DISPLAY_OFF:
               return false;
            default:
               return true;
         }
      }
   }
}

