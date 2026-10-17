package com.harman.navigation.Controller.NDR.util
{
   public class GPSInfo
   {
      
      public var mHeading:int = 0;
      
      public var mCompassHeading:String = "";
      
      public var mHeight:int = 0;
      
      public var mLatitude:int = 0;
      
      public var mLongitude:int = 0;
      
      public var mfix:int = 0;
      
      public var mAntennaState:int = 0;
      
      public var mSatsUsed:int = 0;
      
      public var mSatsVisible:int = 0;
      
      public var mSignalQuality:int = 0;
      
      public var mVertPosError:int = 0;
      
      public var mHorPosError:int = 0;
      
      public var mSpeed:int = 0;
      
      public var mEastSpeed:int = 0;
      
      public var mNorthSpeed:int = 0;
      
      public var mVertSpeed:int = 0;
      
      public var mHdop:int = 0;
      
      public var mPdop:int = 0;
      
      public var mVdop:int = 0;
      
      public var mSec:int = 0;
      
      public var mMin:int = 0;
      
      public var mHrs:int = 0;
      
      public var mDay:int = 0;
      
      public var mMonth:int = 0;
      
      public var mYear:int = 0;
      
      public var mCalibrationLevel:int = 0;
      
      public var mGyroSum:int = 0;
      
      public var mReverseGear:Boolean = false;
      
      private var mPreviousDirection:Number = 0;
      
      private var HYSTERESIS_DEGREES:Number = 2;
      
      private var DIRECTIONS_POSSIBLE:Number = 8;
      
      private var MAX_DEGREE_COMPASS:Number = 360;
      
      private var ANGLE_TRANS_VAL_COMPASS:Number = this.MAX_DEGREE_COMPASS * (this.DIRECTIONS_POSSIBLE * 2 - 1) / (this.DIRECTIONS_POSSIBLE * 2);
      
      private var SCALE_FACTOR_COMPASS:Number = 1 / (this.MAX_DEGREE_COMPASS / this.DIRECTIONS_POSSIBLE);
      
      private var DEGREES_PER_DIR_COMPASS:Number = this.MAX_DEGREE_COMPASS / this.DIRECTIONS_POSSIBLE;
      
      public function GPSInfo()
      {
         super();
      }
      
      public function updateGyroSum(info:Object) : void
      {
         if(info.hasOwnProperty("gyroSum"))
         {
            this.mGyroSum = info.gyroSum;
         }
      }
      
      public function updateCalibrationLevel(info:Object) : void
      {
         if(info.hasOwnProperty("level"))
         {
            this.mCalibrationLevel = info.level;
         }
      }
      
      public function updateInfo(info:Object) : void
      {
         if(info.hasOwnProperty("heading"))
         {
            this.mHeading = info.heading;
         }
         if(info.hasOwnProperty("height"))
         {
            this.mHeight = info.height;
         }
         if(info.hasOwnProperty("latitude"))
         {
            this.mLatitude = info.latitude;
         }
         if(info.hasOwnProperty("longitude"))
         {
            this.mLongitude = info.longitude;
         }
         if(info.hasOwnProperty("fix"))
         {
            this.mfix = info.fix;
         }
         if(info.hasOwnProperty("antennaState"))
         {
            this.mAntennaState = info.antennaState;
         }
         if(info.hasOwnProperty("satsUsed"))
         {
            this.mSatsUsed = info.satsUsed;
         }
         if(info.hasOwnProperty("satsVisible"))
         {
            this.mSatsVisible = info.satsVisible;
         }
         if(info.hasOwnProperty("signalQuality"))
         {
            this.mSignalQuality = info.signalQuality;
         }
         if(info.hasOwnProperty("vertPosError"))
         {
            this.mVertPosError = info.vertPosError;
         }
         if(info.hasOwnProperty("horPosError"))
         {
            this.mHorPosError = info.horPosError;
         }
         if(info.hasOwnProperty("speed"))
         {
            this.mSpeed = info.speed;
         }
         if(info.hasOwnProperty("eastSpeed"))
         {
            this.mEastSpeed = info.eastSpeed;
         }
         if(info.hasOwnProperty("northSpeed"))
         {
            this.mNorthSpeed = info.northSpeed;
         }
         if(info.hasOwnProperty("vertSpeed"))
         {
            this.mVertSpeed = info.vertSpeed;
         }
         if(info.hasOwnProperty("hdop"))
         {
            this.mHdop = info.hdop;
         }
         if(info.hasOwnProperty("pdop"))
         {
            this.mPdop = info.pdop;
         }
         if(info.hasOwnProperty("vdop"))
         {
            this.mVdop = info.vdop;
         }
         if(info.hasOwnProperty("sec"))
         {
            this.mSec = info.sec;
         }
         if(info.hasOwnProperty("min"))
         {
            this.mMin = info.min;
         }
         if(info.hasOwnProperty("hrs"))
         {
            this.mHrs = info.hrs;
         }
         if(info.hasOwnProperty("day"))
         {
            this.mDay = info.day;
         }
         if(info.hasOwnProperty("month"))
         {
            this.mMonth = info.month;
         }
         if(info.hasOwnProperty("year"))
         {
            this.mYear = info.year;
         }
      }
      
      public function updatePOS_Position(pos:Object) : Boolean
      {
         var headingChanged:Boolean = false;
         if(pos.hasOwnProperty("DR_distance"))
         {
         }
         if(pos.hasOwnProperty("DR_latitude"))
         {
            this.mLatitude = pos.DR_latitude;
         }
         if(pos.hasOwnProperty("DR_longitude"))
         {
            this.mLongitude = pos.DR_longitude;
         }
         if(pos.hasOwnProperty("DR_speed"))
         {
            this.mfix = pos.DR_speed;
         }
         if(pos.hasOwnProperty("DR_heading"))
         {
            this.mHeading = pos.DR_heading;
            return this.calculateCompassHeading();
         }
         return false;
      }
      
      public function updateSEN_ReverseGear(rev:Object) : void
      {
         if(rev.hasOwnProperty("reverseValue"))
         {
            this.mReverseGear = rev.reverseValue == 1 ? true : false;
         }
      }
      
      public function calculateCompassHeading() : Boolean
      {
         var direction:Number = NaN;
         var normalAngle:Number = NaN;
         var mPrevious:String = this.mCompassHeading;
         var angle:Number = (this.mHeading + this.ANGLE_TRANS_VAL_COMPASS) % this.MAX_DEGREE_COMPASS;
         direction = angle * this.SCALE_FACTOR_COMPASS;
         direction = Math.floor(direction);
         if(1 == Math.abs(direction - this.mPreviousDirection))
         {
            normalAngle = angle - this.mPreviousDirection * this.DEGREES_PER_DIR_COMPASS;
            if(direction > this.mPreviousDirection || direction == 0 && this.mPreviousDirection == this.DIRECTIONS_POSSIBLE - 1)
            {
               if(angle < direction * this.DEGREES_PER_DIR_COMPASS + this.HYSTERESIS_DEGREES)
               {
                  direction = this.mPreviousDirection;
               }
            }
            else if(angle >= (direction + 1) * this.DEGREES_PER_DIR_COMPASS - this.HYSTERESIS_DEGREES)
            {
               direction = this.mPreviousDirection;
            }
         }
         this.mPreviousDirection = direction;
         direction++;
         if(direction >= this.DIRECTIONS_POSSIBLE)
         {
            direction = 0;
         }
         direction = Math.floor(direction);
         if(0 <= direction && 8 > direction)
         {
            if(direction == 0)
            {
               this.mCompassHeading = "N";
            }
            else if(direction == 1)
            {
               this.mCompassHeading = "NE";
            }
            else if(direction == 2)
            {
               this.mCompassHeading = "E";
            }
            else if(direction == 3)
            {
               this.mCompassHeading = "SE";
            }
            else if(direction == 4)
            {
               this.mCompassHeading = "S";
            }
            else if(direction == 5)
            {
               this.mCompassHeading = "SW";
            }
            else if(direction == 6)
            {
               this.mCompassHeading = "W";
            }
            else if(direction == 7)
            {
               this.mCompassHeading = "NW";
            }
            else
            {
               this.mCompassHeading = "N";
            }
         }
         if(mPrevious == this.mCompassHeading)
         {
            return false;
         }
         return true;
      }
   }
}

