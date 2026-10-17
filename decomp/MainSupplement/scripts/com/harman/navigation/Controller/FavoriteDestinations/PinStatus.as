package com.harman.navigation.Controller.FavoriteDestinations
{
   public class PinStatus
   {
      
      private var bPinned:Boolean = false;
      
      private var bMoveupOk:Boolean = false;
      
      private var bMoveDownOk:Boolean = false;
      
      private var upIndex:int = -1;
      
      private var downToIndex:int = -1;
      
      private var myIndex:int = -1;
      
      public function PinStatus(index:int, pinned:Boolean, moveupToIndex:int = -1, movedownToIndex:int = -1)
      {
         super();
         this.setPinStatus(index,pinned,moveupToIndex,movedownToIndex);
      }
      
      public function get pinned() : Boolean
      {
         return this.bPinned;
      }
      
      public function get moveUpOk() : Boolean
      {
         return this.bMoveupOk;
      }
      
      public function get moveDownOk() : Boolean
      {
         return this.bMoveDownOk;
      }
      
      public function get moveUpToIndex() : int
      {
         return this.upIndex;
      }
      
      public function get moveDownToIndex() : int
      {
         return this.downToIndex;
      }
      
      public function get listIndex() : int
      {
         return this.myIndex;
      }
      
      public function setPinStatus(index:int, pinned:Boolean, moveupToIndex:int = -1, movedownToIndex:int = -1) : void
      {
         this.bPinned = pinned;
         this.myIndex = index;
         this.bMoveDownOk = this.bMoveupOk = false;
         if(this.bPinned == false)
         {
            this.upIndex = moveupToIndex;
            this.downToIndex = movedownToIndex;
            if(moveupToIndex != -1)
            {
               this.bMoveupOk = true;
            }
            if(movedownToIndex != -1)
            {
               this.bMoveDownOk = true;
            }
         }
      }
   }
}

