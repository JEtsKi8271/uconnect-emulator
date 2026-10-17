package com.harman.navigation.Controller.Interchange
{
   public class InterchangeListScreen
   {
      
      private var mTitle:uint = 0;
      
      private var mList:Array = new Array();
      
      private var mSelectedListItem:int = -1;
      
      public function InterchangeListScreen()
      {
         super();
      }
      
      public function addListItem(item:InterchangeListItem) : void
      {
         this.mList.push(item);
      }
      
      public function get list() : Array
      {
         return this.mList;
      }
      
      public function set title(title:uint) : void
      {
         this.mTitle = title;
      }
      
      public function get title() : uint
      {
         return this.mTitle;
      }
      
      public function set selectedItem(item:int) : void
      {
         this.mSelectedListItem = item;
      }
      
      public function get selectedItem() : int
      {
         return this.mSelectedListItem;
      }
   }
}

