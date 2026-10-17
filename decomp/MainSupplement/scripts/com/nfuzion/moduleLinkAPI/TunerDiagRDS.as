package com.nfuzion.moduleLinkAPI
{
   public class TunerDiagRDS
   {
      
      public var T1_RdsSync:int = 0;
      
      public var T1_BlkErrs:int = 0;
      
      public var T1_Received:int = 0;
      
      public var T1_Expected:int = 0;
      
      public var T1_Uncorrectable:int = 0;
      
      public var T2_RdsSync:int = 0;
      
      public var T2_BlkErrs:int = 0;
      
      public var T2_Received:int = 0;
      
      public var T2_Expected:int = 0;
      
      public var T2_Uncorrectable:int = 0;
      
      public var T3_RdsSync:int = 0;
      
      public var T3_BlkErrs:int = 0;
      
      public var T3_Received:int = 0;
      
      public var T3_Expected:int = 0;
      
      public var T3_Uncorrectable:int = 0;
      
      public function TunerDiagRDS()
      {
         super();
      }
      
      public function copyTunerDiagRDS(value:Object) : TunerDiagRDS
      {
         if(value.hasOwnProperty("tuner1"))
         {
            if(value.tuner1.hasOwnProperty("rdsSync"))
            {
               this.T1_RdsSync = value.tuner1.rdsSync;
            }
            if(value.tuner1.hasOwnProperty("blkErrs"))
            {
               this.T1_BlkErrs = value.tuner1.blkErrs;
            }
            if(value.tuner1.hasOwnProperty("recieved"))
            {
               this.T1_Received = value.tuner1.recieved;
            }
            if(value.tuner1.hasOwnProperty("expected"))
            {
               this.T1_Expected = value.tuner1.expected;
            }
            if(value.tuner1.hasOwnProperty("uncorrectable"))
            {
               this.T1_Uncorrectable = value.tuner1.uncorrectable;
            }
         }
         if(value.hasOwnProperty("tuner2"))
         {
            if(value.tuner2.hasOwnProperty("rdsSync"))
            {
               this.T2_RdsSync = value.tuner2.rdsSync;
            }
            if(value.tuner2.hasOwnProperty("blkErrs"))
            {
               this.T2_BlkErrs = value.tuner2.blkErrs;
            }
            if(value.tuner2.hasOwnProperty("recieved"))
            {
               this.T2_Received = value.tuner2.recieved;
            }
            if(value.tuner2.hasOwnProperty("expected"))
            {
               this.T2_Expected = value.tuner2.expected;
            }
            if(value.tuner2.hasOwnProperty("uncorrectable"))
            {
               this.T2_Uncorrectable = value.tuner2.uncorrectable;
            }
         }
         if(value.hasOwnProperty("tuner3"))
         {
            if(value.tuner3.hasOwnProperty("rdsSync"))
            {
               this.T3_RdsSync = value.tuner3.rdsSync;
            }
            if(value.tuner3.hasOwnProperty("blkErrs"))
            {
               this.T3_BlkErrs = value.tuner3.blkErrs;
            }
            if(value.tuner3.hasOwnProperty("recieved"))
            {
               this.T3_Received = value.tuner3.recieved;
            }
            if(value.tuner3.hasOwnProperty("expected"))
            {
               this.T3_Expected = value.tuner3.expected;
            }
            if(value.tuner3.hasOwnProperty("uncorrectable"))
            {
               this.T3_Uncorrectable = value.tuner3.uncorrectable;
            }
         }
         return this;
      }
   }
}

