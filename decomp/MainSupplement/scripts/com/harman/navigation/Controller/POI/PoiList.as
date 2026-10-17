package com.harman.navigation.Controller.POI
{
   public class PoiList extends PoiSearchResultList
   {
      
      private var _poiInputPath:int = -1;
      
      public function PoiList(area:int, searchName:Object)
      {
         super(area,searchName);
      }
      
      public function set poiInputPath(val:int) : void
      {
         this._poiInputPath = val;
      }
      
      public function get poiInputPath() : int
      {
         return this._poiInputPath;
      }
      
      public function addPoi(poi:Poi) : void
      {
         super.addItem(poi);
      }
      
      public function getPoi(index:int) : Poi
      {
         return Poi(super.getItem(index));
      }
      
      public function sortByDistance() : void
      {
         super.sort(function(poi1:Poi, poi2:Poi):int
         {
            return poi1.compareDistanceTo(poi2);
         });
      }
      
      public function sortByNameAndDistance() : void
      {
         super.sortOn(["label","distanceCurrentUnits"]);
      }
   }
}

