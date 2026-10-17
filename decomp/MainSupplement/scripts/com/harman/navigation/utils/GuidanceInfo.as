package com.harman.navigation.utils
{
   public class GuidanceInfo
   {
      
      private var mManeuverDirection:int = -1;
      
      private var mManeuverDistance:int = -1;
      
      private var mManeuverTime:int = -1;
      
      private var mDestinationDistance:int = -1;
      
      private var mDestinationTime:int = -1;
      
      public function GuidanceInfo()
      {
         super();
      }
      
      public function get maneuverDirection() : int
      {
         return this.mManeuverDirection;
      }
      
      public function get maneuverDistance() : int
      {
         return this.mManeuverDistance;
      }
      
      public function get maneuverTime() : int
      {
         return this.mManeuverTime;
      }
      
      public function get destinationDistance() : int
      {
         return this.mDestinationDistance;
      }
      
      public function get destinationTime() : int
      {
         return this.mDestinationTime;
      }
      
      public function setManeuverInfo(direction:int, distance:int, time:int) : void
      {
         this.mManeuverDirection = direction;
         this.mManeuverDistance = distance;
         this.mManeuverTime = time;
      }
      
      public function setDestinationInfo(distance:int, time:int) : void
      {
         this.mDestinationDistance = distance;
         this.mDestinationTime = time;
      }
      
      public function setManeuverDirection(direction:int) : void
      {
         this.mManeuverDirection = direction;
      }
      
      public function setManeuverDistance(distance:int) : void
      {
         this.mManeuverDistance = distance;
      }
      
      public function setManeuverTime(time:int) : void
      {
         this.mManeuverTime = time;
      }
      
      public function setDestinationDistance(distance:int) : void
      {
         this.mDestinationDistance = distance;
      }
      
      public function setDestinationTime(time:int) : void
      {
         this.mDestinationTime = time;
      }
      
      public function reset() : void
      {
         this.mManeuverTime = -1;
         this.mManeuverDirection = -1;
         this.mManeuverDistance = -1;
         this.mDestinationTime = -1;
         this.mDestinationDistance = -1;
      }
   }
}

