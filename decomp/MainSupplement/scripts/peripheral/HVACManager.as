package peripheral
{
   import ancillary.DynamicPopupNames;
   import ancillary.Screens;
   import com.nfuzion.framework.global.Framework;
   import com.nfuzion.moduleLinkAPI.HvacEvent;
   import com.nfuzion.moduleLinkAPI.ICSEvent;
   import core.enums.PopupType;
   import flash.events.EventDispatcher;
   
   public class HVACManager extends EventDispatcher
   {
      
      private var mLastLeftTemp:String = "--";
      
      private var mLastRightTemp:String = "--";
      
      private var mFirstLeftTempChange:Boolean = true;
      
      private var mFirstRightTempChange:Boolean = true;
      
      private var mFirstLeftTempKeyPress:Boolean = true;
      
      private var mFirstRightTempKeyPress:Boolean = true;
      
      private var mLastFanSpeed:String = "off";
      
      private var mFirstFanSpeedChange:Boolean = true;
      
      private var mFirstVentStateChange:Boolean = true;
      
      public function HVACManager()
      {
         super();
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_ZONE_FRONT_LEFT_TEMP,this.onHVACZoneLeftTemp,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_ZONE_FRONT_RIGHT_TEMP,this.onHVACZoneRightTemp,false,0,true);
         Peripheral.ics.addEventListener(ICSEvent.LEFT_TEMP_UP,this.onICSLeftTempKey,false,0,true);
         Peripheral.ics.addEventListener(ICSEvent.LEFT_TEMP_DOWN,this.onICSLeftTempKey,false,0,true);
         Peripheral.ics.addEventListener(ICSEvent.RIGHT_TEMP_UP,this.onICSRightTempKey,false,0,true);
         Peripheral.ics.addEventListener(ICSEvent.RIGHT_TEMP_DOWN,this.onICSRightTempKey,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_F_CLIMATE_STATE,this.onClimateStateChange,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_F_FAN_SPEED,this.onFanSpeedChange,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_AUTO_STATE,this.onAutoStateChange,false,0,true);
         Peripheral.hvac.addEventListener(HvacEvent.HVAC_VENT_MODE,this.onVentStateChange,false,0,true);
         Peripheral.ics.addEventListener(ICSEvent.ICS_KNOB3,this.onICSKnob3,false,0,true);
      }
      
      private function onClimateStateChange(e:HvacEvent) : void
      {
         this.updateFanSpeed();
         this.updateVentState();
      }
      
      private function onAutoStateChange(e:HvacEvent) : void
      {
         this.updateFanSpeed();
         this.updateVentState();
      }
      
      private function onFanSpeedChange(e:HvacEvent) : void
      {
         this.updateFanSpeed(true);
      }
      
      private function onVentStateChange(e:HvacEvent) : void
      {
         this.updateVentState(e);
      }
      
      private function updateFanSpeed(eventTriggered:Boolean = false) : void
      {
         var fanSpeed:String = Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_FRONT);
         if(this.mLastFanSpeed != fanSpeed)
         {
            if(eventTriggered)
            {
               if(this.mFirstFanSpeedChange || this.mLastFanSpeed == "off" || fanSpeed == "off")
               {
                  this.mFirstFanSpeedChange = false;
               }
               else
               {
                  this.showFanSpeedPopup(fanSpeed);
               }
            }
            this.mLastFanSpeed = fanSpeed;
         }
      }
      
      private function updateVentState(e:HvacEvent = null) : void
      {
         if(Peripheral.hvac.isClimateEnabled(Peripheral.hvac.ZONE_FRONT))
         {
            if(Peripheral.hvac.autoState(Peripheral.hvac.ZONE_FRONT) != Peripheral.hvac.AUTO_ON)
            {
               if(e == null || e != null && e.hasOwnProperty("data") && e.data == Peripheral.hvac.ZONE_FRONT)
               {
                  if(!this.mFirstVentStateChange)
                  {
                     this.showAirFlowPopup();
                  }
                  else
                  {
                     this.mFirstVentStateChange = false;
                  }
               }
            }
         }
      }
      
      private function showFanSpeedPopup(fanSpeed:String) : void
      {
         if(Framework.structure.currentBranch != Screens.MAIN_HVAC && Peripheral.hvac.FAN_AUTO != fanSpeed && Framework.popupManager.active != DynamicPopupNames.FAN_SPEED)
         {
            Framework.popupManager.show(DynamicPopupNames.FAN_SPEED,Screens.POPUP_FANSPEED,{
               "timeout":2000,
               "type":PopupType.CLIMATE
            });
         }
      }
      
      private function showAirFlowPopup() : void
      {
         if(Framework.structure.currentBranch != Screens.MAIN_HVAC && Framework.structure.currentBranch != Screens.REAR_HVAC && Framework.popupManager.active != DynamicPopupNames.AIR_FLOW && Peripheral.vehConfig.vehicleLine == "RU")
         {
            Framework.popupManager.show(DynamicPopupNames.AIR_FLOW,Screens.POPUP_AIRFLOW,{
               "timeout":2000,
               "type":PopupType.CLIMATE
            });
         }
      }
      
      private function onICSKnob3(e:ICSEvent) : void
      {
         var fanSpeed:String = Peripheral.hvac.fanSpeed(Peripheral.hvac.ZONE_FRONT);
         if(Framework.structure.currentBranch != Screens.MAIN_HVAC && Framework.popupManager.active != DynamicPopupNames.FAN_SPEED && (fanSpeed == "7" && e.data > 0 || fanSpeed == "1" && e.data < 0))
         {
            Framework.popupManager.show(DynamicPopupNames.FAN_SPEED,Screens.POPUP_FANSPEED,{
               "timeout":2000,
               "type":PopupType.CLIMATE
            });
         }
      }
      
      private function onHVACZoneLeftTemp(e:HvacEvent) : void
      {
         var _temp:String = null;
         _temp = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_LEFT);
         if(this.mLastLeftTemp != _temp)
         {
            this.mLastLeftTemp = _temp;
            if(this.mFirstLeftTempChange)
            {
               this.mFirstLeftTempChange = false;
            }
            else if(Framework.structure.currentBranch != Screens.MAIN_HVAC)
            {
               Framework.popupManager.show(DynamicPopupNames.HVAC,Screens.POPUP_HVAC,{
                  "type":PopupType.CLIMATE,
                  "zone":Peripheral.hvac.ZONE_FRONT_LEFT,
                  "temp":_temp
               });
            }
         }
      }
      
      private function onHVACZoneRightTemp(e:HvacEvent) : void
      {
         var _temp:String = null;
         _temp = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_RIGHT);
         if(this.mLastRightTemp != _temp)
         {
            this.mLastRightTemp = _temp;
            if(this.mFirstRightTempChange)
            {
               this.mFirstRightTempChange = false;
            }
            else if(Framework.structure.currentBranch != Screens.MAIN_HVAC)
            {
               Framework.popupManager.show(DynamicPopupNames.HVAC,Screens.POPUP_HVAC,{
                  "type":PopupType.CLIMATE,
                  "zone":Peripheral.hvac.ZONE_FRONT_RIGHT,
                  "temp":_temp
               });
            }
         }
      }
      
      private function onICSLeftTempKey(e:ICSEvent) : void
      {
         var _temp:String = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_LEFT);
         switch(e.type)
         {
            case ICSEvent.LEFT_TEMP_UP:
               if(_temp == Peripheral.hvac.TEMP_HI)
               {
                  if(this.mFirstLeftTempKeyPress)
                  {
                     this.mFirstLeftTempKeyPress = false;
                  }
                  else if(Framework.structure.currentBranch != Screens.MAIN_HVAC)
                  {
                     Framework.popupManager.show(DynamicPopupNames.HVAC,Screens.POPUP_HVAC,{
                        "type":PopupType.CLIMATE,
                        "zone":Peripheral.hvac.ZONE_FRONT_LEFT,
                        "temp":_temp
                     });
                  }
               }
               break;
            case ICSEvent.LEFT_TEMP_DOWN:
               if(_temp == Peripheral.hvac.TEMP_LO)
               {
                  if(this.mFirstLeftTempKeyPress)
                  {
                     this.mFirstLeftTempKeyPress = false;
                  }
                  else if(Framework.structure.currentBranch != Screens.MAIN_HVAC)
                  {
                     Framework.popupManager.show(DynamicPopupNames.HVAC,Screens.POPUP_HVAC,{
                        "type":PopupType.CLIMATE,
                        "zone":Peripheral.hvac.ZONE_FRONT_LEFT,
                        "temp":_temp
                     });
                  }
               }
         }
      }
      
      private function onICSRightTempKey(e:ICSEvent) : void
      {
         var _temp:String = Peripheral.hvac.zoneTemp(Peripheral.hvac.ZONE_FRONT_RIGHT);
         switch(e.type)
         {
            case ICSEvent.RIGHT_TEMP_UP:
               if(_temp == Peripheral.hvac.TEMP_HI)
               {
                  if(this.mFirstRightTempKeyPress)
                  {
                     this.mFirstRightTempKeyPress = false;
                  }
                  else if(Framework.structure.currentBranch != Screens.MAIN_HVAC)
                  {
                     Framework.popupManager.show(DynamicPopupNames.HVAC,Screens.POPUP_HVAC,{
                        "type":PopupType.CLIMATE,
                        "zone":Peripheral.hvac.ZONE_FRONT_RIGHT,
                        "temp":_temp
                     });
                  }
               }
               break;
            case ICSEvent.RIGHT_TEMP_DOWN:
               if(_temp == Peripheral.hvac.TEMP_LO)
               {
                  if(this.mFirstRightTempKeyPress)
                  {
                     this.mFirstRightTempKeyPress = false;
                  }
                  else if(Framework.structure.currentBranch != Screens.MAIN_HVAC)
                  {
                     Framework.popupManager.show(DynamicPopupNames.HVAC,Screens.POPUP_HVAC,{
                        "type":PopupType.CLIMATE,
                        "zone":Peripheral.hvac.ZONE_FRONT_RIGHT,
                        "temp":_temp
                     });
                  }
               }
         }
      }
   }
}

