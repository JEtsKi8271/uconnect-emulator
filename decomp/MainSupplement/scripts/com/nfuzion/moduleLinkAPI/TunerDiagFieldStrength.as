package com.nfuzion.moduleLinkAPI
{
   public class TunerDiagFieldStrength
   {
      
      public var T1_FieldStrength:int = 0;
      
      public var T2_FieldStrength:int = 0;
      
      public var T3_FieldStrength:int = 0;
      
      public function TunerDiagFieldStrength()
      {
         super();
      }
      
      public function copyTunerDiagFieldStrength(value:Object) : TunerDiagFieldStrength
      {
         if(value.hasOwnProperty("tuner1"))
         {
            this.T1_FieldStrength = value.tuner1;
         }
         if(value.hasOwnProperty("tuner2"))
         {
            this.T2_FieldStrength = value.tuner2;
         }
         if(value.hasOwnProperty("tuner3"))
         {
            this.T3_FieldStrength = value.tuner3;
         }
         return this;
      }
   }
}

