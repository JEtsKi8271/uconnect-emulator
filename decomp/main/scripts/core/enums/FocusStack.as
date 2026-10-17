package core.enums
{
   import flash.utils.Dictionary;
   
   public dynamic class FocusStack extends Dictionary
   {
      
      public function FocusStack()
      {
         super();
         this.deleteFocusObjects();
      }
      
      public function deleteFocusObjects() : void
      {
         this[FocusPriority.MAXIMUM] = null;
         this[FocusPriority.REGULAR] = null;
         this[FocusPriority.MINIMUM] = null;
      }
   }
}

