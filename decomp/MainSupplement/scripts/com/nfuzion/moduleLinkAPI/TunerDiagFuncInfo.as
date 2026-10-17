package com.nfuzion.moduleLinkAPI
{
   public class TunerDiagFuncInfo
   {
      
      public var T1_Status:String = "";
      
      public var T1_FirmwareVersion:String = "";
      
      public var T1_PatchVersion:String = "";
      
      public var T1_WBFunction:String = "";
      
      public var T2_Status:String = "";
      
      public var T2_FirmwareVersion:String = "";
      
      public var T2_PatchVersion:String = "";
      
      public var T2_WBFunction:String = "";
      
      public var T3_Status:String = "";
      
      public var T3_FirmwareVersion:String = "";
      
      public var T3_PatchVersion:String = "";
      
      public var T3_WBFunction:String = "";
      
      public function TunerDiagFuncInfo()
      {
         super();
      }
      
      public function copyTunerDiagFuncInfo(value:Object) : TunerDiagFuncInfo
      {
         if(value.hasOwnProperty("tuner1"))
         {
            if(value.tuner1.hasOwnProperty("status"))
            {
               this.T1_Status = value.tuner1.status.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner1.hasOwnProperty("PatchH")) && Boolean(value.tuner1.hasOwnProperty("PatchL")))
            {
               this.T1_PatchVersion = value.tuner1.PatchH.toString(16).toUpperCase() + value.tuner1.PatchL.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner1.hasOwnProperty("FWMajor")) && Boolean(value.tuner1.hasOwnProperty("FWMinor1")) && Boolean(value.tuner1.hasOwnProperty("FWMinor2")))
            {
               this.T1_FirmwareVersion = value.tuner1.FWMajor.toString().toUpperCase() + "." + value.tuner1.FWMinor1.toString().toUpperCase() + "." + value.tuner1.FWMinor2.toString().toUpperCase();
            }
            if(value.tuner1.hasOwnProperty("Func"))
            {
               this.T1_WBFunction = value.tuner1.Func == 1 ? "FM" : "AM/MW";
            }
         }
         if(value.hasOwnProperty("tuner2"))
         {
            if(value.tuner2.hasOwnProperty("status"))
            {
               this.T2_Status = value.tuner2.status.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner2.hasOwnProperty("PatchH")) && Boolean(value.tuner2.hasOwnProperty("PatchL")))
            {
               this.T2_PatchVersion = value.tuner2.PatchH.toString(16).toUpperCase() + value.tuner2.PatchL.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner2.hasOwnProperty("FWMajor")) && Boolean(value.tuner2.hasOwnProperty("FWMinor1")) && Boolean(value.tuner2.hasOwnProperty("FWMinor2")))
            {
               this.T2_FirmwareVersion = value.tuner2.FWMajor.toString().toUpperCase() + "." + value.tuner2.FWMinor1.toString().toUpperCase() + "." + value.tuner2.FWMinor2.toString().toUpperCase();
            }
            if(value.tuner2.hasOwnProperty("Func"))
            {
               this.T2_WBFunction = value.tuner2.Func == 1 ? "FM" : "AM/MW";
            }
         }
         if(value.hasOwnProperty("tuner3"))
         {
            if(value.tuner3.hasOwnProperty("status"))
            {
               this.T3_Status = value.tuner3.status.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner3.hasOwnProperty("PatchH")) && Boolean(value.tuner3.hasOwnProperty("PatchL")))
            {
               this.T3_PatchVersion = value.tuner3.PatchH.toString(16).toUpperCase() + value.tuner3.PatchL.toString(16).toUpperCase();
            }
            if(Boolean(value.tuner3.hasOwnProperty("FWMajor")) && Boolean(value.tuner3.hasOwnProperty("FWMinor1")) && Boolean(value.tuner3.hasOwnProperty("FWMinor2")))
            {
               this.T3_FirmwareVersion = value.tuner3.FWMajor.toString().toUpperCase() + "." + value.tuner3.FWMinor1.toString().toUpperCase() + "." + value.tuner3.FWMinor2.toString().toUpperCase();
            }
            if(value.tuner3.hasOwnProperty("Func"))
            {
               this.T3_WBFunction = value.tuner3.Func == 1 ? "FM" : "AM/MW";
            }
         }
         return this;
      }
   }
}

