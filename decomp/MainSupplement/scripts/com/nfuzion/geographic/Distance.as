package com.nfuzion.geographic
{
   public class Distance
   {
      
      private static const MILE_LENGTH:Number = 1609.344;
      
      private var mMeters:Number = NaN;
      
      public function Distance(distance:Distance = null)
      {
         super();
         if(distance != null)
         {
            this.mMeters = distance.meters;
         }
      }
      
      public function set meters(meters:Number) : void
      {
         this.mMeters = meters;
      }
      
      public function get meters() : Number
      {
         return this.mMeters;
      }
      
      public function set miles(miles:Number) : void
      {
         this.mMeters = miles * MILE_LENGTH;
      }
      
      public function get miles() : Number
      {
         return this.mMeters / MILE_LENGTH;
      }
      
      public function get kilometers() : Number
      {
         return this.mMeters / 1000;
      }
      
      public function set kilometers(kilometers:Number) : void
      {
         this.mMeters = kilometers * 1000;
      }
   }
}

