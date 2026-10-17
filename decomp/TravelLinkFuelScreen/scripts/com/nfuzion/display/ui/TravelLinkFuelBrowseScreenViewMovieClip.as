package com.nfuzion.display.ui
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TravelLinkFuelBrowseScreenViewMovieClip extends BaseMovieClip
   {
      
      public var defaultFuelType_label:TextField;
      
      public var viewButtons_group:MovieClip;
      
      public var itemsInList_label:TextField;
      
      public var list_scroller:ScrollbarComponent;
      
      public var views_group:MovieClip;
      
      public function TravelLinkFuelBrowseScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.itemsInList_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.defaultFuelType_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.fuelPrice_group.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.fuelPrice_group.info_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.fuelInfo_group.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.fuelInfo_group.address_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.fuelInfo_group.phone_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.fuelType_group.listTitle_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.fuelListingNone_group.label_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.views_group.fuelListingNone_group.label_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.itemsInList_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.defaultFuelType_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.fuelPrice_group.name_label,Skin.style.currentTheme.alertCautionText);
         Skin.style.applyStyle(this.views_group.fuelPrice_group.info_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.fuelInfo_group.name_label,Skin.style.currentTheme.alertCautionText);
         Skin.style.applyStyle(this.views_group.fuelInfo_group.address_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.fuelInfo_group.phone_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.fuelType_group.listTitle_translate,Skin.style.currentTheme.primaryText);
      }
   }
}

