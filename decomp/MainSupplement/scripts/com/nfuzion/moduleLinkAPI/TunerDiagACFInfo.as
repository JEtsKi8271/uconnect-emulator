package com.nfuzion.moduleLinkAPI
{
   public class TunerDiagACFInfo
   {
      
      public var T1_hiblend:int;
      
      public var T1_smattn:int;
      
      public var T1_smute:int;
      
      public var T1_lowcut:int;
      
      public var T1_chbw:int;
      
      public var T1_pilot:int;
      
      public var T1_hicut:int;
      
      public var T1_stblend:int;
      
      public function TunerDiagACFInfo()
      {
         super();
      }
      
      public function copyTunerDiagACFInfo(value:Object) : TunerDiagACFInfo
      {
         if(value.hasOwnProperty("hiblend"))
         {
            this.T1_hiblend = value.hiblend;
         }
         if(value.hasOwnProperty("smattn"))
         {
            this.T1_smattn = value.smattn;
         }
         if(value.hasOwnProperty("smute"))
         {
            this.T1_smute = value.smute;
         }
         if(value.hasOwnProperty("chbw"))
         {
            this.T1_chbw = value.chbw;
         }
         if(value.hasOwnProperty("pilot"))
         {
            this.T1_pilot = value.pilot;
         }
         if(value.hasOwnProperty("hicut"))
         {
            this.T1_hicut = value.hicut;
         }
         if(value.hasOwnProperty("stblend"))
         {
            this.T1_stblend = value.stblend;
         }
         return this;
      }
   }
}

