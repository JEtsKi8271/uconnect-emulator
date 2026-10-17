package com.nfuzion.geographic
{
   public class Coordinates
   {
      
      private var mEarthModel:String = "spherical";
      
      public var mLatitude:Number = NaN;
      
      public var mLongitude:Number = NaN;
      
      public var mAltitude:Number = NaN;
      
      public function Coordinates(coordinates:Coordinates = null)
      {
         super();
         if(coordinates != null)
         {
            this.mLatitude = coordinates.latitude;
            this.mLongitude = coordinates.longitude;
            this.mAltitude = coordinates.altitude;
         }
         else
         {
            this.mLatitude = 0;
            this.mLongitude = 0;
            this.mAltitude = 0;
         }
      }
      
      public function set latitude(latitude:Number) : void
      {
         if(latitude > 90)
         {
            latitude = 90;
            trace("Latitude value is too large.");
         }
         else if(latitude < -90)
         {
            latitude = -90;
            trace("Latitude value is too small.");
         }
         this.mLatitude = latitude;
      }
      
      public function get latitude() : Number
      {
         return this.mLatitude;
      }
      
      public function set longitude(longitude:Number) : void
      {
         if(longitude > 180)
         {
            longitude = 180;
            trace("Longitude value is too large.");
         }
         else if(longitude < -180)
         {
            longitude = -180;
            trace("Longitude value is too small.");
         }
         this.mLongitude = longitude;
      }
      
      public function get longitude() : Number
      {
         return this.mLongitude;
      }
      
      public function set altitude(latitude:Number) : void
      {
         this.mAltitude = this.altitude;
      }
      
      public function get altitude() : Number
      {
         return this.mAltitude;
      }
      
      public function distanceTo(to:Coordinates) : Distance
      {
         var scale:Number = NaN;
         var fromLatitude:Number = NaN;
         var toLatitude:Number = NaN;
         var fromLongitude:Number = NaN;
         var toLongitude:Number = NaN;
         var deltaLongitude:Number = NaN;
         var radius:Number = NaN;
         var meters:Number = NaN;
         var distance:Distance = new Distance();
         if(this.latitude == to.latitude && this.longitude == to.longitude)
         {
            distance.meters = 0;
            return distance;
         }
         switch(this.earthModel)
         {
            case EarthModel.SPHERICAL:
               scale = Math.PI / 180;
               fromLatitude = this.latitude * scale;
               toLatitude = to.latitude * scale;
               fromLongitude = Math.abs(this.longitude * scale);
               toLongitude = Math.abs(to.longitude * scale);
               deltaLongitude = Math.abs(toLongitude - fromLongitude);
               radius = 6371009;
               meters = radius * Math.acos(Math.sin(fromLatitude) * Math.sin(toLatitude) + Math.cos(fromLatitude) * Math.cos(toLatitude) * Math.cos(deltaLongitude));
               distance.meters = meters;
               break;
            default:
               trace("Could perform calculation using current earth model.");
               distance.meters = 0;
         }
         return distance;
      }
      
      public function bearingTo(to:Coordinates) : Direction
      {
         var fromLatitude:Number = NaN;
         var toLatitude:Number = NaN;
         var fromLongitude:Number = NaN;
         var toLongitude:Number = NaN;
         var deltaLongitude:Number = NaN;
         var cosToLatitude:Number = NaN;
         var y:Number = NaN;
         var x:Number = NaN;
         var angle:Number = NaN;
         var direction:Direction = new Direction();
         if(this.latitude == to.latitude && this.longitude == to.longitude)
         {
            direction.degrees = 0;
            return direction;
         }
         switch(this.earthModel)
         {
            case EarthModel.SPHERICAL:
               fromLatitude = this.latitude / 180 * Math.PI;
               toLatitude = to.latitude / 180 * Math.PI;
               fromLongitude = this.longitude / 180 * Math.PI;
               toLongitude = to.longitude / 180 * Math.PI;
               deltaLongitude = toLongitude - fromLongitude;
               cosToLatitude = Math.cos(toLatitude);
               y = Math.sin(deltaLongitude) * cosToLatitude;
               x = Math.cos(fromLatitude) * Math.sin(toLatitude) - Math.sin(fromLatitude) * cosToLatitude * Math.cos(deltaLongitude);
               angle = Math.atan2(y,x) * 180 / Math.PI;
               if(angle < 0)
               {
                  angle += 360;
               }
               direction.degrees = angle;
               break;
            default:
               trace("Could perform calculation using current earth model.");
               direction.degrees = 0;
         }
         return direction;
      }
      
      public function set earthModel(earthModel:String) : void
      {
         switch(earthModel)
         {
            case EarthModel.ELLIPSOIDAL:
            case EarthModel.FLAT:
            case EarthModel.SPHERICAL:
               this.mEarthModel = earthModel;
         }
      }
      
      public function get earthModel() : String
      {
         return this.mEarthModel;
      }
   }
}

