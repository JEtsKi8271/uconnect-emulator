package com.nfuzion.moduleLinkAPI
{
   public class TunerVersionInfo
   {
      
      public var BG1_chipRev:String = "";
      
      public var BG1_rev:String = "";
      
      public var BG1_romRev:String = "";
      
      public var BG1_variant:String = "";
      
      public var FE1_chipRev:String = "";
      
      public var FE1_rev:String = "";
      
      public var FE1_romRev:String = "";
      
      public var FE1_variant:String = "";
      
      public var FE2_chipRev:String = "";
      
      public var FE2_rev:String = "";
      
      public var FE2_romRev:String = "";
      
      public var FE2_variant:String = "";
      
      public function TunerVersionInfo()
      {
         super();
      }
      
      public function copyTunerVersionInfo(value:Object) : TunerVersionInfo
      {
         if(value.hasOwnProperty("BG1"))
         {
            if(value.BG1.hasOwnProperty("chipRev"))
            {
               this.BG1_chipRev = value.BG1.chipRev;
            }
            if(value.BG1.hasOwnProperty("rev"))
            {
               this.BG1_rev = value.BG1.rev;
            }
            if(value.BG1.hasOwnProperty("romRev"))
            {
               this.BG1_romRev = value.BG1.romRev;
            }
            if(value.BG1.hasOwnProperty("variant"))
            {
               this.BG1_variant = value.BG1.variant;
            }
         }
         if(value.hasOwnProperty("FE1"))
         {
            if(value.FE1.hasOwnProperty("chipRev"))
            {
               this.FE1_chipRev = value.FE1.chipRev;
            }
            if(value.FE1.hasOwnProperty("rev"))
            {
               this.FE1_rev = value.FE1.rev;
            }
            if(value.FE1.hasOwnProperty("romRev"))
            {
               this.FE1_romRev = value.FE1.romRev;
            }
            if(value.FE1.hasOwnProperty("variant"))
            {
               this.FE1_variant = value.FE1.variant;
            }
         }
         if(value.hasOwnProperty("FE2"))
         {
            if(value.FE2.hasOwnProperty("chipRev"))
            {
               this.FE2_chipRev = value.FE2.chipRev;
            }
            if(value.FE2.hasOwnProperty("rev"))
            {
               this.FE2_rev = value.FE2.rev;
            }
            if(value.FE2.hasOwnProperty("romRev"))
            {
               this.FE2_romRev = value.FE2.romRev;
            }
            if(value.FE2.hasOwnProperty("variant"))
            {
               this.FE2_variant = value.FE2.variant;
            }
         }
         return this;
      }
   }
}

