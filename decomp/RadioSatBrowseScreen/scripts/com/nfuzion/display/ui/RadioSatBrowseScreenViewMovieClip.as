package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.text.TextField;
   import skin.Skin;
   
   public dynamic class RadioSatBrowseScreenViewMovieClip extends BaseMovieClip implements IMovieClip
   {
      
      public var itemsInList_label:TextField;
      
      public function RadioSatBrowseScreenViewMovieClip()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.itemsInList_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.itemsInList_label,Skin.style.currentTheme.primaryText);
      }
   }
}

