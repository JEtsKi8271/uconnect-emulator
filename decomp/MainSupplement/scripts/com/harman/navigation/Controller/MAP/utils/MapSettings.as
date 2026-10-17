package com.harman.navigation.Controller.MAP.utils
{
   import com.harman.navigation.Controller.MAP.enums.EisTypes;
   import com.harman.navigation.Controller.MAP.enums.MapSettingTypes;
   import com.harman.navigation.Controller.MAP.enums.MapZoomLevels;
   import com.harman.navigation.DomainControl.NavGlobalSettings;
   
   public class MapSettings
   {
      
      public var mID:int = -1;
      
      private var mZoomLevel:Object = {"value":null};
      
      private var mHeading:Object = {"value":null};
      
      private var mViewType:Object = {"value":null};
      
      private var mDetachedFromCar:Object = {"value":null};
      
      private var mFrameRate:Object = {"value":null};
      
      private var mPosition:Object = {"value":null};
      
      private var mResolution:Object = {"value":null};
      
      private var mViewPort:Object = {"value":null};
      
      private var mViewResolution:Object = {"value":null};
      
      private var mGeoCoordinate:Object = {"value":null};
      
      private var mAutoZoomSetting:int = -4;
      
      private var mAutoZoomOveride:Boolean = false;
      
      public function MapSettings(id:int)
      {
         super();
         this.mID = id;
      }
      
      public function setup(zoomLevel:Object, heading:Object, viewType:Object, detachedFromVehicle:Object, frameRate:Object, position:Object, resolution:Object, viewPort:Object, viewResolution:Object) : void
      {
         this.mZoomLevel = zoomLevel;
         this.mHeading = heading;
         this.mViewType = viewType;
         this.mDetachedFromCar = detachedFromVehicle;
         this.mFrameRate = frameRate;
         this.mPosition = position;
         this.mResolution = resolution;
         this.mViewPort = viewPort;
         this.mViewResolution = viewResolution;
      }
      
      public function get transmissionCommandObject() : Object
      {
         var trans:Object = new Object();
         if(this.mHeading["value"] != null)
         {
            if(int(this.mZoomLevel["value"]) >= NavGlobalSettings.MAP_AUTO_NORTH_UP_LEVEL && (this.mAutoZoomSetting != MapZoomLevels.LEVEL_AUTO_OFF && this.mAutoZoomOveride != false || this.mAutoZoomSetting == MapZoomLevels.LEVEL_AUTO_OFF))
            {
               trans[EisTypes.MH] = "" + MapSettingTypes.ORIENTATION_NORTH_UP;
            }
            else
            {
               trans[EisTypes.MH] = "" + int(this.mHeading["value"]);
            }
         }
         if(this.mViewType["value"] != null)
         {
            trans[EisTypes.MVT] = String(this.mViewType["value"]);
         }
         if(this.mDetachedFromCar["value"] != null)
         {
            trans[EisTypes.MSM] = String(this.mDetachedFromCar["value"]);
         }
         if(this.mFrameRate["value"] != null)
         {
            trans[EisTypes.SDF] = String(this.mFrameRate["value"]);
         }
         if(this.mPosition["value"] != null)
         {
            trans[EisTypes.MP] = String(this.mPosition["value"]);
         }
         if(this.mResolution["value"] != null)
         {
            trans[EisTypes.MR] = String(this.mResolution["value"]);
         }
         if(this.mViewPort["value"] != null)
         {
            trans[EisTypes.MVP] = String(this.mViewPort["value"]);
         }
         if(this.mViewResolution["value"] != null)
         {
            trans[EisTypes.MVR] = String(this.mViewResolution["value"]);
         }
         if(this.mAutoZoomSetting != MapZoomLevels.LEVEL_AUTO_OFF && this.mAutoZoomOveride == false)
         {
            trans[EisTypes.MZ] = "" + this.mAutoZoomSetting;
         }
         else if(this.mZoomLevel["value"] != null)
         {
            trans[EisTypes.MZ] = MapZoomLevels.currentZoomLevels[int(this.mZoomLevel["value"])];
         }
         return trans;
      }
      
      public function get transmissionWorldObject() : Object
      {
         var trans:Object = new Object();
         if(this.mGeoCoordinate["value"] != null)
         {
            trans[EisTypes.GEO] = String(this.mGeoCoordinate["value"]);
         }
         return trans;
      }
      
      public function setZoomLevel(value:int) : void
      {
         this.mZoomLevel["value"] = value;
      }
      
      public function setHeading(value:int) : void
      {
         this.mHeading["value"] = value;
      }
      
      public function setViewType(value:int) : void
      {
         this.mViewType["value"] = value;
      }
      
      public function setDetachedFromVehicle(value:int) : void
      {
         this.mDetachedFromCar["value"] = value;
      }
      
      public function setFrameRate(value:int) : void
      {
         this.mFrameRate["value"] = value;
      }
      
      public function setPosition(value:String) : void
      {
         this.mPosition["value"] = value;
      }
      
      public function setResolution(value:String) : void
      {
         this.mResolution["value"] = value;
      }
      
      public function setViewPort(value:String) : void
      {
         this.mViewPort["value"] = value;
      }
      
      public function setViewResolution(value:String) : void
      {
         this.mViewResolution["value"] = value;
      }
      
      public function setGeoCoordinate(value:String) : void
      {
         this.mGeoCoordinate["value"] = value;
      }
      
      public function get zoomLevel() : int
      {
         return int(this.mZoomLevel["value"]);
      }
      
      public function get heading() : int
      {
         return int(this.mHeading["value"]);
      }
      
      public function get viewType() : int
      {
         return int(this.mViewType["value"]);
      }
      
      public function get detachedFromVehicle() : int
      {
         return int(this.mDetachedFromCar["value"]);
      }
      
      public function get frameRate() : int
      {
         return int(this.mFrameRate["value"]);
      }
      
      public function get position() : String
      {
         return String(this.mPosition["value"]);
      }
      
      public function get resolution() : String
      {
         return String(this.mResolution["value"]);
      }
      
      public function get viewPort() : String
      {
         return String(this.mViewPort["value"]);
      }
      
      public function get viewResolution() : String
      {
         return String(this.mViewResolution["value"]);
      }
      
      public function get geoCoordinate() : String
      {
         return String(this.mGeoCoordinate["value"]);
      }
      
      public function get objZoomLevel() : Object
      {
         return this.mZoomLevel;
      }
      
      public function get objHeading() : Object
      {
         return this.mHeading;
      }
      
      public function get objViewType() : Object
      {
         return this.mViewType;
      }
      
      public function get objDetachedFromVehicle() : Object
      {
         return this.mDetachedFromCar;
      }
      
      public function get objFrameRate() : Object
      {
         return this.mFrameRate;
      }
      
      public function get objPosition() : Object
      {
         return this.mPosition;
      }
      
      public function get objResolution() : Object
      {
         return this.mResolution;
      }
      
      public function get objViewPort() : Object
      {
         return this.mViewPort;
      }
      
      public function get objViewResolution() : Object
      {
         return this.mViewResolution;
      }
      
      public function get objGeoCoordinate() : Object
      {
         return this.mGeoCoordinate;
      }
      
      public function setAutoZoomSetting(value:int) : void
      {
         this.mAutoZoomSetting = value;
      }
      
      public function get autoZoomSetting() : int
      {
         return this.mAutoZoomSetting;
      }
      
      public function setAutoZoomOveride(enable:Boolean) : void
      {
         this.mAutoZoomOveride = enable;
      }
      
      public function get autoZoomOveride() : Boolean
      {
         return this.mAutoZoomOveride;
      }
   }
}

