package com.harman.navigation.Controller.POI
{
   import com.harman.navigation.utils.LocationDetails;
   
   public class PoiCategories extends PoiSearchResultList
   {
      
      public function PoiCategories(area:int, searchName:Object)
      {
         super(area,searchName);
      }
      
      public function addCategory(category:LocationDetails) : void
      {
         var cat:Category = Category.fromLocationDetails(category);
         super.addItem(cat);
      }
   }
}

