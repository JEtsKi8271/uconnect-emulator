package com.harman.navigation.global.vServices
{
   import com.harman.navigation.NavigationEvent;
   import com.harman.navigation.global.NavigationPackage;
   import com.nfuzion.framework.global.Framework;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   
   public class VServiceDirectionTracker
   {
      
      private static const DEGREES_PER_RADIANS:Number = 57.2957795;
      
      private static const POS_ABOVE:int = 1;
      
      private static const POS_ABOVE_LEFT:int = 2;
      
      private static const POS_ABOVE_RIGHT:int = 3;
      
      private static const POS_BELOW:int = 4;
      
      private static const POS_BELOW_LEFT:int = 5;
      
      private static const POS_BELOW_RIGHT:int = 6;
      
      private static const POS_LEFT:int = 7;
      
      private static const POS_RIGHT:int = 8;
      
      private static const POS_MATCH:int = 9;
      
      private static var mAngle:int = -1;
      
      private static var mPreviousAngle:int = 0;
      
      private static var mTestInterval:uint = 0;
      
      private static var mTestHeading:int = 0;
      
      private static var mIsEnabled:Boolean = false;
      
      private var mTrackedLongitude:Number = 0;
      
      private var mTrackedLatitude:Number = 0;
      
      private var mVehicleLongitude:Number = 0;
      
      private var mVehicleLatitude:Number = 0;
      
      private var mVehicleDirectionLast:int = 0;
      
      private var mVehicleDirectionNew:int = 0;
      
      private var mCompareLongitude:Number = 0;
      
      private var mCompareLatitude:Number = 0;
      
      private var mRelativePosition:int = 0;
      
      private var mDistance_CP_VP:Number = 0;
      
      private var mDistance_CP_DEST:Number = 0;
      
      private var mDistance_VP_DEST:Number = 0;
      
      public function VServiceDirectionTracker()
      {
         super();
      }
      
      public static function getRelativePosition(srcLat:Number, srcLon:Number, destLat:Number, destLon:Number) : int
      {
         if(destLat < srcLat)
         {
            if(destLon < srcLon)
            {
               return POS_BELOW_LEFT;
            }
            if(destLon > srcLon)
            {
               return POS_BELOW_RIGHT;
            }
            return POS_BELOW;
         }
         if(destLat > srcLat)
         {
            if(destLon < srcLon)
            {
               return POS_ABOVE_LEFT;
            }
            if(destLon > srcLon)
            {
               return POS_ABOVE_RIGHT;
            }
            return POS_ABOVE;
         }
         if(destLon < srcLon)
         {
            return POS_LEFT;
         }
         if(destLon > srcLon)
         {
            return POS_RIGHT;
         }
         return POS_MATCH;
      }
      
      public static function calcAngleC(a:Number, b:Number, c:Number) : Number
      {
         var result:Number = Math.acos((a * a + b * b - c * c) / (2 * a * b));
         return result * DEGREES_PER_RADIANS;
      }
      
      public static function calcDestinationDirection(relativePosition:int, vehicleDirection:Number, vehicleAngle:Number) : Number
      {
         var result:Number = 0;
         switch(relativePosition)
         {
            case POS_ABOVE:
               result = vehicleDirection;
               break;
            case POS_ABOVE_LEFT:
               result = vehicleDirection - vehicleAngle;
               break;
            case POS_ABOVE_RIGHT:
               result = vehicleDirection + vehicleAngle;
               break;
            case POS_BELOW:
               result = vehicleDirection - 180;
               break;
            case POS_BELOW_LEFT:
               result = vehicleDirection - vehicleAngle;
               break;
            case POS_BELOW_RIGHT:
               result = vehicleDirection + vehicleAngle;
               break;
            case POS_LEFT:
               result = vehicleDirection - 90;
               break;
            case POS_RIGHT:
               result = vehicleDirection - 270;
               break;
            case POS_MATCH:
               break;
            default:
               Framework.Trace("calcDestinationDirection() unknown relative position");
         }
         return result;
      }
      
      public function enableDirectionTracker(geoCoordinate:String) : void
      {
         mIsEnabled = true;
         mPreviousAngle = -2;
         mAngle = -1;
         this.mTrackedLongitude = Number(geoCoordinate.substring(0,geoCoordinate.indexOf(" ")));
         this.mTrackedLatitude = Number(geoCoordinate.substring(geoCoordinate.indexOf(" ") + 1,geoCoordinate.length - 1));
         NavigationPackage.peripheral.navigation.navigation.addEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionUpdate,false,0,true);
         NavigationPackage.peripheral.navigation.navigation.posGetPositionInformation();
      }
      
      public function disableDirectionTracker() : void
      {
         mIsEnabled = false;
         NavigationPackage.peripheral.navigation.navigation.removeEventListener(NavigationEvent.POS_POSITIONINFORMATION,this.onPositionUpdate);
      }
      
      public function get angle() : int
      {
         return mAngle;
      }
      
      public function get distance() : String
      {
         var ret:String = NavigationPackage.peripheral.navigation.navVServices.distanceCalculator.getDistanceToPositionString(this.mTrackedLongitude + " " + this.mTrackedLatitude);
         return NavigationPackage.peripheral.navigation.navVServices.distanceCalculator.getDistanceToPositionString(this.mTrackedLongitude + " " + this.mTrackedLatitude);
      }
      
      public function get isEnabled() : Boolean
      {
         return mIsEnabled;
      }
      
      private function onPositionUpdate(e:NavigationEvent) : void
      {
         if(this.parseVehiclePosition())
         {
            this.determineRelativeDestinationPosition();
            this.calcTriangleDistances();
            mAngle = calcDestinationDirection(this.mRelativePosition,this.mVehicleDirectionNew,calcAngleC(this.mDistance_CP_VP,this.mDistance_VP_DEST,this.mDistance_CP_DEST));
            if(mPreviousAngle != mAngle)
            {
               mPreviousAngle = mAngle;
               NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.DIRECTION_TRACKER_UPDATE);
            }
         }
      }
      
      private function parseVehiclePosition() : Boolean
      {
         var vehicleStr:String = NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<GEO>");
         this.mVehicleLongitude = Number(vehicleStr.substring(0,vehicleStr.indexOf(" ")));
         this.mVehicleLatitude = Number(vehicleStr.substring(vehicleStr.indexOf(" ") + 1,vehicleStr.length - 1));
         this.mVehicleDirectionNew = Number(NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<DIR>")) / 255 * 360;
         if(this.mVehicleLongitude == 0 && this.mVehicleLatitude == 0 && this.mVehicleDirectionNew == 0)
         {
            return false;
         }
         return true;
      }
      
      private function determineRelativeDestinationPosition() : void
      {
         this.mRelativePosition = getRelativePosition(this.mVehicleLatitude,this.mVehicleLongitude,this.mTrackedLatitude,this.mTrackedLongitude);
      }
      
      private function calcTriangleDistances() : void
      {
         var tmpDist:Number = this.mDistance_VP_DEST;
         this.mDistance_VP_DEST = Math.sqrt(Math.pow(this.mTrackedLatitude - this.mVehicleLatitude,2) + Math.pow(this.mTrackedLongitude - this.mVehicleLongitude,2));
         if(tmpDist != this.mDistance_VP_DEST)
         {
            mPreviousAngle = -2;
         }
         this.calcComparePointPosition();
         this.mDistance_CP_DEST = Math.sqrt(Math.pow(this.mTrackedLatitude - this.mCompareLatitude,2) + Math.pow(this.mTrackedLongitude - this.mCompareLongitude,2));
      }
      
      private function calcComparePointPosition() : void
      {
         this.mCompareLatitude = this.mVehicleLatitude + this.mDistance_VP_DEST;
         this.mCompareLongitude = this.mVehicleLongitude;
         this.mDistance_CP_VP = this.mCompareLatitude - this.mVehicleLatitude;
      }
      
      private function testDirectionTracker(geoCoordinate:String) : void
      {
         this.mTrackedLongitude = Number(geoCoordinate.substring(0,geoCoordinate.indexOf(" ")));
         this.mTrackedLatitude = Number(geoCoordinate.substring(geoCoordinate.indexOf(" ") + 1,geoCoordinate.length - 1));
         mTestInterval = setInterval(this.onTestPositionUpdate,5);
      }
      
      private function onTestPositionUpdate() : void
      {
         if(this.parseTestVehiclePosition())
         {
            this.determineRelativeDestinationPosition();
            this.calcTriangleDistances();
            mAngle = calcDestinationDirection(this.mRelativePosition,this.mVehicleDirectionNew,calcAngleC(this.mDistance_CP_VP,this.mDistance_VP_DEST,this.mDistance_CP_DEST));
            NavigationPackage.peripheral.navigation.navVServices.eventDispatcher.sendEvent(VServiceEventDispatcherEvent.DIRECTION_TRACKER_UPDATE);
            Framework.Trace("Heading:" + mTestHeading + " Angle:" + mAngle);
         }
      }
      
      private function parseTestVehiclePosition() : Boolean
      {
         var vehicleStr:String = NavigationPackage.peripheral.navigation.navigation.posPositionInformation.getType("<GEO>");
         this.mVehicleLongitude = -83.431027;
         this.mVehicleLatitude = 42.496383;
         this.mVehicleDirectionNew = mTestHeading;
         ++mTestHeading;
         if(mTestHeading > 360)
         {
            clearInterval(mTestInterval);
         }
         return true;
      }
   }
}

