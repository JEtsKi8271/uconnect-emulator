package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.MapController;
   import com.harman.navigation.Controller.MAP.MapControllerEvent;
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.VisibleObject;
   import com.nfuzion.framework.global.Framework;
   
   public class HelperVehicleIcons
   {
      
      private var mParent:MapController;
      
      private var mVehicleIcons:Array = new Array();
      
      private var mVehicleIconId:String = "-1";
      
      private var mVehicleIconName:String = "";
      
      public function HelperVehicleIcons(parent:MapController)
      {
         super();
         this.mParent = parent;
         NavigationApi.api.addEventListener(NavigationEvent.MAP_VEHICLE_ICON_CHANGE,this.onMapVehicleIconsUpdateVehicleIconChange,false,0,true);
      }
      
      public function get availableVehicleIcons() : Array
      {
         return this.mVehicleIcons;
      }
      
      public function get activeVehicleIconID() : String
      {
         return this.mVehicleIconId;
      }
      
      public function get activeVehicleIconName() : String
      {
         var veh:VisibleObject = null;
         Framework.Trace("activeVehicleIconName: mVehicleIconName= " + this.mVehicleIconName);
         if(this.mVehicleIconName == "")
         {
            veh = this.getVisibleObjectFromID(this.mVehicleIconId);
            if(veh != null)
            {
               this.mVehicleIconName = veh.name;
            }
         }
         return this.mVehicleIconName;
      }
      
      public function setActiveVehicleIconID(vehicleIcon:VisibleObject, transmitToNav:Boolean = true) : void
      {
         var veh:VisibleObject = null;
         if(vehicleIcon.name == "")
         {
            veh = this.getVisibleObjectFromID(vehicleIcon.id);
            if(veh != null && veh.name != "")
            {
               vehicleIcon = veh;
            }
         }
         this.mVehicleIconName = vehicleIcon.name;
         this.mVehicleIconId = vehicleIcon.id;
         if(int(this.mVehicleIconId) < 0)
         {
            Framework.Trace("setActiveVehicleIconID(" + vehicleIcon.id + ") illegal -> fallback to \'0\' ");
            this.setDefaultVehicleIconBasedOnVehicleConfig();
         }
         if(transmitToNav)
         {
            NavigationApi.api.mapSendControlCmd("<MID>map<*><MPI_NNG>" + this.mVehicleIconId + "<*>");
         }
      }
      
      public function onMapVehicleIconsUpdate(e:NavigationEvent) : void
      {
         var found:Boolean = false;
         this.mVehicleIcons = NavigationApi.api.mapVehicleIcons;
         var i:int = 0;
         if(this.mVehicleIconId != "")
         {
            found = false;
            for(i = 0; i < this.mVehicleIcons.length; i++)
            {
               if(VisibleObject(this.mVehicleIcons[i]).id == this.mVehicleIconId)
               {
                  found = true;
                  VisibleObject(this.mVehicleIcons[i]).setVisible(true);
                  break;
               }
            }
            if(found == false)
            {
               this.setDefaultVehicleIconBasedOnVehicleConfig();
            }
         }
         if(this.mVehicleIconId == "0")
         {
            this.setDefaultVehicleIconBasedOnVehicleConfig();
         }
         this.mParent.sendEvent(MapControllerEvent.MAP_VEHICLE_ICONS);
      }
      
      private function onMapVehicleIconsUpdateVehicleIconChange(e:NavigationEvent) : void
      {
         NavigationApi.api.mapGetVehicleIcons();
      }
      
      private function getVisibleObjectFromID(id:String) : VisibleObject
      {
         if(this.mVehicleIcons.length == 0)
         {
            this.mVehicleIcons = NavigationApi.api.mapVehicleIcons;
         }
         for(var i:int = 0; i < this.mVehicleIcons.length; i++)
         {
            if(id == VisibleObject(this.mVehicleIcons[i]).id)
            {
               return VisibleObject(this.mVehicleIcons[i]);
            }
         }
         return null;
      }
      
      public function setDefaultVehicleIconBasedOnVehicleConfig() : void
      {
         var found:Boolean = false;
         var defaultVehicleName:String = this.defaultVehicleIconNameBasedonVehicleConfig();
         for(var i:int = 0; i < this.mVehicleIcons.length; i++)
         {
            if(VisibleObject(this.mVehicleIcons[i]).name.indexOf(defaultVehicleName) >= 0)
            {
               found = true;
               this.mParent.setVehicleIcon(VisibleObject(this.mVehicleIcons[i]));
               break;
            }
         }
         if(!found && (this.mVehicleIcons != null && this.mVehicleIcons.length > 0))
         {
            this.mParent.setVehicleIcon(VisibleObject(this.mVehicleIcons[0]));
         }
         else
         {
            NavigationApi.api.mapGetVehicleIcons();
         }
      }
      
      private function defaultVehicleIconNameBasedonVehicleConfig() : String
      {
         var line:String = NavigationPackage.peripheral.vehConfig.vehicleLine;
         var defConfig:String = "";
         switch(line)
         {
            case "DD":
            case "DP":
            case "DF":
            case "DJ":
            case "D2":
            case "DS":
               defConfig = "Truck";
               break;
            case "K4":
            case "K8":
            case "KL":
            case "MP":
            case "M1":
            case "M4":
            case "M6":
            case "W2":
            case "W3":
            case "WK":
            case "WD":
            case "WL":
               defConfig = "Cherokee";
               break;
            case "LA":
               defConfig = "Challenger";
               break;
            case "LD":
               defConfig = "Charger";
               break;
            case "LX":
               defConfig = "300";
               break;
            case "UF":
               defConfig = "200";
               break;
            case "RU":
               defConfig = "Pacifica";
               break;
            default:
               defConfig = "Arrow";
         }
         return defConfig;
      }
   }
}

