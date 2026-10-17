package com.nfuzion.display.ui
{
   import flash.display.IMovieClip;
   import flash.display.MovieClip;
   import skin.Skin;
   
   public dynamic class ScrollbarComponent extends BaseMovieClip implements IMovieClip
   {
      
      public var upArrow_button:ButtonMovieClip;
      
      public var downArrow_button:ButtonMovieClip;
      
      public var thumb:MovieClip;
      
      public var track:MovieClip;
      
      public function ScrollbarComponent()
      {
         super();
      }
      
      override protected function updateTheme() : void
      {
         Skin.style.applyFont(this.thumb.popup_simple.value_label,Skin.style.currentTheme.FONT_PRIMARY);
         Skin.style.applyStyle(this.thumb.popup_simple.value_label,Skin.style.currentTheme.primaryText);
      }
   }
}

