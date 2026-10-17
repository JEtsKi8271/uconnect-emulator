package com.harman.navigation.utils
{
   public class SortableList
   {
      
      private static var _resultsCounter:int = int.MAX_VALUE;
      
      private var _items:Array;
      
      private var _resultsID:int;
      
      private var _indexes:Object;
      
      public function SortableList()
      {
         super();
         this.clear();
      }
      
      public function get id() : int
      {
         return this._resultsID;
      }
      
      public function set id(val:int) : void
      {
         this._resultsID = val;
      }
      
      public function clear() : void
      {
         this._resultsID = _resultsCounter--;
         this._items = new Array();
         this._indexes = new Object();
      }
      
      public function sort(compareFunc:Function) : void
      {
         this._items.sort(compareFunc);
      }
      
      public function sortOn(fieldName:Object, options:Object = null) : Array
      {
         return this._items.sortOn(fieldName,options);
      }
      
      public function get length() : int
      {
         return this._items.length;
      }
      
      public function getItem(index:int) : SortableItem
      {
         return this._items[index];
      }
      
      public function addItem(item:SortableItem) : void
      {
         this._indexes["i" + String(item.id)] = this._items.length;
         this._items.push(item);
      }
      
      public function originalIndexOf(item:SortableItem) : int
      {
         return int(this._indexes["i" + String(item.id)]);
      }
      
      public function indexFromStartChar(c:String) : int
      {
         var lbl:String = null;
         c = c.toLowerCase();
         for(var k:int = 0; k < this._items.length; k++)
         {
            lbl = this._items[k].label;
            if(lbl.length > 0 && lbl.toLowerCase().indexOf(c) == 0)
            {
               return k;
            }
         }
         return -1;
      }
      
      public function get startAlphaCharsAvailable() : Vector.<String>
      {
         var result:SortableItem = null;
         var lbl:String = null;
         var c:String = null;
         var avail:Vector.<String> = new Vector.<String>();
         for each(result in this._items)
         {
            lbl = result.label;
            if(lbl.length > 0)
            {
               c = lbl.charAt(0).toUpperCase();
               if(avail.indexOf(c) < 0)
               {
                  avail.push(c);
               }
            }
         }
         return avail.sort(function(o1:String, o2:String):int
         {
            return o1.localeCompare(o2);
         });
      }
      
      public function sortByLabel() : void
      {
         this._items.sort(function(item1:SortableItem, item2:SortableItem):int
         {
            return item1.label.localeCompare(item2.label);
         });
      }
   }
}

