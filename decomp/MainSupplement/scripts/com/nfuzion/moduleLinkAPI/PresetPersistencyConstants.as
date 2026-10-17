package com.nfuzion.moduleLinkAPI
{
   public class PresetPersistencyConstants
   {
      
      public static const MAX_NUMBER_OF_PRESETS_PER_BAND:uint = 12;
      
      public static const MAX_NUMBER_OF_BANDS:uint = 3;
      
      public static const MAX_NUMBER_OF_PIDS:uint = 1;
      
      public static const MAX_NUMBER_OF_PRESETS:uint = MAX_NUMBER_OF_BANDS * MAX_NUMBER_OF_PRESETS_PER_BAND * MAX_NUMBER_OF_PIDS;
      
      public function PresetPersistencyConstants()
      {
         super();
      }
   }
}

