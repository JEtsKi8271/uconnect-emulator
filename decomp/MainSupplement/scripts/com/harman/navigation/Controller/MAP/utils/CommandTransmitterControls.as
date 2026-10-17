package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.MapController;
   import com.harman.navigation.Controller.MAP.enums.EisTypes;
   import com.harman.navigation.Controller.MAP.enums.MapAppearanceTypes;
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.EisHelper;
   import com.nfuzion.framework.global.Framework;
   
   use namespace NavigationNamespace;
   
   public class CommandTransmitterControls
   {
      
      private static const MAP_CMD:String = "<MID>map<*>";
      
      private var mCurrentSettings:Object = {
         "MP":"",
         "MR":"",
         "MZ":"",
         "MH":"",
         "MVI":"",
         "SDF":"",
         "MVT":"",
         "MEV":"",
         "MAS":"",
         "M3T":"",
         "M3L":"",
         "M3C":"",
         "MSC":"",
         "MRP":"",
         "MRF":"",
         "MRR":"",
         "MCA":"",
         "MRN":"",
         "MTF":"",
         "MTI":"",
         "MSM":"",
         "MVP":"",
         "MVR":"",
         "MEP":"",
         "MLR":"",
         "MSP":"",
         "MJV":"",
         "SJV":"",
         "PRE":"",
         "MPI_NNG":""
      };
      
      public function CommandTransmitterControls()
      {
         super();
         NavigationApi.impl = NavigationImpl.create();
         NavigationApi.api.addEventListener(NavigationEvent.MAP_UPDATED_CONTROLS_CMD,this.onControlCommandUpdate,false,0,true);
      }
      
      public function sendCommands(cmd:Object) : Boolean
      {
         if(cmd != null)
         {
            cmd = this.perform2D_fixedCameraAndgle3D_Hack(cmd);
            this.handleExceptions(cmd);
            cmd = this.updateLocalSettingsAndFilter(cmd);
            this.handlePostExceptions(cmd);
            return this.sendControlCommand(cmd);
         }
         Framework.Trace("Nav.Map.CommandTransmitterControls.sendCommands(null) !!!");
         return false;
      }
      
      public function clearHistory() : void
      {
         var i:String = null;
         for(i in this.mCurrentSettings)
         {
            this.mCurrentSettings[i] = "";
         }
      }
      
      public function clearHistoryValue(eisType:String) : void
      {
         this.mCurrentSettings[eisType] = "";
      }
      
      private function perform2D_fixedCameraAndgle3D_Hack(cmd:Object) : Object
      {
         var i:String = null;
         var retObj:Object = new Object();
         for(i in cmd)
         {
            switch(i)
            {
               case EisTypes.MVT:
                  if(cmd[EisTypes.MVT] == String(MapSettingTypes.VIEW_TYPE_2D) && !NavigationPackage.peripheral.navigation.navMapControl.mapAppearanceSettings.isSet(MapAppearanceTypes.MAP_REAL_2D) && NavigationPackage.peripheral.navigation.navMapControl.mapConfiguration != MapConfiguration.MAP_CONFIRM_ROUTE_ANIMATED && NavigationPackage.peripheral.navigation.navMapControl.mapConfiguration != MapConfiguration.MAP_CONFIRM_ROUTE && NavigationPackage.peripheral.navigation.navMapControl.mapConfiguration != MapConfiguration.MAP_ROUTE_OVERVIEW && NavigationPackage.peripheral.navigation.navMapControl.mapConfiguration != MapConfiguration.MAP_HALF_MAP_ZOOM_LOCATION)
                  {
                     retObj[EisTypes.MVT] = MapSettingTypes.VIEW_TYPE_3D;
                     retObj[EisTypes.MEV] = "90";
                     retObj[EisTypes.M3C] = "0";
                     retObj[EisTypes.M3L] = "0";
                  }
                  else
                  {
                     retObj[i] = cmd[i];
                  }
                  break;
               case EisTypes.MZ:
                  if(int(cmd[EisTypes.MZ]) > NavGlobalSettings.MAP_ZOOM_LEVEL_REDUCED_FRAMERATE_THRESHOLD)
                  {
                     if(!NavigationPackage.peripheral.navigation.navMapControl.mapAppearanceSettings.isSet(MapAppearanceTypes.MAP_FULL_FPS) && NavigationPackage.peripheral.navigation.navMapControl.mapConfiguration != MapConfiguration.MAP_SCROLLING)
                     {
                        retObj[EisTypes.SDF] = MapSettingTypes.MAP_FRAMERATE_ZOOM_OUT;
                     }
                  }
                  retObj[i] = cmd[i];
                  break;
               default:
                  if(retObj[i] == null)
                  {
                     retObj[i] = cmd[i];
                  }
            }
         }
         if(MapController.sPhonecallMapRenderingLimit)
         {
            if(int(retObj[EisTypes.SDF]) > int(MapSettingTypes.MAP_FRAMERATE_PHONECALL))
            {
               retObj[EisTypes.SDF] = MapSettingTypes.MAP_FRAMERATE_PHONECALL;
            }
         }
         if(MapController.sVoiceRecoMapRenderingLimit)
         {
            if(int(retObj[EisTypes.SDF]) > int(MapSettingTypes.MAP_FRAMERATE_VR_SESSION))
            {
               retObj[EisTypes.SDF] = MapSettingTypes.MAP_FRAMERATE_VR_SESSION;
            }
         }
         if(MapController.temporaryZoomLevelChangeFramerateIncreaseEngaged)
         {
            if(int(retObj[EisTypes.SDF]) < int(MapSettingTypes.MAP_FRAMERATE_HIGH))
            {
               retObj[EisTypes.SDF] = MapSettingTypes.MAP_FRAMERATE_HIGH;
            }
         }
         return retObj;
      }
      
      private function handleExceptions(cmd:Object) : void
      {
         var i:String = null;
         for(i in cmd)
         {
            if(EisTypes.MSM == i && cmd[i] == MapSettingTypes.SCROLL_MODE_DETACH_CAR)
            {
               this.mCurrentSettings[EisTypes.MZ] = "";
               this.mCurrentSettings[EisTypes.MSM] = "";
            }
         }
         this.mCurrentSettings[EisTypes.MEV] = "";
      }
      
      private function updateLocalSettingsAndFilter(cmd:Object) : Object
      {
         var i:String = null;
         Framework.Trace("updateLocalSettingsAndFilter -> ");
         var retObj:Object = new Object();
         for(i in cmd)
         {
            if(this.mCurrentSettings[i] != cmd[i])
            {
               this.mCurrentSettings[i] = cmd[i];
               retObj[i] = cmd[i];
            }
         }
         return retObj;
      }
      
      private function handlePostExceptions(cmd:Object) : void
      {
         switch(NavigationPackage.peripheral.navigation.navMapControl.mapConfiguration)
         {
            case MapConfiguration.MAP_SCROLLING:
               this.mCurrentSettings[EisTypes.MH] = "";
         }
      }
      
      private function sendControlCommand(cmd:Object) : Boolean
      {
         var i:String = null;
         var sendMe:String = MAP_CMD;
         for(i in cmd)
         {
            if(String(cmd[i]).length > 0)
            {
               sendMe += "<" + i + ">" + cmd[i] + "<*>";
            }
         }
         if(sendMe.length > MAP_CMD.length)
         {
            NavigationApi.api.mapSendControlCmd(sendMe);
            return true;
         }
         return false;
      }
      
      private function onControlCommandUpdate(e:NavigationEvent) : void
      {
         var mvi:String = EisHelper.getValueOfType(String(e.data),"<MVI>");
         if(mvi != "")
         {
            this.mCurrentSettings[EisTypes.MVI] = mvi;
         }
      }
   }
}

