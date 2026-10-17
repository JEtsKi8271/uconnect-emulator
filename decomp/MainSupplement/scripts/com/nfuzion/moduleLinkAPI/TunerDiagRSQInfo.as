package com.nfuzion.moduleLinkAPI
{
   public class TunerDiagRSQInfo
   {
      
      public var T1_strongDev:int;
      
      public var T1_assi200Dev:int;
      
      public var T1_lassi:int;
      
      public var T1_snr:int;
      
      public var T1_rssi:int;
      
      public var T1_rdsDev:int;
      
      public var T1_freqDev:int;
      
      public var T1_pilotDev:int;
      
      public var T1_multipath:int;
      
      public var T1_freqOff:int;
      
      public var T1_assi200:int;
      
      public var T1_freq:int;
      
      public var T1_issi:int;
      
      public var T1_hassi:int;
      
      public var T1_usn:int;
      
      public function TunerDiagRSQInfo()
      {
         super();
      }
      
      public function copyTunerDiagRSQInfo(value:Object) : TunerDiagRSQInfo
      {
         if(value.hasOwnProperty("strongDev"))
         {
            this.T1_strongDev = value.strongDev;
         }
         if(value.hasOwnProperty("assi200Dev"))
         {
            this.T1_assi200Dev = value.assi200Dev;
         }
         if(value.hasOwnProperty("lassi"))
         {
            this.T1_lassi = value.lassi;
         }
         if(value.hasOwnProperty("snr"))
         {
            this.T1_snr = value.snr;
         }
         if(value.hasOwnProperty("rssi"))
         {
            this.T1_rssi = value.rssi;
         }
         if(value.hasOwnProperty("rdsDev"))
         {
            this.T1_rdsDev = value.rdsDev;
         }
         if(value.hasOwnProperty("freqDev"))
         {
            this.T1_freqDev = value.freqDev;
         }
         if(value.hasOwnProperty("pilotDev"))
         {
            this.T1_pilotDev = value.pilotDev;
         }
         if(value.hasOwnProperty("multipath"))
         {
            this.T1_multipath = value.multipath;
         }
         if(value.hasOwnProperty("freqOff"))
         {
            this.T1_freqOff = value.freqOff;
         }
         if(value.hasOwnProperty("assi200"))
         {
            this.T1_assi200 = value.assi200;
         }
         if(value.hasOwnProperty("freq"))
         {
            this.T1_freq = value.freq;
         }
         if(value.hasOwnProperty("issi"))
         {
            this.T1_issi = value.issi;
         }
         if(value.hasOwnProperty("hassi"))
         {
            this.T1_hassi = value.hassi;
         }
         if(value.hasOwnProperty("usn"))
         {
            this.T1_usn = value.usn;
         }
         return this;
      }
   }
}

