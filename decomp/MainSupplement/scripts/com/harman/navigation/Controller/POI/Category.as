package com.harman.navigation.Controller.POI
{
   import com.harman.navigation.utils.LocationDetails;
   
   public class Category extends PoiSearchResult
   {
      
      public function Category()
      {
         super();
      }
      
      public static function fromPreset(preset:String) : Category
      {
         var cat:Category = new Category();
         cat._label = preset;
         return cat;
      }
      
      public static function fromLocationDetails(details:LocationDetails) : Category
      {
         var cat:Category = new Category();
         cat._label = details.getType("<CAT>");
         return cat;
      }
      
      public function get category() : String
      {
         return label;
      }
      
      public function get categoryEISElement() : String
      {
         return "<CAT>" + this.category + "<*>";
      }
      
      public function get presetEISElement() : String
      {
         return "<PRE>" + this.category + "<*>";
      }
   }
}

