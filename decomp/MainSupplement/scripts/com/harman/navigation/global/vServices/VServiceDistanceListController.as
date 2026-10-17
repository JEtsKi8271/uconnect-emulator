package com.harman.navigation.global.vServices
{
   import com.harman.navigation.NavigationApi;
   import com.harman.navigation.NavigationImpl;
   import com.harman.navigation.NavigationNamespace;
   import com.harman.navigation.global.NavigationPackage;
   import com.harman.navigation.utils.DistanceListObject;
   import com.nfuzion.framework.global.Framework;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   use namespace NavigationNamespace;
   
   public class VServiceDistanceListController
   {
      
      private static const LIST_UPDATE_RATE:int = 2000;
      
      private static const DEGREES_PER_RADIANS:Number = 57.2957795;
      
      private static const PI_BY_180:Number = Math.PI / 180;
      
      private static const POS_ABOVE:int = 1;
      
      private static const POS_ABOVE_LEFT:int = 2;
      
      private static const POS_ABOVE_RIGHT:int = 3;
      
      private static const POS_BELOW:int = 4;
      
      private static const POS_BELOW_LEFT:int = 5;
      
      private static const POS_BELOW_RIGHT:int = 6;
      
      private static const POS_LEFT:int = 7;
      
      private static const POS_RIGHT:int = 8;
      
      private static const POS_MATCH:int = 9;
      
      private var mList:Array = new Array();
      
      private var updateInterval:uint = 0;
      
      private var updating:Boolean = false;
      
      private var mVehicleLongitude:Number = 0;
      
      private var mVehicleLongitudeRad:Number = 0;
      
      private var mVehicleLatitude:Number = 0;
      
      private var mVehicleLatitudeRad:Number = 0;
      
      private var mVehicleDirection:int = 0;
      
      private var mCompareLongitude:Number = 0;
      
      private var mCompareLatitude:Number = 0;
      
      private var mDistance_CP_VP:Number = 0;
      
      private var mDistance_CP_DEST:Number = 0;
      
      private var mDistance_VP_DEST:Number = 0;
      
      private var mRelativePosition:int = 0;
      
      public function VServiceDistanceListController()
      {
         super();
         NavigationApi.impl = NavigationImpl.create();
      }
      
      public static function getImageIdForAngle(angle:int) : int
      {
         angle %= 360;
         if(angle >= 0)
         {
            if(angle >= 338 || angle <= 23)
            {
               return 2;
            }
            if(angle <= 69)
            {
               return 3;
            }
            if(angle <= 113)
            {
               return 4;
            }
            if(angle <= 158)
            {
               return 5;
            }
            if(angle <= 203)
            {
               return 6;
            }
            if(angle <= 248)
            {
               return 7;
            }
            if(angle <= 293)
            {
               return 8;
            }
            return 9;
         }
         if(angle < -338 || angle > -23)
         {
            return 2;
         }
         if(angle >= -69)
         {
            return 9;
         }
         if(angle >= -113)
         {
            return 8;
         }
         if(angle >= -158)
         {
            return 7;
         }
         if(angle >= -203)
         {
            return 6;
         }
         if(angle >= -248)
         {
            return 5;
         }
         if(angle >= -293)
         {
            return 4;
         }
         return 3;
      }
      
      public function setList(list:Array) : void
      {
         this.mList = list;
         this.enableUpdates(true);
         this.onUpdateList();
      }
      
      public function stopUpdates() : void
      {
         this.enableUpdates(false);
      }
      
      public function clearList() : void
      {
         this.mList.splice(0,this.mList.length);
         this.enableUpdates(false);
      }
      
      public function get list() : Array
      {
         return this.mList;
      }
      
      private function enableUpdates(enable:Boolean) : void
      {
         if(enable && !this.updating)
         {
            this.updating = true;
            this.updateInterval = setInterval(this.onUpdateList,LIST_UPDATE_RATE);
         }
         else if(!enable)
         {
            this.updating = false;
            clearInterval(this.updateInterval);
         }
      }
      
      private function parseVehiclePosition() : void
      {
         var vehicleStr:String = NavigationApi.api.posPositionInformation.getType("<GEO>");
         this.mVehicleLongitude = Number(vehicleStr.substring(0,vehicleStr.indexOf(" ")));
         this.mVehicleLatitude = Number(vehicleStr.substring(vehicleStr.indexOf(" ") + 1,vehicleStr.length - 1));
         this.mVehicleDirection = Number(NavigationApi.api.posPositionInformation.getType("<DIR>")) / 255 * 360;
         this.mVehicleLongitudeRad = PI_BY_180 * this.mVehicleLongitude;
         this.mVehicleLatitudeRad = PI_BY_180 * this.mVehicleLatitude;
      }
      
      private function getDistanceToPosition(index:int) : Number
      {
         var distance:Number = 0;
         distance = Math.cos(Number(PI_BY_180 * DistanceListObject(this.mList[index]).latitude)) * Math.cos(this.mVehicleLatitudeRad) * Math.cos(Number(this.mVehicleLongitudeRad - PI_BY_180 * DistanceListObject(this.mList[index]).longitude)) + Math.sin(Number(PI_BY_180 * DistanceListObject(this.mList[index]).latitude)) * Math.sin(this.mVehicleLatitudeRad);
         if(distance < 0)
         {
            distance *= -1;
         }
         return Math.acos(distance) * 6371;
      }
      
      private function onUpdateList() : void
      {
         this.parseVehiclePosition();
         var i:int = 0;
         var distanceToDestination:Number = 0;
         for(var angle:Number = 0; i < this.mList.length; )
         {
            if(DistanceListObject(this.mList[i]).latitude == 0)
            {
               DistanceListObject(this.mList[i]).setDistance("");
               DistanceListObject(this.mList[i]).setDirection(1);
            }
            else
            {
               distanceToDestination = this.getDistanceToPosition(i);
               DistanceListObject(this.mList[i]).setDistance(NavigationPackage.peripheral.navigation.navVServices.distanceCalculator.getDistanceStringWithUnit(distanceToDestination));
               this.determineRelativeDestinationPosition(i);
               this.calcTriangleDistances(i);
               angle = this.calcDestinationDirection(this.calcAngleC(this.mDistance_CP_VP,this.mDistance_VP_DEST,this.mDistance_CP_DEST));
               DistanceListObject(this.mList[i]).setDirection(getImageIdForAngle(angle));
            }
            i++;
         }
         NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.DISTANCE_LIST_UPDATE);
      }
      
      private function calcComparePointPosition() : void
      {
         this.mCompareLatitude = this.mVehicleLatitude + this.mDistance_VP_DEST;
         this.mCompareLongitude = this.mVehicleLongitude;
         this.mDistance_CP_VP = this.mCompareLatitude - this.mVehicleLatitude;
      }
      
      private function determineRelativeDestinationPosition(listIndex:int) : void
      {
         if(DistanceListObject(this.mList[listIndex]).latitude < this.mVehicleLatitude)
         {
            if(DistanceListObject(this.mList[listIndex]).longitude < this.mVehicleLongitude)
            {
               this.mRelativePosition = POS_BELOW_LEFT;
            }
            else if(DistanceListObject(this.mList[listIndex]).longitude > this.mVehicleLongitude)
            {
               this.mRelativePosition = POS_BELOW_RIGHT;
            }
            else
            {
               this.mRelativePosition = POS_BELOW;
            }
         }
         else if(DistanceListObject(this.mList[listIndex]).latitude > this.mVehicleLatitude)
         {
            if(DistanceListObject(this.mList[listIndex]).longitude < this.mVehicleLongitude)
            {
               this.mRelativePosition = POS_ABOVE_LEFT;
            }
            else if(DistanceListObject(this.mList[listIndex]).longitude > this.mVehicleLongitude)
            {
               this.mRelativePosition = POS_ABOVE_RIGHT;
            }
            else
            {
               this.mRelativePosition = POS_ABOVE;
            }
         }
         else if(DistanceListObject(this.mList[listIndex]).longitude < this.mVehicleLongitude)
         {
            this.mRelativePosition = POS_LEFT;
         }
         else if(DistanceListObject(this.mList[listIndex]).longitude > this.mVehicleLongitude)
         {
            this.mRelativePosition = POS_RIGHT;
         }
         else
         {
            this.mRelativePosition = POS_MATCH;
         }
      }
      
      private function calcTriangleDistances(listIndex:int) : void
      {
         this.mDistance_VP_DEST = Math.sqrt(Math.pow(DistanceListObject(this.mList[listIndex]).latitude - this.mVehicleLatitude,2) + Math.pow(DistanceListObject(this.mList[listIndex]).longitude - this.mVehicleLongitude,2));
         this.calcComparePointPosition();
         this.mDistance_CP_DEST = Math.sqrt(Math.pow(DistanceListObject(this.mList[listIndex]).latitude - this.mCompareLatitude,2) + Math.pow(DistanceListObject(this.mList[listIndex]).longitude - this.mCompareLongitude,2));
      }
      
      private function calcAngleC(a:Number, b:Number, c:Number) : Number
      {
         var result:Number = Math.acos((a * a + b * b - c * c) / (2 * a * b));
         return result * DEGREES_PER_RADIANS;
      }
      
      private function calcDestinationDirection(vehicleAngle:Number) : Number
      {
         var result:Number = 0;
         switch(this.mRelativePosition)
         {
            case POS_ABOVE:
               result = this.mVehicleDirection;
               break;
            case POS_ABOVE_LEFT:
               result = this.mVehicleDirection - vehicleAngle;
               break;
            case POS_ABOVE_RIGHT:
               result = this.mVehicleDirection + vehicleAngle;
               break;
            case POS_BELOW:
               result = this.mVehicleDirection - 180;
               break;
            case POS_BELOW_LEFT:
               result = this.mVehicleDirection - vehicleAngle;
               break;
            case POS_BELOW_RIGHT:
               result = this.mVehicleDirection + vehicleAngle;
               break;
            case POS_LEFT:
               result = this.mVehicleDirection - 90;
               break;
            case POS_RIGHT:
               result = this.mVehicleDirection - 270;
               break;
            case POS_MATCH:
               break;
            default:
               Framework.Trace("calcDestinationDirection() unknown relative position");
         }
         return result;
      }
   }
}

