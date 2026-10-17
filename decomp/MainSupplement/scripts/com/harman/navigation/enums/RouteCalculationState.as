package com.harman.navigation.enums
{
   public class RouteCalculationState
   {
      
      public static const Idle:int = 0;
      
      public static const Planning:int = 1;
      
      public static const Planned:int = 2;
      
      public static const Calculating:int = 3;
      
      public static const Calculated:int = 4;
      
      public static const Routing:int = 5;
      
      public static const Routed:int = 6;
      
      public static const Failed:int = 7;
      
      public function RouteCalculationState()
      {
         super();
      }
      
      public static function toString(state:int) : String
      {
         switch(state)
         {
            case Idle:
               return "Idle";
            case Planning:
               return "Planning";
            case Planned:
               return "Planned";
            case Calculating:
               return "Calculating";
            case Calculated:
               return "Calculated";
            case Routing:
               return "Routing";
            case Routed:
               return "Routed";
            case Failed:
               return "Failed";
            default:
               return "Unknown";
         }
      }
   }
}

