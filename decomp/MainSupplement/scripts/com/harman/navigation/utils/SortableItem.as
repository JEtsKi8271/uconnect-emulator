package com.harman.navigation.utils
{
   public class SortableItem
   {
      
      private static var idCounter:int = 0;
      
      protected var _label:String;
      
      private var _id:int;
      
      public function SortableItem()
      {
         super();
         this._label = "unknown";
         this._id = idCounter++;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get label() : String
      {
         return this._label;
      }
   }
}

