package com.harman.navigation.Controller.FavoriteDestinations
{
   import com.harman.navigation.utils.LocationDescription;
   
   public class FavoriteDestination
   {
      
      private var mLocation:LocationDescription = null;
      
      private var mPin:Boolean = false;
      
      private var mSortIndex:int = -1;
      
      public function FavoriteDestination(loc:LocationDescription = null)
      {
         super();
         if(loc != null)
         {
            this.setLocation(loc);
         }
      }
      
      public function setLocation(loc:LocationDescription) : void
      {
         this.mLocation = loc;
      }
      
      public function get location() : LocationDescription
      {
         return this.mLocation;
      }
      
      public function setPin(pin:Boolean) : Boolean
      {
         if(this.mPin != pin)
         {
            this.mPin = pin;
            return true;
         }
         return false;
      }
      
      public function setIndex(index:int) : void
      {
         this.mSortIndex = index;
      }
      
      public function get sortIndex() : int
      {
         return this.mSortIndex;
      }
      
      public function get pinned() : Boolean
      {
         return this.mPin;
      }
      
      public function get chime() : Boolean
      {
         return false;
      }
      
      public function get yomiName() : String
      {
         return "";
      }
   }
}

