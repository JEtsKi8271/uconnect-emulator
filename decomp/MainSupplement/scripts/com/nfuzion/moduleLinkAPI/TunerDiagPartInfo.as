package com.nfuzion.moduleLinkAPI
{
   public class TunerDiagPartInfo
   {
      
      public var T1_Status:String = "";
      
      public var T1_PartRev:String = "";
      
      public var T1_RomId:uint = 0;
      
      public var T1_PartId:uint = 0;
      
      public var T1_ChipRev:uint = 0;
      
      public var T2_Status:String = "";
      
      public var T2_PartRev:String = "";
      
      public var T2_RomId:uint = 0;
      
      public var T2_PartId:uint = 0;
      
      public var T2_ChipRev:uint = 0;
      
      public var T3_Status:String = "";
      
      public var T3_PartRev:String = "";
      
      public var T3_RomId:uint = 0;
      
      public var T3_PartId:uint = 0;
      
      public var T3_ChipRev:uint = 0;
      
      private var partRevChar:String = "";
      
      public function TunerDiagPartInfo()
      {
         super();
      }
      
      public function copyTunerDiagPartInfo(value:Object) : TunerDiagPartInfo
      {
         if(value.hasOwnProperty("tuner1"))
         {
            if(value.tuner1.hasOwnProperty("status"))
            {
               this.T1_Status = value.tuner1.status.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner1.hasOwnProperty("pMajor")) && Boolean(value.tuner1.hasOwnProperty("pMinor")))
            {
               this.partRevChar = String.fromCharCode(value.tuner1.pMajor) + String.fromCharCode(value.tuner1.pMinor);
               this.T1_PartRev = "A" + this.partRevChar;
            }
            if(value.tuner1.hasOwnProperty("romID"))
            {
               this.T1_RomId = value.tuner1.romID;
            }
            if(value.tuner1.hasOwnProperty("part"))
            {
               this.T1_PartId = value.tuner1.part;
            }
            if(value.tuner1.hasOwnProperty("chipRev"))
            {
               this.T1_ChipRev = value.tuner1.romID;
            }
         }
         if(value.hasOwnProperty("tuner2"))
         {
            if(value.tuner2.hasOwnProperty("status"))
            {
               this.T2_Status = value.tuner2.status.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner2.hasOwnProperty("pMajor")) && Boolean(value.tuner2.hasOwnProperty("pMinor")))
            {
               this.partRevChar = String.fromCharCode(value.tuner2.pMajor) + String.fromCharCode(value.tuner2.pMinor);
               this.T2_PartRev = "A" + this.partRevChar;
            }
            if(value.tuner2.hasOwnProperty("romID"))
            {
               this.T2_RomId = value.tuner2.romID;
            }
            if(value.tuner2.hasOwnProperty("part"))
            {
               this.T2_PartId = value.tuner2.part;
            }
            if(value.tuner2.hasOwnProperty("chipRev"))
            {
               this.T2_ChipRev = value.tuner2.romID;
            }
         }
         if(value.hasOwnProperty("tuner3"))
         {
            if(value.tuner3.hasOwnProperty("status"))
            {
               this.T3_Status = value.tuner3.status.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner3.hasOwnProperty("pMajor")) && Boolean(value.tuner3.hasOwnProperty("pMinor")))
            {
               this.partRevChar = String.fromCharCode(value.tuner3.pMajor) + String.fromCharCode(value.tuner3.pMinor);
               this.T3_PartRev = "A" + this.partRevChar;
            }
            if(value.tuner3.hasOwnProperty("romID"))
            {
               this.T3_RomId = value.tuner3.romID;
            }
            if(value.tuner3.hasOwnProperty("part"))
            {
               this.T3_PartId = value.tuner3.part;
            }
            if(value.tuner3.hasOwnProperty("chipRev"))
            {
               this.T3_ChipRev = value.tuner3.romID;
            }
         }
         return this;
      }
   }
}

