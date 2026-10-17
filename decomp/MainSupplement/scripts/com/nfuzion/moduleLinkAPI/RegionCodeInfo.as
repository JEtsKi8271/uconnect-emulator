package com.nfuzion.moduleLinkAPI
{
   public class RegionCodeInfo
   {
      
      public var amUpper:uint = 0;
      
      public var amLower:uint = 0;
      
      public var amStep:uint = 0;
      
      public var fmUpper:uint = 0;
      
      public var fmLower:uint = 0;
      
      public var fmStep:uint = 0;
      
      public function RegionCodeInfo()
      {
         super();
      }
      
      public function updateRegionCodeInfo(newRegionCodeInfo:Object) : void
      {
         this.amUpper = newRegionCodeInfo.amUpper;
         this.amLower = newRegionCodeInfo.amLower;
         this.amStep = newRegionCodeInfo.amStep;
         this.fmUpper = newRegionCodeInfo.fmUpper;
         this.fmLower = newRegionCodeInfo.fmLower;
         this.fmStep = newRegionCodeInfo.fmStep;
      }
   }
}

