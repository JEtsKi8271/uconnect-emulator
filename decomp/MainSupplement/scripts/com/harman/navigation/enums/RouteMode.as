package com.harman.navigation.enums
{
   public class RouteMode
   {
      
      public static const ROUTE_FASTEST:int = 1 << 0;
      
      public static const ROUTE_SHORTEST:int = 1 << 1;
      
      public static const ROUTE_SCENIC:int = 1 << 2;
      
      public static const AVOID_MOTORWAYS:int = 1 << 3;
      
      public static const AVOID_FERRIES:int = 1 << 4;
      
      public static const AVOID_TOLLROADS:int = 1 << 5;
      
      public static const AVOID_IPD:int = 1 << 6;
      
      public static const AVOID_UNPAVED:int = 1 << 7;
      
      public static const AVOID_BORDER:int = 1 << 8;
      
      public static const ROUTE_ECO:int = 1 << 9;
      
      public static const OPTIMIZE_DESTINATION_ORDER:int = 1 << 10;
      
      public static const AVOID_CARTRAIN:int = 1 << 11;
      
      public static const AVOID_TIMERESTRICTED:int = 1 << 12;
      
      public static const AVOID_SEASONALRESTRICTED:int = 1 << 13;
      
      public static const AVOID_TUNNELS:int = 1 << 14;
      
      public static const OPTIMIZEORDERKEEPLASTDEST:int = 1 << 15;
      
      public static const IGNORE_TRAFFICPATTERNS:int = 1 << 16;
      
      public static const NO_IPD_GUIDANCE:int = 1 << 17;
      
      public static const AVOID_RESTRICTED_AREAS:int = 1 << 18;
      
      public static const SPORT_ROUTE:int = 1 << 19;
      
      public static const TRAIL_GUIDANCE:int = 1 << 20;
      
      public static const TRAIL_GUIDANCE_FROM_END:int = 1 << 21;
      
      public static const AVOID_CAR_POOL_LANES:int = 1 << 22;
      
      public static const PREFER_CAR_POOL_LANES:int = 1 << 23;
      
      public static const DEST_ON_CLOSED_ROAD:int = 1 << 24;
      
      public static const LOAD_ROUTE:int = 1 << 25;
      
      public static const HINT_USE_PRECOMPILED_ROUTE:int = 1 << 26;
      
      public static const USE_ALTERNATIVE_IC:int = 1 << 28;
      
      private var mMode:int;
      
      public function RouteMode()
      {
         super();
         this.mMode = 0;
      }
      
      public function get routeMode() : int
      {
         return this.mMode;
      }
      
      public function overwrite(mode:int) : void
      {
         this.mMode = mode;
      }
      
      public function enableMode(mode:int) : void
      {
         if(mode == ROUTE_ECO || mode == ROUTE_SCENIC || mode == ROUTE_FASTEST || mode == ROUTE_SHORTEST)
         {
            this.mMode &= ~ROUTE_ECO;
            this.mMode &= ~ROUTE_SCENIC;
            this.mMode &= ~ROUTE_FASTEST;
            this.mMode &= ~ROUTE_SHORTEST;
         }
         this.mMode |= mode;
      }
      
      public function disableMode(mode:int) : void
      {
         this.mMode ^= mode;
      }
      
      public function toString() : String
      {
         if(this.mMode == 0)
         {
            return "Undefined";
         }
         var erg:String = "";
         if(this.mMode & ROUTE_FASTEST)
         {
            erg += "fastest ";
         }
         if(this.mMode & ROUTE_SHORTEST)
         {
            erg += "shortest ";
         }
         if(this.mMode & ROUTE_SCENIC)
         {
            erg += "eScenicRoute ";
         }
         if(this.mMode & AVOID_MOTORWAYS)
         {
            erg += "avoidMotorways ";
         }
         if(this.mMode & AVOID_FERRIES)
         {
            erg += "avoidFerries ";
         }
         if(this.mMode & AVOID_TOLLROADS)
         {
            erg += "avoidTollroads ";
         }
         if(this.mMode & AVOID_IPD)
         {
            erg += "avoidIPD ";
         }
         if(this.mMode & AVOID_UNPAVED)
         {
            erg += "avoidUnpaved ";
         }
         if(this.mMode & AVOID_BORDER)
         {
            erg += "avoidBorder ";
         }
         if(this.mMode & ROUTE_ECO)
         {
            erg += "ecoRoute ";
         }
         if(this.mMode & OPTIMIZE_DESTINATION_ORDER)
         {
            erg += "optimizeDestOrder ";
         }
         if(this.mMode & AVOID_CARTRAIN)
         {
            erg += "avoidCarTrain ";
         }
         if(this.mMode & AVOID_TIMERESTRICTED)
         {
            erg += "avoidTimeRestricted ";
         }
         if(this.mMode & AVOID_SEASONALRESTRICTED)
         {
            erg += "avoidSeasonalRestricted ";
         }
         if(this.mMode & AVOID_TUNNELS)
         {
            erg += "avoidTunnels ";
         }
         if(this.mMode & OPTIMIZEORDERKEEPLASTDEST)
         {
            erg += "optimizeDestOrderKeepLastDest ";
         }
         if(this.mMode & IGNORE_TRAFFICPATTERNS)
         {
            erg += "ignoreTrafficPatterns ";
         }
         if(this.mMode & NO_IPD_GUIDANCE)
         {
            erg += "noIPDGuidance ";
         }
         return erg;
      }
   }
}

