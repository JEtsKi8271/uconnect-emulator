package com.nfuzion.moduleLinkAPI
{
   import com.harman.types.Enum;
   
   public class RainSensorLevel extends Enum
   {
      
      public static const Level_1:RainSensorLevel = new RainSensorLevel(1);
      
      public static const Level_2:RainSensorLevel = new RainSensorLevel(2);
      
      public static const Level_3:RainSensorLevel = new RainSensorLevel(3);
      
      public static const Level_4:RainSensorLevel = new RainSensorLevel(4);
      
      initEnum(RainSensorLevel);
      
      private var mLevel:uint;
      
      public function RainSensorLevel(level:uint)
      {
         super();
         this.mLevel = level;
      }
      
      public static function get MAXIMUM() : RainSensorLevel
      {
         return Level_4;
      }
      
      public static function get MINIMUM() : RainSensorLevel
      {
         return Level_1;
      }
      
      public static function byValue(value:uint) : RainSensorLevel
      {
         var rainLevel:RainSensorLevel = null;
         for each(rainLevel in Enum.GetConstants(RainSensorLevel))
         {
            if(rainLevel.value == value)
            {
               return rainLevel;
            }
         }
         return null;
      }
      
      public function get value() : uint
      {
         return this.mLevel;
      }
   }
}

