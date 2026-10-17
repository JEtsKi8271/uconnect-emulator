package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class TravelLinkMovieBrowseScreenViewMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var views_group:MovieClip;
      
      public var itemsInList_label:TextField;
      
      public var vewButtons_group:MovieClip;
      
      public var list_scroller:ScrollbarComponent;
      
      public var displayTitle:DisplayTitleMovieClip;
      
      public var back_button:ButtonMovieClip;
      
      public var travelLink_button:NoIconButtonMovieClip;
      
      public function TravelLinkMovieBrowseScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.views_group.message_group.message_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.movieInfo_group.synopsisInfo.description_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.movieListingNone_group.label_translate,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.theaterInfo_group.name_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.theaterInfo_group.address_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.views_group.theaterInfo_group.phone_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyFont(this.itemsInList_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.views_group.message_group.message_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.movieInfo_group.synopsisInfo.description_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.movieListingNone_group.label_translate,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.theaterInfo_group.name_label,Skin.style.currentTheme.alertCautionText);
         Skin.style.applyStyle(this.views_group.theaterInfo_group.address_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.views_group.theaterInfo_group.phone_label,Skin.style.currentTheme.primaryText);
         Skin.style.applyStyle(this.itemsInList_label,Skin.style.currentTheme.primaryText);
      }
   }
}

