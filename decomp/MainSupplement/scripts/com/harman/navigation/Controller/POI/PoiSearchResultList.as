package com.harman.navigation.Controller.POI
{
   import com.harman.navigation.utils.SortableList;
   
   public class PoiSearchResultList extends SortableList
   {
      
      private var _searchArea:int;
      
      private var _searchDesc:String;
      
      private var _searchName:Object;
      
      public function PoiSearchResultList(area:int, searchName:Object)
      {
         super();
         this._searchArea = area;
         this._searchName = searchName;
      }
      
      public function getResult(index:int) : PoiSearchResult
      {
         return PoiSearchResult(super.getItem(index));
      }
      
      public function get searchName() : Object
      {
         return this._searchName;
      }
      
      public function get searchArea() : int
      {
         return this._searchArea;
      }
   }
}

