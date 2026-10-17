package com.harman.moduleLinkAPI
{
   public class HdBER
   {
      
      public var PIDS_BLKER_Mantissa:int = 0;
      
      public var PIDS_BLKER_Exponent:int = 0;
      
      public var PIDS_BLKER_Number:int = 0;
      
      public var PIDS_BER_Mantissa:int = 0;
      
      public var PIDS_BER_Exponent:int = 0;
      
      public var PIDS_BER_Number:int = 0;
      
      public var P3_BER_Mantissa:int = 0;
      
      public var P3_BER_Exponent:int = 0;
      
      public var P3_BER_Number:int = 0;
      
      public var P2_BER_Mantissa:int = 0;
      
      public var P2_BER_Exponent:int = 0;
      
      public var P2_BER_Number:int = 0;
      
      public var P1_BER_Mantissa:int = 0;
      
      public var P1_BER_Exponent:int = 0;
      
      public var P1_BER_Number:int = 0;
      
      public function HdBER()
      {
         super();
      }
      
      public function copyBER(value:Object) : HdBER
      {
         this.PIDS_BLKER_Mantissa = value.PIDS_BLKER.mantissa;
         this.PIDS_BLKER_Exponent = value.PIDS_BLKER.exponent;
         this.PIDS_BLKER_Number = value.PIDS_BLKER.number;
         this.PIDS_BER_Mantissa = value.PIDS_BER.mantissa;
         this.PIDS_BER_Exponent = value.PIDS_BER.exponent;
         this.PIDS_BER_Number = value.PIDS_BER.number;
         this.P3_BER_Mantissa = value.P3_BER.mantissa;
         this.P3_BER_Exponent = value.P3_BER.exponent;
         this.P3_BER_Number = value.P3_BER.number;
         this.P2_BER_Mantissa = value.P2_BER.mantissa;
         this.P2_BER_Exponent = value.P2_BER.exponent;
         this.P2_BER_Number = value.P2_BER.number;
         this.P1_BER_Mantissa = value.P1_BER.mantissa;
         this.P1_BER_Exponent = value.P1_BER.exponent;
         this.P1_BER_Number = value.P1_BER.number;
         return this;
      }
   }
}

